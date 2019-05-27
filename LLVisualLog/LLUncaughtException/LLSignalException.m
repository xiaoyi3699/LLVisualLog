//
//  LLSignalException.m
//  LLCommonSDK
//
//  Created by WangZhaomeng on 2018/2/11.
//  Copyright © 2018年 WangZhaomeng. All rights reserved.
//

#import "LLSignalException.h"
#include <execinfo.h>

@implementation LLSignalException

void LLInstallSignalHandler(void) {
    signal(SIGHUP , SignalExceptionHandler);
    signal(SIGINT , SignalExceptionHandler);
    signal(SIGQUIT, SignalExceptionHandler);

    signal(SIGABRT, SignalExceptionHandler);
    signal(SIGILL , SignalExceptionHandler);
    signal(SIGSEGV, SignalExceptionHandler);
    signal(SIGFPE , SignalExceptionHandler);
    signal(SIGBUS , SignalExceptionHandler);
    signal(SIGPIPE, SignalExceptionHandler);
}

void SignalExceptionHandler(int signal) {
    NSMutableString *mstr = [[NSMutableString alloc] init];
    [mstr appendFormat:@"<b>发送异常错误报告\n\n</b>"];
    [mstr appendFormat:@"<b>应用名称：</b>%@\n", LLAppName];
    [mstr appendFormat:@"<b>Version：</b>%@\n", LLAppVersion];
    [mstr appendFormat:@"<b>Build：</b>%@\n", LLAppBuild];
    [mstr appendFormat:@"<b>iOS版本：</b>%@\n\n", [UIDevice currentDevice].systemVersion];
    
    [mstr appendString:@"<b>callStackSymbols</b>:\n"];
    void* callstack[128];
    int i, frames = backtrace(callstack, 128);
    char** strs = backtrace_symbols(callstack, frames);
    for (i = 0; i <frames; ++i) {
        [mstr appendFormat:@"%s\n", strs[i]];
    }
    
    LLSendEmail *email = [[LLSendEmail alloc] init];
    email.recipients = @"122589615@qq.com";
    email.subject = @"SDK程序异常崩溃";
    email.body = [mstr copy];
    [email send];
}

@end
