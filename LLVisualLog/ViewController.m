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
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 100, 100, 30);
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    [btn setTitle:@"打印日志" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)btnClick:(UIButton *)btn {
    static dispatch_source_t timer;
    if (timer == nil) {
        timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
        dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
        dispatch_source_set_event_handler(timer, ^{
            NSLog(@"哈哈哈");
        });
        dispatch_resume(timer);
    }
    else {
        dispatch_cancel(timer);
        timer = nil;
    }
}

@end
