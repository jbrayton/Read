//
//  JBRWebpageTextService.h
//  Read
//
//  Created by John Brayton on 5/28/23.
//

#import <Foundation/Foundation.h>
@class JBRAccessToken;
@class JBRAccessTokenResponse;
@class JBRWebpageContentResponse;

@interface JBRWebpageTextService : NSObject


// Access outside of the class is really for testing only.
@property (nonatomic, strong, readonly) NSMutableArray* accessTokenCallbacks;

+ (JBRWebpageTextService*) shared;

- (void) getWebpageContentForUrlString:(NSString*) urlString completionHandler:(void (^)(JBRWebpageContentResponse*))completionHandler;

// If we know we are likely to retrieve webpage text soon, get a new
// access token if we do not already have a valid one.
- (void) preloadAccessToken;

// These methods should really only be called by integration tests.
+ (JBRWebpageTextService*) createTestableInstance;
- (JBRAccessToken*) currentAccessToken;
- (void) getAccessTokenWithCompletionHandler:(void (^)(JBRAccessTokenResponse*))completionHandler;
- (void) getWebpageContentForUrlString:(NSString*) urlString accessToken:(NSString*) accessToken completionHandler:(void (^)(JBRWebpageContentResponse*))completionHandler;

@end
