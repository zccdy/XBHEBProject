//
//  RegistViewController.m
//  XBHEBProject
//
//  Created by xubh-note on 15/4/30.
//  Copyright (c) 2015年 xu banghui. All rights reserved.
//

#import "RegistViewController.h"
#import "XBHInputViewHandler.h"
#import <IQKeyboardReturnKeyHandler.h>
#import <QuartzCore/QuartzCore.h>
#import <Masonry.h>
#import "RegistRequest.h"
@interface RegistViewController ()

@end

@implementation RegistViewController
{
    XBHInputViewHandler             *_inputViewHandler;
   
}


-(void)loadView{
    
    
    UIScrollView   *scrollview= [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    scrollview.scrollEnabled=YES;
    self.view=scrollview;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
     self.automaticallyAdjustsScrollViewInsets=NO;
    self.title=@"注册";
    self.view.backgroundColor=XBHUIPageColor;

    // Do any additional setup after loading the view.
    NSMutableArray    *array=[NSMutableArray array];
    
    [array addObject:[[XBHInputViewItem alloc] initWithPlaceholder:@"请输入账号"]];
    [array addObject:[[XBHInputViewItem alloc] initWithPlaceholder:@"请输入密码"]];
    [array addObject:[[XBHInputViewItem alloc] initWithPlaceholder:@"请输入邮箱"]];
    
    CGRect  allInputViewRect=CGRectMake(15, 25+64, CGRectGetWidth(self.view.bounds)-15*2, XBHInputViewHeight*([array count]+1)+AuthCodeSpace);
    
    _inputViewHandler=[[XBHInputViewHandler alloc] initWithSuperController:self Frame:allInputViewRect Items:array HaveAuthCode:YES];
    [_inputViewHandler fieldWithIndex:1].secureTextEntry=YES;;
    _inputViewHandler.textColor=[UIColor whiteColor];
    
    [_inputViewHandler setLeftImage:XBHHomeBundleImageWithName(@"account") index:0];
    [_inputViewHandler setLeftImage:XBHHomeBundleImageWithName(@"password") index:1];
    [_inputViewHandler setLeftImage:XBHHomeBundleImageWithName(@"email") index:2];
    [_inputViewHandler setLeftImage:XBHHomeBundleImageWithName(@"authCode") index:3];
    
    
    
    UIButton   *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor=XBHButtonColor;
    button.layer.masksToBounds=YES;
    button.layer.cornerRadius=XBHCornerRadius;
    [button setTitle:@"提 交" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(registPress) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo([_inputViewHandler lastField].mas_bottom).mas_equalTo(50);
        make.size.mas_equalTo(CGSizeMake(170, 30));
        make.centerX.equalTo(self.view.mas_centerX);
    }];
}







-(void)registPress{
    
    if (![RegistRequest paramsCheckWithUsername:[_inputViewHandler fieldTextWithFieldIndex:0] password:[_inputViewHandler fieldTextWithFieldIndex:1]  mail:[_inputViewHandler fieldTextWithFieldIndex:2] authCode:[_inputViewHandler authCodeText] authCodeInput:[_inputViewHandler fieldTextWithFieldIndex:3]] ) {
        return;
    }
    XBHStartActivityWithView(self.view);
    
    RegistRequest *request=[[RegistRequest alloc] initWithUsername:[_inputViewHandler fieldTextWithFieldIndex:0] password:[_inputViewHandler fieldTextWithFieldIndex:1] mail:[_inputViewHandler fieldTextWithFieldIndex:2] authCode:[_inputViewHandler fieldTextWithFieldIndex:3]];
    XBHWeakSelf;
    [request startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        XBHStrongSelf;
    
        [strongSelf registResultHandler:request.responseJSONObject isSuccess:YES];
        
    } failure:^(YTKBaseRequest *request) {
        XBHStrongSelf;
        
        [strongSelf registResultHandler:request.responseJSONObject isSuccess:YES];
        
    }];

}

-(void)popToPrevcontroller{

     [self.navigationController popViewControllerAnimated:YES];

}
-(void)registResultHandler:(NSDictionary *)responseDict isSuccess:(BOOL)success{
    XBHStopActivityWithView(self.view);
    NSString *status=responseDict[kJSONResponseStatus];
    if (success) {
        if (responseDict[kJSONResponseMessage]) {
            [self.view makeToast:responseDict[kJSONResponseMessage] duration:1.5 position:@"center"];
        }
        if ([status isEqualToString:kJSONResponseStatus_Success]) {
            [NSObject cancelPreviousPerformRequestsWithTarget:self];
            [self performSelector:@selector(popToPrevcontroller) withObject:nil afterDelay:2.5];

        }
    }
    else if (!success){
        
        if (responseDict[kJSONResponseMessage]) {
            [self.view makeToast:responseDict[kJSONResponseMessage] duration:1 position:@"center"];
        }
        else
            [self.view makeToast:@"注册失败!" duration:2.0 position:@"center"];
    
    }
    
    
}


@end
