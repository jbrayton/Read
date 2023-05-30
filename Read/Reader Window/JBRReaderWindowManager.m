//
//  JBRReaderWindowManager.m
//  Read
//
//  Created by John Brayton on 5/30/23.
//

#import "JBRReaderWindowManager.h"
#import "JBRReaderWindowController.h"
#import <AppKit/AppKit.h>

@interface JBRReaderWindowManager ()

@property (nonatomic, strong, readwrite, nonnull) NSMutableArray* windowControllers;

@end

@implementation JBRReaderWindowManager


+ (JBRReaderWindowManager*) shared {
    static dispatch_once_t pred = 0;
    static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (instancetype) init {
    self = [super init];
    if (self) {
        self.windowControllers = [NSMutableArray array];
    }
    return self;
}

- (void) createReaderWindow {
    JBRReaderWindowController* windowController = [[NSStoryboard storyboardWithName:@"JBRReaderWindow" bundle:nil] instantiateControllerWithIdentifier:@"JBRReaderWindowController"];
    [self.windowControllers addObject:windowController];
    
    // This is a `dispatch_async` call because the [NSWindow setFrame:] call just does not seem to work
    // when done immediately.
    dispatch_async(dispatch_get_main_queue(), ^{
        [windowController showWindow:nil];
    });
}

- (void) createReaderWindowIfNone {
    if ([self.windowControllers count] == 0) {
        [self createReaderWindow];
    }
}

- (void) closingReaderWindowWithWindowController:(JBRReaderWindowController*) windowController {
    [self.windowControllers removeObject:windowController];
}


@end
