//
//  JBRWebpageTextServiceIntegrationTests.m
//  Read Integration Tests
//
//  Created by John Brayton on 5/28/23.
//

#import <XCTest/XCTest.h>
#import "JBRAccessToken.h"
#import "JBRAccessTokenResponse.h"
#import "JBRWebpageContentResponse.h"
#import "JBRWebpageTextService.h"

@interface JBRWebpageTextServiceIntegrationTests : XCTestCase

@end

@implementation JBRWebpageTextServiceIntegrationTests

- (void) testRetrievingAccessTokenAndWebpageContent {
    __block JBRAccessTokenResponse* accessTokenResponse = nil;
    XCTestExpectation* accessTokenExpectation = [self expectationWithDescription:@"retrieve access token"];
    [[JBRWebpageTextService shared] getAccessTokenWithCompletionHandler:^(JBRAccessTokenResponse * tokenResponse) {
        XCTAssertNotNil(tokenResponse);
        XCTAssert([NSThread isMainThread]);
        accessTokenResponse = tokenResponse;
        [accessTokenExpectation fulfill];
    }];
    [self waitForExpectations:@[accessTokenExpectation] timeout:60.0];
    if (accessTokenResponse) {
        XCTestExpectation* webpageContentExpectation = [self expectationWithDescription:@"get webpage content"];
        [[JBRWebpageTextService shared] getWebpageContentForUrlString:@"https://www.goldenhillsoftware.com/2023/01/unread-33-adds-the-ability-to-create-an-article-from-a-webpage-a-readwise-article-action-and-more/" accessToken:accessTokenResponse.accessToken completionHandler:^(JBRWebpageContentResponse * webpageContentResponse) {
            XCTAssert([NSThread isMainThread]);
            XCTAssertNotNil(webpageContentResponse);
            XCTAssertEqualObjects(webpageContentResponse.responseUrlString, @"https://www.goldenhillsoftware.com/2023/01/unread-33-adds-the-ability-to-create-an-article-from-a-webpage-a-readwise-article-action-and-more/");
            XCTAssertEqualObjects(webpageContentResponse.title, @"Unread 3.3 Adds the Ability to Create an Article From a Webpage, a Readwise Article Action, and More");
            XCTAssertEqualObjects(webpageContentResponse.author, @"John Brayton");
            XCTAssertNotNil(webpageContentResponse.html);
            XCTAssert([webpageContentResponse.html rangeOfString:@"<p>"].location != NSNotFound);
            [webpageContentExpectation fulfill];
        }];
        [self waitForExpectations:@[webpageContentExpectation] timeout:60.0];
    } else {
        XCTFail();
    }
}

/*
    This does an end-to-end test, letting the `JBRWebpageTextService` instance manage getting an access
    token when necessary. This verifies that:
    - If we do not already have a good access token, we get one.
    - If we have a good access token, we do not get a second one.
 */
- (void) testCombined {
    JBRWebpageTextService* service = [JBRWebpageTextService createTestableInstance];
    
    __block JBRAccessToken* firstAccessToken;
    __block JBRAccessToken* secondAccessToken;

    XCTestExpectation* firstPageExpectation = [self expectationWithDescription:@"first page expectation"];
    [service getWebpageContentForUrlString:@"https://www.goldenhillsoftware.com/2023/01/unread-33-adds-the-ability-to-create-an-article-from-a-webpage-a-readwise-article-action-and-more/" completionHandler:^(JBRWebpageContentResponse * webpageContentResponse) {
        XCTAssertNotNil(webpageContentResponse);
        firstAccessToken = [service currentAccessToken];
        [firstPageExpectation fulfill];
    }];
    [self waitForExpectations:@[firstPageExpectation]];
    
    XCTestExpectation* secondPageExpectation = [self expectationWithDescription:@"second page expectation"];
    [service getWebpageContentForUrlString:@"https://www.goldenhillsoftware.com/2022/11/unread-32-adds-new-custom-app-icons-a-new-blue-on-black-theme-article-action-improvements-and-more/" completionHandler:^(JBRWebpageContentResponse * webpageContentResponse) {
        XCTAssertNotNil(webpageContentResponse);
        secondAccessToken = [service currentAccessToken];
        [secondPageExpectation fulfill];
    }];
    [self waitForExpectations:@[secondPageExpectation]];
    
    XCTAssertNotNil(firstAccessToken);
    XCTAssertNotNil(secondAccessToken);
    XCTAssertEqualObjects(firstAccessToken.accessToken, secondAccessToken.accessToken);
}

- (void) testMultipleSimultaneousAccessTokenRequests {
    JBRWebpageTextService* service = [JBRWebpageTextService createTestableInstance];
    
    __block JBRAccessTokenResponse* firstAccessTokenResponse;
    __block JBRAccessTokenResponse* secondAccessTokenResponse;
    
    XCTestExpectation* firstExpectation = [self expectationWithDescription:@"first expectation"];
    XCTestExpectation* secondExpectation = [self expectationWithDescription:@"second expectation"];
    
    [service getAccessTokenWithCompletionHandler:^(JBRAccessTokenResponse * accessTokenResponse) {
        firstAccessTokenResponse = accessTokenResponse;
        [firstExpectation fulfill];
    }];
    
    [service getAccessTokenWithCompletionHandler:^(JBRAccessTokenResponse * accessTokenResponse) {
        secondAccessTokenResponse = accessTokenResponse;
        [secondExpectation fulfill];
    }];
    
    [self waitForExpectations:@[firstExpectation, secondExpectation]];
    
    XCTAssertNotNil(firstAccessTokenResponse);
    XCTAssertNotNil(secondAccessTokenResponse);
    XCTAssertEqualObjects(firstAccessTokenResponse.accessToken, secondAccessTokenResponse.accessToken);
    
    // Verify that the callbacks have been removed, so they will
    // not be called again.
    XCTAssertNil(service.accessTokenCallbacks);
}

@end
