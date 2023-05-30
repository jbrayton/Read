//
//  JBRReaderWindowController.h
//  Read
//
//  Created by John Brayton on 5/28/23.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface JBRReaderWindowController : NSWindowController

- (void) showWithUrlString:(NSString* _Nullable) urlString viaStateRestoration:(BOOL) viaStateRestoration;

@end

NS_ASSUME_NONNULL_END
