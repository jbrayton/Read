//
//  JBRBundleScheme.m
//  Read
//
//  Created by John Brayton on 5/29/23.
//

#import "JBRBundleSchemeHandler.h"

@implementation JBRBundleSchemeHandler

- (void)webView:(WKWebView *)webView startURLSchemeTask:(id<WKURLSchemeTask>)urlSchemeTask {
    NSURL* url = urlSchemeTask.request.URL;
    NSString* filename = [url lastPathComponent];
    
    // Ensure that the requested file is one we expect.
    const NSSet* allowedFilenames = [NSSet setWithArray:@[@"static.css",@"mac.css",@"insets.css",@"fontsizes.css",@"lightmodecolors.css",@"darkmodecolors.css"]];
    if (![allowedFilenames containsObject:filename]) {
        NSLog(@"JBRBundleScheme received request for disallowed filename: %@", filename);
        [urlSchemeTask didFailWithError:[NSError errorWithDomain:@"com.goldenhillsoftware.Read.JBRBundleScheme" code:1000 userInfo:nil]];
        return;
    }
    NSArray* components = [filename componentsSeparatedByString:@"."];
    NSURL* resourceUrl = [[NSBundle mainBundle] URLForResource:components[0] withExtension:components[1]];
    NSData* data = [NSData dataWithContentsOfURL:resourceUrl];
    NSHTTPURLResponse* response = [[NSHTTPURLResponse alloc] initWithURL:url statusCode:200 HTTPVersion:@"2.0" headerFields:@{@"Content-Type":@"text/css"}];
    [urlSchemeTask didReceiveResponse:response];
    [urlSchemeTask didReceiveData:data];
    [urlSchemeTask didFinish];
}

- (void)webView:(WKWebView *)webView stopURLSchemeTask:(id<WKURLSchemeTask>)urlSchemeTask {
    //
}

@end
