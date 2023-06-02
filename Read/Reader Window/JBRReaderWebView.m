//
//  JBRReaderWebView.m
//  Read
//
//  Created by John Brayton on 5/29/23.
//

#import "JBRReaderWebView.h"

@implementation JBRReaderWebView

/*
    By default WKWebView context menus include items that will not work from this app:
    - Open Link in New Window
    - Download Linked File
    - Open Image in New Window
    - Download Image
 
    This removes those context menu items.
 */
- (void) willOpenMenu:(NSMenu *)menu withEvent:(NSEvent *)event {
    [super willOpenMenu:menu withEvent:event];
    
    const NSSet* removeMenuItemIdentifiers = [NSSet setWithArray:@[@"WKMenuItemIdentifierOpenLinkInNewWindow", @"WKMenuItemIdentifierDownloadLinkedFile", @"WKMenuItemIdentifierOpenImageInNewWindow", @"WKMenuItemIdentifierDownloadImage"]];
    
    for( NSMenuItem* item in [menu itemArray] ) {
        if ((item.identifier) && ([removeMenuItemIdentifiers containsObject:item.identifier])) {
            [menu removeItem:item];
        }
    }
}

@end
