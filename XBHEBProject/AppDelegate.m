//
//  AppDelegate.m
//  XBHEBProject
//
//  Created by xubh-note on 15/3/17.
//  Copyright (c) 2015年 xu banghui. All rights reserved.
//

#import "AppDelegate.h"

#import <IQKeyboardManager.h>
#import "HomeViewController.h"
#import "XBHNetworking.h"
#import "TransferListViewController.h"

#import "LoginViewController.h"

#import "XBHBackgroundHandler.h"
#import "LoginRequest.h"
#import "XBHEditTextTableViewController.h"

#import <MBProgressHUD.h>
#import "ViewController.h"
@interface AppDelegate ()
@property  (nonatomic,strong)       NSString        *curLoginUserName;
@property   (nonatomic,strong)      NSString        *curLoginPassword;
@end

@implementation AppDelegate
{
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside=YES;
    [XBHNetworking XBHNetworkinginitsetWithBaseURL:@"http://symplasima.eicp.net:8090" CDNURL:nil];
    self.shareQX=1;
    
    
    self.window=[[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor=[UIColor whiteColor];
    
    if (IOS7SYSTEMVERSION_OR_LATER) {
#if       IOS7SDK_OR_LATER
        [[ UINavigationBar appearance] setBarTintColor:XBHUIThemeColor];
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]]; //返回< 和文字的颜色
        
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
#endif
        
    }
    else{
        [[UINavigationBar appearance] setTintColor:XBHUIThemeColor];
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
    
    
    NSString *name=[XBHUitility getLaunchImageNameForOrientation:UIInterfaceOrientationPortrait];
    
    if(name){
        
        UIImageView *imageView=[[UIImageView alloc] initWithFrame:self.window.bounds];
        imageView.tag=XBHSubViewCommonTag;
        imageView.image=[UIImage imageNamed:name];
        [self.window addSubview:imageView];
    }
    
    
    
    [self appStartHandle];
    
    
     [self.window makeKeyAndVisible];
   
    return YES;
}

-(void)intoFirstPage{
    XBHStopActivityWithView(self.window);
    [[self.window viewWithTag:XBHSubViewCommonTag] removeFromSuperview];
    XBHNavigationController *navigationController = [[XBHNavigationController alloc] initWithRootViewController:[[HomeViewController alloc] init]];
    
    self.window.rootViewController = navigationController;
    


}

-(void)appStartHandle{
    [XBHBackgroundHandler shareInstance];
    
    if (XBHLoginType_Account == [[XBHBackgroundHandler shareInstance] lastLoginTypeGetLoginStatus:nil]) {
        NSString *userName=nil;
        NSString *password=nil;
        
        [[XBHBackgroundHandler shareInstance] lastLoginUserName:&userName lastPassword:&password];
        if (userName
            &&password) {
            
            XBHStartActivityWithView(self.window);
            
            self.curLoginUserName=userName;
            self.curLoginPassword=password;
            [self loginWithUserName:userName password:password];
        }
        else{
            [self intoFirstPage];
        }
        
    }
    else{
    
        [self intoFirstPage];
    }

}
-(void)loginWithUserName:(NSString *)name password:(NSString *)password{
    
    LoginRequest *request=[[LoginRequest alloc] initWithUserName:name Password:password AuthCode:nil];
    XBHWeakSelf;
    [request startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        XBHStrongSelf;
        [strongSelf loginResultHandler:request.responseJSONObject isSuccess:YES];
    } failure:^(YTKBaseRequest *request) {
        
        XBHStrongSelf;
        
        [strongSelf loginResultHandler:request.responseJSONObject isSuccess:NO];
        
    }];
    
    
}


-(void)loginResultHandler:(NSDictionary *)responseDict isSuccess:(BOOL)success{
    [XBHNetworking responseStatusFilterWithRespJSONObject:responseDict netWorkingIsSuccess:success compeletion:^(NSDictionary *Json, XBHRequestResultStatus reStatus, NSString *message) {
        
        if (reStatus == XBHRequestResultStatus_Success) {
            [[XBHBackgroundHandler shareInstance] setLoginUserName:self.curLoginUserName password:self.curLoginPassword loginType:XBHLoginType_Account isSuccess:YES];
        }
        
        [self intoFirstPage];
        
    }];
    
    
}

#pragma mark -  

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



#pragma mark --




-(void)startActivityWithView:(UIView *)view{
    [MBProgressHUD  showHUDAddedTo:view animated:YES];
    
    view.userInteractionEnabled = NO;

}


-(void)stopActivityWithView:(UIView *)view{
    [MBProgressHUD hideHUDForView:view animated:YES];
   view.userInteractionEnabled = YES;

   
}



-(BOOL)homePageJumpToLoginController{
    
    if ([[XBHBackgroundHandler shareInstance] isAccountLoginAndLoginSuccess]){
        return NO;
    }
    if ([self.window.rootViewController isKindOfClass:[UINavigationController class]]) {
        UIViewController   *controller=[(UINavigationController *)self.window.rootViewController topViewController];
        if ([controller isKindOfClass:[HomeViewController class]]) {
            [controller.navigationController pushViewController:[[LoginViewController alloc] init] animated:YES];
            return YES;
        }
        
    }
    
    return NO;
}



@end
