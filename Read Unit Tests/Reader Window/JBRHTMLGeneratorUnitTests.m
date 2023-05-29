//
//  JBRHTMLGeneratorUnitTests.m
//  Read Unit Tests
//
//  Created by John Brayton on 5/29/23.
//

#import <XCTest/XCTest.h>
#import "JBRHTMLGenerator.h"

@interface JBRHTMLGeneratorUnitTests : XCTestCase

@end

@implementation JBRHTMLGeneratorUnitTests

- (void)testWebsiteDomain {
    XCTAssertEqualObjects([JBRHTMLGenerator websiteDomainFromUrlString:@"https://www.apple.com/some/webpage"], @"apple.com");
    XCTAssertEqualObjects([JBRHTMLGenerator websiteDomainFromUrlString:@"https://apple.com/some/webpage"], @"apple.com");
    XCTAssertEqualObjects([JBRHTMLGenerator websiteDomainFromUrlString:@"https://WwW.apple.com/some/webpage"], @"apple.com");
    XCTAssertEqualObjects([JBRHTMLGenerator websiteDomainFromUrlString:@"http://WwW.Foo.Com/some/webpage"], @"foo.com");
    XCTAssertEqualObjects([JBRHTMLGenerator websiteDomainFromUrlString:@"https://WwW.x/some/webpage"], @"x");
    XCTAssertNil([JBRHTMLGenerator websiteDomainFromUrlString:@"https://WwW./some/webpage"]);
    XCTAssertNil([JBRHTMLGenerator websiteDomainFromUrlString:@"http:///some/webpage"]);

    // NSURL will be unable to parse these, so the website domain should be nil.
    XCTAssertNil([JBRHTMLGenerator websiteDomainFromUrlString:@"not a url"]);
    XCTAssertNil([JBRHTMLGenerator websiteDomainFromUrlString:@"https://😊/some/webpage"]);
}

@end
