//
//  JBRAccessTokenUnitTests.m
//  Read Unit Tests
//
//  Created by John Brayton on 5/29/23.
//

#import <XCTest/XCTest.h>
#import "JBRAccessToken.h"

@interface JBRAccessTokenUnitTests : XCTestCase

@end

@implementation JBRAccessTokenUnitTests

- (void)testAccessTokenValid {
    XCTAssertFalse([[[JBRAccessToken alloc] initWithAccessToken:@"" expirationDate:[[NSDate date] dateByAddingTimeInterval:-3600]] stillValid]);
    XCTAssertFalse([[[JBRAccessToken alloc] initWithAccessToken:@"" expirationDate:[[NSDate date] dateByAddingTimeInterval:-120]] stillValid]);
    XCTAssertFalse([[[JBRAccessToken alloc] initWithAccessToken:@"" expirationDate:[[NSDate date] dateByAddingTimeInterval:-60]] stillValid]);
    XCTAssertFalse([[[JBRAccessToken alloc] initWithAccessToken:@"" expirationDate:[[NSDate date] dateByAddingTimeInterval:0]] stillValid]);
    XCTAssertFalse([[[JBRAccessToken alloc] initWithAccessToken:@"" expirationDate:[[NSDate date] dateByAddingTimeInterval:58]] stillValid]);
    XCTAssertTrue([[[JBRAccessToken alloc] initWithAccessToken:@"" expirationDate:[[NSDate date] dateByAddingTimeInterval:120]] stillValid]);
    XCTAssertTrue([[[JBRAccessToken alloc] initWithAccessToken:@"" expirationDate:[[NSDate date] dateByAddingTimeInterval:3600]] stillValid]);
}

@end
