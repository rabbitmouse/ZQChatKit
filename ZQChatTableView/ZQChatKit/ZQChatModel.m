//
//  ZQChatModel.m
//  ZQChatTableView
//
//  Created by zzq on 2018/7/18.
//  Copyright © 2018年 zzq. All rights reserved.
//

#import "ZQChatModel.h"
#import "ZQMessage.h"
#import "ZQMessageFrame.h"

@implementation ZQChatModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configModel];
    }
    return self;
}

- (void)configModel {
    self.dataSource = [NSMutableArray array];
    NSArray *texts = @[@"文字文字",
                       @"文字文字文字文字文字文字文字文字文字文字文字文字文字文字",
                       @"文字文字文字文字文字文字文字文字文字文字文字文字文字文字",
                       @"文字文字",
                       @"文文字文字文字文字文字文字文字文字文字文字文字文字文字文字字文字",
                       @"文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字",
                       @"文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字",
                       @"文字文文字文字文字文字文字文字文字文字文字文字文字文字文字文字字",
                       @"文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字",
                       @"文字文字文字文字文字文字文字文字文字文字文字文字文字文文字文字文字文字文字文字文字文字文字文字文字文字文字文字字文字文字",
                       @"文文字文字文文字",
                       @"文字文文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字字",
                       @"文文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字字文字",
                       @"文字文文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字字",
                       @"文字文文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字字"];
    
    [texts enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ZQMessage *message = [[ZQMessage alloc] initWithText:obj UserId:@(idx).stringValue sender:@"用户名" timestamp:[NSDate date]];
        message.bubbleMessageType = idx % 3 ? ZQBubbleMessageTypeSend : ZQBubbleMessageTypeReceive;
        message.isFailure = (idx % 3);
        ZQMessageFrame *messageFrame = [[ZQMessageFrame alloc] init];
        messageFrame.message = message;
        messageFrame.showTime = YES;
        messageFrame.shouldShowUserName = YES;
        [self.dataSource addObject:messageFrame];
    }];
    
    ZQMessage *photoMessage = [[ZQMessage alloc] initWithPhoto:nil UserId:@"aaa" thumbnailUrl:nil originPhotoUrl:@"http://mpic.tiankong.com/db1/635/db16351cdb0d0d2d326bb2a4cae5a0b6/640.jpg@!670w" size:CGSizeMake(100, 80) sender:@"发图片" timestamp:[NSDate date]];
    ZQMessageFrame *photoFrame = [[ZQMessageFrame alloc] init];
    photoFrame.message = photoMessage;
    photoFrame.shouldShowUserName = YES;
    photoFrame.showTime = YES;
    [self.dataSource addObject:photoFrame];
    
    ZQMessage *voiceMessage = [[ZQMessage alloc] initWithVoicePath:@"" UserId:@"voice" voiceUrl:@"" voiceDuration:24 sender:@"voice" timestamp:[NSDate date] isRead:YES];
    ZQMessageFrame *voiceFrame = [[ZQMessageFrame alloc] init];
    voiceFrame.message = voiceMessage;
    voiceFrame.shouldShowUserName = YES;
    voiceFrame.showTime = YES;
    [self.dataSource addObject:voiceFrame];
    
    ZQMessage *voiceMessage1 = [[ZQMessage alloc] initWithVoicePath:@"" UserId:@"voice" voiceUrl:@"" voiceDuration:5 sender:@"voice1" timestamp:[NSDate date] isRead:NO];
    voiceMessage1.bubbleMessageType = ZQBubbleMessageTypeReceive;
    ZQMessageFrame *voiceFrame1 = [[ZQMessageFrame alloc] init];
    voiceFrame1.message = voiceMessage1;
    [self.dataSource addObject:voiceFrame1];
}

@end
