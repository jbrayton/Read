//
//  JBRBundleScheme.h
//  Read
//
//  Created by John Brayton on 5/29/23.
//

#import <Foundation/Foundation.h>
@import WebKit;

NS_ASSUME_NONNULL_BEGIN

// HTML loaded from a string into a WKWebView cannot directly access CSS files or other resources
// of an app bundle or other local file. Therefore the CSS files are loaded from
// "bundle://" URLs This scheme handler is responsible for loading content for those URLs directly from
// the app bundle.
@interface JBRBundleSchemeHandler : NSObject<WKURLSchemeHandler>

@end

NS_ASSUME_NONNULL_END
