//
//  ZQTextToolView.m
//  ZQChatTableView
//
//  Created by zzq on 2018/7/4.
//  Copyright © 2018年 zzq. All rights reserved.
//

#import "ZQTextToolView.h"
#import <AVFoundation/AVFoundation.h>

@interface ZQTextToolView() <UITextViewDelegate, AVAudioRecorderDelegate> {
    BOOL _isbeginVoiceRecord;
    NSInteger _playTime;
    NSString *_docmentFilePath;
}

@property (nonatomic, strong) NSTimer *playTimer;
@property (nonatomic, strong) AVAudioRecorder *recorder;

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
- (void)countVoiceTime {
    _playTime ++;
    if (_playTime >= 60) {
        [self endRecordVoice:self.recordButton];
    }
}

- (void)endRecordVoice:(UIButton *)button
{
    [_recorder stop];
    [_playTimer invalidate];
    _playTimer = nil;
    //缓冲消失时间 (最好有block回调消失完成)
    [button setTitle:@"按住说话" forState:UIControlStateNormal];
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
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *err = nil;
    [audioSession setCategory :AVAudioSessionCategoryRecord error:&err];
    if (err) {
        NSLog(@"audioSession: %@ %zd %@", [err domain], [err code], [[err userInfo] description]);
        return;
    }
    [audioSession setActive:YES error:&err];
    if (err) {
        NSLog(@"audioSession: %@ %zd %@", [err domain], [err code], [[err userInfo] description]);
        return;
    }
    
    NSDictionary *recordSetting = @{
                                    AVEncoderAudioQualityKey : [NSNumber numberWithInt:AVAudioQualityMin],
                                    AVEncoderBitRateKey : [NSNumber numberWithInt:16],
                                    AVFormatIDKey : [NSNumber numberWithInt:kAudioFormatLinearPCM],
                                    AVNumberOfChannelsKey : @2,
                                    AVLinearPCMBitDepthKey : @8
                                    };
    NSError *error = nil;
    NSString *docments = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    _docmentFilePath = [NSString stringWithFormat:@"%@/%@",docments,@"123"];
    
    NSURL *pathURL = [NSURL fileURLWithPath:_docmentFilePath];
    _recorder = [[AVAudioRecorder alloc] initWithURL:pathURL settings:recordSetting error:&error];
    if (error || !_recorder) {
        NSLog(@"recorder: %@ %zd %@", [error domain], [error code], [[error userInfo] description]);
        return;
    }
    _recorder.delegate = self;
    [_recorder prepareToRecord];
    _recorder.meteringEnabled = YES;
    
    [_recorder record];
    _playTime = 0;
    _playTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countVoiceTime) userInfo:nil repeats:YES];
}
- (IBAction)recordButtonFinish:(UIButton *)sender {
    [self endRecordVoice:sender];
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

#pragma mark - AVAudioRecorderDelegate

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    NSURL *url = [NSURL fileURLWithPath:_docmentFilePath];
    NSError *err = nil;
    NSData *audioData = [NSData dataWithContentsOfFile:[url path] options:0 error:&err];
    if (audioData) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didSendVoiceAction:)]) {
            [self.delegate didSendVoiceAction:audioData];
        }
        self.recordButton.enabled = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.recordButton.enabled = YES;
        });
    }
}

@end
