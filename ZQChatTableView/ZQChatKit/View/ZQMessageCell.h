//
//  ZQMessageCell.h
//  ZQChatTableView
//
//  Created by zzq on 2018/6/29.
//  Copyright © 2018年 zzq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZQMessageContentView.h"

@class ZQMessageCell;
@class ZQMessageFrame;

@protocol ZQMessageCellDelegate <NSObject>
@optional
- (void)chatCell:(ZQMessageCell *)cell headImageDidClick:(NSString *)userId;
- (void)chatCell:(ZQMessageCell *)cell contentButtonClick:(NSString *)userId;
@end

@interface ZQMessageCell : UITableViewCell

@property (nonatomic, strong) ZQMessageFrame *messageFrame;
@property (nonatomic, weak) id<ZQMessageCellDelegate> delegate;


/**
 发送方文字颜色
 */
@property (nonatomic, strong) UIColor *senderTextColor;

/**
 接受方文字颜色
 */
@property (nonatomic, strong) UIColor *reciveTextColor;

/**
 聊天背景颜色
 */
@property (nonatomic, strong) UIColor *backViewColor;

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
