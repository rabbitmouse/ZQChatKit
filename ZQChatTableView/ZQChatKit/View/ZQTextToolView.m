//
//  ZQTextToolView.m
//  ZQChatTableView
//
//  Created by zzq on 2018/7/4.
//  Copyright © 2018年 zzq. All rights reserved.
//

#import "ZQTextToolView.h"

@interface ZQTextToolView() <UITextViewDelegate>

@end

@implementation ZQTextToolView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.inputTextView.delegate = self;
}

- (IBAction)mediaBtnClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedMultipleMediaAction)]) {
        [self.delegate didSelectedMultipleMediaAction];
    }
}

#pragma mark - Message input view

+ (CGFloat)textViewLineHeight {
    return 36.0f; // for fontSize 16.0f
}

+ (CGFloat)maxLines {
    return ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) ? 3.0f : 8.0f;
}

+ (CGFloat)maxHeight {
    return ([ZQTextToolView maxLines] + 1.0f) * [ZQTextToolView textViewLineHeight];
}

#pragma mark - Text view delegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if ([self.delegate respondsToSelector:@selector(inputTextViewWillBeginEditing:)]) {
        [self.delegate inputTextViewWillBeginEditing:self.inputTextView];
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    [textView becomeFirstResponder];
    if ([self.delegate respondsToSelector:@selector(inputTextViewDidBeginEditing:)]) {
        [self.delegate inputTextViewDidBeginEditing:self.inputTextView];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    [textView resignFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        if ([self.delegate respondsToSelector:@selector(didSendTextAction:)]) {
            [self.delegate didSendTextAction:textView.text];
        }
        return NO;
    }
    return YES;
}
@end
