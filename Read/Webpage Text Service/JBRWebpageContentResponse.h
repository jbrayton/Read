//
//  JBRWebpageContentResponse.h
//  Read
//
//  Created by John Brayton on 5/28/23.
//

#import <Foundation/Foundation.h>

@interface JBRWebpageContentResponse : NSObject

// This might be different from the requested page URL if the website issued a redirect.
@property (nonatomic, strong, readonly) NSString* responseUrlString;

@property (nonatomic, strong, readonly) NSString* title;
@property (nonatomic, strong, readonly) NSString* author;
@property (nonatomic, strong, readonly) NSString* html;

+ (JBRWebpageContentResponse*) fromJsonObject:(id) input;

@end
