//
//  CollectionViewCell.m
//  ZQChatTableView
//
//  Created by 朱志勤 on 2018/7/9.
//  Copyright © 2018年 zzq. All rights reserved.
//

#import "ZQMenuCell.h"

#define itemPadding 10

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
    
    self.iconView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.iconView.layer.borderWidth = 1.f;
    self.iconView.layer.cornerRadius = 4.f;
//    self.iconView.layer.masksToBounds = YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    
    CGFloat imgWH = width - itemPadding *2;
    self.iconView.frame = CGRectMake(itemPadding, 0, imgWH, imgWH);
    self.titleLabel.frame = CGRectMake(0, imgWH + 5, width, height - imgWH);
}

- (void)setItem:(ZQMenuItem *)item {
    _item = item;
    self.iconView.image = [UIImage imageNamed:item.imgName];
    self.titleLabel.text = item.title;
}

@end
