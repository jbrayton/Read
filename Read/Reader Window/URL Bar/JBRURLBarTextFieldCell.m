//
//  JBRURLBarTextFieldCell.m
//  Read
//
//  Created by John Brayton on 5/28/23.
//

#import "JBRURLBarTextFieldCell.h"

/*
    I wanted a somewhat tall-looking text field with the text vertically centered, like Safari. This subclass of NSTextFieldCell
    insets the text.
 */
@implementation JBRURLBarTextFieldCell

- (NSRect) adjustedFrameToVerticallyCenterTextFromRect:(NSRect) rect {
    return NSInsetRect(rect, 4.0, 3.0);
}

- (void) editWithFrame:(NSRect)rect inView:(NSView *)controlView editor:(NSText *)textObj delegate:(id)delegate event:(NSEvent *)event {
    [super editWithFrame:[self adjustedFrameToVerticallyCenterTextFromRect:rect] inView:controlView editor:textObj delegate:delegate event:event];
}

- (void) selectWithFrame:(NSRect)rect inView:(NSView *)controlView editor:(NSText *)textObj delegate:(id)delegate start:(NSInteger)selStart length:(NSInteger)selLength {
    [super selectWithFrame:[self adjustedFrameToVerticallyCenterTextFromRect:rect] inView:controlView editor:textObj delegate:delegate start:selStart length:selLength];
}

- (void) drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
    [super drawInteriorWithFrame:[self adjustedFrameToVerticallyCenterTextFromRect:cellFrame] inView:controlView];
}

@end
