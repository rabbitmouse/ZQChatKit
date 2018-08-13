//
//  ZQMessage.m
//  ZQChatTableView
//
//  Created by zzq on 2018/6/29.
//  Copyright © 2018年 zzq. All rights reserved.
//

#import "ZQMessage.h"


@implementation ZQMessage


- (instancetype)initWithText:(NSString *)text
                      UserId:(NSString *)userId
                      sender:(NSString *)sender
                   timestamp:(NSDate *)timestamp {
    
    self = [super init];
    if (self) {
        self.text = text;
        self.userId = userId;
        self.sender = sender;
        self.timestamp = timestamp;
        
        self.isUpload = YES;
        
        self.messageMediaType = ZQBubbleMessageMediaTypeText;
    }
    return self;
}


- (instancetype)initWithPhoto:(UIImage *)photo
                       UserId:(NSString *)userId
                 thumbnailUrl:(NSString *)thumbnailUrl
               originPhotoUrl:(NSString *)originPhotoUrl
                         size:(CGSize)picSize
                       sender:(NSString *)sender
                    timestamp:(NSDate *)timestamp {
    
    self = [super init];
    if (self) {
        self.photo = photo;
        self.userId = userId;
        self.thumbnailUrl = thumbnailUrl;
        self.originPhotoUrl = originPhotoUrl;
        self.picWidth = picSize.width;
        self.picHeight = picSize.height;
        
        self.sender = sender;
        self.timestamp = timestamp;
        
        self.isUpload = YES;
        
        self.messageMediaType = ZQBubbleMessageMediaTypePhoto;
    }
    return self;
}


- (instancetype)initWithVideoConverPhoto:(UIImage *)videoConverPhoto
                                  UserId:(NSString *)userId
                               videoPath:(NSString *)videoPath
                                videoUrl:(NSString *)videoUrl
                                  sender:(NSString *)sender
                               timestamp:(NSDate *)timestamp {
    self = [super init];
    if (self) {
        self.videoConverPhoto = videoConverPhoto;
        self.userId = userId;
        self.videoPath = videoPath;
        self.videoUrl = videoUrl;
        
        self.sender = sender;
        self.timestamp = timestamp;
        
        self.isUpload = YES;
        
        self.messageMediaType = ZQBubbleMessageMediaTypeVideo;
    }
    return self;
}

- (instancetype)initWithVoicePath:(NSString *)voicePath
                           UserId:(NSString *)userId
                         voiceUrl:(NSString *)voiceUrl
                    voiceDuration:(NSInteger )voiceDuration
                           sender:(NSString *)sender
                        timestamp:(NSDate *)timestamp
                           isRead:(BOOL)isRead {
    self = [super init];
    if (self) {
        self.voicePath = voicePath;
        self.userId = userId;
        self.voiceUrl = voiceUrl;
        self.voiceDuration = voiceDuration;
        
        self.sender = sender;
        self.timestamp = timestamp;
        self.isRead = isRead;
        
        self.isUpload = YES;
        
        self.messageMediaType = ZQBubbleMessageMediaTypeVoice;
    }
    return self;
}


- (void)dealloc {
    _text = nil;
    _userId = nil;
    _photo = nil;
    _thumbnailUrl = nil;
    _originPhotoUrl = nil;
    
    _videoConverPhoto = nil;
    _videoPath = nil;
    _videoUrl = nil;
    
    _voicePath = nil;
    _voiceUrl = nil;
    
    _avatar = nil;
    _avatarUrl = nil;
    
    _sender = nil;
    
    _timestamp = nil;
}


@end
