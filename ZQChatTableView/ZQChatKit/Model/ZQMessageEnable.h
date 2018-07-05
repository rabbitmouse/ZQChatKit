//
//  ZQMessageEnable.h
//  ZQChatTableView
//
//  Created by 朱志勤 on 2018/6/29.
//  Copyright © 2018年 朱志勤. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIkit.h>

typedef NS_ENUM(NSUInteger, ZQBubbleMessageType) {
    ZQBubbleMessageTypeSend,
    ZQBubbleMessageTypeReceive,
};

typedef NS_ENUM(NSUInteger, ZQBubbleMessageMediaType) {
    ZQBubbleMessageMediaTypeText = 0,
    ZQBubbleMessageMediaTypePhoto = 1,
    ZQBubbleMessageMediaTypeVideo = 2,
    ZQBubbleMessageMediaTypeVoice = 3,
};

@protocol ZQMessageEnable <NSObject>

@required
- (NSString *)text;

- (UIImage *)photo;
- (NSString *)thumbnailUrl;
- (NSString *)originPhotoUrl;

- (UIImage *)videoConverPhoto;
- (NSString *)videoPath;
- (NSString *)videoUrl;

- (NSString *)voicePath;
- (NSString *)voiceUrl;
- (NSString *)voiceDuration;

- (UIImage *)avatar;
- (NSString *)avatarUrl;

- (ZQBubbleMessageType)bubbleMessageType;

@end
