//
//  JBRURLBarViewController.h
//  Read
//
//  Created by John Brayton on 5/28/23.
//

#import <Cocoa/Cocoa.h>
@class JBRURLBarViewController;

NS_ASSUME_NONNULL_BEGIN

@protocol JBRURLBarViewControllerDelegate
- (void) urlBarViewController:(JBRURLBarViewController*) urlBarViewController urlStringChangedTo:(NSString*) urlString;
@end

@interface JBRURLBarViewController : NSTitlebarAccessoryViewController

@property (nonatomic, weak, nullable) id<JBRURLBarViewControllerDelegate> delegate;

- (void) makeUrlBarFirstResponder;

@end

NS_ASSUME_NONNULL_END
