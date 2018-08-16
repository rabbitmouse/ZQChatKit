//
//  DemoViewController.m
//  ZQChatTableView
//
//  Created by zzq on 2018/7/9.
//  Copyright © 2018年 zzq. All rights reserved.
//

#import "DemoViewController.h"
#import "ZQMessageCell.h"

@interface DemoViewController ()

@end

@implementation DemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
//        self.edgesForExtendedLayout = UIRectEdgeNone;
//    }
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
    NSLog(@"发送者:%@ , 新的:%@",sender, text);
    ZQMessage *message = [[ZQMessage alloc] initWithText:text UserId:self.chatModel.senderId sender:sender timestamp:date];
    message.bubbleMessageType = ZQBubbleMessageTypeSend;
    ZQMessageFrame *messageFrame = [[ZQMessageFrame alloc] init];
    messageFrame.message = message;
    messageFrame.showTime = YES;
    messageFrame.shouldShowUserName = YES;
    [self.chatModel.dataSource addObject:messageFrame];
    [self reloadChatView];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //模拟发送失败
            message.isFailure = YES;
            [self.tableview reloadData];
        });
    });
}

- (void)didSendPhoto:(UIImage *)photo fromSender:(NSString *)sender onDate:(NSDate *)date {
    NSLog(@"发送者：%@， 发送的图片", sender);
    ZQMessage *message = [[ZQMessage alloc] initWithPhoto:photo UserId:self.chatModel.senderId thumbnailUrl:nil originPhotoUrl:nil size:photo.size sender:sender timestamp:date];
    message.bubbleMessageType = ZQBubbleMessageTypeSend;
    message.isUpload = NO;
    ZQMessageFrame *messageFrame = [[ZQMessageFrame alloc] init];
    messageFrame.message = message;
    messageFrame.showTime = YES;
    messageFrame.shouldShowUserName = YES;
    [self.chatModel.dataSource addObject:messageFrame];
    [self reloadChatView];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //模拟发送成功
            message.isUpload = YES;
            message.isFailure = YES;
            message.originPhotoUrl = @"将URL保存到内存和数据库";
            [self.tableview reloadData];
        });
    });
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
    //模拟重新发送
    [button startAnimation];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            message.isFailure = NO;
//            [button isFailure:message.isFailure]; //若失败 则添加这一句
            [button stopAnitmaion];
        });
    });
}

- (BOOL)shouldLoadMoreMessagesScrollToTop {
    return YES;
}

- (void)loadMoreMessagesScrollTotop {
    NSArray *texts = @[@"新的新的",
                       @"新的新的新的新的新的新的新的新的新的新的新的新的新的新的",
                       @"新的新的新的新的新的新的新的新的新的新的新的新的新的新的",
                       @"文新的新的新的新的新的新的新的新的新的新的新的新的新的新的字新的",
                       @"新的新的新的新的新的新的新的新的新的新的新的新的新的新的新的新的新的新的新的新的新的新的新的新的新的新的新的新的新的新的新的新的新的新的新的新的新的新的新的新的新的新的",
                       @"新的新的新的新的新的新的新的新的新的新的新的新的新的新的新的新的新的新的新的新的新的新的新的新的新的新的新的新的",
                       @"新的新的新的新的新的新的新的新的新的新的新的新的新的新的新的新的新的新的新的新的新的新的新的新的新的新的",
                       @"文新的新的文新的",
                       @"新的文新的新的新的新的新的新的新的新的新的新的新的新的新的新的新的新的新的新的新的新的新的新的新的新的新的新的新的新的新的新的新的新的新的新的新的新的新的新的新的新的新的新的新的新的新的新的新的新的字",
                       @"新的文新的新的新的新的新的新的新的新的新的新的新的新的新的新的新的新的字",
                       @"新的文新的新的新的新的新的新的新的新的新的新的新的新的新的新的新的新的新的新的字"];
    
    NSMutableArray *datas = [NSMutableArray array];
    [texts enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ZQMessage *message = [[ZQMessage alloc] initWithText:obj UserId:@(idx).stringValue sender:@"用户名" timestamp:[NSDate date]];
        message.bubbleMessageType = idx % 3 ? ZQBubbleMessageTypeSend : ZQBubbleMessageTypeReceive;
        message.isFailure = NO;
        ZQMessageFrame *messageFrame = [[ZQMessageFrame alloc] init];
        messageFrame.message = message;
        messageFrame.showTime = YES;
        messageFrame.shouldShowUserName = YES;
        [datas addObject:messageFrame];
    }];
    
    NSMutableIndexSet *indexes = [NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(0, datas.count)];
    [self.chatModel.dataSource insertObjects:datas atIndexes:indexes];
    [self headerRefreshEnd];
    [self.tableview reloadData];
    NSIndexPath *index = [NSIndexPath indexPathForRow:datas.count inSection:0];
    [self.tableview scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionTop animated:NO];
    
}

@end
