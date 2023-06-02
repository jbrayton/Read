//
//  JBRAppDelegate.m
//  Read
//
//  Created by John Brayton on 5/28/23.
//

#import "JBRAppDelegate.h"
#import "JBRReaderWindowManager.h"
#import "JBRWebpageTextService.h"
#import <Cocoa/Cocoa.h>

@interface JBRAppDelegate ()

@end

@implementation JBRAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
    // When launching the app, it is likely that the user will want to retrieve
    // webpage text for a webpage URL. Therefore preload an access token for the
    // webpage text service.
    [[JBRWebpageTextService shared] preloadAccessToken];
    
    // If state restoration did not create a window and if the user did not open the
    // app with a read-http:// or read-https:// URL, create an empty window.
    [[JBRReaderWindowManager shared] createReaderWindowIfNone];
}

- (BOOL)applicationSupportsSecureRestorableState:(NSApplication *)app {
    return YES;
}

- (IBAction) createNewReaderWindow:(id) sender {
    // When creating a new window, it is likely that the user will want to retrieve
    // webpage text for a webpage URL. Therefore preload an access token for the
    // webpage text service.
    [[JBRWebpageTextService shared] preloadAccessToken];
    
    [[JBRReaderWindowManager shared] createReaderWindow];
}

// If a Reader Window Controller is first responder, it will put the focus on the
// text field in the URL bar. If the app delegate is the first responder, it will
// create a new window.
- (IBAction) openLocation:(id) sender {

    // Since the user is about to edit the URL textfield, it is likely that the user will want to retrieve
    // webpage text for a webpage URL. Therefore preload an access token for the
    // webpage text service.
    [[JBRWebpageTextService shared] preloadAccessToken];

    [[JBRReaderWindowManager shared] createReaderWindow];
}

// MARK: Handle being opened by a URL.

- (void) application:(NSApplication *)application openURLs:(NSArray<NSURL *> *)urls {
    for( NSURL* url in urls ) {
        NSString* urlString = [self readUrlStringFromUrl:url];
        if (urlString) {
            [[JBRReaderWindowManager shared] createReaderWindowWithUrlString:urlString];
        }
    }
    
}

- (NSString*) readUrlStringFromUrl:(NSURL*) inputUrl {
    NSURLComponents* urlComponents = [[NSURLComponents alloc] initWithURL:inputUrl resolvingAgainstBaseURL:NO];
    if (!urlComponents) {
        return nil;
    }
    if ([[urlComponents scheme] isEqualToString:@"read-http"]) {
        [urlComponents setScheme:@"http"];
        return [[urlComponents URL] absoluteString];
    }
    if ([[urlComponents scheme] isEqualToString:@"read-https"]) {
        [urlComponents setScheme:@"https"];
        return [[urlComponents URL] absoluteString];
    }
    return nil;
}

@end
