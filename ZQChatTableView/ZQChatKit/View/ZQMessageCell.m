//
//  ZQMessageCell.m
//  ZQChatTableView
//
//  Created by zzq on 2018/6/29.
//  Copyright © 2018年 zzq. All rights reserved.
//

#import "ZQMessageCell.h"
#import "ZQMessageFrame.h"
#import "ZQMessage.h"
#import "ZQImageBrowser.h"
#import "ZQAudioPlayer.h"

#import "NSString+ZQChat.h"
#import "UIImageView+WebCache.h"

@interface ZQMessageCell() <ZQAudioPlayerDelegate> {
    UIImageView *_headImageBackView;
}

@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *namelabel;
@property (nonatomic, strong) UIButton *headImageButton;

@end

@implementation ZQMessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // 1、创建时间
        self.dateLabel = [[UILabel alloc] init];
        self.dateLabel.textAlignment = NSTextAlignmentCenter;
        self.dateLabel.textColor = [UIColor grayColor];
        self.dateLabel.font = ChatTimeFont;
        [self.contentView addSubview:self.dateLabel];
        
        // 2、创建头像
        _headImageBackView = [[UIImageView alloc]init];
        _headImageBackView.layer.cornerRadius = 22;
        _headImageBackView.layer.masksToBounds = YES;
        _headImageBackView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.4];
        [self.contentView addSubview:_headImageBackView];
        self.headImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.headImageButton.layer.cornerRadius = 22;
        self.headImageButton.layer.masksToBounds = YES;
        [self.headImageButton addTarget:self action:@selector(btnHeadImageClick:)  forControlEvents:UIControlEventTouchUpInside];
        [_headImageBackView addSubview:self.headImageButton];
        
        // 3、创建名字
        self.namelabel = [[UILabel alloc] init];
        self.namelabel.textColor = [UIColor grayColor];
        self.namelabel.textAlignment = NSTextAlignmentCenter;
        self.namelabel.font = ChatTimeFont;
        self.namelabel.numberOfLines = 0;
        [self.contentView addSubview:self.namelabel];
        
        // 4、创建内容
        self.btnContent = [ZQMessageContentView buttonWithType:UIButtonTypeCustom];
        [self.btnContent setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.btnContent.titleLabel.font = ChatContentFont;
        self.btnContent.titleLabel.numberOfLines = 0;
        [self.btnContent addTarget:self action:@selector(btnContentClick)  forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.btnContent];
        
        
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
}

- (void)setMessageFrame:(ZQMessageFrame *)messageFrame {
    //——————————————————get data——————————————
    _messageFrame = messageFrame;
    ZQMessage *message = _messageFrame.message;
    
    //——————————————————set data——————————————
    //time
    self.dateLabel.text = [NSString timeStringWithDate:message.timestamp];
    self.dateLabel.frame = messageFrame.timeF;
    
    //avatar
    _headImageBackView.frame = messageFrame.iconF;
    
    UIImage *defualtAvatar = message.bubbleMessageType == ZQBubbleMessageTypeSend ? self.senderAvatarImage : self.reciveAvatarImage;

    if (message.avatar) {
        _headImageBackView.image = message.avatar;
    } else if (message.avatarUrl) {
        [_headImageBackView sd_setImageWithURL:[NSURL URLWithString:message.avatarUrl] placeholderImage:defualtAvatar];
    } else {
        _headImageBackView.image = defualtAvatar;
    }
    self.headImageButton.frame = _headImageBackView.bounds;
    
    //name
    self.namelabel.text = message.sender;
    self.namelabel.frame = messageFrame.nameF;
    
    //content
    [self.btnContent setTitle:@"" forState:UIControlStateNormal];
    self.btnContent.backImageView.hidden = YES;
    self.btnContent.frame = messageFrame.contentF;
    
    if (message.bubbleMessageType == ZQBubbleMessageTypeSend) {
        [self.btnContent setTitleColor:self.senderTextColor forState:UIControlStateNormal];
        self.btnContent.titleEdgeInsets = UIEdgeInsetsMake(ChatContentTopBottom, ChatContentSmaller, ChatContentTopBottom, ChatContentBiger);
    } else {
        [self.btnContent setTitleColor:self.reciveTextColor forState:UIControlStateNormal];
        self.btnContent.titleEdgeInsets = UIEdgeInsetsMake(ChatContentTopBottom, ChatContentBiger, ChatContentTopBottom, ChatContentSmaller);
    }
    
    //content-background image
    UIImage *normal;
    if (message.messageMediaType == ZQBubbleMessageMediaTypeText || message.messageMediaType == ZQBubbleMessageMediaTypeVoice) {
        if (message.bubbleMessageType == ZQBubbleMessageTypeSend) {
            normal = self.senderBubbleImage;
            normal = [normal resizableImageWithCapInsets:UIEdgeInsetsMake(35, 10, 10, 22)];
        }
        else{
            normal = self.reciveBubbleImage;
            normal = [normal resizableImageWithCapInsets:UIEdgeInsetsMake(35, 22, 10, 10)];
        }
        [self.btnContent setBackgroundImage:normal forState:UIControlStateNormal];
        [self.btnContent setBackgroundImage:normal forState:UIControlStateHighlighted];
    } else {
        [self.btnContent setBackgroundImage:nil forState:UIControlStateNormal];
        [self.btnContent setBackgroundImage:nil forState:UIControlStateHighlighted];
    }
    
    //content-text
    switch (message.messageMediaType) {
        case ZQBubbleMessageMediaTypeText:
            [self.btnContent setTitle:message.text forState:UIControlStateNormal];
            self.btnContent.message = message;
            break;
        case ZQBubbleMessageMediaTypePhoto:
        case ZQBubbleMessageMediaTypeVoice: {
            self.btnContent.message = message;
        }
            break;
            
        default:
            break;
    }
}


