//
//  ShareInterface.m
//  gwEdu
//
//  Created by xu banghui  on 13-5-21.
//  Copyright (c) 2013年 gwsoft. All rights reserved.
//




NSString *const GWNotify_ShareInterfaceResponse = @"GWNotify_ShareInterfaceResponse";
#import <UIKit/UIKit.h>
#import "ShareInterface.h"
#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"
#import "WeiboApi.h"
#import "WeiboSDK.h"
#import <MessageUI/MFMailComposeViewController.h>


#pragma mark-  单例  end


@interface ShareInterface ()<ISSShareViewDelegate>

@property   (nonatomic,strong)      NSString     *mShareToSinaText;
@property   (nonatomic,strong)      UIImage     *mShareToSinaImg;

@end


@implementation ShareInterface
{
    BOOL            mbSinaWateToShare;
}
@synthesize delegate;
@synthesize mShareToSinaImg;
@synthesize mShareToSinaText;

- (void)dealloc
{
    self.mShareToSinaText=nil;
    self.mShareToSinaImg=nil;
    
}

+ (ShareInterface *)defaultInstance
{
    static ShareInterface *defaultShareInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        defaultShareInstance = [[[self class] alloc] init];
    });
    return defaultShareInstance;
}


+(void)ShareInterfaceDidFinishLaunching{
    
    [ShareSDK registerApp:AppKey_ShareSDK];
    
    
    //添加新浪微博应用 注册网址 http://open.weibo.com
    [ShareSDK connectSinaWeiboWithAppKey:AppKey_SinaWeibo
                               appSecret:AppSecret_SinaWeibo
                             redirectUri:RedirectURL_SinaWeibo];
 
    //当使用新浪微博客户端分享的时候需要按照下面的方法来初始化新浪的平台
    [ShareSDK  connectSinaWeiboWithAppKey:AppKey_SinaWeibo
                                appSecret:AppSecret_SinaWeibo
                              redirectUri:RedirectURL_SinaWeibo
                              weiboSDKCls:[WeiboSDK class]];
 
 
    //添加腾讯微博应用 注册网址 http://dev.t.qq.com
    [ShareSDK connectTencentWeiboWithAppKey:AppKey_TCWeibo
                                  appSecret:AppSecret_TCWeibo
                                redirectUri:RedirectURL_TCWeibo
                                   wbApiCls:[WeiboApi class]];
    
    
    //添加微信应用 注册网址 http://open.weixin.qq.com
    [ShareSDK connectWeChatWithAppId:AppKey_WeiXin
                           wechatCls:[WXApi class]];
    
    //连接邮件
    [ShareSDK connectMail];
    
    /*
     //连接短信分享
     [ShareSDK connectSMS];

    
    //添加QQ空间应用  注册网址  http://connect.qq.com/intro/login/
    [ShareSDK connectQZoneWithAppKey:@"100371282"
                           appSecret:@"aed9b0303e3ed1e27bae87c33761161d"
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    
    //添加QQ应用  注册网址  http://open.qq.com/
    [ShareSDK connectQQWithQZoneAppKey:@"100371282"
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
    
    */

}

+(BOOL)ShareInterface_handleOpenURL:(NSURL *)url
{
    
    return [ShareSDK handleOpenURL:url
                 wxDelegate:self];
    
}

+(BOOL)ShareInterface_openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
   return  [ShareSDK handleOpenURL:url
          sourceApplication:sourceApplication
                 annotation:annotation
                 wxDelegate:self];

}


+(void)setCurShareSDKType:(SDK_Type)type{
    NSMutableDictionary *dict= [self getCurrentShareTypeDict];
    [dict setObject:[NSNumber numberWithUnsignedInteger:type] forKey:@"CurrentShareType"];
    [dict writeToFile:[self storeCurrentShareTypePath] atomically:YES];
}
+(SDK_Type)getCurShareSDKType{
    NSMutableDictionary *dict= [self getCurrentShareTypeDict];
    if ([dict count]) {
        NSNumber *num=[dict objectForKey:@"CurrentShareType"];
        if (num) {
            return (SDK_Type)[num unsignedIntegerValue];
        }
    }
    return SDK_Type_None;
}

