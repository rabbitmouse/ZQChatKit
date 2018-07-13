//
//  ZQChatViewController.m
//  ZQChatTableView
//
//  Created by zzq on 2018/6/29.
//  Copyright © 2018年 zzq. All rights reserved.
//

#import "ZQChatViewController.h"

#import "ZQMessageCell.h"
#import "ZQTextToolView.h"
#import "ZQChatMenuView.h"

#import <Masonry/Masonry.h>

#import "UIScrollView+ZQkeyboardControl.h"

#define TextViewDefualtHeight 40

@interface ZQChatViewController ()
<UITableViewDelegate,
UITableViewDataSource,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
ZQMessageInputViewDelegate,
ZQMessageCellDelegate,
ZQChatMenuViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *bottomToolView;

@property (nonatomic, strong) ZQTextToolView *textMessageView;
@property (nonatomic, strong) ZQChatMenuView *menuView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolBottomLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolHeightLayout;

@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@property (nonatomic, assign, readwrite) ZQChatInputViewType inputViewType;

/**
 *  记录旧的textView contentSize Heigth
 */
@property (nonatomic, assign) CGFloat previousTextViewContentHeight;


@end

@implementation ZQChatViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 设置键盘通知或者手势控制键盘消失
    [self.tableview setupPanGestureControlKeyboardHide:NO];
    
    // KVO 检查contentSize
    [self.textMessageView.inputTextView addObserver:self
                                          forKeyPath:@"contentSize"
                                             options:NSKeyValueObservingOptionNew
                                             context:nil];
    
    [self.textMessageView.inputTextView setEditable:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // remove键盘通知或者手势
    [self.tableview disSetupPanGestureControlKeyboardHide:NO];
    
    // remove KVO
    [self.textMessageView.inputTextView removeObserver:self forKeyPath:@"contentSize"];
    [self.textMessageView.inputTextView setEditable:NO];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configUI];
    [self addKeyboardAction];
}

- (void)configUI {
    self.delegate = self;
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.estimatedRowHeight =0;
    self.tableview.estimatedSectionHeaderHeight =0;
    self.tableview.estimatedSectionFooterHeight =0;
    [self.tableview registerClass:[ZQMessageCell class] forCellReuseIdentifier:NSStringFromClass([ZQMessageCell class])];
    
    ZQTextToolView *textView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ZQTextToolView class]) owner:nil options:nil].firstObject;
    textView.recordButton.alpha = 0;
    textView.delegate = self;
    [self.bottomToolView addSubview:textView];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.bottomToolView);
    }];
    self.textMessageView = textView;
    
    ZQChatMenuView *menuView = [ZQChatMenuView new];
    menuView.delegate = self;
    if (self.delegate && [self.delegate respondsToSelector:@selector(loadCustomMenus)]) {
        menuView.menus = [self.delegate loadCustomMenus].copy;
    } else {
        NSArray *titles = @[@"拍照",@"照片",@"位置"];
        NSArray *icons = @[@"sharemore_video",@"sharemore_pic",@"sharemore_location"];
        NSMutableArray *menus = [NSMutableArray array];
        for (int i = 0; i < 3; ++i) {
            ZQMenuItem *item = [ZQMenuItem new];
            item.title = titles[i];
            item.imgName = icons[i];
            [menus addObject:item];
        }
        menuView.menus = [menus copy];
    }
    menuView.alpha = 0;
    [self.view addSubview:menuView];
    [menuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.bottomToolView.mas_bottom);
        make.height.mas_equalTo(@200);
    }];
    self.menuView = menuView;
    
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidTap:)];
    [self.tableview addGestureRecognizer:self.tapGesture];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.inputViewType = ZQChatInputViewTypeNormal;
}

- (void)addKeyboardAction {
    WEAKSELF
    self.tableview.keyboardWillChange = ^(CGRect keyboardRect, UIViewAnimationOptions options, double duration, BOOL showKeyboard) {
        [UIView animateWithDuration:duration
                              delay:0.0
                            options:options
                         animations:^{
                             
                             if (self.inputViewType != ZQChatInputViewTypeTool) {
                                 weakSelf.toolBottomLayout.constant = showKeyboard ? keyboardRect.size.height : 0;
                                 
                                 [weakSelf.view layoutIfNeeded];
                                 
                                 if (showKeyboard) {
                                     [weakSelf scrollToBottomAnimated:NO];
                                 }
                             }
                         }
                         completion:nil];
    };
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZQMessageFrame *frame = self.dataSource[indexPath.row];
    return frame.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZQMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZQMessageCell class])];
    cell.senderTextColor = self.senderTextColor;
    cell.reciveTextColor = self.reciveTextColor;
    cell.backViewColor = self.backViewColor;
    cell.senderBubbleImage = self.senderBubbleImage;
    cell.reciveBubbleImage = self.reciveBubbleImage;
    cell.senderAvatarImage = self.senderAvatarImage;
    cell.reciveAvatarImage = self.reciveAvatarImage;
    cell.delegate = self;
    
    cell.messageFrame = self.dataSource[indexPath.row];
    return cell;
}

