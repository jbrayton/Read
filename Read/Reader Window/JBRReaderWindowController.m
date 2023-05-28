//
//  JBRReaderWindowController.m
//  Read
//
//  Created by John Brayton on 5/28/23.
//

#import "JBRReaderWindowController.h"
#import "JBRURLBarViewController.h"
#import "JBRReaderViewController.h"

@interface JBRReaderWindowController ()<NSToolbarDelegate>

@property (nonatomic, strong, nonnull) JBRURLBarViewController* urlBarViewController;

@end

@implementation JBRReaderWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
}

- (void) showWindow:(id)sender {
    [self configureToolbar];
    self.urlBarViewController = [[JBRURLBarViewController alloc] init];
    self.urlBarViewController.delegate = (JBRReaderViewController*) self.contentViewController;
    [self.window addTitlebarAccessoryViewController:self.urlBarViewController];
    [super showWindow:sender];
    [self.urlBarViewController makeUrlBarFirstResponder];
}

- (IBAction) openLocation:(id) sender {
    [self.urlBarViewController makeUrlBarFirstResponder];
}

#pragma mark - Toolbar

- (void) configureToolbar {
    NSToolbar* toolbar = [[NSToolbar alloc] initWithIdentifier: @"com.goldenhillsoftware.Read.readerWindowToolbar"];
    [toolbar setDisplayMode:NSToolbarDisplayModeIconOnly];
    [toolbar setDelegate:self];
    [self.window setToolbar:toolbar];
}

- (NSToolbarItem*) toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSToolbarItemIdentifier)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag {
#warning This needs a delegate. It does not share anything yet.
    NSSharingServicePickerToolbarItem* item = [[NSSharingServicePickerToolbarItem alloc] initWithItemIdentifier:itemIdentifier];
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
