//
//  XBHBackgroundHandler.h
//  XBHEBProject
//
//  Created by xubh-note on 15/4/30.
//  Copyright (c) 2015年 xu banghui. All rights reserved.
//

#import <Foundation/Foundation.h>



typedef NS_ENUM(NSUInteger, XBHLoginType){
    XBHLoginType_Guest=1,
    XBHLoginType_Account

};


typedef NS_ENUM(NSUInteger, XBHLoginStatus){
    XBHLoginStatus_Failure=0,
    
    XBHLoginStatus_Success
};



@interface XBHBackgroundHandler : NSObject




+ (XBHBackgroundHandler *)shareInstance;

-(NSMutableDictionary *)loginAccount;

-(void)setLoginUserName:(NSString *)name password:(NSString *)password loginType:(XBHLoginType)type isSuccess:(BOOL)yn;
-(void)setLastLoginType:(XBHLoginType)lastLoginType;

/**
 *  获取最近一次的登陆信息
 *
 *  @param name     登陆账号  
 *  @param password 登陆密码
 *
 *  @return 返回登陆是否成功
 */
-(BOOL )lastLoginUserName:(NSString *__autoreleasing*)name   lastPassword:(NSString *__autoreleasing*)password;

-(XBHLoginType)lastLoginTypeGetLoginStatus:(XBHLoginStatus*)status;
/**
 *  是否是账户登录并且登陆成功
 *
 *  @return 
 */
-(BOOL)isAccountLoginAndLoginSuccess;
@end
