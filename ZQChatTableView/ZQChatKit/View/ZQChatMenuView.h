//
//  ZQChatMenuView.h
//  ZQChatTableView
//
//  Created by zzq on 2018/7/5.
//  Copyright © 2018年 zzq. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZQChatMenuViewDelegate <NSObject>

- (void)MenuViewDidSelectItem:(NSIndexPath *)indexPath;

@end

@interface ZQChatMenuView : UIView

@property (nonatomic, strong) NSArray *menus;
@property (nonatomic, weak) id<ZQChatMenuViewDelegate> delegate;

- (void)reloadMenu;

@end
