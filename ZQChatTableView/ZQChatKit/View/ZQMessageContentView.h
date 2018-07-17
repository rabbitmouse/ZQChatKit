//
//  ZQMessageContentView.h
//  ZQChatTableView
//
//  Created by zzq on 2018/6/29.
//  Copyright © 2018年 zzq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZQMessage.h"

@interface ZQMessageContentView : UIButton

@property (nonatomic, weak) ZQMessage *message;

//bubble imgae
@property (nonatomic, strong) UIImageView *backImageView;

/**
 *  用于显示语音的控件，并且支持播放动画
 */
@property (nonatomic, strong) UIImageView *animationVoiceImageView;

/**
 *  用于显示语音未读的控件，小圆点
 */
@property (nonatomic, strong) UIImageView *voiceUnreadDotImageView;

/**
 *  用于显示语音时长的label
 */
@property (nonatomic, strong) UILabel *voiceDurationLabel;

/**
 *  显示语音播放的图片控件
 */
@property (nonatomic, strong) UIImageView *videoPlayImageView;
@end
