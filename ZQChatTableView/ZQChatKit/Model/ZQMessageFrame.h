//
//  ZQMessageFrame.h
//  ZQChatTableView
//
//  Created by zzq on 2018/6/29.
//  Copyright © 2018年 zzq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define ChatMargin 10       //间隔
#define ChatIconWH 44       //头像宽高height、width
#define ChatPicWH 200       //图片宽高
#define ChatContentW 180    //内容宽度
#define FailBtnW 24         //失败按钮宽度

#define ChatContentTopBottom 8 //文本内容与按钮上边缘间隔
#define ChatContentBiger 20         //文本内容带角的一端
#define ChatContentSmaller 8     //文本内容不带角的一端

#define ChatTimeFont [UIFont systemFontOfSize:11]    //时间字体
#define ChatContentFont [UIFont systemFontOfSize:14] //内容字体

@class ZQMessage;
@interface ZQMessageFrame : NSObject

@property (nonatomic, assign, readonly) CGRect timeF;
@property (nonatomic, assign, readonly) CGRect iconF;
@property (nonatomic, assign, readonly) CGRect nameF;
@property (nonatomic, assign, readonly) CGRect contentF;
@property (nonatomic, assign, readonly) CGRect failBtnF;

@property (nonatomic, assign, readonly) CGFloat cellHeight;
@property (nonatomic, strong) ZQMessage *message;

@property (nonatomic, assign) BOOL showTime;
@property (nonatomic, assign) BOOL shouldShowUserName;

@end
