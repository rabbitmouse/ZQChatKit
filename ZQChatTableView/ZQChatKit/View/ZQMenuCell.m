//
//  CollectionViewCell.m
//  ZQChatTableView
//
//  Created by 朱志勤 on 2018/7/9.
//  Copyright © 2018年 zzq. All rights reserved.
//

#import "ZQMenuCell.h"

@interface ZQMenuCell()
@property (nonnull, strong) UIButton *button;
@end

@implementation ZQMenuCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
    }
    return self;
}

- (void)configUI {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.enabled = NO;
    button.backgroundColor = [UIColor greenColor];
    [self addSubview:button];
    
    self.button = button;
}

- (void)layoutSubviews {
    self.button.frame = self.bounds;
}

@end
