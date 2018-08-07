//
//  ZQMessage.h
//  ZQChatTableView
//
//  Created by zzq on 2018/6/29.
//  Copyright © 2018年 zzq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZQMessageEnable.h"

@interface ZQMessage : NSObject<ZQMessageEnable, NSCoding, NSCopying>

@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *userId;

@property (nonatomic, strong) UIImage *photo;
@property (nonatomic, copy) NSString *thumbnailUrl;
@property (nonatomic, copy) NSString *originPhotoUrl;
@property (nonatomic, assign) CGFloat picWidth;
@property (nonatomic, assign) CGFloat picHeight;

@property (nonatomic, strong) UIImage *videoConverPhoto;
@property (nonatomic, copy) NSString *videoPath;
@property (nonatomic, copy) NSString *videoUrl;

@property (nonatomic, copy) NSString *voicePath;
@property (nonatomic, copy) NSString *voiceUrl;
@property (nonatomic, assign) NSInteger voiceDuration;

@property (nonatomic, strong) UIImage *avatar;
@property (nonatomic, copy) NSString *avatarUrl;

@property (nonatomic, copy) NSString *sender;

@property (nonatomic, strong) NSDate *timestamp;

@property (nonatomic, assign) BOOL sended;
@property (nonatomic, assign) BOOL isRead;
@property (nonatomic, assign) BOOL isFailure;

@property (nonatomic, assign) ZQBubbleMessageMediaType messageMediaType;

@property (nonatomic, assign) ZQBubbleMessageType bubbleMessageType;

/**
 *  初始化文本消息
 *
 *  @param text   发送的目标文本
 *  @param sender 发送者的名称
 *  @param timestamp   发送的时间
 *
 *  @return 返回Message model 对象
 */
- (instancetype)initWithText:(NSString *)text
                      UserId:(NSString *)userId
                      sender:(NSString *)sender
                   timestamp:(NSDate *)timestamp;

/**
 *  初始化图片类型的消息
 *
 *  @param photo          目标图片
 *  @param thumbnailUrl   目标图片在服务器的缩略图地址
 *  @param originPhotoUrl 目标图片在服务器的原图地址
 *  @param sender         发送者
 *  @param timestamp           发送时间
 *
 *  @return 返回Message model 对象
 */
- (instancetype)initWithPhoto:(UIImage *)photo
                       UserId:(NSString *)userId
                 thumbnailUrl:(NSString *)thumbnailUrl
               originPhotoUrl:(NSString *)originPhotoUrl
                         size:(CGSize)picSize
                       sender:(NSString *)sender
                    timestamp:(NSDate *)timestamp;

/**
 *  初始化视频类型的消息
 *
 *  @param videoConverPhoto 目标视频的封面图
 *  @param videoPath        目标视频的本地路径，如果是下载过，或者是从本地发送的时候，会存在
 *  @param videoUrl         目标视频在服务器上的地址
 *  @param sender           发送者
 *  @param timestamp             发送时间
 *
 *  @return 返回Message model 对象
 */
- (instancetype)initWithVideoConverPhoto:(UIImage *)videoConverPhoto
                                  UserId:(NSString *)userId
                               videoPath:(NSString *)videoPath
                                videoUrl:(NSString *)videoUrl
                                  sender:(NSString *)sender
                               timestamp:(NSDate *)timestamp;


/**
 *  初始化语音类型的消息
 *
 *  @param voicePath        目标语音的本地路径
 *  @param voiceUrl         目标语音在服务器的地址
 *  @param voiceDuration    目标语音的时长
 *  @param sender           发送者
 *  @param timestamp             发送时间
 *  @param isRead           已读未读标记
 *
 *  @return 返回Message model 对象
 */
- (instancetype)initWithVoicePath:(NSString *)voicePath
                           UserId:(NSString *)userId
                         voiceUrl:(NSString *)voiceUrl
                    voiceDuration:(NSInteger )voiceDuration
                           sender:(NSString *)sender
                        timestamp:(NSDate *)timestamp
                           isRead:(BOOL)isRead;
@end
