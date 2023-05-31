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

@interface JBRReaderViewController : NSViewController<JBRURLBarViewControllerDelegate,NSSharingServicePickerToolbarItemDelegate>

@property (nonatomic, weak) id<JBRReaderViewControllerLoadingDelegate> loadingDelegate;

- (NSString*) urlString;

@end
