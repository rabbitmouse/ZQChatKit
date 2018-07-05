//
//  ZQMessageContentView.m
//  ZQChatTableView
//
//  Created by 朱志勤 on 2018/6/29.
//  Copyright © 2018年 朱志勤. All rights reserved.
//

#import "ZQMessageContentView.h"

@implementation ZQMessageContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //图片
        self.backImageView = [[UIImageView alloc] init];
        self.backImageView.layer.cornerRadius = 5;
        self.backImageView.layer.masksToBounds  = YES;
        self.backImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:self.backImageView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.backImageView.frame = self.bounds;
}

- (void)setIsMyMessage:(BOOL)isMyMessage
{
    self.backImageView.frame = self.bounds;
//    _isMyMessage = isMyMessage;
//    if (isMyMessage) {
//        self.backImageView.frame = CGRectMake(5, 5, 220, 220);
////        self.voiceBackView.frame = CGRectMake(15, 10, 130, 35);
////        self.second.textColor = [UIColor whiteColor];
//    }else{
//        self.backImageView.frame = CGRectMake(15, 5, 220, 220);
////        self.voiceBackView.frame = CGRectMake(25, 10, 130, 35);
////        self.second.textColor = [UIColor grayColor];
//    }
}

@end
