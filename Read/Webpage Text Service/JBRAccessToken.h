//
//  JBRAccessToken.h
//  Read
//
//  Created by John Brayton on 5/28/23.
//

#import <Foundation/Foundation.h>

@interface JBRAccessToken : NSObject

@property (nonatomic, strong, readonly) NSString* accessToken;
@property (nonatomic, assign, readonly) NSDate* expirationDate;

- (instancetype) initWithAccessToken:(NSString*) accessToken expirationDate:(NSDate*) expirationDate;

- (BOOL) stillValid;

@end

