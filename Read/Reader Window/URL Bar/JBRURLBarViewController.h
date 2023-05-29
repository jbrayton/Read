//
//  JBRURLBarViewController.h
//  Read
//
//  Created by John Brayton on 5/28/23.
//

#import <Cocoa/Cocoa.h>
#import "JBRReaderViewController.h"
@class JBRURLBarViewController;
@protocol JBRReaderViewControllerLoadingDelegate;

NS_ASSUME_NONNULL_BEGIN

@protocol JBRURLBarViewControllerDelegate
- (void) urlBarViewController:(JBRURLBarViewController*) urlBarViewController urlStringChangedTo:(NSString*) urlString;
@end

@interface JBRURLBarViewController : NSTitlebarAccessoryViewController<JBRReaderViewControllerLoadingDelegate>

@property (nonatomic, weak, nullable) id<JBRURLBarViewControllerDelegate> delegate;

- (void) makeUrlBarFirstResponder;

@end

NS_ASSUME_NONNULL_END
