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

// Generates a full HTML file based on webpage text HTML and other metadata.
+ (NSString*) generateForWebpageContentResponse:(JBRWebpageContentResponse*) webpageContentResponse {
    NSMutableString* result = [NSMutableString string];
    [result appendString:@"<html>"];
    [result appendString:@"<head>"];
    [result appendFormat:@"<title>%@</title>", [self encodedString:webpageContentResponse.title]];
    [result appendString:@"<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\">"];
    [result appendFormat:@"<base href=\"%@\">", [self encodedString:webpageContentResponse.responseUrlString]];
    
    // HTML content from the webpage text service should already be sanitized, but this is an additional level of
    // protection that limits what the displayed HTML can do. CSS can only be loaded from "bundle:" URLs. Images and
    // frames can be from HTTP or HTTPS URLs. No other scripts or remote content can be run.
    [result appendString:@"<meta http-equiv=\"Content-Security-Policy\" content=\"default-src 'none'; style-src bundle:; img-src http: https:; frame-src http: https:;\">"];
    
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

// Return an HTML-coded string based on _input_. Return "" if _input_ is nil.
+ (NSString*) encodedString:(NSString*) input {
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
+ (NSString*) websiteDomainFromUrlString:(NSString*) urlString {
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
