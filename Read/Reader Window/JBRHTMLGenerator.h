//
//  JBRHTMLGenerator.h
//  Read
//
//  Created by John Brayton on 5/29/23.
//

#import <Foundation/Foundation.h>
@class JBRWebpageContentResponse;

NS_ASSUME_NONNULL_BEGIN

@interface JBRHTMLGenerator : NSObject

+ (NSString*) generateForWebpageContentResponse:(JBRWebpageContentResponse*) webpageContentResponse;

// This should only be called externally from tests.
+ (NSString* _Nullable) websiteDomainFromUrlString:(NSString*) urlString;

@end

NS_ASSUME_NONNULL_END
