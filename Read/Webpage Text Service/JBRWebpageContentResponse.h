//
//  JBRWebpageContentResponse.h
//  Read
//
//  Created by John Brayton on 5/28/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JBRWebpageContentResponse : NSObject

// This might be different from the requested page URL if the website issued a redirect.
@property (nonatomic, strong, nonnull, readonly) NSString* responseUrlString;

@property (nonatomic, strong, nullable, readonly) NSString* title;
@property (nonatomic, strong, nullable, readonly) NSString* author;
@property (nonatomic, strong, nullable, readonly) NSString* html;

+ (nullable JBRWebpageContentResponse*) fromJsonObject:(id) input;

@end

NS_ASSUME_NONNULL_END
