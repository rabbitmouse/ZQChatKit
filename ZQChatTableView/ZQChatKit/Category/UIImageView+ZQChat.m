//
//  UIImageView+ZQChat.m
//  ZQChatTableView
//
//  Created by zzq on 2018/7/16.
//  Copyright © 2018年 zzq. All rights reserved.
//

#import "UIImageView+ZQChat.h"

@implementation UIImageView (ZQChat)

+ (UIImageView *)messageVoiceAnimationImageViewWithBubbleMessageType:(ZQBubbleMessageType)type {
    UIImageView *messageVoiceAniamtionImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 14, 17)];
    NSString *imageSepatorName;
    switch (type) {
        case ZQBubbleMessageTypeSend:
            imageSepatorName = @"Sender";
            break;
        case ZQBubbleMessageTypeReceive:
            imageSepatorName = @"Receiver";
            break;
        default:
            break;
    }
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:4];
    for (NSInteger i = 0; i < 4; i ++) {
        UIImage *image = [UIImage imageNamed:[imageSepatorName stringByAppendingFormat:@"VoiceNodePlaying00%ld", (long)i]];
        if (image)
            [images addObject:image];
    }
    
    messageVoiceAniamtionImageView.image = [UIImage imageNamed:[imageSepatorName stringByAppendingString:@"VoiceNodePlaying"]];
    messageVoiceAniamtionImageView.animationImages = images;
    messageVoiceAniamtionImageView.animationDuration = 1.0;
    [messageVoiceAniamtionImageView stopAnimating];
    
    return messageVoiceAniamtionImageView;
}


@end
