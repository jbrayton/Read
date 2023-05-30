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
#warning Currently not performing state restoration.
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

@end
