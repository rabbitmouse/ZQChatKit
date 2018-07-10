//
//  CollectionViewCell.m
//  ZQChatTableView
//
//  Created by 朱志勤 on 2018/7/9.
//  Copyright © 2018年 zzq. All rights reserved.
//

#import "ZQMenuCell.h"

@interface ZQMenuCell()
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *titleLabel;
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
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self addSubview:imgView];
    self.iconView = imgView;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor lightGrayColor];
    [self addSubview:label];
    self.titleLabel = label;
}

- (void)layoutSubviews {
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    self.iconView.frame = CGRectMake(0, 0, width, width);
    self.titleLabel.frame = CGRectMake(0, width + 3, width, height - width - 3);
}

@end
