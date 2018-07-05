//
//  ZQChatViewController.m
//  ZQChatTableView
//
//  Created by 朱志勤 on 2018/6/29.
//  Copyright © 2018年 朱志勤. All rights reserved.
//

#import "ZQChatViewController.h"
#import "ZQChatTableView.h"
#import "ZQMessageCell.h"
#import "ZQTextToolView.h"
#import "ZQMessage.h"
#import "ZQMessageFrame.h"
#import "ZQChatDefault.h"
#import <Masonry/Masonry.h>

#import "UIScrollView+ZQkeyboardControl.h"

#define TextViewDefualtHeight 40

@interface ZQChatViewController ()<UITableViewDelegate, UITableViewDataSource, ZQMessageInputViewDelegate, ZQMessageCellDelegate>
@property (weak, nonatomic) IBOutlet ZQChatTableView *tableview;
@property (weak, nonatomic) IBOutlet UIView *bottomToolView;
@property (nonatomic, strong) ZQTextToolView *textMessageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolBottomLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolHeightLayout;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

/**
 *  记录旧的textView contentSize Heigth
 */
@property (nonatomic, assign) CGFloat previousTextViewContentHeight;

@property (nonatomic, strong) NSMutableArray *dataSource;
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
    [self configModel];
    [self addKeyboardAction];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self scrollToBottomAnimated:NO];
    });
}

- (void)configUI {
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[ZQMessageCell class] forCellReuseIdentifier:NSStringFromClass([ZQMessageCell class])];
    
    ZQTextToolView *textView = [[NSBundle mainBundle] loadNibNamed:@"ZQTextToolView" owner:nil options:nil].firstObject;
    textView.delegate = self;
    [self.bottomToolView addSubview:textView];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.bottomToolView);
    }];
    self.textMessageView = textView;
    
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidTap:)];
    [self.view addGestureRecognizer:self.tapGesture];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)addKeyboardAction {
    WEAKSELF
    self.tableview.keyboardWillChange = ^(CGRect keyboardRect, UIViewAnimationOptions options, double duration, BOOL showKeyboard) {
        [UIView animateWithDuration:duration
                              delay:0.0
                            options:options
                         animations:^{
                             weakSelf.toolBottomLayout.constant = showKeyboard ? keyboardRect.size.height : 0;
                             [weakSelf.view layoutIfNeeded];
                             
                             if (showKeyboard) {
                                 [weakSelf scrollToBottomAnimated:NO];
                             }
                         }
                         completion:nil];
    };
}

- (void)configModel {
    self.dataSource = [NSMutableArray array];
    NSArray *texts = @[@"文字文字",
                       @"文字文字文字文字文字文字文字文字文字文字文字文字文字文字",
                       @"文字文字文字文字文字文字文字文字文字文字文字文字文字文字",
                       @"文字文字",
                       @"文文字文字文字文字文字文字文字文字文字文字文字文字文字文字字文字",
                       @"文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字",
                       @"文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字",
                       @"文字文文字文字文字文字文字文字文字文字文字文字文字文字文字文字字",
                       @"文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字",
                       @"文字文字文字文字文字文字文字文字文字文字文字文字文字文文字文字文字文字文字文字文字文字文字文字文字文字文字文字字文字文字",
                       @"文文字文字文文字",
                       @"文字文文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字字",
                       @"文文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字字文字",
                       @"文字文文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字字",
                       @"文字文文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字字"];
    
    [texts enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ZQMessage *message = [[ZQMessage alloc] initWithText:obj UserId:@(idx).stringValue sender:@"用户名" timestamp:[NSDate date]];
        message.bubbleMessageType = idx % 3 ? ZQBubbleMessageTypeSend : ZQBubbleMessageTypeReceive;
        ZQMessageFrame *messageFrame = [[ZQMessageFrame alloc] init];
        messageFrame.message = message;
        messageFrame.showTime = YES;
        messageFrame.shouldShowUserName = YES;
        [self.dataSource addObject:messageFrame];
    }];
    
    ZQMessage *photoMessage = [[ZQMessage alloc] initWithPhoto:[UIImage imageNamed:@"defualtPhoto"] UserId:@"aaa" thumbnailUrl:nil originPhotoUrl:nil sender:@"发图片" timestamp:[NSDate date]];
    ZQMessageFrame *photoFrame = [[ZQMessageFrame alloc] init];
    photoFrame.message = photoMessage;
    photoFrame.shouldShowUserName = YES;
    photoFrame.showTime = YES;
    [self.dataSource addObject:photoFrame];
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

- (void)viewDidTap:(UITapGestureRecognizer *)tap {
    [self.textMessageView.inputTextView resignFirstResponder];
}

#pragma mark - ZQMessageInputViewDelegate
- (void)inputTextViewWillBeginEditing:(ZQMessageTextView *)messageInputTextView {
//    self.textViewInputViewType = XHInputViewTypeText;
}

- (void)inputTextViewDidBeginEditing:(ZQMessageTextView *)messageInputTextView {
    if (!self.previousTextViewContentHeight)
        self.previousTextViewContentHeight = MAX([self getTextViewContentH:messageInputTextView], TextViewDefualtHeight) ;
}

- (void)didSendTextAction:(NSString *)text {
    //发送按钮
    NSLog(@"点击了发送按钮");
}

#pragma mark -

- (void)chatCell:(ZQMessageCell *)cell headImageDidClick:(NSString *)userId {
    NSLog(@"点击了头像");
}

- (void)chatCell:(ZQMessageCell *)cell contentButtonClick:(NSString *)userId {
    [self.textMessageView.inputView resignFirstResponder];
    NSLog(@"点击了内容");
}

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