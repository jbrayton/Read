//
//  JBRAccessToken.m
//  Read
//
//  Created by John Brayton on 5/28/23.
//

#import "JBRAccessToken.h"

@implementation JBRAccessToken

- (instancetype) initWithAccessToken:(NSString*) accessToken expirationDate:(NSDate*) expirationDate {
    self = [super init];
    if (self) {
        _accessToken = accessToken;
        _expirationDate = expirationDate;
    }
    return self;
}

/*
    Return true if the expiration date is more than 60 seconds ahead of the current time.
    The 60 seconds is probably overkill, but I want to err on the side of getting a new access token
    when necessary.
 */
- (BOOL) stillValid {
    return [_expirationDate compare:[[NSDate date] dateByAddingTimeInterval:60]] == NSOrderedDescending;
}

@end
