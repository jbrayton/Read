//
//  JBRURLSessionDelegate.h
//  Read
//
//  Created by John Brayton on 5/28/23.
//

#import <Foundation/Foundation.h>

/*
    This prevents redirects. The REST APIs should never respond with redirects. In that
    very unexpected scenario this delegate forces the request to fail.
 */
@interface JBRURLSessionDelegate : NSObject<NSURLSessionDelegate>

@end
