//
//  JBRReaderViewController.m
//  Read
//
//  Created by John Brayton on 5/28/23.
//

#import "JBRReaderViewController.h"
#import "JBRBundleSchemeHandler.h"
#import "JBRHTMLGenerator.h"
#import "JBRReaderWebView.h"
#import "JBRURLBarViewController.h"
#import "JBRWebpageContentResponse.h"
#import "JBRWebpageTextService.h"
@import WebKit;

@interface JBRReaderViewController ()<WKNavigationDelegate>

@property (nonatomic, strong, nonnull) WKWebView* webView;

@property (nonatomic, strong, nullable) NSString* currentUrlString;

// Use this to avoid race condition, where:
// 1. User enters a URL.
// 2. We start to retrieve webpage text, but it takes a while.
// 3. User enters a second URL.
// 4. We get the webpage text for the prior URL that the user no longer wants.
// We increment this when the user requests a new URL. If the value does not match the value it had
// when we requested the webpage text, we ignore the response.
@property (nonatomic, assign) NSInteger currentRequestCounter;

// These are non-nil and shown when we cannot generate webpage text for the specified URL.
@property (nonatomic, strong, nullable) NSTextField* webpageTextUnavailableLabel;
@property (nonatomic, strong, nullable) NSButton* tryAgainButton;

@end

@implementation JBRReaderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WKWebViewConfiguration* configuration = [[WKWebViewConfiguration alloc] init];
    [configuration setURLSchemeHandler:[[JBRBundleSchemeHandler alloc] init] forURLScheme:@"bundle"];
    
    self.webView = [[JBRReaderWebView alloc] initWithFrame:CGRectZero configuration:configuration];
    self.webView.translatesAutoresizingMaskIntoConstraints = NO;
    self.webView.navigationDelegate = self;
    [self.view addSubview:self.webView];
    [self.view addConstraints:@[
        [self.webView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.webView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.webView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [self.webView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ]];
    self.currentRequestCounter = 0;
}

- (void)urlBarViewController:(JBRURLBarViewController *)urlBarViewController urlStringChangedTo:(NSString *)urlString {
    [self startLoadingUrlString:urlString];
}

- (void) startLoadingUrlString:(NSString *)urlString {
    __weak JBRReaderViewController* weakSelf = self;
    self.currentRequestCounter += 1;
    self.currentUrlString = urlString;
    NSInteger initialCurrentRequestCounter = self.currentRequestCounter;
    [self.loadingDelegate readerViewController:self setLoadingPage:YES];
    [[JBRWebpageTextService shared] getWebpageContentForUrlString:urlString completionHandler:^(JBRWebpageContentResponse * _Nullable webpageContentResponse) {
        if (initialCurrentRequestCounter == weakSelf.currentRequestCounter) {
            
            // Let the loadingDelegate know that we are done. Put "self" into "strongSelf" so that we do not
            // create a memory leak, and to ensure that we do not end up passing a readerViewController value of "nil".
            __weak JBRReaderViewController* strongSelf = self;
            if (strongSelf) {
                [strongSelf.loadingDelegate readerViewController:strongSelf setLoadingPage:NO];
            }
            
            if (weakSelf.webpageTextUnavailableLabel) {
                [weakSelf.webpageTextUnavailableLabel removeFromSuperview];
                weakSelf.webpageTextUnavailableLabel = nil;
                [weakSelf.tryAgainButton removeFromSuperview];
                weakSelf.tryAgainButton = nil;
            }
            if (webpageContentResponse) {
                [weakSelf showWebpageContentResponse:webpageContentResponse];
            } else {
                [weakSelf showFailureToLoad];
            }
        }
    }];
}

- (void) showWebpageContentResponse:(JBRWebpageContentResponse*) webpageContentResponse {
    NSString* html = [JBRHTMLGenerator generateForWebpageContentResponse:webpageContentResponse];
    [self.webView loadHTMLString:html baseURL:nil];
}

- (void) showFailureToLoad {
    [self.webView loadHTMLString:@"" baseURL:nil];
    NSString* errorMessage = NSLocalizedString(@"Unable to generate webpage text for this URL.", @"");
    self.webpageTextUnavailableLabel = [[NSTextField alloc] init];
    self.webpageTextUnavailableLabel.font = [NSFont boldSystemFontOfSize:18.0];
    self.webpageTextUnavailableLabel.bordered = NO;
    self.webpageTextUnavailableLabel.drawsBackground = NO;
    self.webpageTextUnavailableLabel.editable = NO;
    self.webpageTextUnavailableLabel.stringValue = errorMessage;
    self.webpageTextUnavailableLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.webView addSubview:self.webpageTextUnavailableLabel];
    [self.webView addConstraints:@[
        [self.webpageTextUnavailableLabel.centerXAnchor constraintEqualToAnchor:self.webView.centerXAnchor],
        [self.webpageTextUnavailableLabel.topAnchor constraintEqualToAnchor:self.webView.topAnchor constant:200.0]
    ]];
    self.tryAgainButton = [[NSButton alloc] init];
    self.tryAgainButton.buttonType = NSButtonTypeMomentaryPushIn;
    self.tryAgainButton.bezelStyle = NSBezelStyleRounded;
    self.tryAgainButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.tryAgainButton.title = NSLocalizedString(@"Try Again", @"");
    self.tryAgainButton.target = self;
    self.tryAgainButton.action = @selector(handleTryAgainButton:);
    [self.webView addSubview:self.tryAgainButton];
    [self.webView addConstraints:@[
        [self.tryAgainButton.centerXAnchor constraintEqualToAnchor:self.webView.centerXAnchor],
        [self.tryAgainButton.topAnchor constraintEqualToAnchor:self.webpageTextUnavailableLabel.bottomAnchor constant:20.0]
    ]];

    NSDictionary* userInfo = @{ NSAccessibilityAnnouncementKey: errorMessage, NSAccessibilityPriorityKey: @(NSAccessibilityPriorityHigh) };
    NSAccessibilityPostNotificationWithUserInfo(self.webView, NSAccessibilityAnnouncementRequestedNotification, userInfo);
}

