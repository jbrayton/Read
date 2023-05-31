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
            [attachment loadItemForTypeIdentifier:@"public.url" options:nil completionHandler:^(__kindof id<NSSecureCoding> item, NSError * _Null_unspecified error) {
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
    Safari tends to bring itself to the foreground after the extension is dismissed.
    Therefore this method opens the Read app as follows:
    - It immediately opens a read-http(s):// URL in the background (activates: NO),
      so that the article immediately begins to load.
    - It dismisses the extension with `completeRequestReturningItems`.
    - After 0.25 seconds it opens the URL "read:" in the foreground (activates: YES). The app does not do anything with that URL, but it brings the app to the foreground.
 */
- (void) openUrlString:(NSString*) inputUrlString {
    __weak JBRShareViewController* weakSelf = self;
    NSString* outputUrlString = [NSString stringWithFormat:@"read-%@", inputUrlString];
    NSURL* outputUrl = [NSURL URLWithString:outputUrlString];
    if (outputUrl) {
        NSWorkspaceOpenConfiguration* config = [[NSWorkspaceOpenConfiguration alloc] init];
        [config setActivates:NO];
        [[NSWorkspace sharedWorkspace] openURL:outputUrl configuration:config completionHandler:^(NSRunningApplication * app, NSError * error) {
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.25 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [config setActivates:YES];
            NSURL* bringToFrontUrl = [NSURL URLWithString:@"read:"];
            [[NSWorkspace sharedWorkspace] openURL:bringToFrontUrl configuration:config completionHandler:^(NSRunningApplication * app, NSError * error) {
            }];
        });
        [weakSelf.extensionContext completeRequestReturningItems:@[[[NSExtensionItem alloc] init]] completionHandler:nil];
    }
}

@end

