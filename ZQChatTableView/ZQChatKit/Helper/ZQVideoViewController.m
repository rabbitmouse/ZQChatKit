//
//  ZQVideoViewController.m
//  ZQChatTableView
//
//  Created by zzq on 2018/8/22.
//  Copyright © 2018年 zzq. All rights reserved.
//

#import "ZQVideoViewController.h"
#import "ZQVideoHelper.h"
#import "ZQChatDefault.h"
#import "ZQRoundProgressButton.h"

@interface ZQVideoViewController ()

@property (nonatomic, strong) ZQVideoHelper *videoHelper;
@property (nonatomic, strong) ZQRoundProgressButton *recordButton;


@end

@implementation ZQVideoViewController

- (void)dealloc {
    NSLog(@"video controller 释放成功");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configUI];
}

- (void)configUI {
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ZQScreenWidth, 64)];
    topView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:topView];
    
    UIView *playerView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topView.frame), ZQScreenWidth, ZQScreenHeight - 64 - 100)];
    playerView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:playerView];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(playerView.frame), ZQScreenWidth, 100)];
    bottomView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:bottomView];
    
    CGFloat btnWH = 44.f;
    CGFloat btnPadding = 20.f;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(btnPadding, btnPadding, btnWH, btnWH);
    backButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backButton setTitle:@"取消" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(dismissController) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:backButton];
    
    UIButton *switchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    switchButton.frame = CGRectMake(ZQScreenWidth - btnPadding - btnWH, btnPadding, btnWH, btnWH);
    switchButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [switchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [switchButton setTitle:@"切换" forState:UIControlStateNormal];
    [switchButton addTarget:self action:@selector(switchButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:switchButton];
    
    WEAKSELF
    ZQRoundProgressButton *recordButton = [[ZQRoundProgressButton alloc] initProgressButtonWithCompleteBlock:^{
        [weakSelf finishRecordVideo];
    }];;
    CGFloat WH = 60.f;
    recordButton.frame = CGRectMake((ZQScreenWidth - WH) / 2, (100 - WH)/2, WH, WH);
    [recordButton setBackgroundImage:[UIImage imageNamed:@"radio-button-off"] forState:UIControlStateNormal];
    [recordButton setBackgroundImage:[UIImage imageNamed:@"radio-button-on"] forState:UIControlStateHighlighted];
    [recordButton addTarget:self action:@selector(recordVideoButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [recordButton addTarget:self action:@selector(recordVideoButtonTouchUp:) forControlEvents:UIControlEventTouchUpInside];
    [recordButton addTarget:self action:@selector(recordVideoButtonTouchUp:) forControlEvents:UIControlEventTouchUpOutside];
    [bottomView addSubview:recordButton];
    self.recordButton = recordButton;
    
    CALayer *previewLayer = self.videoHelper.playerView;
    previewLayer.frame = playerView.bounds;
    [playerView.layer insertSublayer:previewLayer atIndex:0];
}

- (void)finishRecordVideo {
    [self.videoHelper stopRecordVideo];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didRecordVideoFinished:)]) {
        [self.delegate didRecordVideoFinished:self.videoHelper.lastFilePath];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - action
- (void)dismissController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)switchButtonClicked {
    [self.videoHelper switchScene];
}

- (void)recordVideoButtonTouchDown:(ZQRoundProgressButton *)sender {
    [sender startProgressWithTimer:15.f];
    [self.videoHelper startRecordVideo];
}

- (void)recordVideoButtonTouchUp:(ZQRoundProgressButton *)sender {
    [sender stopProgress];
    [self finishRecordVideo];
}

#pragma mark - getter && setter
- (ZQVideoHelper *)videoHelper {
    if (!_videoHelper) {
        _videoHelper = [[ZQVideoHelper alloc] init];
    }
    return _videoHelper;
}

@end
