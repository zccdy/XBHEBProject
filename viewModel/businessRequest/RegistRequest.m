//
//  RegistRequest.m
//  XBHEBProject
//
//  Created by xubh-note on 15/5/8.
//  Copyright (c) 2015年 xu banghui. All rights reserved.
//

#import "RegistRequest.h"

@implementation RegistRequest{
    NSString *_username;
    NSString *_password;
    NSString *_mail;
    NSString *_authCode;
}


+(BOOL)paramsCheckWithUsername:(NSString *)username password:(NSString *)password  mail:(NSString *)mail authCode:(NSString *)code authCodeInput:(NSString *)codeInput{
    NSString *notifyMessage=nil;
    
    if (![username length]) {
        notifyMessage=@"请输入账户名";
    }
    else if (![XBHUitility isValidateUserName:username]){
        notifyMessage=@"用户名以字母开头，支持5-16个由字母、数字、下划线组成的字符";
    }
    else if (![password length]) {
        notifyMessage=@"请输入密码";
    }
   /*
    if (![password2 length]) {
        notifyMessage=@"请确认密码";
    }
    
    if (![password isEqualToString:password2]) {
        notifyMessage=@"输入的密码与确认密码不一致";
    }
*/
    else if (![mail length]) {
        notifyMessage=@"请输入邮箱";
    }
    else if (![XBHUitility isValidateEmail:mail]){
    
        notifyMessage=@"邮箱格式不正确";
    
    }
    
    
    else if (![codeInput length]) {
        notifyMessage=@"请输入验证码";
    }
    else if (![XBHUitility authCodeCheck:codeInput authCode:code]){
    
        notifyMessage=@"验证码不正确";
    }
    
    
    
    if(notifyMessage){
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"出错" message:notifyMessage delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    
    
    
    
    return YES;
}


- (id)initWithUsername:(NSString *)username password:(NSString *)password mail:(NSString *)mail authCode:(NSString *)code{
    self = [super init];
    if (self) {
        _username = username;
        _password = password;
        _mail=mail;
        _authCode=code;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"/docmaster/app/account";
}


- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}

- (id)requestArgument {
    return @{@"register":@"",
             @"loginname": _username,
             @"password": _password,
             @"mail":_mail,
             @"verifycode":@"magicdoc",
    };
}
@end
