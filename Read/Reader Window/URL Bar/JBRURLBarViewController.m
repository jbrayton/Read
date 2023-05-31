//
//  JBRURLBarViewController.m
//  Read
//
//  Created by John Brayton on 5/28/23.
//

#import "JBRURLBarViewController.h"
#import "JBRURLBarTextField.h"
#import "JBRReaderViewController.h"

@interface JBRURLBarViewController ()<NSTextFieldDelegate>

@property (nonatomic, strong, nullable) NSTextField* urlTextField;
@property (nonatomic, strong, nullable) NSProgressIndicator* progressIndicator;

// This keeps track of whether the progress indicator should be animating.
@property (nonatomic, assign) BOOL currentlyLoading;

// When we get a response back from the server, we change the urlTextField to the
// server-specified URL. It might be different from that entered as the result of
// redirects. But we do not want to change the urlTextField if the user started entering
// a different URL. This keeps track of whether the user started entering a new URL
// while fetching the page.
@property (nonatomic, assign) BOOL urlTextFieldHasChanges;

@end

@implementation JBRURLBarViewController

-(instancetype) init {
    self = [super init];
    if (self != nil) {
        self.layoutAttribute = NSLayoutAttributeTop;
    }
    return self;
}

- (void)loadView {
    self.view = [[NSView alloc] init];
    self.urlTextField = [[JBRURLBarTextField alloc] init];
    self.urlTextField.translatesAutoresizingMaskIntoConstraints = NO;
    self.urlTextField.cell.wraps = NO;
    self.urlTextField.delegate = self;
    self.urlTextField.target = self;
    self.urlTextField.action = @selector(handleUrlStringChanged:);
    [self.view addSubview:self.urlTextField];
    
    // I want the URL field to be centered, but the space it is working in is not centered. It is the
    // space between the close/minimize/full screen buttons and the toolbar item. The constants may need to be
    // adjusted with a future version of macOS.
    const CGFloat margin = 60.0;
    const CGFloat addToRightMargin = 66.0;
    [self.view addConstraints:@[
        [self.urlTextField.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:margin],
        [self.urlTextField.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:0-margin-addToRightMargin],
        [self.urlTextField.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
        [self.urlTextField.heightAnchor constraintEqualToConstant:28.0],
    ]];
    
    self.progressIndicator = [[NSProgressIndicator alloc] init];
    self.progressIndicator.translatesAutoresizingMaskIntoConstraints = NO;
    self.progressIndicator.style = NSProgressIndicatorStyleSpinning;
    self.progressIndicator.controlSize = NSControlSizeSmall;
    self.progressIndicator.displayedWhenStopped = NO;
    [self.view addSubview:self.progressIndicator];
    [self.view addConstraints:@[
        [self.progressIndicator.leadingAnchor constraintEqualToAnchor:self.urlTextField.trailingAnchor constant:20.0],
        [self.progressIndicator.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor]
    ]];
}

- (void) makeUrlBarFirstResponder {
    [self.urlTextField becomeFirstResponder];
}

- (void) handleUrlStringChanged:(NSTextField*) urlStringField {
    NSString* urlString = [urlStringField stringValue];

    // If the URL is something like "apple.com", prepend "https://".
    if ([urlString rangeOfString:@":/"].location == NSNotFound) {
        urlString = [NSString stringWithFormat:@"https://%@", urlString];
        [self.urlTextField setStringValue:urlString];
    }
    
    [self.delegate urlBarViewController:self urlStringChangedTo:urlString];
    self.urlTextFieldHasChanges = NO;
}

#pragma mark - JBRReaderViewControllerLoadingDelegate

- (void) readerViewController:(JBRReaderViewController*) readerViewController setLoadingPage:(BOOL) loadingPage {
    if (loadingPage != _currentlyLoading) {
        _currentlyLoading = loadingPage;
        if (loadingPage) {
            [self.progressIndicator startAnimation:nil];
        } else {
            [self.progressIndicator stopAnimation:nil];
        }
    }
}

- (void) readerViewController:(JBRReaderViewController*) readerViewController urlStringSetTo:(NSString*) urlString {
    if (!self.urlTextFieldHasChanges) {
        [self.urlTextField setStringValue:urlString];
    }
}

#pragma mark - NSTextFieldDelegate

- (void) controlTextDidBeginEditing:(NSNotification *)obj {
    self.urlTextFieldHasChanges = YES;
}

@end
