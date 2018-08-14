//
//  ZQTextToolView.m
//  ZQChatTableView
//
//  Created by zzq on 2018/7/4.
//  Copyright © 2018年 zzq. All rights reserved.
//

#import "ZQTextToolView.h"
#import <AVFoundation/AVFoundation.h>
#import "ZQChatDefault.h"

@interface ZQTextToolView() <UITextViewDelegate, AVAudioRecorderDelegate> {
    BOOL _isbeginVoiceRecord;
    CGFloat _playTime;
    NSString *_docmentFilePath;
}

@property (nonatomic, strong) NSTimer *playTimer;
@property (nonatomic, strong) AVAudioRecorder *recorder;
/**
 *  是否取消錄音
 */
@property (nonatomic, assign, readwrite) BOOL isCancelled;

/**
 *  是否正在錄音
 */
@property (nonatomic, assign, readwrite) BOOL isRecording;

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
    self.recordButton.layer.cornerRadius = 4.f;
    self.recordButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.recordButton.layer.borderWidth = 0.75f;
}

#pragma mark - private methods

- (IBAction)panGesture:(UIPanGestureRecognizer *)ges {
    if (ges.state == UIGestureRecognizerStateEnded) {
        [self commitTranslation:[ges translationInView:self]];
    }
}

- (void)commitTranslation:(CGPoint)translation {
    
    CGFloat absX = fabs(translation.x);
    CGFloat absY = fabs(translation.y);
    
    // 设置滑动有效距离
    if (MAX(absX, absY) < 5)
        return;

    if (absY > absX) {
        if (translation.y < 0) {
            //向上滑动
        } else {
            //向下滑动
            if (self.delegate && [self.delegate respondsToSelector:@selector(viewDidPan)]) {
                [self.delegate viewDidPan];
            }
        }
    }
}

#pragma mark - action
- (IBAction)mediaBtnClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedMultipleMediaAction)]) {
        [self.delegate didSelectedMultipleMediaAction];
    }
}
- (IBAction)voiceBtnClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedVoiceMediaAction)]) {
        [self.delegate didSelectedVoiceMediaAction];
    }
}

- (IBAction)recordButtonDown:(UIButton *)sender {
    [sender setTitle:@"松开结束" forState:UIControlStateNormal];
    self.isCancelled = NO;
    self.isRecording = NO;
    if ([self.delegate respondsToSelector:@selector(prepareRecordingVoiceActionWithCompletion:)]) {
        WEAKSELF
        
        //這邊回調 return 的 YES, 或 NO, 可以讓底層知道該次錄音是否成功, 進而處理無用的 record 對象
        [self.delegate prepareRecordingVoiceActionWithCompletion:^BOOL{
            STRONGSELF
            
            //這邊要判斷回調回來的時候, 使用者是不是已經早就鬆開手了
            if (strongSelf && !strongSelf.isCancelled) {
                strongSelf.isRecording = YES;
                [strongSelf.delegate didStartRecordingVoiceAction];
                return YES;
            } else {
                return NO;
            }
        }];
    }
}
- (IBAction)recordButtonOutside:(id)sender {
    //如果已經開始錄音了, 才需要做拖曳出去的動作, 否則只要切換 isCancelled, 不讓錄音開始.
    if (self.isRecording) {
        if ([self.delegate respondsToSelector:@selector(didDragOutsideAction)]) {
            [self.delegate didDragOutsideAction];
        }
    } else {
        self.isCancelled = YES;
    }
}
- (IBAction)recordButtonInside:(id)sender {
    //如果已經開始錄音了, 才需要做拖曳回來的動作, 否則只要切換 isCancelled, 不讓錄音開始.
    if (self.isRecording) {
        if ([self.delegate respondsToSelector:@selector(didDragInsideAction)]) {
            [self.delegate didDragInsideAction];
        }
    } else {
        self.isCancelled = YES;
    }
}
- (IBAction)recordButtonUpInside:(id)sender {
    [sender setTitle:@"按住说话" forState:UIControlStateNormal];
    //如果已經開始錄音了, 才需要做結束的動作, 否則只要切換 isCancelled, 不讓錄音開始.
    if (self.isRecording) {
        if ([self.delegate respondsToSelector:@selector(didFinishRecoingVoiceAction)]) {
            [self.delegate didFinishRecoingVoiceAction];
        }
    } else {
        self.isCancelled = YES;
    }
}
- (IBAction)recordButtonUpOutside:(id)sender {
    [sender setTitle:@"按住说话" forState:UIControlStateNormal];
    //如果已經開始錄音了, 才需要做取消的動作, 否則只要切換 isCancelled, 不讓錄音開始.
    if (self.isRecording) {
        if ([self.delegate respondsToSelector:@selector(didCancelRecordingVoiceAction)]) {
            [self.delegate didCancelRecordingVoiceAction];
        }
    } else {
        self.isCancelled = YES;
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
