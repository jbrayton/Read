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

NS_ASSUME_NONNULL_BEGIN

@interface JBRWebpageTextService : NSObject

+ (JBRWebpageTextService*) shared;

- (void) getWebpageContentForUrlString:(NSString*) urlString completionHandler:(void (^)(JBRWebpageContentResponse*))completionHandler;

// These methods should really only be called by integration tests.
+ (JBRWebpageTextService*) createTestableInstance;
- (JBRAccessToken*) currentAccessToken;
- (void) getAccessTokenWithCompletionHandler:(void (^)(JBRAccessTokenResponse*))completionHandler;
- (void) getWebpageContentForUrlString:(NSString*) urlString accessToken:(NSString*) accessToken completionHandler:(void (^)(JBRWebpageContentResponse*))completionHandler;

@end

NS_ASSUME_NONNULL_END
