//
//  XBHBackgroundHandler.m
//  XBHEBProject
//
//  Created by xubh-note on 15/4/30.
//  Copyright (c) 2015年 xu banghui. All rights reserved.
//

#import "XBHBackgroundHandler.h"
#import <AFNetworkReachabilityManager.h>
#import "Toast+UIView.h"
#import "LoginRequest.h"


@implementation XBHBackgroundHandler


+ (XBHBackgroundHandler *)shareInstance
{
    static XBHBackgroundHandler *shareInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        shareInstance = [[[self class] alloc] initShareInstance];
    });
    return shareInstance;
}

-(id)init
{
    NSAssert(NO, @"单列类，不能通过alloc init方法 来创建");
    return nil;
}


- (void)dealloc
{
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initShareInstance
{
    self = [super init];
    if (self) {
        
        [self performSelector:@selector(startMonitoring) withObject:nil afterDelay:2.5f];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(intoBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    }
    return self;
}



-(void)startMonitoring{

    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        if (status == AFNetworkReachabilityStatusNotReachable) {
            [[UIApplication sharedApplication].keyWindow makeToast:@"网络出错，请检查网络设置" duration:2.0f position:@"center"];
        }
        
    }];
}


-(void)backForeground{
    [self performSelector:@selector(startMonitoring) withObject:nil afterDelay:1.5f];
}

-(void)intoBackground{
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
}


-(void)setLoginAccountInfo:(NSDictionary *)info{

    if ([info count]) {
        
        [info writeToFile:[XBHUitility getDocumentPathWithFileName:@".loginAccountDat"] atomically:NO];
    }

}

-(void)setLoginUserName:(NSString *)name password:(NSString *)password loginType:(XBHLoginType)type isSuccess:(BOOL)yn{

    NSMutableDictionary *dict=[self loginAccount];
    if (!dict) {
        dict=[NSMutableDictionary dictionary];
    }
    if (name) {
        dict[kJSONLoginUserName]=name;
    }
    if (password) {
        dict[kJSONLoginPassword]=password;
    }
    
    dict[kJSONPrevLoginType]=@(type);
    
    dict[kJSONLoginResult]=@(yn);

     [self setLoginAccountInfo:dict];
}


-(BOOL )lastLoginUserName:(NSString *__autoreleasing*)name   lastPassword:(NSString *__autoreleasing*)password{

     NSMutableDictionary *dict=[self loginAccount];
    if (!dict) {
        return NO;
    }
    if (name) {
        *name=dict[kJSONLoginUserName];
    }
    
    if (password) {
        *password=dict[kJSONLoginPassword];
    }
    
    NSNumber *num=dict[kJSONLoginResult];
    if (!num) {
        return NO;
    }
    
    return [num boolValue];

}


-(NSMutableDictionary *)loginAccount{

    NSString *path=[XBHUitility getDocumentPathWithFileName:@".loginAccountDat"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        return [NSMutableDictionary dictionaryWithContentsOfFile:path];
    }
    return nil;
}

-(void)setLastLoginType:(XBHLoginType)lastLoginType{
    NSMutableDictionary  *dict=[self loginAccount];
    if (!dict) {
        dict=[NSMutableDictionary dictionary];
    }
    
    dict[kJSONPrevLoginType]=@(lastLoginType);
    
    [self setLoginAccountInfo:dict];
}


-(XBHLoginType)lastLoginTypeGetLoginStatus:(XBHLoginStatus*)status{
    NSMutableDictionary  *dict=[self loginAccount];
    if (dict) {
        NSNumber  *num=nil;
        if (status) {
            num=dict[kJSONLoginResult];
            if (num
                &&[num boolValue ]) {
                *status=XBHLoginStatus_Success;
            }
            else{
                *status=XBHLoginStatus_Failure;
            }
        }
        
        num=dict[kJSONPrevLoginType];
        if (!num) {
            return XBHLoginType_Guest;
        }
        return [num unsignedIntegerValue];
    }
    return XBHLoginType_Guest;

}

-(BOOL)isAccountLoginAndLoginSuccess{
    
    XBHLoginStatus   status=0;
    XBHLoginType  type=[self lastLoginTypeGetLoginStatus:&status];
    if (type ==XBHLoginType_Account
        &&status == XBHLoginStatus_Success) {
        return YES;
    }
    return NO;
}



@end
