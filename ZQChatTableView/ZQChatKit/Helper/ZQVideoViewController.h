//
//  ZQVideoViewController.h
//  ZQChatTableView
//
//  Created by zzq on 2018/8/22.
//  Copyright © 2018年 zzq. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZQRecordVideoDelegate<NSObject>

- (void)didRecordVideoFinished:(NSString *)videoPath;

@end

@interface ZQVideoViewController : UIViewController

@property (nonatomic, weak) id<ZQRecordVideoDelegate> delegate;

@end
