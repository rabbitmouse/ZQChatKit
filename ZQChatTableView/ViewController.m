//
//  ViewController.m
//  ZQChatTableView
//
//  Created by zzq on 2018/6/29.
//  Copyright © 2018年 zzq. All rights reserved.
//

#import "ViewController.h"
#import "ZQChatViewController.h"
#import "DemoViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}


- (IBAction)PushButtonClicked:(id)sender {
    [self.navigationController pushViewController:[DemoViewController new] animated:YES];
}


@end
