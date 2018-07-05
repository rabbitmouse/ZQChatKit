//
//  ZQMessage.m
//  ZQChatTableView
//
//  Created by 朱志勤 on 2018/6/29.
//  Copyright © 2018年 朱志勤. All rights reserved.
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
        
        self.messageMediaType = ZQBubbleMessageMediaTypeText;
    }
    return self;
}


- (instancetype)initWithPhoto:(UIImage *)photo
                       UserId:(NSString *)userId
                 thumbnailUrl:(NSString *)thumbnailUrl
               originPhotoUrl:(NSString *)originPhotoUrl
                       sender:(NSString *)sender
                    timestamp:(NSDate *)timestamp {
    
    self = [super init];
    if (self) {
        self.photo = photo;
        self.userId = userId;
        self.thumbnailUrl = thumbnailUrl;
        self.originPhotoUrl = originPhotoUrl;
        
        self.sender = sender;
        self.timestamp = timestamp;
        
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
        
        self.messageMediaType = ZQBubbleMessageMediaTypeVideo;
    }
    return self;
}

- (instancetype)initWithVoicePath:(NSString *)voicePath
                           UserId:(NSString *)userId
                         voiceUrl:(NSString *)voiceUrl
                    voiceDuration:(NSString *)voiceDuration
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
    _voiceDuration = nil;
    
    _avatar = nil;
    _avatarUrl = nil;
    
    _sender = nil;
    
    _timestamp = nil;
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        _text = [aDecoder decodeObjectForKey:@"text"];
        _userId = [aDecoder decodeObjectForKey:@"userId"];
        _photo = [aDecoder decodeObjectForKey:@"photo"];
        _thumbnailUrl = [aDecoder decodeObjectForKey:@"thumbnailUrl"];
        _originPhotoUrl = [aDecoder decodeObjectForKey:@"originPhotoUrl"];
        
        _videoConverPhoto = [aDecoder decodeObjectForKey:@"videoConverPhoto"];
        _videoPath = [aDecoder decodeObjectForKey:@"videoPath"];
        _videoUrl = [aDecoder decodeObjectForKey:@"videoUrl"];
        
        _voicePath = [aDecoder decodeObjectForKey:@"voicePath"];
        _voiceUrl = [aDecoder decodeObjectForKey:@"voiceUrl"];
        _voiceDuration = [aDecoder decodeObjectForKey:@"voiceDuration"];
        
        _avatar = [aDecoder decodeObjectForKey:@"avatar"];
        _avatarUrl = [aDecoder decodeObjectForKey:@"avatarUrl"];
        
        _sender = [aDecoder decodeObjectForKey:@"sender"];
        _timestamp = [aDecoder decodeObjectForKey:@"timestamp"];
        
        _messageMediaType = [[aDecoder decodeObjectForKey:@"messageMediaType"] integerValue];
        _bubbleMessageType = [[aDecoder decodeObjectForKey:@"bubbleMessageType"] integerValue];
        _isRead = [[aDecoder decodeObjectForKey:@"isRead"] boolValue];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.text forKey:@"text"];
    [aCoder encodeObject:self.userId forKey:@"userId"];
    
    [aCoder encodeObject:self.photo forKey:@"photo"];
    [aCoder encodeObject:self.thumbnailUrl forKey:@"thumbnailUrl"];
    [aCoder encodeObject:self.originPhotoUrl forKey:@"originPhotoUrl"];
    
    [aCoder encodeObject:self.videoConverPhoto forKey:@"videoConverPhoto"];
    [aCoder encodeObject:self.videoPath forKey:@"videoPath"];
    [aCoder encodeObject:self.videoUrl forKey:@"videoUrl"];
    
    [aCoder encodeObject:self.voicePath forKey:@"voicePath"];
    [aCoder encodeObject:self.voiceUrl forKey:@"voiceUrl"];
    [aCoder encodeObject:self.voiceDuration forKey:@"voiceDuration"];
    
    [aCoder encodeObject:self.avatar forKey:@"avatar"];
    [aCoder encodeObject:self.avatarUrl forKey:@"avatarUrl"];
    
    
    [aCoder encodeObject:self.sender forKey:@"sender"];
    [aCoder encodeObject:self.timestamp forKey:@"timestamp"];
    
    [aCoder encodeObject:[NSNumber numberWithInteger:self.messageMediaType] forKey:@"messageMediaType"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.bubbleMessageType] forKey:@"bubbleMessageType"];
    [aCoder encodeObject:[NSNumber numberWithBool:self.isRead] forKey:@"isRead"];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    switch (self.messageMediaType) {
        case ZQBubbleMessageMediaTypeText:
            return [[[self class] allocWithZone:zone] initWithText:[self.text copy]
                                                            UserId:[self.userId copy]
                                                            sender:[self.sender copy]
                                                         timestamp:[self.timestamp copy]];
        case ZQBubbleMessageMediaTypePhoto:
            return [[[self class] allocWithZone:zone] initWithPhoto:[self.photo copy]
                                                             UserId:[self.userId copy]
                                                       thumbnailUrl:[self.thumbnailUrl copy]
                                                     originPhotoUrl:[self.originPhotoUrl copy]
                                                             sender:[self.sender copy]
                                                          timestamp:[self.timestamp copy]];
        case ZQBubbleMessageMediaTypeVideo:
            return [[[self class] allocWithZone:zone] initWithVideoConverPhoto:[self.videoConverPhoto copy]
                                                                        UserId:[self.userId copy]
                                                                     videoPath:[self.videoPath copy]
                                                                      videoUrl:[self.videoUrl copy]
                                                                        sender:[self.sender copy]
                                                                     timestamp:[self.timestamp copy]];
        case ZQBubbleMessageMediaTypeVoice:
            return [[[self class] allocWithZone:zone] initWithVoicePath:[self.voicePath copy]
                                                                 UserId:[self.userId copy]
                                                               voiceUrl:[self.voiceUrl copy]
                                                          voiceDuration:[self.voiceDuration copy]
                                                                 sender:[self.sender copy]
                                                              timestamp:[self.timestamp copy]
                                                                 isRead:self.isRead];
        default:
            return nil;
    }
}

@end
