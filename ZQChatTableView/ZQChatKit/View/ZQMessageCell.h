//
//  ZQMessageCell.h
//  ZQChatTableView
//
//  Created by zzq on 2018/6/29.
//  Copyright © 2018年 zzq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZQMessageContentView.h"
#import "ZQLoadingButton.h"

@class ZQMessageCell;
@class ZQMessageFrame;
@class ZQMessage;

@protocol ZQMessageCellDelegate <NSObject>
@optional
// tap
- (void)chatCell:(ZQMessageCell *)cell headImageDidClick:(NSString *)userId;
- (void)chatCell:(ZQMessageCell *)cell contentButtonClick:(NSString *)userId;
- (void)chatCell:(ZQMessageCell *)cell voiceButtonClick:(NSString *)userId;
- (void)chatCell:(ZQMessageCell *)cell voiceDidFinish:(NSString *)userId;
- (void)chatCell:(ZQMessageCell *)cell videoButtonClick:(NSString *)userId;
- (void)chatCell:(ZQMessageCell *)cell failureButton:(ZQLoadingButton *)button Clicked:(NSString *)userId;

@end

@interface ZQMessageCell : UITableViewCell

@property (nonatomic, strong) ZQMessageFrame *messageFrame;
@property (nonatomic, weak) id<ZQMessageCellDelegate> delegate;

@property (nonatomic, strong) ZQMessageContentView *btnContent;

/**
 发送方文字颜色
 */
@property (nonatomic, strong) UIColor *senderTextColor;

/**
 接受方文字颜色
 */
@property (nonatomic, strong) UIColor *reciveTextColor;

/**
 发送方聊天气泡图片
 */
@property (nonatomic, strong) UIImage *senderBubbleImage;

/**
 接受方聊天气泡图片
 */
@property (nonatomic, strong) UIImage *reciveBubbleImage;

/**
 发送方头像图片
 */
@property (nonatomic, strong) UIImage *senderAvatarImage;

/**
 接受方头像图片
 */
@property (nonatomic, strong) UIImage *reciveAvatarImage;

@end
