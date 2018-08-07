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
    ZQChatModel *model = [[ZQChatModel alloc] init];
    self.chatModel = model;
    
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
- (void)didSelectedAvatar:(ZQMessage *)message {
    NSLog(@"点击了头像");
}

- (void)didSendText:(NSString *)text fromSender:(NSString *)sender onDate:(NSDate *)date {
    NSLog(@"发送者:%@ , 文字:%@",sender, text);
    ZQMessage *message = [[ZQMessage alloc] initWithText:text UserId:self.chatModel.senderId sender:sender timestamp:date];
    message.bubbleMessageType = ZQBubbleMessageTypeSend;
    ZQMessageFrame *messageFrame = [[ZQMessageFrame alloc] init];
    messageFrame.message = message;
    messageFrame.showTime = YES;
    messageFrame.shouldShowUserName = YES;
    [self.chatModel.dataSource addObject:messageFrame];
    [self reloadChatView];
}

- (void)didSendPhoto:(UIImage *)photo fromSender:(NSString *)sender onDate:(NSDate *)date {
    NSLog(@"发送者：%@， 发送的图片", sender);
    ZQMessage *message = [[ZQMessage alloc] initWithPhoto:photo UserId:self.chatModel.senderId thumbnailUrl:nil originPhotoUrl:nil size:photo.size sender:sender timestamp:date];
    message.bubbleMessageType = ZQBubbleMessageTypeSend;
    ZQMessageFrame *messageFrame = [[ZQMessageFrame alloc] init];
    messageFrame.message = message;
    messageFrame.showTime = YES;
    messageFrame.shouldShowUserName = YES;
    [self.chatModel.dataSource addObject:messageFrame];
    [self reloadChatView];
}

- (void)didSendVoice:(NSString *)voicePath voiceDuration:(NSInteger )voiceDuration fromSender:(NSString *)sender onDate:(NSDate *)date {
    ZQMessage *voiceMessage = [[ZQMessage alloc] initWithVoicePath:voicePath UserId:self.chatModel.senderId voiceUrl:@"" voiceDuration:voiceDuration sender:sender timestamp:[NSDate date] isRead:YES];
    ZQMessageFrame *voiceFrame = [[ZQMessageFrame alloc] init];
    voiceFrame.message = voiceMessage;
    voiceFrame.shouldShowUserName = YES;
    voiceFrame.showTime = YES;
    [self.chatModel.dataSource addObject:voiceFrame];
    [self reloadChatView];
}

- (void)didFailureButton:(ZQLoadingButton *)button Clicked:(ZQMessage *)message {
    [button startAnimation];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [button stopAnitmaion];
        });
    });
}

@end
