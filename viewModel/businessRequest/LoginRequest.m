//
//  LoginRequest.m
//  XBHEBProject
//
//  Created by xubh-note on 15/4/30.
//  Copyright (c) 2015年 xu banghui. All rights reserved.
//

#import "LoginRequest.h"

@implementation LoginRequest
{
    NSString *_userName;
    NSString *_passWord;
    NSString *_authCode;

}


+(BOOL)paramsCheckWithUsername:(NSString *)username password:(NSString *)password  authCode:(NSString *)code authCodeInput:(NSString *)codeInput{
    NSString *notifyMessage=nil;
    
    if (![username length]) {
        notifyMessage=@"请输入账户名";
    }
    else if (![XBHUitility isValidateUserName:username]){
        notifyMessage=@"用户名以字母开头，支持5-16个由字母、数字、下划线组成的字符";
    }
    
    
    if (![password length]) {
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
    
    
    if (![codeInput length]) {
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

- (instancetype)initWithUserName:(NSString *)name Password:(NSString *)password AuthCode:(NSString *)code
{
    self = [super init];
    if (self) {
        _userName=name;
        _passWord=password;
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
    return @{@"login":@"",
             @"loginname": _userName,
             @"password": _passWord,
             @"verifycode":@"magicdoc",
    };
}

- (NSTimeInterval)requestTimeoutInterval;

{

    return 15.0;
}

@end
