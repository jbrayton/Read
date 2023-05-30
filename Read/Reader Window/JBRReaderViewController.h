//
//  JBRReaderViewController.h
//  Read
//
//  Created by John Brayton on 5/28/23.
//

#import <Cocoa/Cocoa.h>
#import "JBRURLBarViewController.h"
#import "JBRURLBarViewControllerDelegate.h"
#import "JBRReaderViewControllerLoadingDelegate.h"
@class JBRReaderViewController;
@protocol JBRURLBarViewControllerDelegate;

NS_ASSUME_NONNULL_BEGIN

@interface JBRReaderViewController : NSViewController<JBRURLBarViewControllerDelegate>

@property (nonatomic, weak, nullable) id<JBRReaderViewControllerLoadingDelegate> loadingDelegate;

@end

NS_ASSUME_NONNULL_END
