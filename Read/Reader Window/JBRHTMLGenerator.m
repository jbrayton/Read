//
//  JBRHTMLGenerator.m
//  Read
//
//  Created by John Brayton on 5/29/23.
//

#import "JBRHTMLGenerator.h"
#import "JBRWebpageContentResponse.h"
#import "GTMNSString+HTML.h"

@implementation JBRHTMLGenerator

+ (NSString*) generateForWebpageContentResponse:(JBRWebpageContentResponse*) webpageContentResponse {
    NSMutableString* result = [NSMutableString string];
    [result appendString:@"<html>"];
    [result appendString:@"<head>"];
    [result appendFormat:@"<title>%@</title>", [self encodedString:webpageContentResponse.title]];
    [result appendString:@"<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\">"];
    
#warning Add a Content-Security-Policy
    NSArray* cssFilenameStubs = @[@"static",@"mac",@"insets",@"fontsizes",@"lightmodecolors"];
    for( NSString* cssFilenameStub in cssFilenameStubs ) {
        [result appendFormat:@"<link rel=\"stylesheet\" type=\"text/css\" href=\"bundle:///%@.css\">", [self encodedString:cssFilenameStub]];
    }
    [result appendString:@"<link rel=\"stylesheet\" type=\"text/css\" href=\"bundle:///darkmodecolors.css\" media=\"(prefers-color-scheme: dark)\">"];
    [result appendString:@"</head>"];
    [result appendFormat:@"<body>"];
    
    [result appendString:@"<div class=\"titlediv\" dir=\"auto\">"];
    
    // Article title
    if (webpageContentResponse.title) {
        [result appendFormat:@"<h1><a href=\"%@\">%@</a></h1>", [self encodedString:webpageContentResponse.responseUrlString], [self encodedString:webpageContentResponse.title]];
    }
    
    if ([webpageContentResponse.author length]) {
        [result appendFormat:@"<h3>%@</h3>", [self encodedString:webpageContentResponse.author]];
    }

    // Show the website host.
    NSString* websiteHost = [self websiteDomainFromUrlString:webpageContentResponse.responseUrlString];
    if (websiteHost) {
        [result appendFormat:@"<h3 class=\"unread_articledomain\"><a href=\"%@\">%@</a></h3>", [self encodedString:webpageContentResponse.responseUrlString], [self encodedString:websiteHost]];
    }

    [result appendString:@"</div>"];

    if (webpageContentResponse.html) {
        [result appendString:@"<div class=\"bodydiv\" dir=\"auto\">"];
        [result appendString:webpageContentResponse.html];
        [result appendString:@"</div>"];
    }
    
    [result appendFormat:@"</body>"];
    [result appendFormat:@"</html>"];
    return result;
}

+ (NSString*) encodedString:(NSString* _Nullable) input {
    if ([input length]) {
        return [input gtm_stringByEscapingForHTML];
    } else {
        return @"";
    }
}

/*
    Get the website domain from the URL string. A few notes:
 
    - It removes a "www." prefix from the host, if present.
    - It converts the host to all lowercase.
    - If the host is blank or if the URL cannot be parsed, it returns nil.
 */
+ (NSString* _Nullable) websiteDomainFromUrlString:(NSString*) urlString {
    const NSString* prefixToRemove = @"www.";
    NSURL* url = [NSURL URLWithString:urlString];
    if (!url) {
        return nil;
    }
    NSString* lowercaseHost = [url.host lowercaseString];
    if (!lowercaseHost) {
        return nil;
    }
    // Using "[prefixToRemove copy]" avoids the warning "Sending 'const NSString *__strong' to parameter of type 'NSString * _Nonnull' discards qualifiers".
    if ([lowercaseHost hasPrefix:[prefixToRemove copy]]) {
        // If this condition matches, the URL host is "www.". Just return nil if that happens.
        if ([lowercaseHost length] == [prefixToRemove length]) {
            return nil;
        }
        lowercaseHost = [lowercaseHost substringFromIndex:[prefixToRemove length]];
    }
    return lowercaseHost;
}

@end
