//
//  ZQRoundProgressButton.h
//  ZQChatTableView
//
//  Created by zzq on 2018/8/23.
//  Copyright © 2018年 zzq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZQRoundProgressButton : UIButton

- (instancetype)initProgressButtonWithCompleteBlock:(void(^)(void))complete;

- (void)startProgressWithTimer:(CGFloat)time;
- (void)stopProgress;

@end
