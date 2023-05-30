//
//  JBRReaderWindowManager.h
//  Read
//
//  Created by John Brayton on 5/30/23.
//

#import <AppKit/AppKit.h>
@class JBRReaderWindowController;

NS_ASSUME_NONNULL_BEGIN

@interface JBRReaderWindowManager : NSObject<NSWindowRestoration>

@property (nonatomic, strong, readonly, nonnull) NSMutableArray* windowControllers;

+ (JBRReaderWindowManager*) shared;
- (void) createReaderWindow;
- (void) createReaderWindowIfNone;
- (void) closingReaderWindowWithWindowController:(JBRReaderWindowController*) windowController;

@end

NS_ASSUME_NONNULL_END
