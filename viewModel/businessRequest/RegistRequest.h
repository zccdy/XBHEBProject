//
//  RegistRequest.h
//  XBHEBProject
//
//  Created by xubh-note on 15/5/8.
//  Copyright (c) 2015年 xu banghui. All rights reserved.
//

#import "XBHBaseRequest.h"

@interface RegistRequest : XBHBaseRequest

+(BOOL)paramsCheckWithUsername:(NSString *)username password:(NSString *)password  mail:(NSString *)mail authCode:(NSString *)code authCodeInput:(NSString *)codeInput;
- (id)initWithUsername:(NSString *)username password:(NSString *)password mail:(NSString *)mail authCode:(NSString *)code;

@end
