//
//  JBRAccessTokenResponseUnitTests.m
//  ReadTests
//
//  Created by John Brayton on 5/28/23.
//

#import <XCTest/XCTest.h>
#import "JBRAccessTokenResponse.h"

@interface JBRAccessTokenResponseUnitTests : XCTestCase

@end

@implementation JBRAccessTokenResponseUnitTests

- (void)testFromJson {
    
    // Verify that fromJsonObject: returns nil if the input is not a dictionary.
    XCTAssertNil([JBRAccessTokenResponse fromJsonObject:@[]]);

    // Verify that fromJsonObject: returns nil if the access token is not specified or is not a string.
    NSDictionary* dictionary = @{ @"expires_in": @(35.4) };
    XCTAssertNil([JBRAccessTokenResponse fromJsonObject:dictionary]);

    dictionary = @{ @"expires_in": @(35.4), @"a": @"b" };
    XCTAssertNil([JBRAccessTokenResponse fromJsonObject:dictionary]);

    // Verify that fromJsonObject: returns nil if the expiration date is not parseable as a number.
    dictionary = @{ @"access_token": @"foobar" };
    XCTAssertNil([JBRAccessTokenResponse fromJsonObject:dictionary]);

    dictionary = @{ @"access_token": @"foobar", @"expires_in": @"x" };
    XCTAssertNil([JBRAccessTokenResponse fromJsonObject:dictionary]);

    // Now verify good input.
    dictionary = @{ @"access_token": @"foobar", @"expires_in": @(35.4) };
    JBRAccessTokenResponse* response = [JBRAccessTokenResponse fromJsonObject:dictionary];
    XCTAssertNotNil(response);
    XCTAssertEqualObjects(response.accessToken, @"foobar");
    XCTAssertEqual(response.expiresInTimeInterval, 35.4);
}

@end
