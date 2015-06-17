//
//  LoginViewController.m
//  XBHEBProject
//
//  Created by xubh-note on 15/4/7.
//  Copyright (c) 2015年 xu banghui. All rights reserved.
//

#import "LoginViewController.h"
#import <Masonry.h>

#import <QuartzCore/QuartzCore.h>
#import "XBHInputViewHandler.h"
#import "RegistViewController.h"
#import "ModifyPasswordViewController.h"
#import "ForgetPasswordViewController.h"
#import "LoginRequest.h"



#define LoginInputViewTop               (XBHScreenHeight>480 ? (64+45) :(64+15))

#define LogAndInputSpace                (XBHScreenHeight>480 ? (49) :(25))
#define RegistButtonW                   (80)
#define RegistButtonH                   (25)



@interface LoginViewController ()

@end

@implementation LoginViewController
{
    XBHInputViewHandler             *_inputViewHandler;
   
}
-(BOOL)mbRefreshEnable{
    return NO;
}
-(BOOL)mbLoadMoreEnable{
    return NO;
}

-(void)loadView{
    
    
   UIScrollView   *scrollview= [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    //scrollview.scrollEnabled=NO;
    
    self.view= scrollview;
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.view.backgroundColor=XBHUIPageColor;
    self.title=@"登  录";
     XBHSubcontrollerBackTitle(@"登录");
    
    //背景
    UIImageView    *view=[[UIImageView alloc] initWithImage:XBHHomeBundleImageWithName(@"loginBg")];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        
    }];
    //log
    UIImage     *log=XBHHomeBundleImageWithName(@"logIcon");
    UIImageView   *logView=[[UIImageView alloc] initWithImage:log];
    [self.view addSubview:logView];
    if (log) {
        logView.frame=CGRectMake((CGRectGetWidth(self.view.frame)-log.size.width)/2, LoginInputViewTop, log.size.width, log.size.height);
        
    }

   
    // Do any additional setup after loading the view.
    NSMutableArray    *array=[NSMutableArray array];
    
   [array addObject:[[XBHInputViewItem alloc] initWithPlaceholder:@"请输入账号"]];
   [array addObject:[[XBHInputViewItem alloc] initWithPlaceholder:@"请输入密码"]];

    CGRect  allInputViewRect=CGRectMake(15, CGRectGetMaxY(logView.frame)+LogAndInputSpace, CGRectGetWidth(self.view.bounds)-15*2, XBHInputViewHeight*([array count]+1)+AuthCodeSpace);
    
    _inputViewHandler=[[XBHInputViewHandler alloc] initWithSuperController:self Frame:allInputViewRect Items:array HaveAuthCode:YES];
    [_inputViewHandler fieldWithIndex:1].secureTextEntry=YES;;
    _inputViewHandler.textColor=[UIColor whiteColor];
    
    [_inputViewHandler setLeftImage:XBHHomeBundleImageWithName(@"account") index:0];
    [_inputViewHandler setLeftImage:XBHHomeBundleImageWithName(@"password") index:1];
    [_inputViewHandler setLeftImage:XBHHomeBundleImageWithName(@"authCode") index:2];
    
    //账号
    NSString   *account=nil;
    [[XBHBackgroundHandler shareInstance] lastLoginUserName:&account lastPassword:nil];
    if ([account length]) {
        [_inputViewHandler firstField].text=account;
    }
    
    
    UITextField  *lastField=[_inputViewHandler lastField];
    
    // 登陆 注册背景
    UIView    *loginBgView=[[UIView alloc] init];
    loginBgView.userInteractionEnabled=YES;
    loginBgView.layer.masksToBounds=YES; //00a1d9
    loginBgView.layer.cornerRadius=XBHCornerRadius;
    loginBgView.backgroundColor=XBHButtonColor;
    [self.view addSubview:loginBgView];
    [loginBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lastField.mas_bottom).mas_equalTo(22.5);
        make.left.equalTo(self.view.mas_left).mas_equalTo(24.5);
        make.width.mas_equalTo(CGRectGetWidth(self.view.bounds)-22.5*2);
        make.height.mas_equalTo(39);
    }];
    
    
    UIButton    *loginButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton setTitle:@"登  录" forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginButton.titleLabel.font=XBHSysFont(15);
    [loginBgView addSubview:loginButton];
    [loginButton addTarget:self action:@selector(loginButtonPress) forControlEvents:UIControlEventTouchUpInside];
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(loginBgView.mas_left).with.offset(0);
        make.top.equalTo(loginBgView.mas_top).mas_equalTo(0);
        make.width.equalTo(loginBgView.mas_width).multipliedBy(0.5);
        make.height.equalTo(loginBgView.mas_height);
        
    }];
    
    
    UIView   *seperLine=[[UIView alloc] init];
    seperLine.backgroundColor=[UIColor whiteColor];
    [loginBgView addSubview:seperLine];
    [seperLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(loginBgView.mas_top);
        make.left.equalTo(loginButton.mas_right).mas_equalTo(0);
        make.width.equalTo(@(1));
        make.height.equalTo(loginBgView.mas_height);
        
    }];
    
    UIButton  *registButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [registButton setTitle:@"注  册" forState:UIControlStateNormal];
    [registButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    registButton.opaque=NO;
    registButton.titleLabel.font=XBHSysFont(15);
    [registButton addTarget:self action:@selector(registPress) forControlEvents:UIControlEventTouchUpInside];
    [loginBgView addSubview:registButton];
    [registButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(loginBgView.mas_top);
        make.left.equalTo(loginButton.mas_right).mas_equalTo(0);
        make.width.equalTo(loginBgView.mas_width).multipliedBy(0.5);
        make.height.equalTo(loginBgView.mas_height);
        
    }];

    
    UIButton  *forgetButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [forgetButton setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [forgetButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    forgetButton.opaque=NO;
    [forgetButton addTarget:self action:@selector(forgetPasswordPress) forControlEvents:UIControlEventTouchUpInside];
    forgetButton.titleLabel.font=[UIFont systemFontOfSize:13];
  
    [self.view addSubview:forgetButton];
    
    [forgetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(loginBgView.mas_bottom).with.offset(15);
        make.right.equalTo(loginBgView.mas_right);
        make.size.mas_equalTo(CGSizeMake(RegistButtonW, RegistButtonH));
    }];
    
    
    
   
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)registPress{
    [self.navigationController pushViewController:[[RegistViewController alloc] init] animated:YES];

}

