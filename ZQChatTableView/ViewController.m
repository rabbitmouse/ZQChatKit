//
//  ViewController.m
//  ZQChatTableView
//
//  Created by 朱志勤 on 2018/6/29.
//  Copyright © 2018年 朱志勤. All rights reserved.
//

#import "ViewController.h"
#import "ZQChatViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}


- (IBAction)PushButtonClicked:(id)sender {
    [self.navigationController pushViewController:[ZQChatViewController new] animated:YES];
}


@end
