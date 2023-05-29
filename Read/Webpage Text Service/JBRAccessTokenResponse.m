//
//  JBRAccessTokenResponse.m
//  Read
//
//  Created by John Brayton on 5/28/23.
//

#import "JBRAccessTokenResponse.h"

@implementation JBRAccessTokenResponse

- (instancetype) initWithAccessToken:(NSString*) accessToken expiresInTimeInterval:(NSTimeInterval) expiresInTimeInterval {
    self = [super init];
    if (self) {
        _accessToken = accessToken;
        _expiresInTimeInterval = expiresInTimeInterval;
    }
    return self;
}

+ (nullable JBRAccessTokenResponse*) fromJsonObject:(id) input {
    if (![input isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    NSDictionary* inputDictionary = (NSDictionary*) input;
    if (![inputDictionary[@"access_token"] isKindOfClass:[NSString class]]) {
        return nil;
    }
    if (![inputDictionary[@"expires_in"] isKindOfClass:[NSNumber class]]) {
        return nil;
    }
    NSNumber* timeIntervalNumber = (NSNumber*) inputDictionary[@"expires_in"];
    return [[JBRAccessTokenResponse alloc] initWithAccessToken:inputDictionary[@"access_token"] expiresInTimeInterval:timeIntervalNumber.doubleValue];
}

@end
