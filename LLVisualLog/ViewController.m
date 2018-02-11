//
//  ViewController.m
//  LLVisualLog
//
//  Created by WangZhaomeng on 2018/2/5.
//  Copyright © 2018年 WangZhaomeng. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *logBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    logBtn.frame = CGRectMake(100, 100, 100, 30);
    logBtn.tag = 0;
    logBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [logBtn setTitle:@"打印日志" forState:UIControlStateNormal];
    [logBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [logBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logBtn];
    
    UIButton *errorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    errorBtn.frame = CGRectMake(100, 200, 100, 30);
    errorBtn.tag = 1;
    errorBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [errorBtn setTitle:@"异常捕获" forState:UIControlStateNormal];
    [errorBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [errorBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:errorBtn];
}

- (void)btnClick:(UIButton *)btn {
    if (btn.tag == 0) {
        NSLog(@"哈哈哈");
    }
    else {
        NSString *text = nil;
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:text];
    }
}

@end
