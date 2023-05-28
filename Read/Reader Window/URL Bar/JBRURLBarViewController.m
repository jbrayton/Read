//
//  JBRURLBarViewController.m
//  Read
//
//  Created by John Brayton on 5/28/23.
//

#import "JBRURLBarViewController.h"
#import "JBRURLBarTextField.h"

@interface JBRURLBarViewController ()

@property (strong, nonatomic, nullable) NSTextField* urlTextField;

@end

@implementation JBRURLBarViewController

-(id) init {
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
    [self.view addSubview:self.urlTextField];
    
    // I want the URL field to be centered, but the space it is working with not centered. It is the
    // space between the close/minimize/full screen buttons and the toolbar item. The constants may need to be
    // adjusted with a future version of macOS.
    CGFloat margin = 60.0;
    CGFloat addToRightMargin = 66.0;
    [self.view addConstraints:@[
        [self.urlTextField.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:margin],
        [self.urlTextField.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:0-margin-addToRightMargin],
        [self.urlTextField.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
        [self.urlTextField.heightAnchor constraintEqualToConstant:28.0],
    ]];
}

@end
