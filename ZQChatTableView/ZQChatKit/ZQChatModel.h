//
//  ZQChatModel.h
//  ZQChatTableView
//
//  Created by zzq on 2018/7/18.
//  Copyright © 2018年 zzq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZQChatModel : NSObject

@property (nonatomic, copy) NSString *senderName;
@property (nonatomic, copy) NSString *senderId;

@property (nonatomic, strong) NSMutableArray *dataSource;


@end
