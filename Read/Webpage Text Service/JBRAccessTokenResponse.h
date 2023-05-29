//
//  JBRAccessTokenResponse.h
//  Read
//
//  Created by John Brayton on 5/28/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JBRAccessTokenResponse : NSObject

@property (nonatomic, strong, nonnull, readonly) NSString* accessToken;
@property (nonatomic, assign, readonly) NSTimeInterval expiresInTimeInterval;

+ (nullable JBRAccessTokenResponse*) fromJsonObject:(id) input;

@end

NS_ASSUME_NONNULL_END
