//
//  JBRAccessTokenResponse.h
//  Read
//
//  Created by John Brayton on 5/28/23.
//

#import <Foundation/Foundation.h>

@interface JBRAccessTokenResponse : NSObject

@property (nonatomic, strong, readonly) NSString* accessToken;
@property (nonatomic, assign, readonly) NSTimeInterval expiresInTimeInterval;

+ (JBRAccessTokenResponse*) fromJsonObject:(id) input;

@end

