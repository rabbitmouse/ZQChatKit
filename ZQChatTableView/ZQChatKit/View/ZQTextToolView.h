//
//  ZQTextToolView.h
//  ZQChatTableView
//
//  Created by zzq on 2018/7/4.
//  Copyright © 2018年 zzq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZQMessageTextView.h"

@protocol ZQMessageInputViewDelegate <NSObject>

@required

/**
 *  输入框刚好开始编辑
 *
 *  @param messageInputTextView 输入框对象
 */
- (void)inputTextViewDidBeginEditing:(ZQMessageTextView *)messageInputTextView;

/**
 *  输入框将要开始编辑
 *
 *  @param messageInputTextView 输入框对象
 */
- (void)inputTextViewWillBeginEditing:(ZQMessageTextView *)messageInputTextView;

@optional

/**
 *  在发送文本和语音之间发送改变时，会触发这个回调函数
 *
 *  @param changed 是否改为发送语音状态
 */
- (void)didChangeSendVoiceAction:(BOOL)changed;

/**
 *  发送文本消息，包括系统的表情
 *
 *  @param text 目标文本消息
 */
- (void)didSendTextAction:(NSString *)text;

/**
 *  发送语音消息
 *
 *  @param data 目标语音数据
 */
- (void)didSendVoiceAction:(NSData *)data;

/**
 *  点击+号按钮Action
 */
- (void)didSelectedMultipleMediaAction;

/**
 *  点击语音按钮Action
 */
- (void)didSelectedVoiceMediaAction;

@end

@interface ZQTextToolView : UIView

@property (nonatomic, weak) id <ZQMessageInputViewDelegate> delegate;

/**
 *  用于输入文本消息的输入框
 */
@property (weak, nonatomic) IBOutlet ZQMessageTextView *inputTextView;
/**
 *  用于录音的按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *recordButton;

/**
 *  获取输入框内容字体行高
 *
 *  @return 返回行高
 */
+ (CGFloat)textViewLineHeight;

/**
 *  获取最大行数
 *
 *  @return 返回最大行数
 */
+ (CGFloat)maxLines;

/**
 *  获取根据最大行数和每行高度计算出来的最大显示高度
 *
 *  @return 返回最大显示高度
 */
+ (CGFloat)maxHeight;

@end
