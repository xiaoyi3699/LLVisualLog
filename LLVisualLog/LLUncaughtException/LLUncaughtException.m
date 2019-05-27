//
//  LLUncaughtException.m
//  LLCommonSDK
//
//  Created by WangZhaomeng on 2018/2/11.
//  Copyright © 2018年 WangZhaomeng. All rights reserved.
//

#import "LLUncaughtException.h"

static NSUncaughtExceptionHandler LLUncaughtExceptionHandler;
static NSUncaughtExceptionHandler *oldhandler;
@implementation LLUncaughtException

void LLInstallUncaughtExceptionHandler(void) {
    if(NSGetUncaughtExceptionHandler() != LLUncaughtExceptionHandler) {
        oldhandler = NSGetUncaughtExceptionHandler();
    }
    NSSetUncaughtExceptionHandler(&LLUncaughtExceptionHandler);
}

void LLUninstall(void) {
    NSSetUncaughtExceptionHandler(oldhandler);
}

void LLUncaughtExceptionHandler(NSException *exception) {
    
    //获取异常崩溃信息
    NSArray *callStack = [exception callStackSymbols];
    NSString *reason = [exception reason];
    NSString *name = [exception name];
    NSString *content = [NSString stringWithFormat:@"<b>name：</b>\n%@\n\n<b>reason：</b>\n%@\n\n<b>callStackSymbols：</b>\n%@",name,reason,[callStack componentsJoinedByString:@"\n"]];
    
    NSMutableString *mstr = [[NSMutableString alloc] init];
    [mstr appendFormat:@"<b>发送异常错误报告\n\n</b>"];
    [mstr appendFormat:@"<b>应用名称：</b>%@\n", LLAppName];
    [mstr appendFormat:@"<b>Version：</b>%@\n", LLAppVersion];
    [mstr appendFormat:@"<b>Build：</b>%@\n", LLAppBuild];
    [mstr appendFormat:@"<b>iOS版本：</b>%@\n\n", [UIDevice currentDevice].systemVersion];
    [mstr appendFormat:@"%@", content];
    
    LLSendEmail *email = [[LLSendEmail alloc] init];
    email.recipients = @"122589615@qq.com";
    email.subject = @"SDK程序异常崩溃";
    email.body = [mstr copy];
    [email send];
}

@end


