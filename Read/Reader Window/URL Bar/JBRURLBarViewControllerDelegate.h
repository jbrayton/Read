//
//  JBRURLBarViewControllerDelegate.h
//  Read
//
//  Created by John Brayton on 5/29/23.
//

#ifndef JBRURLBarViewControllerDelegate_h
#define JBRURLBarViewControllerDelegate_h

@class JBRURLBarViewController;

@protocol JBRURLBarViewControllerDelegate
- (void) urlBarViewController:(JBRURLBarViewController*) urlBarViewController urlStringChangedTo:(NSString*) urlString;
@end

#endif /* JBRURLBarViewControllerDelegate_h */
