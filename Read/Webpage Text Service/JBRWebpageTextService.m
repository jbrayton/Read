//
//  JBRWebpageTextService.m
//  Read
//
//  Created by John Brayton on 5/28/23.
//

#import "JBRWebpageTextService.h"
#import "JBRAccessToken.h"
#import "JBRAccessTokenResponse.h"
#import "JBRURLSessionDelegate.h"
#import "JBRWebpageContentResponse.h"

@interface JBRWebpageTextService ()

@property (nonatomic, strong) JBRURLSessionDelegate* urlSessionDelegate;
@property (nonatomic, strong) NSURLSession* urlSession;

// This stores the current access token. It may be nil or expired.
@property (nonatomic, strong) JBRAccessToken* currentAccessToken;

// When we are requesting an access token, this is an array of callback functions to
// call when we have a response. This is nil when we are not requesting an access token.
// If `getAccessTokenWithCompletionHandler:` is called when we already have an outstanding
// request for an access token, a second callback will be added to `accessTokenCallbacks`.
@property (nonatomic, strong) NSMutableArray* accessTokenCallbacks;

@end

@implementation JBRWebpageTextService

NSString* const CLIENT_ID = @"Read";
NSString* const CLIENT_SECRET = @"y!Tu3#P5m!Ec#Ee8Y%4PwYc4mP0E6L*h";

+ (JBRWebpageTextService*) shared {
    static dispatch_once_t pred = 0;
    static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (instancetype) init {
    self = [super init];
    if (self) {
        _urlSessionDelegate = [[JBRURLSessionDelegate alloc] init];
        NSURLSessionConfiguration* urlSessionConfiguration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        _urlSession = [NSURLSession sessionWithConfiguration:urlSessionConfiguration delegate:_urlSessionDelegate delegateQueue:nil];
    }
    return self;
}

+ (JBRWebpageTextService*) createTestableInstance {
    return [[JBRWebpageTextService alloc] init];
}

// This must be called on the main thread. The completion handler will be called on the main thread as well.
- (void) getWebpageContentForUrlString:(NSString*) urlString completionHandler:(void (^)(JBRWebpageContentResponse*))completionHandler {
    if ((self.currentAccessToken) && ([self.currentAccessToken stillValid])) {
        [self getWebpageContentForUrlString:urlString accessToken:self.currentAccessToken.accessToken completionHandler:^(JBRWebpageContentResponse * contentResponse) {
            completionHandler(contentResponse);
        }];
    } else {
        __weak JBRWebpageTextService* weakSelf = self;
        [self getAccessTokenWithCompletionHandler:^(JBRAccessTokenResponse * accessTokenResponse) {
            NSDate* expirationDate = [[NSDate date] dateByAddingTimeInterval:accessTokenResponse.expiresInTimeInterval];
            weakSelf.currentAccessToken = [[JBRAccessToken alloc] initWithAccessToken:accessTokenResponse.accessToken expirationDate:expirationDate];
            [weakSelf getWebpageContentForUrlString:urlString accessToken:accessTokenResponse.accessToken completionHandler:^(JBRWebpageContentResponse * contentResponse) {
                completionHandler(contentResponse);
            }];
        }];
    }
}

// Call this when it is likely that we are going to issue a request to the webpage text service, but we do not yet
// know what we will request.
- (void) preloadAccessToken {
    __weak JBRWebpageTextService* weakSelf = self;
    if (![self.currentAccessToken stillValid]) {
        [self getAccessTokenWithCompletionHandler:^(JBRAccessTokenResponse * accessTokenResponse) {
            NSDate* expirationDate = [[NSDate date] dateByAddingTimeInterval:accessTokenResponse.expiresInTimeInterval];
            weakSelf.currentAccessToken = [[JBRAccessToken alloc] initWithAccessToken:accessTokenResponse.accessToken expirationDate:expirationDate];
        }];
    }
}

- (void) dealloc {
    [_urlSession finishTasksAndInvalidate];
}

// The completionHandler is always called on the main thread. It will be called with `nil` if an error occurs.
- (void) getAccessTokenWithCompletionHandler:(void (^)(JBRAccessTokenResponse*))completionHandler {
    
    assert(NSThread.isMainThread);
    
    __weak JBRWebpageTextService* weakSelf = self;
    
    if (self.accessTokenCallbacks) {
        [self.accessTokenCallbacks addObject:completionHandler];
        return;
    }
    
    self.accessTokenCallbacks = [NSMutableArray array];
    [self.accessTokenCallbacks addObject:completionHandler];

    NSURL* url = [NSURL URLWithString:@"https://auth.goldenhillsoftware.com/1.0/tokens"];
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSDictionary* payload = @{@"client_id": CLIENT_ID, @"client_secret": CLIENT_SECRET, @"scope": @"https://webpagetextapi.goldenhillsoftware.com/", @"grant_type": @"client_credentials"};
    NSData* payloadData = [NSJSONSerialization dataWithJSONObject:payload options:0 error:nil];
    [request setHTTPBody:payloadData];
    NSURLSessionDataTask* task = [_urlSession dataTaskWithRequest:request completionHandler:^(NSData * data, NSURLResponse * response, NSError * error) {
        NSDictionary* jsonObject = [self jsonObjectIfLooksLikeGoodJsonData:data urlResponse:response error:error requestDescription:@"retrieving access token"];
        JBRAccessTokenResponse* accessTokenResponse = [JBRAccessTokenResponse fromJsonObject:jsonObject];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!accessTokenResponse) {
                NSLog(@"Unable to create access token response from JSON.");
            }
            NSArray* callbacks = weakSelf.accessTokenCallbacks;
            if (callbacks) {
                for( id (^callback)(JBRAccessTokenResponse*) in callbacks ) {
                    callback(accessTokenResponse);
                }
                weakSelf.accessTokenCallbacks = nil;
            }
        });
    }];
    [task resume];
}

