//
//  JBRReaderViewControllerLoadingDelegate.h
//  Read
//
//  Created by John Brayton on 5/29/23.
//

#ifndef JBRReaderViewControllerLoadingDelegate_h
#define JBRReaderViewControllerLoadingDelegate_h

@class JBRReaderViewController;

@protocol JBRReaderViewControllerLoadingDelegate

- (void) readerViewController:(JBRReaderViewController*) readerViewController setLoadingPage:(BOOL) loadingPage;
- (void) readerViewController:(JBRReaderViewController*) readerViewController urlStringSetTo:(NSString*) urlString;

@end

#endif /* JBRReaderViewControllerLoadingDelegate_h */