#pragma mark - Key-value Observing

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if (object == self.textMessageView.inputTextView && [keyPath isEqualToString:@"contentSize"]) {
        [self layoutAndAnimateMessageInputTextView:object];
    }
}

#pragma mark - UITextView Helper Method

- (CGFloat)getTextViewContentH:(UITextView *)textView {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        return [textView sizeThatFits:CGSizeMake(CGRectGetWidth(textView.frame), MAXFLOAT)].height;
    } else {
        return textView.contentSize.height;
    }
}

#pragma mark - Scroll Message TableView Helper Method

- (void)setTableViewInsetsWithBottomValue:(CGFloat)bottom {
    UIEdgeInsets insets = [self tableViewInsetsWithBottomValue:bottom];
    self.tableview.contentInset = insets;
    self.tableview.scrollIndicatorInsets = insets;
}

- (UIEdgeInsets)tableViewInsetsWithBottomValue:(CGFloat)bottom {
    UIEdgeInsets insets = UIEdgeInsetsZero;
    
    if ([self respondsToSelector:@selector(topLayoutGuide)]) {
        insets.top = self.topLayoutGuide.length;
    }
    
    insets.bottom = bottom;
    
    return insets;
}

#pragma mark - Layout Message Input View Helper Method

- (void)reloadChatView {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableview reloadData];
        [self scrollToBottomAnimated:YES];
    });
}

- (void)scrollToBottomAnimated:(BOOL)animated {
    
    NSInteger rows = [self.tableview numberOfRowsInSection:0];
    
    if (rows > 0) {
        [self.tableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rows - 1 inSection:0]
                                     atScrollPosition:UITableViewScrollPositionBottom
                                             animated:animated];
    }
}

- (void)layoutAndAnimateMessageInputTextView:(UITextView *)textView {
    
    CGFloat maxHeight = [ZQTextToolView maxHeight];
    
    CGFloat contentH = [self getTextViewContentH:textView];
    
    BOOL isShrinking = contentH < self.previousTextViewContentHeight;
    CGFloat changeInHeight = contentH - _previousTextViewContentHeight;
    
    if (!isShrinking && (self.previousTextViewContentHeight == maxHeight || contentH <= TextViewDefualtHeight)) {
        changeInHeight = 0;
    }
    else {
        changeInHeight = MIN(changeInHeight, maxHeight - self.previousTextViewContentHeight);
    }
    
    if (changeInHeight != 0.0f) {
        [UIView animateWithDuration:0.25f
                         animations:^{
                             [self scrollToBottomAnimated:NO];
                             self.toolHeightLayout.constant = MAX(contentH, TextViewDefualtHeight)  + 10;
                             [self.view layoutIfNeeded];
                         }
                         completion:nil];
        
        self.previousTextViewContentHeight = MIN(contentH, maxHeight);
    }
}

- (void)menuViewNeedHide:(BOOL)nHide {
    if (nHide && self.inputViewType == ZQChatInputViewTypeTool) {
        [self.textMessageView.inputTextView becomeFirstResponder];
    } else if (!nHide && self.inputViewType == ZQChatInputViewTypeTool) {
        [self showVoiceView:NO];
        [self.textMessageView.inputTextView resignFirstResponder];
    }
    
    if (nHide) {
        // hide
        [UIView animateWithDuration:0.25f animations:^{
            self.menuView.alpha = 0;
            if (self.inputViewType == ZQChatInputViewTypeNormal) {
                self.toolBottomLayout.constant = 0;
            }
            [self.view layoutIfNeeded];
        } completion:nil];
    } else {
        // show
        [UIView animateWithDuration:0.25f animations:^{
            self.menuView.alpha = 1;
            self.toolBottomLayout.constant = CGRectGetHeight(self.menuView.frame);
            [self.view layoutIfNeeded];
            
            [self scrollToBottomAnimated:NO];
        } completion:nil];
    }
}

- (void)showVoiceView:(BOOL)show {
    if (!show && self.inputViewType == ZQChatInputViewTypeVoice) {
        [self.textMessageView.inputTextView becomeFirstResponder];
    }
    
    if (show) {
        [self.textMessageView.inputTextView resignFirstResponder];
        [self menuViewNeedHide:YES];
        
        [UIView animateWithDuration:0.25 animations:^{
            self.textMessageView.inputTextView.alpha = 0;
            self.textMessageView.recordButton.alpha = 1;
            self.toolBottomLayout.constant = 0;
            [self.view layoutIfNeeded];
        }];
    } else {
        [UIView animateWithDuration:0.25 animations:^{
            self.textMessageView.inputTextView.alpha = 1;
            self.textMessageView.recordButton.alpha = 0;
            [self.view layoutIfNeeded];
        }];
    }
}