-(void)forgetPasswordPress{
    
    [self.navigationController pushViewController:[[ForgetPasswordViewController alloc] init] animated:YES];
}



-(void)loginButtonPress{
    
    if (![LoginRequest paramsCheckWithUsername:[_inputViewHandler fieldTextWithFieldIndex:0] password:[_inputViewHandler fieldTextWithFieldIndex:1] authCode:[_inputViewHandler fieldTextWithFieldIndex:2] authCodeInput:[_inputViewHandler authCodeText]]) {
        return;
    }
    XBHStartActivityWithView(self.view);
    
    LoginRequest *request=[[LoginRequest alloc] initWithUserName:[_inputViewHandler fieldTextWithFieldIndex:0] Password:[_inputViewHandler fieldTextWithFieldIndex:1] AuthCode:[_inputViewHandler fieldTextWithFieldIndex:2]];
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
    XBHStopActivityWithView(self.view);
    
    [XBHNetworking responseStatusFilterWithRespJSONObject:responseDict netWorkingIsSuccess:success compeletion:^(NSDictionary *Json, XBHRequestResultStatus reStatus, NSString *message) {
        
        if (reStatus == XBHRequestResultStatus_Success) {
            [[XBHBackgroundHandler shareInstance] setLoginUserName:[_inputViewHandler fieldTextWithFieldIndex:0] password:[_inputViewHandler fieldTextWithFieldIndex:1] loginType:XBHLoginType_Account isSuccess:YES];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else {
            [[XBHBackgroundHandler shareInstance] setLoginUserName:[_inputViewHandler fieldTextWithFieldIndex:0] password:[_inputViewHandler fieldTextWithFieldIndex:1] loginType:XBHLoginType_Account isSuccess:NO];
            
            [self.view makeToast:message duration:2 position:@"center"];
        }
        
        
    }];
    
    

}

@end
