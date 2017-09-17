//
//  ViewController.m
//  AutoCycleScrollView
//
//  Created by 袁鑫亮 on 2017/9/17.
//  Copyright © 2017年 yxl. All rights reserved.
//

#import "ViewController.h"
#import "YXLAutoCycleScrollView.h"

@interface ViewController ()

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat width = self.view.frame.size.width;
    YXLAutoCycleScrollView *scrollView = [[YXLAutoCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, width, width / 2)];
    scrollView.center = self.view.center;
    scrollView.imageNameArray = @[@"0", @"1", @"2", @"3", @"4"];
    [self.view addSubview:scrollView];
}


@end
