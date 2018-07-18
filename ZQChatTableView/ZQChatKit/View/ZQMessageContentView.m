//
//  ZQMessageContentView.m
//  ZQChatTableView
//
//  Created by zzq on 2018/6/29.
//  Copyright © 2018年 zzq. All rights reserved.
//

#define voiceBubbleMargin 8.0f // 文本、视频、表情气泡上下边的间隙
#define voiceBubbleVoiceMargin 13.5f // 语音气泡上下边的间隙

#define voiceMargin 20.0f // 播放语音时的动画控件距离头像的间隙
#define voiceUnReadDotSize 10.0f // 语音未读的红点大小

#import "ZQMessageContentView.h"
#import "UIImageView+WebCache.h"
#import "UIImageView+ZQChat.h"

@interface ZQMessageContentView() {
    UIActivityIndicatorView *_indicator;
}

@end

@implementation ZQMessageContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //图片
        if (!self.backImageView) {
            self.backImageView = [[UIImageView alloc] init];
            self.backImageView.layer.cornerRadius = 5;
            self.backImageView.layer.masksToBounds  = YES;
            self.backImageView.contentMode = UIViewContentModeScaleAspectFill;
            [self addSubview:self.backImageView];
            
            UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
            [self.backImageView addSubview:indicator];
            _indicator = indicator;
        }
        
        if (!self.voiceDurationLabel) {
            UILabel *voiceDurationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, voiceBubbleMargin , 28, 30)];
            voiceDurationLabel.textColor = [UIColor colorWithWhite:0.579 alpha:1.000];
            voiceDurationLabel.backgroundColor = [UIColor clearColor];
            voiceDurationLabel.font = [UIFont systemFontOfSize:13.f];
            voiceDurationLabel.textAlignment = NSTextAlignmentCenter;
            voiceDurationLabel.hidden = YES;
            [self addSubview:voiceDurationLabel];
            self.voiceDurationLabel = voiceDurationLabel;
        }
        
        if (!_videoPlayImageView) {
            UIImageView *videoPlayImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MessageVideoPlay"]];
            [self addSubview:videoPlayImageView];
            _videoPlayImageView = videoPlayImageView;
        }
        
        if (!_voiceUnreadDotImageView) {
            NSString *voiceUnreadImageName = @"msg_chat_voice_unread";
            
            UIImageView *voiceUnreadDotImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, voiceUnReadDotSize, voiceUnReadDotSize)];
            voiceUnreadDotImageView.image = [UIImage imageNamed:voiceUnreadImageName];
            voiceUnreadDotImageView.hidden = YES;
            [self addSubview:voiceUnreadDotImageView];
            _voiceUnreadDotImageView = voiceUnreadDotImageView;
        }
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // 配置图片
    self.backImageView.frame = self.bounds;
    _indicator.center = self.backImageView.center;
    
    // 配置语音播放的位置
    CGRect bubbleFrame = self.bounds;
    CGRect animationVoiceImageViewFrame = self.animationVoiceImageView.frame;
    CGFloat voiceImagePaddingX = CGRectGetMaxX(bubbleFrame) - voiceMargin - CGRectGetWidth(animationVoiceImageViewFrame);
    if (self.message.bubbleMessageType == ZQBubbleMessageTypeReceive) {
        voiceImagePaddingX = CGRectGetMinX(bubbleFrame) + voiceMargin;
    }
    animationVoiceImageViewFrame.origin = CGPointMake(voiceImagePaddingX, CGRectGetMidY(bubbleFrame) - CGRectGetHeight(animationVoiceImageViewFrame) / 2.0);  // 垂直居中
    self.animationVoiceImageView.frame = animationVoiceImageViewFrame;
    
    [self configureVoiceUnreadDotImageViewFrameWithBubbleFrame:bubbleFrame];
    [self configureVoiceDurationLabelFrameWithBubbleFrame:bubbleFrame];
}

