//
//  ZQRoundProgressButton.m
//  ZQChatTableView
//
//  Created by zzq on 2018/8/23.
//  Copyright © 2018年 zzq. All rights reserved.
//

#import "ZQRoundProgressButton.h"

typedef void(^complete)(void);

@interface ZQRoundProgressButton()

@property (nonatomic, strong) CAShapeLayer *progressLayer;
@property (nonatomic, strong) CADisplayLink *link;
@property (nonatomic, assign) CGFloat countTime;
@property (nonatomic, assign) CGFloat progress;

@property (nonatomic, copy) complete complete;

@end

@implementation ZQRoundProgressButton

- (instancetype)initProgressButtonWithCompleteBlock:(void(^)(void))complete
{
    self = [super init];
    if (self) {
        self.complete = complete;
        [self setup];
    }
    return self;
}

- (void)setup {
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.lineWidth = 5.f;
    layer.strokeColor = [UIColor greenColor].CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeStart = 0.f;
    layer.strokeEnd = 0.f;
    
    [self.layer addSublayer:layer];
    
    _progressLayer = layer;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = self.bounds.size.width;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(width/2, width/2) radius:width/2 - 5 startAngle:-M_PI/2 endAngle:M_PI/2 * 3 clockwise:YES];
    _progressLayer.frame = self.bounds;
    _progressLayer.position = CGPointMake(width/2, width/2);
    _progressLayer.path = path.CGPath;
}

- (void)startProgressWithTimer:(CGFloat)time {
    [_link invalidate];
    _link = nil;
    
    self.countTime = time;
    self.progress = 1 / self.countTime / 60;
    
    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(drawCircleLink:)];
    [link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    _link = link;
}

- (void)stopProgress {
    if (_link) {
        [_link invalidate];
        _link = nil;
        self.countTime = 0.f;
        self.progress = 0.f;
    }
}

- (void)drawCircleLink:(CADisplayLink *)link {
    _progressLayer.strokeEnd += self.progress;
    
    self.countTime -= link.duration;
    if (self.countTime <= 0) {
        [self stopProgress];
        if (self.complete) {
            self.complete();
        }
    }
}

@end