// The completionHandler is always called on the main thread. It will be called with `nil` if an error occurs.
- (void) getWebpageContentForUrlString:(NSString*) urlString accessToken:(NSString*) accessToken completionHandler:(void (^)(JBRWebpageContentResponse*))completionHandler {
    NSURL* url = [NSURL URLWithString:@"https://webpagetextapi.goldenhillsoftware.com/1.0/retrievals"];
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"Bearer %@", accessToken] forHTTPHeaderField:@"Authorization"];
    NSDictionary* payload = @{@"url": urlString};
    NSData* payloadData = [NSJSONSerialization dataWithJSONObject:payload options:0 error:nil];
    [request setHTTPBody:payloadData];
    NSURLSessionDataTask* task = [_urlSession dataTaskWithRequest:request completionHandler:^(NSData * data, NSURLResponse * response, NSError * error) {
        NSDictionary* jsonObject = [self jsonObjectIfLooksLikeGoodJsonData:data urlResponse:response error:error requestDescription:@"retrieving webpage content"];
        JBRWebpageContentResponse* webpageContentResponse = [JBRWebpageContentResponse fromJsonObject:jsonObject];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!webpageContentResponse) {
                NSLog(@"Unable to create webpage content response from JSON.");
                completionHandler(nil);
                return;
            }
            completionHandler(webpageContentResponse);
        });
    }];
    [task resume];
}

/*
    Looks at the response and returns the result of [NSJSONSerialization JSONObjectWithData:data options:0 error:nil]
    if it looks like doing so makes sense. Returns nil if any one of the following conditions is true:
    - `error` is not nil
    - `data` is nil.
    - `urlResponse` is nil or is not an `HTTPURLResponse`.
    - The response code is not 200.
    - The data cannot be parsed as JSON.
 */
- (id) jsonObjectIfLooksLikeGoodJsonData:(NSData*) data urlResponse:(NSURLResponse*) urlResponse error:(NSError*) error requestDescription:(NSString*) requestDescription {
    if (error) {
        NSLog(@"Got error getting webpage text for %@: %@", requestDescription, [error localizedDescription]);
        return nil;
    }
    if ((!urlResponse) || (![urlResponse isKindOfClass:[NSHTTPURLResponse class]])) {
        NSLog(@"Did not get HTTP response for %@.", requestDescription);
        return nil;
    }
    if ([(NSHTTPURLResponse*) urlResponse statusCode] != 200) {
        NSLog(@"Got response code of %ld for %@.", [(NSHTTPURLResponse*) urlResponse statusCode], requestDescription);
        return nil;
    }
    if (!data) {
        NSLog(@"No data in response for %@.", requestDescription);
        return nil;
    }
    NSDictionary* jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    if (!jsonObject) {
        NSLog(@"Unable to parse json for %@", requestDescription);
        return nil;
    }
    return jsonObject;
}

@end