#pragma mark - config UI
- (void)configureVoiceDurationLabelFrameWithBubbleFrame:(CGRect)bubbleFrame {
    CGRect voiceFrame = _voiceDurationLabel.frame;
    voiceFrame.origin.x = (self.message.bubbleMessageType == ZQBubbleMessageTypeSend ? CGRectGetMinX(_animationVoiceImageView.frame) - CGRectGetWidth(voiceFrame) - 2 : CGRectGetMaxX(_animationVoiceImageView.frame) + 2);
    _voiceDurationLabel.frame = voiceFrame;
}

- (void)configureVoiceUnreadDotImageViewFrameWithBubbleFrame:(CGRect)bubbleFrame {
    CGRect voiceUnreadDotFrame = _voiceUnreadDotImageView.frame;
    voiceUnreadDotFrame.origin.x = (self.message.bubbleMessageType == ZQBubbleMessageTypeSend ? bubbleFrame.origin.x + voiceUnReadDotSize : CGRectGetMaxX(bubbleFrame) - voiceUnReadDotSize * 2);
    voiceUnreadDotFrame.origin.y = CGRectGetMidY(bubbleFrame) - voiceUnReadDotSize / 2.0;
    _voiceUnreadDotImageView.frame = voiceUnreadDotFrame;
}

- (void)hiddenContentViews {
    switch (self.message.messageMediaType) {
        case ZQBubbleMessageMediaTypeText:
            self.backImageView.hidden = YES;
            self.animationVoiceImageView.hidden = YES;
            self.voiceDurationLabel.hidden = YES;
            self.videoPlayImageView.hidden = YES;
            self.animationVoiceImageView.hidden = YES;
            self.voiceUnreadDotImageView.hidden = YES;
            break;
        case ZQBubbleMessageMediaTypePhoto:
            self.backImageView.hidden = NO;
            self.animationVoiceImageView.hidden = YES;
            self.voiceDurationLabel.hidden = YES;
            self.videoPlayImageView.hidden = YES;
            self.animationVoiceImageView.hidden = YES;
            self.voiceUnreadDotImageView.hidden = YES;
            break;
        case ZQBubbleMessageMediaTypeVoice:
            self.backImageView.hidden = YES;
            self.animationVoiceImageView.hidden = NO;
            self.voiceDurationLabel.hidden = NO;
            self.videoPlayImageView.hidden = NO;
            self.animationVoiceImageView.hidden = NO;
            self.voiceUnreadDotImageView.hidden = self.message.isRead;
            break;
        default:
            break;
    }
}

#pragma mark - setter
- (void)setMessage:(ZQMessage *)message {
    _message = message;
    
    [self hiddenContentViews];
    
    switch (_message.messageMediaType) {
        case ZQBubbleMessageMediaTypePhoto: {
            self.imageView.contentMode = UIViewContentModeScaleAspectFit;
            UIImage *defualtPhoto = [UIImage imageNamed:@"defualtPhoto"];
            if (message.photo) {
                self.backImageView.image = message.photo;
            } else if (message.thumbnailUrl) {
                [_indicator startAnimating];
                [self.backImageView sd_setImageWithURL:[NSURL URLWithString:message.thumbnailUrl] placeholderImage:defualtPhoto completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                    [_indicator stopAnimating];
                }];
            } else if (message.originPhotoUrl) {
                [_indicator startAnimating];
                [self.backImageView sd_setImageWithURL:[NSURL URLWithString:message.originPhotoUrl] placeholderImage:defualtPhoto completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                    [_indicator stopAnimating];
                }];
            } else {
                self.backImageView.image = defualtPhoto;
            }
        }
            break;
        case ZQBubbleMessageMediaTypeVoice: {
            [_animationVoiceImageView removeFromSuperview];
            _animationVoiceImageView = nil;
            
            UIImageView *animationVoiceImageView = [UIImageView messageVoiceAnimationImageViewWithBubbleMessageType:message.bubbleMessageType];
            [self addSubview:animationVoiceImageView];
            self.animationVoiceImageView = animationVoiceImageView;
            
            self.voiceDurationLabel.text = [NSString stringWithFormat:@"%ld\'\'", message.voiceDuration];
        }
            break;
            
        default:
            break;
    }
}


@end
