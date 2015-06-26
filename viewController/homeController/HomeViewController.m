//
//  HomeViewController.m
//  XBHEBProject
//
//  Created by xubh-note on 15/4/17.
//  Copyright (c) 2015年 xu banghui. All rights reserved.
//

#import "HomeViewController.h"
#import "LoginViewController.h"
#import "UploadViewController.h"
#import "TransferListViewController.h"
#import "QueryViewController.h"
#import "XBHQRScanViewController.h"
#import "sourceDownloadViewController.h"
#import "UserInfoViewController.h"
#import "DocClassifyViewController.h"
@interface HomeViewController ()<UITabBarControllerDelegate>

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=XBHUIPageColor;
    self.edgesForExtendedLayout=UIRectEdgeNone;
    //选中后的颜色
    if (IOS7SYSTEMVERSION_OR_LATER) {
        self.tabBar.tintColor=XBHMakeRGB(48.0, 161.0, 240.0);
        self.tabBar.barTintColor=XBHUIThemeColor;
    }
    else{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        self.tabBar.selectedImageTintColor=XBHMakeRGB(48.0, 161.0, 240.0);
#pragma clang diagnostic pop
        self.tabBar.tintColor=XBHUIThemeColor;
    }
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithImage:XBHHomeBundleImageWithName(@"ico_userCard") style:UIBarButtonItemStylePlain target:self action:@selector(gotoLoginViewController)];
    

    //b.创建子控制器
    
    
    QueryViewController *c1=[[QueryViewController alloc]init];
    c1.title=@"查询";
    c1.tabBarItem.title=c1.title;
    [c1.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    [c1.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:XBHMakeRGB(48.0, 161.0, 240.0)} forState:UIControlStateHighlighted];
    c1.tabBarItem.image=[XBHHomeBundleImageWithName(@"icon_query") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    c1.tabBarItem.selectedImage=[XBHHomeBundleImageWithName(@"icon_query_1") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    UploadViewController *c2=[[UploadViewController alloc]init];
    c2.view.opaque=NO;
    c2.title=@"上传";
    c2.tabBarItem.title=c2.title;
    [c2.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    [c2.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:XBHMakeRGB(48.0, 161.0, 240.0)} forState:UIControlStateHighlighted];
    c2.tabBarItem.image=[XBHHomeBundleImageWithName(@"icon_upload") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    c2.tabBarItem.selectedImage=[XBHHomeBundleImageWithName(@"icon_upload_1") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    XBHQRScanViewController *c3=[[XBHQRScanViewController alloc]init];
    c3.title=@"扫码";
    c3.tabBarItem.title=c3.title;
    c3.tabBarItem.image=[XBHHomeBundleImageWithName(@"icon_qrcode") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    c3.tabBarItem.selectedImage=[XBHHomeBundleImageWithName(@"icon_qrcode_1") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [c3.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    [c3.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:XBHMakeRGB(48.0, 161.0, 240.0)} forState:UIControlStateHighlighted];
    
    
    
    DocClassifyViewController *c4=[[DocClassifyViewController alloc]init];
    c4.title=@"文档";
    c4.tabBarItem.title=c4.title;
    c4.tabBarItem.image=[XBHHomeBundleImageWithName(@"icon_doc") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    c4.tabBarItem.selectedImage=[XBHHomeBundleImageWithName(@"icon_doc_1") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [c4.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    [c4.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:XBHMakeRGB(48.0, 161.0, 240.0)} forState:UIControlStateHighlighted];
    
    
    self.viewControllers=@[c1,c2,c3,c4];
    
    self.delegate=self;
    
    self.title=c1.title;
    
    
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(tappedRightButton:)];
    
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    
    [self.view addGestureRecognizer:swipeLeft];
    
    
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(tappedLeftButton:)];
    
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    
    [self.view addGestureRecognizer:swipeRight];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)gotoLoginViewController{
     // [self.navigationController pushViewController:[[TransferListViewController alloc] init] animated:YES];
    if ([[XBHBackgroundHandler shareInstance] isAccountLoginAndLoginSuccess]) {
        [self.navigationController pushViewController:[[UserInfoViewController alloc] init] animated:YES];
    }
    else{
        [self.navigationController pushViewController:[[LoginViewController alloc] init] animated:YES];
    }
    
}


- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    self.title=viewController.title;
    XBHSubcontrollerBackTitle(self.title);
    return YES;
}

#pragma mark -



- (IBAction) tappedRightButton:(id)sender

{
    
    NSUInteger selectedIndex = [self selectedIndex];
    
    
    
    NSArray *aryViewController = self.viewControllers;
    
    if (selectedIndex < aryViewController.count - 1) {
        
        
        UIView *fromView = [self.selectedViewController view];
        
        UIViewController *toViewController = [self.viewControllers objectAtIndex:selectedIndex +1] ;
        
        [UIView transitionFromView:fromView toView:toViewController.view duration:0.5f options:UIViewAnimationOptionTransitionCrossDissolve completion:^(BOOL finished) {
            
            if (finished) {
                
                [self setSelectedIndex:selectedIndex +1];
                 self.title=toViewController.title;
            }
            
        }];
        
    }
    
    
    
}



- (IBAction) tappedLeftButton:(id)sender

{
    
    NSUInteger selectedIndex = [self selectedIndex];
    
    
    
    if (selectedIndex > 0) {
        
        UIView *fromView = [self.selectedViewController view];
        
        UIViewController *toViewController = [self.viewControllers objectAtIndex:selectedIndex - 1] ;
        
        [UIView transitionFromView:fromView toView:toViewController.view duration:0.5f options:UIViewAnimationOptionTransitionCrossDissolve completion:^(BOOL finished) {
            
            if (finished) {
                
                [self setSelectedViewController:toViewController];
                self.title=toViewController.title;
            }
            
        }];
        
    }
    
    
}

@end
