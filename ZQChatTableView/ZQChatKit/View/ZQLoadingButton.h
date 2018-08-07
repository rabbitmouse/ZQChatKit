//
//  ZQLoadingButton.h
//  ZQChatTableView
//
//  Created by zzq on 2018/8/7.
//  Copyright © 2018年 zzq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZQLoadingButton : UIButton

- (void)startAnimation;
- (void)stopAnitmaion;
- (void)isFailure:(BOOL)failure;
@end
