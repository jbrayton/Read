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

@interface JBRURLBarViewController : NSTitlebarAccessoryViewController<JBRReaderViewControllerLoadingDelegate>

@property (nonatomic, strong, readonly) NSTextField* urlTextField;
@property (nonatomic, weak) id<JBRURLBarViewControllerDelegate> delegate;

- (void) makeUrlBarFirstResponder;

@end
