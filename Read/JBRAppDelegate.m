//
//  JBRAppDelegate.m
//  Read
//
//  Created by John Brayton on 5/28/23.
//

#import "JBRAppDelegate.h"
#import "JBRReaderWindowManager.h"
#import <Cocoa/Cocoa.h>

@interface JBRAppDelegate ()

@end

@implementation JBRAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [[JBRReaderWindowManager shared] createReaderWindowIfNone];
}

- (BOOL)applicationSupportsSecureRestorableState:(NSApplication *)app {
    return YES;
}

- (IBAction) createNewReaderWindow:(id) sender {
    [[JBRReaderWindowManager shared] createReaderWindow];
}

// If a Reader Window Controller is first responder, it will put the focus on the
// text field in the URL bar. If the app delegate is the first responder, it will
// create a new window.
- (IBAction) openLocation:(id) sender {
    [[JBRReaderWindowManager shared] createReaderWindow];
}

- (void) application:(NSApplication *)application openURLs:(NSArray<NSURL *> *)urls {
    for( NSURL* url in urls ) {
        NSString* urlString = [self readUrlStringFromUrl:url];
        if (urlString) {
            [[JBRReaderWindowManager shared] createReaderWindowWithUrlString:urlString];
        }
    }
}

- (NSString* _Nullable) readUrlStringFromUrl:(NSURL*) inputUrl {
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
