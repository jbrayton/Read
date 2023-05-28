//
//  JBRURLBarTextField.m
//  Read
//
//  Created by John Brayton on 5/28/23.
//

#import "JBRURLBarTextField.h"
#import "JBRURLBarTextFieldCell.h"

@implementation JBRURLBarTextField

+(void)load {
    [self setCellClass:[JBRURLBarTextFieldCell class]];
}

@end
