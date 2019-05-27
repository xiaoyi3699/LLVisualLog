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
        static dispatch_source_t timer;
        if (timer == nil) {
            timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
            dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
            dispatch_source_set_event_handler(timer, ^{
                NSLog(@"哈哈哈");
            });
            dispatch_resume(timer);
            [btn setTitle:@"关闭日志" forState:UIControlStateNormal];
        }
        else {
            dispatch_cancel(timer);
            timer = nil;
            [btn setTitle:@"打印日志" forState:UIControlStateNormal];
        }
    }
    else {
        NSString *text = nil;
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:text];
    }
}

@end
