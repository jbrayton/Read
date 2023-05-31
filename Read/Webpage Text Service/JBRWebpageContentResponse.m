//
//  JBRWebpageContentResponse.m
//  Read
//
//  Created by John Brayton on 5/28/23.
//

#import "JBRWebpageContentResponse.h"

@implementation JBRWebpageContentResponse

- (instancetype) initWithResponseUrlString:(NSString*) responseUrlString
                                     title:(NSString*) title
                                    author:(NSString*) author
                                      html:(NSString*) html {
    self = [super init];
    if (self) {
        _responseUrlString = responseUrlString;
        _title = title;
        _author = author;
        _html = html;
    }
    return self;
}

+ (JBRWebpageContentResponse*) fromJsonObject:(id) input {
    if (![input isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    NSDictionary* inputDictionary = (NSDictionary*) input;
    NSString* responseUrlString = inputDictionary[@"response_url"];
    if (![responseUrlString isKindOfClass:[NSString class]]) {
        return nil;
    }
    NSString* title = inputDictionary[@"title"];
    if ((title) && (![title isKindOfClass:[NSString class]])) {
        return nil;
    }
    NSString* author = inputDictionary[@"author"];
    if ((author) && (![author isKindOfClass:[NSString class]])) {
        return nil;
    }
    NSString* html = inputDictionary[@"html"];
    if ((html) && (![html isKindOfClass:[NSString class]])) {
        return nil;
    }
    return [[JBRWebpageContentResponse alloc] initWithResponseUrlString:responseUrlString title:title author:author html:html];
}

@end
