//
//  ZQLoadingButton.m
//  ZQChatTableView
//
//  Created by zzq on 2018/8/7.
//  Copyright © 2018年 zzq. All rights reserved.
//

#import "ZQLoadingButton.h"

@interface ZQLoadingButton()

@property (nonatomic, strong) UIActivityIndicatorView *indicator;

@end

@implementation ZQLoadingButton

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configUI];
    }
    return self;
}

- (void)configUI {
    self.indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.indicator.hidden = YES;
    [self addSubview:self.indicator];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.indicator.frame = self.bounds;
}

- (void)startAnimation {
    self.indicator.hidden = NO;
    [self.indicator startAnimating];
}

- (void)stopAnitmaion {
    self.indicator.hidden = YES;
    [self.indicator stopAnimating];
}

- (void)isFailure:(BOOL)failure {
    UIImage *img = [UIImage imageNamed:failure ? @"ic_failure_btn" : @""];
    [self setBackgroundImage:img forState:UIControlStateNormal];
}

@end
