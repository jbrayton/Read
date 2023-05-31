//
//  JBRAppDelegateUnitTests.m
//  Read Unit Tests
//
//  Created by John Brayton on 5/30/23.
//

#import <XCTest/XCTest.h>
#import "JBRAppDelegate.h"

@interface JBRAppDelegateUnitTests : XCTestCase

@end

@implementation JBRAppDelegateUnitTests

- (void)testExample {
    XCTAssertEqualObjects([[[JBRAppDelegate alloc] init] readUrlStringFromUrl:[NSURL URLWithString:@"read-https://www.apple.com/foobar/"]], @"https://www.apple.com/foobar/");
    XCTAssertEqualObjects([[[JBRAppDelegate alloc] init] readUrlStringFromUrl:[NSURL URLWithString:@"read-http://www.google.com/foobar/"]], @"http://www.google.com/foobar/");
    XCTAssertNil([[[JBRAppDelegate alloc] init] readUrlStringFromUrl:[NSURL URLWithString:@"read-dsdf://www.google.com/foobar/"]]);
    XCTAssertNil([[[JBRAppDelegate alloc] init] readUrlStringFromUrl:[NSURL URLWithString:@"aaf-dsdf://www.google.com/foobar/"]]);
    XCTAssertNil([[[JBRAppDelegate alloc] init] readUrlStringFromUrl:[NSURL URLWithString:@"read://www.google.com/foobar/"]]);
}

@end
