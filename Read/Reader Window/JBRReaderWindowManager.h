//
//  JBRReaderWindowManager.h
//  Read
//
//  Created by John Brayton on 5/30/23.
//

#import <AppKit/AppKit.h>
@class JBRReaderWindowController;

@interface JBRReaderWindowManager : NSObject<NSWindowRestoration>

@property (nonatomic, strong, readonly) NSMutableArray* windowControllers;

+ (JBRReaderWindowManager*) shared;
- (void) createReaderWindow;
- (void) createReaderWindowWithUrlString:(NSString*) urlString;
- (void) createReaderWindowIfNone;
- (void) closingReaderWindowWithWindowController:(JBRReaderWindowController*) windowController;

@end
