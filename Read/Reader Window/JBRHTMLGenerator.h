//
//  JBRHTMLGenerator.h
//  Read
//
//  Created by John Brayton on 5/29/23.
//

#import <Foundation/Foundation.h>
@class JBRWebpageContentResponse;

@interface JBRHTMLGenerator : NSObject

+ (NSString*) generateForWebpageContentResponse:(JBRWebpageContentResponse*) webpageContentResponse;

// This should only be called externally from tests.
+ (NSString*) websiteDomainFromUrlString:(NSString*) urlString;

@end
