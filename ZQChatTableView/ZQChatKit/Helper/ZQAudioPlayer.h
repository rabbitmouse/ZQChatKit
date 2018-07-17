//
//  ZQAudioPlayer.h
//  ZQChatTableView
//
//  Created by zzq on 2018/7/16.
//  Copyright © 2018年 zzq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>


@protocol ZQAudioPlayerDelegate <NSObject>

- (void)ZQAudioPlayerBeiginLoadVoice;

- (void)ZQAudioPlayerBeiginPlay;

- (void)ZQAudioPlayerDidFinishPlay;

@end

@interface ZQAudioPlayer : NSObject

@property (nonatomic, strong) AVAudioPlayer *player;

@property (nonatomic, weak) id<ZQAudioPlayerDelegate> delegate;

+ (instancetype)sharedInstance;

-(void)playSongWithUrl:(NSString *)songUrl;

-(void)playSongWithData:(NSData *)songData;

- (void)stopSound;

@end
