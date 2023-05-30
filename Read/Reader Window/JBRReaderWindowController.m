//
//  JBRReaderWindowController.m
//  Read
//
//  Created by John Brayton on 5/28/23.
//

#import "JBRReaderWindowController.h"
#import "JBRReaderWindowManager.h"
#import "JBRURLBarViewController.h"
#import "JBRReaderViewController.h"

@interface JBRReaderWindowController ()<NSToolbarDelegate>

@property (nonatomic, strong, nonnull) JBRURLBarViewController* urlBarViewController;
@property (nonatomic, readwrite, assign) CGPoint cascadedToPoint;

@end

@implementation JBRReaderWindowController

- (void) windowDidLoad {
    [super windowDidLoad];
    [self.window setTitle:NSLocalizedString(@"Untitled", @"")];
}

- (void) showWindow:(id)sender {
    /*
        The first window should be vertically centered, and 900x1200 points -- or as close to that as possible
        while fitting inside the main screen's visible frame. Subsequent windows should be cascaded.
     */
    CGFloat desiredWidth = 900.0;
    CGFloat desiredHeight = 1200.0;
    CGRect screenFrame = [[NSScreen mainScreen] visibleFrame];
    CGRect windowFrame = CGRectMake(screenFrame.origin.x + (screenFrame.size.width - desiredWidth) / 2.0, screenFrame.origin.y + (screenFrame.size.height - desiredHeight) / 2.0, desiredWidth, desiredHeight);
    if (desiredWidth > screenFrame.size.width) {
        windowFrame.origin.x = screenFrame.origin.x;
        windowFrame.size.width = screenFrame.size.width;
    }
    if (desiredHeight > screenFrame.size.height) {
        windowFrame.origin.y = screenFrame.origin.y;
        windowFrame.size.height = screenFrame.size.height;
    }

    [self.window setFrame:windowFrame display:NO];

    JBRReaderWindowController* lastWindowController = nil;
    for ( JBRReaderWindowController* windowController in [[JBRReaderWindowManager shared] windowControllers] ) {
        if (windowController != self) {
            lastWindowController = windowController;
        }
    }
    if (lastWindowController) {
        self.cascadedToPoint = [self.window cascadeTopLeftFromPoint:lastWindowController.cascadedToPoint];
    } else {
        self.cascadedToPoint = [self.window cascadeTopLeftFromPoint:CGPointZero];
    }
    
    [self configureToolbar];
    self.urlBarViewController = [[JBRURLBarViewController alloc] init];
    self.urlBarViewController.delegate = (JBRReaderViewController*) self.contentViewController;
    ((JBRReaderViewController*) self.contentViewController).loadingDelegate = self.urlBarViewController;
    [self.window addTitlebarAccessoryViewController:self.urlBarViewController];
    [super showWindow:sender];
    [self.urlBarViewController makeUrlBarFirstResponder];
}

- (IBAction) openLocation:(id) sender {
    [self.urlBarViewController makeUrlBarFirstResponder];
}

- (void) windowWillClose:(NSNotification*) notification {
    [[JBRReaderWindowManager shared] closingReaderWindowWithWindowController:self];
}

#pragma mark - Toolbar

- (void) configureToolbar {
    NSToolbar* toolbar = [[NSToolbar alloc] initWithIdentifier: @"com.goldenhillsoftware.Read.readerWindowToolbar"];
    [toolbar setDisplayMode:NSToolbarDisplayModeIconOnly];
    [toolbar setDelegate:self];
    [self.window setToolbar:toolbar];
}

- (NSToolbarItem*) toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSToolbarItemIdentifier)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag {
    NSSharingServicePickerToolbarItem* item = [[NSSharingServicePickerToolbarItem alloc] initWithItemIdentifier:itemIdentifier];
    [item setDelegate:(JBRReaderViewController*) self.contentViewController];
    return item;
}

- (NSArray<NSToolbarItemIdentifier> *)toolbarAllowedItemIdentifiers:(NSToolbar *)toolbar {
    return [self toolbarItemIdentifiers];
}

- (NSArray<NSToolbarItemIdentifier> *)toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar {
    return [self toolbarItemIdentifiers];
}

- (NSArray<NSToolbarItemIdentifier> *) toolbarItemIdentifiers {
    return @[NSToolbarFlexibleSpaceItemIdentifier, @"share"];
}

@end
