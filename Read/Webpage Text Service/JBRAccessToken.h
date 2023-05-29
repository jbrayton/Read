//
//  JBRAccessToken.h
//  Read
//
//  Created by John Brayton on 5/28/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JBRAccessToken : NSObject

@property (nonatomic, strong, nonnull, readonly) NSString* accessToken;
@property (nonatomic, assign, nonnull, readonly) NSDate* expirationDate;

- (instancetype) initWithAccessToken:(NSString*) accessToken expirationDate:(NSDate*) expirationDate;

- (BOOL) stillValid;

@end

NS_ASSUME_NONNULL_END
