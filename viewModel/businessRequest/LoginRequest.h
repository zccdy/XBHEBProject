//
//  LoginRequest.h
//  XBHEBProject
//
//  Created by xubh-note on 15/4/30.
//  Copyright (c) 2015年 xu banghui. All rights reserved.
//

#import "XBHBaseRequest.h"

@interface LoginRequest : XBHBaseRequest

+(BOOL)paramsCheckWithUsername:(NSString *)username password:(NSString *)password  authCode:(NSString *)code authCodeInput:(NSString *)codeInput;
- (instancetype)initWithUserName:(NSString *)name Password:(NSString *)password AuthCode:(NSString *)code;
@end
