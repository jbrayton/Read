//
//  JBRWebpageContentResponseUnitTests.m
//  Read Unit Tests
//
//  Created by John Brayton on 5/28/23.
//

#import <XCTest/XCTest.h>
#import "JBRWebpageContentResponse.h"

@interface JBRWebpageContentResponseUnitTests : XCTestCase

@end

@implementation JBRWebpageContentResponseUnitTests

- (void) testFromJson {
    
    XCTAssertNil([JBRWebpageContentResponse fromJsonObject:@[]]);
    
    // If the response_url is nil or not a string, something is wrong.
    NSDictionary* dictionary = @{@"response_url": @3, @"title": @"My title", @"author": @"me", @"html": @"<p>hi</p>"};
    XCTAssertNil([JBRWebpageContentResponse fromJsonObject:dictionary]);
    dictionary = @{@"title": @"My title", @"author": @"me", @"html": @"<p>hi</p>"};
    XCTAssertNil([JBRWebpageContentResponse fromJsonObject:dictionary]);
    
    
    // If the title is not nil and not a string, something is wrong.
    dictionary = @{@"response_url": @"https://www.apple.com/", @"title": @[], @"author": @"me", @"html": @"<p>hi</p>"};
    XCTAssertNil([JBRWebpageContentResponse fromJsonObject:dictionary]);
    
    // A nil title is ok.
    dictionary = @{@"response_url": @"https://www.apple.com/", @"author": @"me", @"html": @"<p>hi</p>"};
    JBRWebpageContentResponse* response = [JBRWebpageContentResponse fromJsonObject:dictionary];
    XCTAssertNotNil(response);
    XCTAssertEqualObjects(response.responseUrlString, @"https://www.apple.com/");
    XCTAssertNil(response.title);
    XCTAssertEqualObjects(response.author, @"me");
    XCTAssertEqualObjects(response.html, @"<p>hi</p>");

    
    // If the author is not nil and not a string, something is wrong.
    dictionary = @{@"response_url": @"https://www.apple.com/", @"title": @"My title", @"author": @2, @"html": @"<p>hi</p>"};
    XCTAssertNil([JBRWebpageContentResponse fromJsonObject:dictionary]);
    
    // A nil author is ok.
    dictionary = @{@"response_url": @"https://www.apple.com/", @"title": @"My title", @"html": @"<p>hi</p>"};
    response = [JBRWebpageContentResponse fromJsonObject:dictionary];
    XCTAssertNotNil(response);
    XCTAssertEqualObjects(response.responseUrlString, @"https://www.apple.com/");
    XCTAssertEqualObjects(response.title, @"My title");
    XCTAssertNil(response.author);
    XCTAssertEqualObjects(response.html, @"<p>hi</p>");

    
    // If the html is not nil and not a string, something is wrong.
    dictionary = @{@"response_url": @"https://www.apple.com/", @"title": @"My title", @"author": @"me", @"html": @3};
    XCTAssertNil([JBRWebpageContentResponse fromJsonObject:dictionary]);
    
    // A nil html string is ok.
    dictionary = @{@"response_url": @"https://www.apple.com/", @"title": @"My title", @"author": @"me"};
    response = [JBRWebpageContentResponse fromJsonObject:dictionary];
    XCTAssertNotNil(response);
    XCTAssertEqualObjects(response.responseUrlString, @"https://www.apple.com/");
    XCTAssertEqualObjects(response.title, @"My title");
    XCTAssertEqualObjects(response.author, @"me");
    XCTAssertNil(response.html);

    
    // Test a good and fully-formed response.
    dictionary = @{@"response_url": @"https://www.apple.com/", @"title": @"My title", @"author": @"me", @"html": @"<p>hi</p>"};
    response = [JBRWebpageContentResponse fromJsonObject:dictionary];
    XCTAssertNotNil(response);
    XCTAssertEqualObjects(response.responseUrlString, @"https://www.apple.com/");
    XCTAssertEqualObjects(response.title, @"My title");
    XCTAssertEqualObjects(response.author, @"me");
    XCTAssertEqualObjects(response.html, @"<p>hi</p>");
}

@end
