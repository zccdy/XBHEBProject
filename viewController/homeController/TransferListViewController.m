//
//  TransferListViewController.m
//  XBHEBProject
//
//  Created by xubh-note on 15/4/24.
//  Copyright (c) 2015年 xu banghui. All rights reserved.
//

#import "TransferListViewController.h"
#import "UploadListViewController.h"
#import "DownloadListViewController.h"
#import "XBHContainerViewController.h"

@interface TransferListViewController ()<XBHContainerViewControllerDelegate>

@end

@implementation TransferListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.title=@"传输列表";
  //  self.view.backgroundColor=XBHUIPageColor;

    UploadListViewController   *upController=[[UploadListViewController alloc] init];
   
    DownloadListViewController  *downController=[[DownloadListViewController alloc] init];
   
    
    XBHContainerViewController  *controller=[[XBHContainerViewController alloc] initWithControllers:@[upController,downController] topBarHeight:0 parentViewController:self];
    controller.menuBackGroudColor=XBHMakeRGB(96.0, 102.0, 112.0);
    controller.menuItemTitleColor=[UIColor whiteColor];
    controller.menuItemSelectedTitleColor=[UIColor whiteColor];
    controller.menuIndicatorColor=[UIColor clearColor];
    controller.menuItemFont=XBHSysFont(12);
    controller.delegate=self;
    controller.itemNormalBackgroundImage=XBHHomeBundleImageWithName(@"menuItemBg");
    controller.menuItemInfoArray=@[
                @{kXBHMenuItemTitle:@"上传列表",kXBHMenuItemIcon:XBHHomeBundleImageWithName(@"uploadIcon")},
                @{kXBHMenuItemTitle:@"下载列表",kXBHMenuItemIcon:XBHHomeBundleImageWithName(@"downloadIcon")}
                ];
    controller.view.backgroundColor=XBHUIPageColor;
    [self.view addSubview:controller.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)containerViewItemIndex:(NSInteger)index currentController:(UIViewController *)controller{
    [controller viewWillAppear:YES];

}

@end