#pragma mark - action

//头像点击
- (void)btnHeadImageClick:(UIButton *)button{
    if ([self.delegate respondsToSelector:@selector(chatCell:headImageDidClick:)])  {
        [self.delegate chatCell:self headImageDidClick:self.messageFrame.message.userId];
    }
}

- (void)btnContentClick{
    ZQMessage *message = self.messageFrame.message;
    //play audio
    if (message.messageMediaType == ZQBubbleMessageMediaTypeVideo) {
//        if(!_contentVoiceIsPlaying){
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"VoicePlayHasInterrupt" object:nil];
//            _contentVoiceIsPlaying = YES;
//            _audio = [UUAVAudioPlayer sharedInstance];
//            _audio.delegate = self;
//            //        [_audio playSongWithUrl:_voiceURL];
//            [_audio playSongWithData:_songData];
//        }else{
//            [self UUAVAudioPlayerDidFinishPlay];
//        }
    }
    //show the picture
    else if (message.messageMediaType == ZQBubbleMessageMediaTypePhoto)
    {
        if (self.btnContent.backImageView) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(chatCell:contentButtonClick:)]) {
                [self.delegate chatCell:self contentButtonClick:message.userId];
            }
            [ZQImageBrowser showImage:self.btnContent.backImageView];
        }
        if ([self.delegate isKindOfClass:[UIViewController class]]) {
            [[(UIViewController *)self.delegate view] endEditing:YES];
        }
    }
    // show text and gonna copy that
    else if (message.messageMediaType == ZQBubbleMessageMediaTypeText)
    {
        [self.btnContent becomeFirstResponder];
        UIMenuController *menu = [UIMenuController sharedMenuController];
        [menu setTargetRect:self.btnContent.frame inView:self.btnContent.superview];
        [menu setMenuVisible:YES animated:YES];
    }
    // show voice
    else if (message.messageMediaType == ZQBubbleMessageMediaTypeVoice) {
        if (message.voicePath || message.voiceUrl) {
            //animation
            [self.btnContent.animationVoiceImageView startAnimating];
//            [self.btnContent.animationVoiceImageView performSelector:@selector(stopAnimating) withObject:nil afterDelay:message.voiceDuration];
            //info
            self.btnContent.voiceUnreadDotImageView.hidden = YES;
            message.isRead = YES;
            //voice
            NSError *err = nil;
            NSData *audioData = nil;
            if (message.voicePath) {
                audioData = [NSData dataWithContentsOfFile:self.messageFrame.message.voicePath options:0 error:&err];
            } else {
                audioData = [NSData dataWithContentsOfURL:[NSURL URLWithString:message.voiceUrl]];
            }
            [[ZQAudioPlayer sharedInstance] playSongWithData:audioData];
            [ZQAudioPlayer sharedInstance].delegate = self;
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(chatCell:voiceButtonClick:)]) {
                [self.delegate chatCell:self voiceButtonClick:self.messageFrame.message.userId];
            }
        }
    }
}

#pragma mark - ZQAudioPlayerDelegate

- (void)ZQAudioPlayerBeiginLoadVoice {
    
}

- (void)ZQAudioPlayerBeiginPlay {
    
}

- (void)ZQAudioPlayerDidFinishPlay {
    [self.btnContent.animationVoiceImageView stopAnimating];
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatCell:voiceDidFinish:)]) {
        [self.delegate chatCell:self voiceDidFinish:self.messageFrame.message.userId];
    }
}

@end
