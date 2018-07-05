//
//  ZQMessageCell.m
//  ZQChatTableView
//
//  Created by 朱志勤 on 2018/6/29.
//  Copyright © 2018年 朱志勤. All rights reserved.
//

#import "ZQMessageCell.h"
#import "ZQMessageFrame.h"
#import "ZQMessage.h"
#import "ZQImageBrowser.h"

#import "NSString+ZQChat.h"
#import "UIImageView+WebCache.h"

@interface ZQMessageCell() {
    UIImageView *_headImageBackView;
}

@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *namelabel;
@property (nonatomic, strong) UIButton *headImageButton;

@property (nonatomic, strong) ZQMessageContentView *btnContent;

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
//        self.btnContent.isMyMessage = YES;
        [self.btnContent setTitleColor:self.senderTextColor forState:UIControlStateNormal];
        self.btnContent.titleEdgeInsets = UIEdgeInsetsMake(ChatContentTopBottom, ChatContentSmaller, ChatContentTopBottom, ChatContentBiger);
    } else {
//        self.btnContent.isMyMessage = NO;
        [self.btnContent setTitleColor:self.reciveTextColor forState:UIControlStateNormal];
        self.btnContent.titleEdgeInsets = UIEdgeInsetsMake(ChatContentTopBottom, ChatContentBiger, ChatContentTopBottom, ChatContentSmaller);
    }
    
    //content-background image
    UIImage *normal;
    if (message.messageMediaType == ZQBubbleMessageMediaTypeText) {
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
            break;
        case ZQBubbleMessageMediaTypePhoto:
        {
            self.btnContent.backImageView.hidden = NO;
            self.btnContent.imageView.contentMode = UIViewContentModeScaleAspectFit;
            UIImage *defualtPhoto = [UIImage imageNamed:@"defualtPhoto"];
            if (message.photo) {
                self.btnContent.backImageView.image = message.photo;
            } else if (message.thumbnailUrl) {
                [self.btnContent.backImageView sd_setImageWithURL:[NSURL URLWithString:message.thumbnailUrl] placeholderImage:defualtPhoto];
            } else if (message.originPhotoUrl) {
                [self.btnContent.backImageView sd_setImageWithURL:[NSURL URLWithString:message.originPhotoUrl] placeholderImage:defualtPhoto];
            } else {
                self.btnContent.backImageView.image = defualtPhoto;
            }
            
//            [self makeMaskView:self.btnContent.backImageView withImage:normal];
        }
            break;
        case ZQBubbleMessageMediaTypeVideo:
        {
//            self.btnContent.voiceBackView.hidden = NO;
//            self.btnContent.second.text = [NSString stringWithFormat:@"%@'s Voice",message.strVoiceTime];
//            _songData = message.voice;
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
    //play audio
    if (self.messageFrame.message.messageMediaType == ZQBubbleMessageMediaTypeVideo) {
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
    else if (self.messageFrame.message.messageMediaType == ZQBubbleMessageMediaTypePhoto)
    {
        if (self.btnContent.backImageView) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(chatCell:contentButtonClick:)]) {
                [self.delegate chatCell:self contentButtonClick:self.messageFrame.message.userId];
            }
            [ZQImageBrowser showImage:self.btnContent.backImageView];
        }
        if ([self.delegate isKindOfClass:[UIViewController class]]) {
            [[(UIViewController *)self.delegate view] endEditing:YES];
        }
    }
    // show text and gonna copy that
    else if (self.messageFrame.message.messageMediaType == ZQBubbleMessageMediaTypeText)
    {
        [self.btnContent becomeFirstResponder];
        UIMenuController *menu = [UIMenuController sharedMenuController];
        [menu setTargetRect:self.btnContent.frame inView:self.btnContent.superview];
        [menu setMenuVisible:YES animated:YES];
    }
}

@end