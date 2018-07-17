//
//  DemoViewController.m
//  ZQChatTableView
//
//  Created by zzq on 2018/7/9.
//  Copyright © 2018年 zzq. All rights reserved.
//

#import "DemoViewController.h"

@interface DemoViewController ()

@end

@implementation DemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configModel];
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
        ZQMessageFrame *messageFrame = [[ZQMessageFrame alloc] init];
        messageFrame.message = message;
        messageFrame.showTime = YES;
        messageFrame.shouldShowUserName = YES;
        [self.dataSource addObject:messageFrame];
    }];
    
    ZQMessage *photoMessage = [[ZQMessage alloc] initWithPhoto:[UIImage imageNamed:@"defualtPhoto"] UserId:@"aaa" thumbnailUrl:nil originPhotoUrl:nil sender:@"发图片" timestamp:[NSDate date]];
    ZQMessageFrame *photoFrame = [[ZQMessageFrame alloc] init];
    photoFrame.message = photoMessage;
    photoFrame.shouldShowUserName = YES;
    photoFrame.showTime = YES;
    [self.dataSource addObject:photoFrame];
    
    ZQMessage *voiceMessage = [[ZQMessage alloc] initWithVoicePath:@"" UserId:@"voice" voiceUrl:@"" voiceDuration:12 sender:@"voice" timestamp:[NSDate date] isRead:YES];
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
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self scrollToBottomAnimated:NO];
    });
}

/**
 * 使用了xib，子类需要实现这个方法
 */
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:NSStringFromClass([ZQChatViewController class]) bundle:nibBundleOrNil];
    return self;
}


#pragma mark - ZQMessageTableViewControllerDelegate
- (void)didSendText:(NSString *)text fromSender:(NSString *)sender onDate:(NSDate *)date {
    NSLog(@"发送者:%@ , 文字:%@",sender, text);
    ZQMessage *message = [[ZQMessage alloc] initWithText:text UserId:@"uid" sender:sender timestamp:date];
    message.bubbleMessageType = ZQBubbleMessageTypeSend;
    ZQMessageFrame *messageFrame = [[ZQMessageFrame alloc] init];
    messageFrame.message = message;
    messageFrame.showTime = YES;
    messageFrame.shouldShowUserName = YES;
    [self.dataSource addObject:messageFrame];
    [self reloadChatView];
}

- (void)didSendPhoto:(UIImage *)photo fromSender:(NSString *)sender onDate:(NSDate *)date {
    NSLog(@"发送者：%@， 发送的图片", sender);
    ZQMessage *message = [[ZQMessage alloc] initWithPhoto:photo UserId:@"uid" thumbnailUrl:nil originPhotoUrl:nil sender:sender timestamp:date];
    message.bubbleMessageType = ZQBubbleMessageTypeSend;
    ZQMessageFrame *messageFrame = [[ZQMessageFrame alloc] init];
    messageFrame.message = message;
    messageFrame.showTime = YES;
    messageFrame.shouldShowUserName = YES;
    [self.dataSource addObject:messageFrame];
    [self reloadChatView];
}

- (void)didSendVoice:(NSString *)voicePath voiceDuration:(NSInteger )voiceDuration fromSender:(NSString *)sender onDate:(NSDate *)date {
    ZQMessage *voiceMessage = [[ZQMessage alloc] initWithVoicePath:voicePath UserId:@"voice" voiceUrl:@"" voiceDuration:voiceDuration sender:sender timestamp:[NSDate date] isRead:YES];
    ZQMessageFrame *voiceFrame = [[ZQMessageFrame alloc] init];
    voiceFrame.message = voiceMessage;
    voiceFrame.shouldShowUserName = YES;
    voiceFrame.showTime = YES;
    [self.dataSource addObject:voiceFrame];
    [self reloadChatView];
}

@end
