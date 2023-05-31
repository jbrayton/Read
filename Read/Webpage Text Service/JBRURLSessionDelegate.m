//
//  JBRURLSessionDelegate.m
//  Read
//
//  Created by John Brayton on 5/28/23.
//

#import "JBRURLSessionDelegate.h"

@implementation JBRURLSessionDelegate

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
willPerformHTTPRedirection:(NSHTTPURLResponse *)response
        newRequest:(NSURLRequest *)request
 completionHandler:(void (^)(NSURLRequest *))completionHandler{
    completionHandler(nil);
}

@end
