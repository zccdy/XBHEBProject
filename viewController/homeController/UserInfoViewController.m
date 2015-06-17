//
//  UserInfoViewController.m
//  XBHEBProject
//
//  Created by xubh-note on 15/5/19.
//  Copyright (c) 2015年 xu banghui. All rights reserved.
//

#import "UserInfoViewController.h"
#import "XBHKVView.h"
//#import "UITableView+XBHImageParallax.h"
//#import "UINavigationBar+XBHDynamicEffect.h"
#import "TransferListViewController.h"

#import "ModifyPasswordViewController.h"






#pragma mark -

static NSString    *identifier=@"myCells";

@interface UserInfoViewController ()<UIAlertViewDelegate,XBHKVViewDelegate>
@property       (nonatomic,strong)  NSString     *mPhoneNum;
@end

@implementation UserInfoViewController
{
  
    NSArray                  *_contentViewArray;
    NSString                 *_userName;
    UIButton                 *_loginOutButton;
}

- (void)dealloc
{
    // [self.tableView cancelParallax];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"个人信息";
    XBHSubcontrollerBackTitle(self.title);
    
    self.tableView.tableFooterView=[[UIView alloc] init];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor=XBHUIPageColor;
    //[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:identifier];
    self.tableView.rowHeight=44;
    //[self.tableView setParallaxImage:XBHHomeBundleImageWithName(@"course") ParallaxMode:XBHImageParallaxMode_Scale];
    [self createContentViewArray];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
 //   [self.navigationController.navigationBar registerScrollerView:self.tableView backgroundColor:[UIColor redColor]];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
 //   [self.navigationController.navigationBar de_reset];
   
}



-(void)clearSubView:(UITableViewCell *)cell{
    for (UIView *view in cell.subviews) {
        if (view.tag == 999) {
            [view removeFromSuperview];
        }
    }

}

-(void)createContentViewArray{

    _contentViewArray=nil;
    NSDictionary   *dict=[[XBHBackgroundHandler shareInstance] loginAccount];
    _userName=dict[kJSONLoginUserName];
    
    
    self.tableView.tableHeaderView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 60)];
    self.tableView.tableHeaderView.opaque=NO;
    
    UIImage  *image=XBHHomeBundleImageWithName(@"ico_09");
    UIImageView   *headerImage=[[UIImageView alloc] initWithImage:image];
    headerImage.layer.masksToBounds=YES;
    headerImage.layer.cornerRadius=image.size.width/2;
    headerImage.layer.borderWidth=1;
    headerImage.layer.borderColor=[UIColor whiteColor].CGColor;
    CGFloat  centerX=self.tableView.tableHeaderView.center.x;
    CGFloat  centerY=CGRectGetMaxY(self.tableView.tableHeaderView.frame)-image.size.height/2;
    headerImage.center=CGPointMake(centerX, centerY);
    [self.tableView addSubview:headerImage];
    
    //
    
    XBHKVView *view0=[[XBHKVView alloc] init];
    view0.mTitleLabel.text=@"账号";
    view0.mTextContentLabel.text=_userName;
    view0.mTitleLabel.textColor=[UIColor whiteColor];
    view0.mTextContentLabel.textColor=[UIColor whiteColor];
    view0.tag=999;

    
    
    XBHKVView *view1=[[XBHKVView alloc] init];
    view1.mTitleLabel.text=@"邮箱";
    view1.mTextContentLabel.text=@"306623725@qq.com";
    view1.mTitleLabel.textColor=[UIColor whiteColor];
    view1.mTextContentLabel.textColor=[UIColor whiteColor];
    view1.tag=999;
    
    XBHKVView *view2=[[XBHKVView alloc] init];
    view2.mTitleLabel.text=@"电话";
    view2.mTextContentLabel.text=@"13183799979";
    view2.mTitleLabel.textColor=[UIColor whiteColor];
    view2.mbIsPhone=YES;
    view2.mTextContentLabel.textColor=[UIColor whiteColor];
    view2.tag=999;
    view2.delegate=self;
    _contentViewArray=@[view0,view1,view2];
    
    
    //推出登陆
    _loginOutButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [_loginOutButton setTitle:@"退出登录" forState:UIControlStateNormal];
    [_loginOutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_loginOutButton addTarget:self action:@selector(loginOutButtonPress) forControlEvents:UIControlEventTouchUpInside];
    _loginOutButton.frame=CGRectMake(0, 0, 160, 35);
    _loginOutButton.backgroundColor=XBHButtonColor;
    _loginOutButton.layer.masksToBounds=YES;
    _loginOutButton.layer.cornerRadius=XBHCornerRadius;
    _loginOutButton.tag=999;
}



#pragma mark - Table view data source
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.backgroundColor=[UIColor clearColor];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    
    if ([_contentViewArray count]) {
        return [_contentViewArray count]+4;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    // Configure the cell...
    [self clearSubView:cell];
    cell.accessoryType=UITableViewCellAccessoryNone;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (indexPath.row <[_contentViewArray count]) {
        UIView *view=_contentViewArray[indexPath.row];
        view.frame=CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 44);
        [cell.contentView addSubview:view];
    }
    else if (indexPath.row ==[_contentViewArray count]){
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle=UITableViewCellSelectionStyleDefault;
        cell.textLabel.font=XBHKVView_TitleFont;
        cell.textLabel.text=@"修改密码";
        cell.textLabel.textColor=[UIColor whiteColor];
    }
    else if (indexPath.row ==[_contentViewArray count]+1){
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle=UITableViewCellSelectionStyleDefault;
        cell.textLabel.font=XBHKVView_TitleFont;
        cell.textLabel.text=@"传输列表";
        cell.textLabel.textColor=[UIColor whiteColor];
    }
    else if (indexPath.row ==[_contentViewArray count]+3){
        _loginOutButton.center=cell.contentView.center;
        [cell.contentView addSubview:_loginOutButton];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == [_contentViewArray count]) {
        [self.navigationController pushViewController:[[ModifyPasswordViewController alloc] init] animated:YES];
    }
    else  if (indexPath.row == [_contentViewArray count]+1) {
        [self.navigationController pushViewController:[[TransferListViewController alloc] init] animated:YES];
    }


}


#pragma mark -

-(void)XBHKVViewPhoneNumberDidTap:(NSString *)number{
    self.mPhoneNum=number;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"是否拨打：%@ ?",number] delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    [alert show];
   
}
#pragma UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1){
        NSString *tel = [NSString stringWithFormat:@"tel://%@",self.mPhoneNum];
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:tel]]) {
            UIWebView *callWeb = [[UIWebView alloc] init];
            [callWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:tel]]];
            [self.view addSubview:callWeb];
           
        }
        else{
            [XBHUitility showNotifyMessage:@"抱歉，您的设备无法拨打电话！" title:@"提示"];
            
        }
    }
}

#pragma mark -  退出登录

-(void)loginOutEnd{
    XBHStopActivityWithView(self.view);
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)loginOutButtonPress{
    XBHStartActivityWithView(self.view);
    [[XBHBackgroundHandler shareInstance] setLastLoginType:XBHLoginType_Guest];
    [self performSelector:@selector(loginOutEnd) withObject:nil afterDelay:1];

    

}
@end
