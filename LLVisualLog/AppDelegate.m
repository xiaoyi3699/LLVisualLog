//
//  AppDelegate.m
//  LLVisualLog
//
//  Created by WangZhaomeng on 2018/2/5.
//  Copyright © 2018年 WangZhaomeng. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [self.window setRootViewController:[ViewController new]];
    
#if DEBUG
    //日志打印
    [LLLogView startLog];
    //监听cup使用量和页面帧率
    [self.window startObserveFpsAndCpu];
    //异常捕获
    LLInstallSignalHandler();
    LLInstallUncaughtExceptionHandler();
#endif
    return YES;
}

void UncaughtExceptionHandler(NSException *exception) {
    
    //获取异常崩溃信息
    NSArray *callStack = [exception callStackSymbols];
    NSString *reason = [exception reason];
    NSString *name = [exception name];
    NSString *content = [NSString stringWithFormat:@"<b>发送异常错误报告</b>\n<b>name</b>:\n%@\n\n<b>reason</b>:\n%@\n\n<b>callStackSymbols</b>:\n%@",name,reason,[callStack componentsJoinedByString:@"\n"]];
    
    //在这里可以自行处理崩溃日志：
    /* 处理方式1：仿友盟错误统计
      将崩溃信息存入本地，当程序再次打开时，将本地的错误信息发送至指定服务器，实现统计错误信息的目的
     */
    /* 处理方式2：将错误信息发送到开发者邮箱
     须真机，且手机邮箱已登录
     */
    
    //这里使用方式2，将错误信息发送至开发者邮箱
    NSMutableString *mailUrl = [[NSMutableString alloc] init];
    [mailUrl appendFormat:@"mailto:122589615@qq.com?"];
    [mailUrl appendFormat:@"&subject=程序异常崩溃"];
    [mailUrl appendFormat:@"&body=%@",content];
    
    NSString *emailPath = [mailUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:emailPath]];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
