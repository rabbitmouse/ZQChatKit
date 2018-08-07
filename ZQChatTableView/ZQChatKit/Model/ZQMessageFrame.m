//
//  ZQMessageFrame.m
//  ZQChatTableView
//
//  Created by zzq on 2018/6/29.
//  Copyright © 2018年 zzq. All rights reserved.
//

#import "ZQMessageFrame.h"
#import "ZQMessage.h"
#import "ZQChatDefault.h"
#import "NSString+ZQChat.h"

@implementation ZQMessageFrame

- (void)setMessage:(ZQMessage *)message {
    _message = message;
    
    CGFloat const sWitdh = ZQScreenWidth;
    
    //计算timeF
    if (self.showTime) {
        NSString *timeStr = [NSString timeStringWithDate:_message.timestamp];
        CGSize timeSize = [timeStr zq_sizeWithFont:ChatTimeFont constrainedToSize:CGSizeMake(300, 100)];
        _timeF = CGRectMake((sWitdh - timeSize.width)/2, ChatMargin, timeSize.width, timeSize.height);
    } else {
        _timeF = CGRectZero;
    }
    
    //计算iconF
    CGFloat iconX = _message.bubbleMessageType == ZQBubbleMessageTypeReceive ? ChatMargin : (sWitdh - ChatMargin - ChatIconWH);
    _iconF = CGRectMake(iconX, CGRectGetMaxY(_timeF) + ChatMargin, ChatIconWH, ChatIconWH);
    
    //计算nameF
    if(self.shouldShowUserName) {
        CGSize nameSize = [_message.sender zq_sizeWithFont:ChatTimeFont constrainedToSize:CGSizeMake(ChatIconWH+ChatMargin, 50)];
        CGFloat nameMargin = ChatIconWH + 2 * ChatMargin;
        CGFloat nameX = _message.bubbleMessageType == ZQBubbleMessageTypeReceive ? nameMargin - ChatMargin : sWitdh - nameMargin - nameSize.width - ChatMargin/2.0;
        _nameF = CGRectMake(nameX, CGRectGetMaxY(_timeF) + ChatMargin/2.0, ChatIconWH+ChatMargin, nameSize.height);
    } else {
        _nameF = CGRectZero;
    }
    
    
    //计算contentF
    //根据种类分
    CGSize contentSize;
    switch (_message.messageMediaType) {
        case ZQBubbleMessageMediaTypeText:
            contentSize = [_message.text zq_sizeWithFont:ChatContentFont constrainedToSize:CGSizeMake(MAX(ChatContentW, sWitdh*0.6), CGFLOAT_MAX)];
            contentSize.height = MAX(contentSize.height, 30);
            contentSize.width = MAX(contentSize.width, 40);
            break;
        case ZQBubbleMessageMediaTypePhoto:
        case ZQBubbleMessageMediaTypeVideo: {
            if (_message.photo) {
                CGFloat pWidth = _message.photo.size.width;
                CGFloat pHeight = _message.photo.size.height;
                CGFloat picWitdh = MIN(ChatPicWH, pWidth);
                contentSize = CGSizeMake(picWitdh, pHeight/pWidth * picWitdh);
            } else {
                CGFloat pWidth = _message.picWidth == 0 ? ChatPicWH : MIN(ChatPicWH, _message.picWidth);
                CGFloat pHeight = _message.picHeight == 0 ? ChatPicWH : MIN(ChatPicWH, _message.picHeight);
                contentSize = CGSizeMake(pWidth, pHeight);
            }
        }
            break;
        case ZQBubbleMessageMediaTypeVoice: {
            CGFloat maxWidth = ZQScreenWidth /2 - 60;
            CGFloat precent = (_message.voiceDuration - 8) / @(60 - 8).floatValue;
            CGFloat vWidth = _message.voiceDuration < 8 ? 60 : (maxWidth * precent) + 60;
            
            contentSize = CGSizeMake(vWidth, 30);
        }
            break;
        default:
            break;
    }
    
    CGFloat contentX = _message.bubbleMessageType == ZQBubbleMessageTypeReceive ? (iconX + ChatIconWH + ChatMargin) : sWitdh - (contentSize.width + ChatContentSmaller + ChatContentBiger + 2 * ChatMargin + ChatIconWH);
    _contentF = CGRectMake(contentX, MAX(CGRectGetMaxY(_timeF), CGRectGetMaxY(_nameF)) + ChatMargin, contentSize.width + ChatContentBiger + ChatContentSmaller, contentSize.height + ChatContentTopBottom * 2);
    
    //失败按钮frame
    CGFloat failX = 0.f;
    if (_message.bubbleMessageType == ZQBubbleMessageTypeReceive) {
        failX = CGRectGetMaxX(self.contentF) + ChatMargin;
    } else {
        failX = contentX - ChatMargin - FailBtnW;
    }
    _failBtnF = CGRectMake(failX, CGRectGetMaxY(_contentF) - FailBtnW, FailBtnW, FailBtnW);
    
    //计算cellHeight
    _cellHeight = CGRectGetMaxY(_contentF) + CGRectGetMaxY(_timeF)  + ChatMargin;
}

- (void)setShowTime:(BOOL)showTime
{
    _showTime = showTime;
    
    if (_message) {
        self.message = _message;
    }
}
- (void)setShouldShowUserName:(BOOL)shouldShowUserName {
    _shouldShowUserName = shouldShowUserName;
    
    if (_message) {
        self.message = _message;
    }
}

@end
