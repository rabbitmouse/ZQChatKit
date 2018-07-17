//
//  UIImageView+ZQChat.h
//  ZQChatTableView
//
//  Created by zzq on 2018/7/16.
//  Copyright © 2018年 zzq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZQMessageEnable.h"

@interface UIImageView (ZQChat)
+ (UIImageView *)messageVoiceAnimationImageViewWithBubbleMessageType:(ZQBubbleMessageType)type;
@end
