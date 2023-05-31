//
//  JBRShareViewController.m
//  Read Share Extension
//
//  Created by John Brayton on 5/30/23.
//

#import "JBRShareViewController.h"

@interface JBRShareViewController ()

@property (nonatomic, strong) NSTextField* errorTextField;

@end

@implementation JBRShareViewController

/*
    A share extension principal class requires a view controller, but I do not want a user interface. So I create
    a hidden view.
 */
- (void)loadView {
    self.view = [[NSView alloc] initWithFrame:CGRectMake(0.0, 0.0, 400.0, 250.0)];
    self.view.hidden = YES;
}

- (void) viewDidLoad {
    __weak JBRShareViewController* weakSelf = self;
    [super viewDidLoad];
    NSExtensionItem *item = self.extensionContext.inputItems.firstObject;
    for( NSItemProvider* attachment in [item attachments] ) {
        if ([attachment hasItemConformingToTypeIdentifier:@"public.url"]) {
            [attachment loadItemForTypeIdentifier:@"public.url" options:nil completionHandler:^(__kindof id<NSSecureCoding>  _Nullable item, NSError * _Null_unspecified error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSData* data = (NSData*) item;
                    NSURL* inputUrl = [[NSURL alloc] initWithDataRepresentation:data relativeToURL:nil];
                    [weakSelf openUrlString:[inputUrl absoluteString]];
                });
            }];
            return;
        }
    }
    
    // We should never get here. If we do, cancel out.
    NSError *cancelError = [NSError errorWithDomain:NSCocoaErrorDomain code:NSUserCancelledError userInfo:nil];
    [self.extensionContext cancelRequestWithError:cancelError];
}

/*
    Safari tends to bring itself to the foreground after the extension is dismissed. So we dismiss the extension
    and then send the URL to Read 0.5 seconds later so that the end result is Read being in the foreground.
 */
- (void) openUrlString:(NSString*) inputUrlString {
    __weak JBRShareViewController* weakSelf = self;
    NSString* outputUrlString = [NSString stringWithFormat:@"read-%@", inputUrlString];
    NSURL* outputUrl = [NSURL URLWithString:outputUrlString];
    if (outputUrl) {
        NSWorkspaceOpenConfiguration* config = [[NSWorkspaceOpenConfiguration alloc] init];
        [config setActivates:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [[NSWorkspace sharedWorkspace] openURL:outputUrl configuration:config completionHandler:^(NSRunningApplication * _Nullable app, NSError * _Nullable error) {
            }];
        });
        [weakSelf.extensionContext completeRequestReturningItems:@[[[NSExtensionItem alloc] init]] completionHandler:nil];
    }
}

@end

