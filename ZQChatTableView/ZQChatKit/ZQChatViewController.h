//
//  ZQChatViewController.h
//  ZQChatTableView
//
//  Created by zzq on 2018/6/29.
//  Copyright © 2018年 zzq. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ZQChatTableView.h"

#import "ZQMessage.h"
#import "ZQMessageFrame.h"
#import "ZQChatDefault.h"

#import "ZQMenuItem.h"


typedef NS_ENUM(NSUInteger, ZQChatInputViewType) {
    ZQChatInputViewTypeNormal = 0 << 1,
    ZQChatInputViewTypeText,
    ZQChatInputViewTypeTool,
};


@protocol ZQMessageTableViewControllerDelegate <NSObject>

@optional
/**
 *  发送文本消息的回调方法
 *
 *  @param text   目标文本字符串
 *  @param sender 发送者的名字
 *  @param date   发送时间
 */
- (void)didSendText:(NSString *)text fromSender:(NSString *)sender onDate:(NSDate *)date;

/**
 *  发送图片消息的回调方法
 *
 *  @param photo  目标图片对象，后续有可能会换
 *  @param sender 发送者的名字
 *  @param date   发送时间
 */
- (void)didSendPhoto:(UIImage *)photo fromSender:(NSString *)sender onDate:(NSDate *)date;

/**
 *  发送视频消息的回调方法
 *
 *  @param videoConverPhoto 目标视频的封面图
 *  @param videoPath        目标视频本地路径
 *  @param sender           发送者的名字
 *  @param date             发送时间
 */
- (void)didSendVideoConverPhoto:(UIImage *)videoConverPhoto videoPath:(NSString *)videoPath fromSender:(NSString *)sender onDate:(NSDate *)date;

/**
 *  发送语音消息的回调方法
 *
 *  @param voicePath        目标语音本地路径
 *  @param voiceDuration    目标语音时长
 *  @param sender           发送者的名字
 *  @param date             发送时间
 */
- (void)didSendVoice:(NSString *)voicePath voiceDuration:(NSString*)voiceDuration fromSender:(NSString *)sender onDate:(NSDate *)date;

/**
 *  判断是否支持下拉加载更多消息
 *
 *  @return 返回BOOL值，判定是否拥有这个功能
 */
- (BOOL)shouldLoadMoreMessagesScrollToTop;

/**
 *  下拉加载更多消息，只有在支持下拉加载更多消息的情况下才会调用。
 */
- (void)loadMoreMessagesScrollTotop;

/**
 *  自定义菜单栏，需要传入DataSource
 */
- (NSMutableArray<ZQMenuItem *> *)loadCustomMenus;

/**
 *  自定义菜单，接受事件
 */
- (void)customMenusDidSelectItem:(NSIndexPath *)indexPath;

@end


@interface ZQChatViewController : UIViewController <ZQMessageTableViewControllerDelegate>

@property (weak, nonatomic) IBOutlet ZQChatTableView *tableview;

@property (nonatomic, weak) id<ZQMessageTableViewControllerDelegate> delegate;

@property (nonatomic, assign, readonly) ZQChatInputViewType inputViewType;

@property (nonatomic, strong) NSMutableArray *dataSource;

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

//滚到底部
- (void)scrollToBottomAnimated:(BOOL)animated;

@end
