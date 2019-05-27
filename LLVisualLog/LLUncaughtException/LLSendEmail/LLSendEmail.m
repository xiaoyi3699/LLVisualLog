//
//  LLSendEmail.m
//  LLCommonSDK
//
//  Created by WangZhaomeng on 2018/2/8.
//  Copyright © 2018年 WangZhaomeng. All rights reserved.
//

#import "LLSendEmail.h"

@implementation LLSendEmail

- (void)send {
    if ([MFMailComposeViewController canSendMail]) {
        NSMutableString *mailUrl = [[NSMutableString alloc] init];
        [mailUrl appendFormat:@"mailto:%@?", self.recipients];
        [mailUrl appendFormat:@"&subject=%@",self.subject];
        [mailUrl appendFormat:@"&body=%@",self.body];
        
        NSURL *URL = [NSURL URLWithString:mailUrl];
        if (URL == nil) {
            URL = [NSURL URLWithString:[self ll_URLEncodedString:mailUrl]];
        }
        [[UIApplication sharedApplication]openURL:URL];
    }
}

- (NSString *)ll_URLEncodedString:(NSString *)str {
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0) {
        return [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    }
    return [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

@end

@implementation UIViewController (LLSendEmail)

- (void)sendEmail:(LLSendEmail *)email {
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailCompose = [[MFMailComposeViewController alloc] init];
        [mailCompose setMailComposeDelegate:self];
        [mailCompose setSubject:email.subject];
        [mailCompose setToRecipients:[email.recipients componentsSeparatedByString:@","]];
        //非HTML格式
        [mailCompose setMessageBody:email.body isHTML:NO];
        //HTML格式
        //[mailCompose setMessageBody:@"<html><body><p>Hello</p><p>World！</p></body></html>" isHTML:YES];
        [self presentViewController:mailCompose animated:YES completion:nil];
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    switch (result)
    {
        case MFMailComposeResultCancelled: {
            NSLog(@"用户取消编辑");
        }
            break;
        case MFMailComposeResultSaved: {
            NSLog(@"用户保存邮件");
        }
            break;
        case MFMailComposeResultSent: {
            NSLog(@"用户点击发送");
        }
            break;
        case MFMailComposeResultFailed: {
            NSLog(@"用户尝试保存或发送邮件失败", [error localizedDescription]);
        }break;
    }
    [controller dismissViewControllerAnimated:YES completion:nil];
}

@end
