//
//  JBRReaderViewController.m
//  Read
//
//  Created by John Brayton on 5/28/23.
//

#import "JBRReaderViewController.h"
#import "JBRURLBarViewController.h"
@import WebKit;

@interface JBRReaderViewController ()

@property (nonatomic, strong, nonnull) WKWebView* webView;

@end

@implementation JBRReaderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView = [[WKWebView alloc] init];
    self.webView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.webView];
    [self.view addConstraints:@[
        [self.webView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.webView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.webView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [self.webView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ]];
    
}

- (void)urlBarViewController:(JBRURLBarViewController *)urlBarViewController urlStringChangedTo:(NSString *)urlString {
    NSURL* url = [NSURL URLWithString:urlString];
    if (url) {
        NSURLRequest* request = [[NSURLRequest alloc] initWithURL:url];
        [self.webView loadRequest:request];
    }
}

@end
