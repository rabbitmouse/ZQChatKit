//
//  ZQVideoHelper.h
//  ZQChatTableView
//
//  Created by zzq on 2018/8/22.
//  Copyright © 2018年 zzq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ZQVideoHelper : NSObject

- (void)switchScene;
- (void)startRecordVideo;
- (void)stopRecordVideo;

@property (nonatomic, strong) CALayer *playerView;
@property (nonatomic, strong) NSString *lastFilePath;


@end
