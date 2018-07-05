//
//  ZQConfigStyle.h
//  ZQChatTableView
//
//  Created by 朱志勤 on 2018/7/3.
//  Copyright © 2018年 朱志勤. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface ZQConfigStyle : NSObject

@property (class, nonatomic, strong, readonly) UIColor *senderDefualtColor;
@property (class, nonatomic, strong, readonly) UIColor *reciveDefualtColor;
@property (class, nonatomic, strong, readonly) UIColor *backgroudDefualtColor;

@property (class, nonatomic, strong, readonly) UIImage *senderBubbleDefualtImage;
@property (class, nonatomic, strong, readonly) UIImage *reciveBubbleDefualtImage;
@property (class, nonatomic, strong, readonly) UIImage *senderDefualtAvatar;
@property (class, nonatomic, strong, readonly) UIImage *reciveDefualtAvatar;
@end
