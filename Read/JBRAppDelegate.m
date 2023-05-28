//
//  JBRAppDelegate.m
//  Read
//
//  Created by John Brayton on 5/28/23.
//

#import "JBRAppDelegate.h"
#import "JBRReaderWindowController.h"

@interface JBRAppDelegate ()

#warning This should be an array of window controllers. It needs to support multiple windows.
@property (strong, nonatomic, nullable) JBRReaderWindowController* readerWindowController;

@end

@implementation JBRAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
#warning Should only create if we are not instantiating windows via state restoration.
    self.readerWindowController = [self createReaderWindow];
}

- (BOOL)applicationSupportsSecureRestorableState:(NSApplication *)app {
#warning Currently not performing state restoration.
    return YES;
}

- (JBRReaderWindowController*) createReaderWindow {
    JBRReaderWindowController* windowController = [[NSStoryboard storyboardWithName:@"JBRReaderWindow" bundle:nil] instantiateControllerWithIdentifier:@"JBRReaderWindowController"];
    [windowController showWindow:nil];
    return windowController;
}


@end