// MARK: Handle try again

- (void) handleTryAgainButton:(NSButton*) sender {
    [self startLoadingUrlString:self.currentUrlString];
}

// MARK: WKNavigationDelegate

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    if ((navigationAction.navigationType == WKNavigationTypeOther) && ([navigationAction.request.URL.absoluteString isEqualToString:@"about:blank"])) {
        // The navigation is the result of the app loading HTML. Allow it.
        decisionHandler(WKNavigationActionPolicyAllow);
        return;
    }
    if (navigationAction.navigationType == WKNavigationTypeLinkActivated) {
        const NSSet* allowedUrlSchemes = [NSSet setWithArray:@[@"https",@"http",@"mailto"]];
        NSString* scheme = [navigationAction.request.URL.scheme lowercaseString];
        if ((scheme) && ([allowedUrlSchemes containsObject:scheme])) {
            // The user clicked on a link to an HTTPS, HTTP, or "mailto:" link. Prevent the webview from
            // following the request, but open the link in a web browser.
            [[NSWorkspace sharedWorkspace] openURL:navigationAction.request.URL];
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }
    }
    
    // Prevent the webview from performing any other navigation action.
    decisionHandler(WKNavigationActionPolicyCancel);
}

// MARK: NSSharingServicePickerToolbarItemDelegate

- (nonnull NSArray *)itemsForSharingServicePickerToolbarItem:(nonnull NSSharingServicePickerToolbarItem *)pickerToolbarItem {
    NSMutableArray* result = [NSMutableArray array];
    NSString* currentUrlString = self.currentUrlString;
    if (currentUrlString) {
        NSURL* url = [NSURL URLWithString:currentUrlString];
        if (url) {
            [result addObject:url];
        } else {
            // If we cannot parse the URL, share the URL string.
            [result addObject:currentUrlString];
        }
    }
    
    return result;
}

@end
