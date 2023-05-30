//
//  JBRURLBarViewController.h
//  Read
//
//  Created by John Brayton on 5/28/23.
//

#import <Cocoa/Cocoa.h>
#import "JBRReaderViewController.h"
#import "JBRReaderViewControllerLoadingDelegate.h"
#import "JBRURLBarViewControllerDelegate.h"
@class JBRURLBarViewController;
@protocol JBRReaderViewControllerLoadingDelegate;

NS_ASSUME_NONNULL_BEGIN

@interface JBRURLBarViewController : NSTitlebarAccessoryViewController<JBRReaderViewControllerLoadingDelegate>

@property (nonatomic, strong, readonly, nullable) NSTextField* urlTextField;
@property (nonatomic, weak, nullable) id<JBRURLBarViewControllerDelegate> delegate;

- (void) makeUrlBarFirstResponder;

@end

NS_ASSUME_NONNULL_END
