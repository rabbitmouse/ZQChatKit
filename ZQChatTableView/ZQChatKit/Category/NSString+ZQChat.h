//
//  NSString+ZQChat.h
//  ZQChatTableView
//
//  Created by zzq on 2018/6/29.
//  Copyright © 2018年 zzq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (ZQChat)
- (NSUInteger)numberOfLines;

- (CGSize)zq_sizeWithFont:(UIFont *)font;

- (CGSize)zq_sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;

+ (NSString *)timeStringWithDate:(NSDate *)timestamp;
@end
