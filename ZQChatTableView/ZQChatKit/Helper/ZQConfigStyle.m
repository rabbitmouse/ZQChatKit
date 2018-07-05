//
//  ZQConfigStyle.m
//  ZQChatTableView
//
//  Created by 朱志勤 on 2018/7/3.
//  Copyright © 2018年 朱志勤. All rights reserved.
//

#import "ZQConfigStyle.h"

@implementation ZQConfigStyle

+ (UIColor *)senderDefualtColor {
    return [UIColor whiteColor];
}

+ (UIColor *)reciveDefualtColor {
    return [UIColor grayColor];
}

+ (UIColor *)backgroudDefualtColor {
    return [UIColor whiteColor];
}

+ (UIImage *)senderBubbleDefualtImage {
    return [UIImage imageNamed:@"chatto_bg_normal"];
}

+ (UIImage *)reciveBubbleDefualtImage {
    return [UIImage imageNamed:@"chatfrom_bg_normal"];;
}

+ (UIImage *)senderDefualtAvatar {
    return [UIImage imageNamed:@"chatfrom_doctor_icon"];
}

+ (UIImage *)reciveDefualtAvatar {
    return [UIImage imageNamed:@"chatfrom_doctor_icon"];
}

@end
