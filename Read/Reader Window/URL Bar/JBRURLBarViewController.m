//
//  JBRURLBarViewController.m
//  Read
//
//  Created by John Brayton on 5/28/23.
//

#import "JBRURLBarViewController.h"
#import "JBRURLBarTextField.h"

@interface JBRURLBarViewController ()

@property (nonatomic, strong, nullable) NSTextField* urlTextField;

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
}

- (void) makeUrlBarFirstResponder {
    [self.urlTextField becomeFirstResponder];
}

#pragma mark - NSTextFieldDelegate

- (void) handleUrlStringChanged:(NSTextField*) urlStringField {
    NSString* urlString = [urlStringField stringValue];

    // If the URL is something like "apple.com", prepend "https://".
    if ([urlString rangeOfString:@":/"].location == NSNotFound) {
        urlString = [NSString stringWithFormat:@"https://%@", urlString];
        [self.urlTextField setStringValue:urlString];
    }
    
    [self.delegate urlBarViewController:self urlStringChangedTo:urlString];
}

@end
