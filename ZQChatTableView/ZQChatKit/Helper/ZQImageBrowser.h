//
//  ZQImageBrowser.h
//  ZQChatTableView
//
//  Created by zzq on 2018/7/3.
//  Copyright © 2018年 zzq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ZQImageBrowser : NSObject

+ (void)showImage:(UIImageView *)avatarImageView;
+ (void)hideImage:(UITapGestureRecognizer *)tap;

@end