+(NSString *)storeCurrentShareTypePath{
    NSString *path=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    return [NSString stringWithString:[path stringByAppendingPathComponent:@"CurrentShareType"]];
}
+(NSMutableDictionary *)getCurrentShareTypeDict{
    
    
    NSString *filePath=[self storeCurrentShareTypePath] ;
    
    NSMutableDictionary *dict=[NSMutableDictionary dictionary];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath ]) {
        dict=[NSMutableDictionary dictionaryWithContentsOfFile:filePath];
    }
    return dict;
    
}

-(void)shareWithView:(UIView *)sender{
    
    NSString *ShareLink=@"http://www.join4talk.com";
    
    
    NSString *ShareTextContent=@"测试";

   NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"ico" ofType:@"png"];
   
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:ShareTextContent
                                       defaultContent:ShareTextContent
                                                image:[ShareSDK imageWithPath:imagePath]
                                                title:@"appname"
                                                  url:ShareLink          //人人、微信、qq
                                          description:@""   //人人网
                                            mediaType:SSPublishContentMediaTypeNews];//qq、微信
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:sender arrowDirect:UIPopoverArrowDirectionUp];
   // [container setIPhoneContainerWithViewController:sender];
    
    //创建自定义分享列表
    NSArray *shareList = nil;
    BOOL   isShowWeChat=YES;
    BOOL   isShowMail=YES;
    if (![WXApi isWXAppInstalled]    //没安装
        ||![WXApi isWXAppSupportApi] //版本过低
        ) {
        isShowWeChat=NO;
    }
    
    
    if (![MFMailComposeViewController canSendMail]){
        isShowMail=NO;
    }
    
    if (!isShowMail
        &&!isShowWeChat) {
        shareList=[ShareSDK getShareListWithType:
                   ShareTypeSinaWeibo,
                   ShareTypeTencentWeibo,nil];
    }
    else if (!isShowWeChat){
        shareList=[ShareSDK getShareListWithType:
                   ShareTypeSinaWeibo,
                   ShareTypeTencentWeibo,
                   ShareTypeMail,nil];

    }
    else if (!isShowMail){
    
        shareList=[ShareSDK getShareListWithType:
                   ShareTypeSinaWeibo,
                   ShareTypeTencentWeibo,
                   ShareTypeWeixiSession,
                   ShareTypeWeixiTimeline,nil];

    }
    else{
        shareList=[ShareSDK getShareListWithType:
                   ShareTypeSinaWeibo,
                   ShareTypeTencentWeibo,
                   ShareTypeWeixiSession,
                   ShareTypeWeixiTimeline,
                   ShareTypeMail,nil];

    
    }
    

    //自定义标题栏相关委托
   
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                                allowCallback:NO
                                                                scopes:nil
                                                                powerByHidden:YES
                                                                followAccounts:nil
                                                                authViewStyle:SSAuthViewStyleFullScreenPopup
                                                                viewDelegate:self
                                                                authManagerViewDelegate:nil];
    
    //自定义标题栏相关委托
    id<ISSShareOptions> shareOptions = [ShareSDK defaultShareOptionsWithTitle:@"分享内容"
                                                              oneKeyShareList:[NSArray defaultOneKeyShareList]
                                                               qqButtonHidden:YES
                                                        wxSessionButtonHidden:YES
                                                       wxTimelineButtonHidden:YES
                                                         showKeyboardOnAppear:NO
                                                            shareViewDelegate:self
                                                          friendsViewDelegate:nil
                                                        picViewerViewDelegate:nil];
    
    
    
    //弹出分享菜单
    [ShareSDK showShareActionSheet:container    //只适应iphone  可以为nil
                         shareList:shareList
                           content:publishContent
                     statusBarTips:YES
                       authOptions:authOptions
                      shareOptions:shareOptions
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    
                                    NSLog(@"分享失败,错误码:%ld,错误描述:%@", (long)[error errorCode], [error errorDescription]);
                                }
                            }];



}

- (void)viewOnWillDisplay:(UIViewController *)viewController shareType:(ShareType)shareType
{
    //修改分享界面和授权界面的导航栏背景
    if (IOS7SYSTEMVERSION_OR_LATER) {
#if       IOS7SDK_OR_LATER
        viewController.navigationController.navigationBar.barTintColor = [UIColor darkGrayColor];
        viewController.navigationController.navigationBar.tintColor=[UIColor whiteColor];//返回< 和文字的颜色
        
#endif
        
    }
    else{
        viewController.navigationController.navigationBar.tintColor=[UIColor darkGrayColor];
        
    }

    
}

@end