- (void)viewDidTap:(UITapGestureRecognizer *)tap {
    if (self.inputViewType == ZQChatInputViewTypeVoice) {
        return;
    }
    if (self.inputViewType == ZQChatInputViewTypeTool) {
        [self menuViewNeedHide:YES];
    }
    self.inputViewType = ZQInputViewTypeNormal;
    [self.textMessageView.inputTextView resignFirstResponder];
}

- (void)showPhotoWithSourceType:(BOOL)isCamera {
    if (isCamera && ![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        return;
    }
    if (!isCamera && ![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        return;
    }
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = isCamera ? UIImagePickerControllerSourceTypeCamera : UIImagePickerControllerSourceTypePhotoLibrary;
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - ZQMessageInputViewDelegate
- (void)inputTextViewWillBeginEditing:(ZQMessageTextView *)messageInputTextView {
    self.inputViewType = ZQChatInputViewTypeText;
    [self menuViewNeedHide:YES];
}

- (void)inputTextViewDidBeginEditing:(ZQMessageTextView *)messageInputTextView {
    if (!self.previousTextViewContentHeight)
        self.previousTextViewContentHeight = MAX([self getTextViewContentH:messageInputTextView], TextViewDefualtHeight) ;
}

- (void)didSendTextAction:(NSString *)text {
    //发送按钮
    NSLog(@"点击了发送按钮");
    self.textMessageView.inputTextView.text = @"";
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSendText:fromSender:onDate:)]) {
        [self.delegate didSendText:text fromSender:@"sender" onDate:[NSDate date]];
    }
}

- (void)didSelectedMultipleMediaAction {
    if (self.inputViewType != ZQChatInputViewTypeTool) {
        self.inputViewType = ZQChatInputViewTypeTool;
        [self menuViewNeedHide:NO];
    } else {
        [self menuViewNeedHide:YES];
    }
}

- (void)didSelectedVoiceMediaAction {
    if (self.inputViewType != ZQChatInputViewTypeVoice) {
        self.inputViewType = ZQChatInputViewTypeVoice;
        [self showVoiceView:YES];
    } else {
        [self showVoiceView:NO];
    }
}

#pragma mark - ZQMessageCellDelegate

- (void)chatCell:(ZQMessageCell *)cell headImageDidClick:(NSString *)userId {
    NSLog(@"点击了头像");
}

- (void)chatCell:(ZQMessageCell *)cell contentButtonClick:(NSString *)userId {
    [self.textMessageView.inputView resignFirstResponder];
    NSLog(@"点击了内容");
}

#pragma mark - ZQChatMenuViewDelegate
- (void)MenuViewDidSelectItem:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(customMenusDidSelectItem:)]) {
        [self.delegate customMenusDidSelectItem:indexPath];
    } else {
        //默认
        switch (indexPath.item) {
            case 0:
                //拍照
                NSLog(@"点击了拍照");
                [self showPhotoWithSourceType:YES];
                break;
            case 1:
                //相册
                NSLog(@"点击了相册");
                [self showPhotoWithSourceType:NO];
                break;
            case 2:
                //地点
                break;

            default:
                break;
        }
    }
}

#pragma mark - UIImagePickerViewDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSendPhoto:fromSender:onDate:)]) {
        [self.delegate didSendPhoto:image fromSender:@"self" onDate:[NSDate date]];
    }
}

//- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
//    [self dismissViewControllerAnimated:YES completion:nil];
//}

#pragma mark - getter & setter
- (UIColor *)senderTextColor {
    if (_senderTextColor == nil) {
        return ZQConfigStyle.senderDefualtColor;
    }
    return _senderTextColor;
}

- (UIColor *)reciveTextColor {
    if (_reciveTextColor == nil) {
        return ZQConfigStyle.reciveDefualtColor;
    }
    return _reciveTextColor;
}

- (UIColor *)backViewColor {
    if (_backViewColor == nil) {
        return ZQConfigStyle.backgroudDefualtColor;
    }
    return _backViewColor;
}

- (UIImage *)senderBubbleImage {
    if (_senderBubbleImage == nil) {
        return ZQConfigStyle.senderBubbleDefualtImage;
    }
    return _senderBubbleImage;
}

- (UIImage *)reciveBubbleImage {
    if (_reciveBubbleImage == nil) {
        return ZQConfigStyle.reciveBubbleDefualtImage;
    }
    return _reciveBubbleImage;
}

- (UIImage *)senderAvatarImage {
    if (_senderAvatarImage == nil) {
        return ZQConfigStyle.senderDefualtAvatar;
    }
    return _senderAvatarImage;
}

- (UIImage *)reciveAvatarImage {
    if (_reciveAvatarImage == nil) {
        return ZQConfigStyle.reciveDefualtAvatar;
    }
    return _reciveAvatarImage;
}

@end
