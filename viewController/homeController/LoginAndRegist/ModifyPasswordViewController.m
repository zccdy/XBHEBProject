//
//  ModifyPasswordViewController.m
//  XBHEBProject
//
//  Created by xubh-note on 15/4/30.
//  Copyright (c) 2015年 xu banghui. All rights reserved.
//

#import "ModifyPasswordViewController.h"
#import "XBHInputViewHandler.h"
#import <IQKeyboardReturnKeyHandler.h>
#import <QuartzCore/QuartzCore.h>
#import <Masonry.h>


@interface ModifyPasswordViewController ()

@end

@implementation ModifyPasswordViewController

{
    XBHInputViewHandler             *_inputViewHandler;
   
}


-(void)loadView{
    
    
    UIScrollView   *scrollview= [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    scrollview.scrollEnabled=NO;
    self.view=scrollview;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)viewDidLoad {
    [super viewDidLoad];
     self.automaticallyAdjustsScrollViewInsets=NO;
    self.title=@"修改密码";
    self.view.backgroundColor=XBHUIPageColor;
    
    // Do any additional setup after loading the view.
    NSMutableArray    *array=[NSMutableArray array];
    
    [array addObject:[[XBHInputViewItem alloc] initWithPlaceholder:@"请输入原密码"]];
    [array addObject:[[XBHInputViewItem alloc] initWithPlaceholder:@"请输入新密码"]];
    [array addObject:[[XBHInputViewItem alloc] initWithPlaceholder:@"请再次输入新密码"]];
    
    CGRect  allInputViewRect=CGRectMake(15, 25+64, CGRectGetWidth(self.view.bounds)-15*2, XBHInputViewHeight*([array count]+1)+AuthCodeSpace);
    
    _inputViewHandler=[[XBHInputViewHandler alloc] initWithSuperController:self Frame:allInputViewRect Items:array HaveAuthCode:YES];
     _inputViewHandler.textColor=[UIColor whiteColor];
    
    
    [_inputViewHandler setLeftImage:XBHHomeBundleImageWithName(@"password") index:0];
    [_inputViewHandler setLeftImage:XBHHomeBundleImageWithName(@"password") index:1];
    [_inputViewHandler setLeftImage:XBHHomeBundleImageWithName(@"password") index:2];
    [_inputViewHandler setLeftImage:XBHHomeBundleImageWithName(@"authCode") index:3];
    

    
    UIButton   *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor=XBHButtonColor;
    button.layer.masksToBounds=YES;
    button.layer.cornerRadius=XBHCornerRadius;
    [button setTitle:@"确 定" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(modifyPress) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo([_inputViewHandler lastField].mas_bottom).mas_equalTo(50);
        make.size.mas_equalTo(CGSizeMake(148, 30));
        make.centerX.equalTo(self.view.mas_centerX);
    }];
}



-(void)modifyPress{
    
    
    
    
}

@end