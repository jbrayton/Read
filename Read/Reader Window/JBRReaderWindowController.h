//
//  JBRReaderWindowController.h
//  Read
//
//  Created by John Brayton on 5/28/23.
//

#import <Cocoa/Cocoa.h>

@interface JBRReaderWindowController : NSWindowController

- (void) showWithUrlString:(NSString*) urlString viaStateRestoration:(BOOL) viaStateRestoration;

@end
