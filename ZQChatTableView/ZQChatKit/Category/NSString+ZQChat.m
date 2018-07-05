//
//  NSString+ZQChat.m
//  ZQChatTableView
//
//  Created by 朱志勤 on 2018/6/29.
//  Copyright © 2018年 朱志勤. All rights reserved.
//

#import "NSString+ZQChat.h"


@implementation NSString (ZQChat)

- (CGSize)zq_sizeWithFont:(UIFont *)font
{
    CGSize result = [self sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil]];
    result.height = ceilf(result.height);
    result.width = ceilf(result.width);
    return result;
}

- (CGSize)zq_sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size
{
    CGSize result = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil] context:nil].size;
    result.height = ceilf(result.height);
    result.width = ceilf(result.width);
    return result;
}

+ (NSString *)timeStringWithDate:(NSDate *)timestamp {
    NSString *dateText = nil;
    NSString *timeText = nil;
    
    NSDate *today = [NSDate date];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:-1];
    NSDate *yesterday = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:today options:0];
    
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:timestamp];
    NSDateComponents *todayComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:today];
    NSDateComponents *yesterdayComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:yesterday];
    
    if (dateComponents.year == todayComponents.year && dateComponents.month == todayComponents.month && dateComponents.day == todayComponents.day) {
        dateText = NSLocalizedStringFromTable(@"Today", @"MessageDisplayKitString", @"今天");
    } else if (dateComponents.year == yesterdayComponents.year && dateComponents.month == yesterdayComponents.month && dateComponents.day == yesterdayComponents.day) {
        dateText = NSLocalizedStringFromTable(@"Yesterday", @"MessageDisplayKitString", @"昨天");
    } else {
        dateText = [NSDateFormatter localizedStringFromDate:timestamp dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterNoStyle];
    }
    timeText = [NSDateFormatter localizedStringFromDate:timestamp dateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterShortStyle];
    
    return timeText;
}

- (NSUInteger)numberOfLines {
    return [[self componentsSeparatedByString:@"\n"] count] + 1;
}
@end
