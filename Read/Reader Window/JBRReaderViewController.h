//
//  JBRReaderViewController.h
//  Read
//
//  Created by John Brayton on 5/28/23.
//

#import <Cocoa/Cocoa.h>
#import "JBRURLBarViewController.h"
@class JBRReaderViewController;
@protocol JBRURLBarViewControllerDelegate;

NS_ASSUME_NONNULL_BEGIN

@protocol JBRReaderViewControllerLoadingDelegate

- (void) readerViewController:(JBRReaderViewController*) readerViewController setLoadingPage:(BOOL) loadingPage;

@end


#pragma clang diagnostic push
// Xcode warns that it cannot find a protocol definition for JBRURLBarViewControllerDelegate, even though it is defined
// in JBRURLBarViewController.h and that is imported. The "#pragma" marks suppress the warning.
#pragma clang diagnostic ignored "-Weverything"
@interface JBRReaderViewController : NSViewController<JBRURLBarViewControllerDelegate>
#pragma clang diagnostic pop


@property (nonatomic, weak, nullable) id<JBRReaderViewControllerLoadingDelegate> loadingDelegate;

@end

NS_ASSUME_NONNULL_END
