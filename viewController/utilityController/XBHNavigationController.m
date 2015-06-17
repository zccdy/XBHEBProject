//
//  XBHNavigationController.m
//  XBHEBProject
//
//  Created by xubh-note on 15/3/26.
//  Copyright (c) 2015年 xu banghui. All rights reserved.
//

#import "XBHNavigationController.h"

@interface XBHNavigationController ()

@end

@implementation XBHNavigationController


- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

  // [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                       //  forBarMetrics:UIBarMetricsDefault];
    NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:18],NSFontAttributeName, nil];
    
    [self.navigationBar setTitleTextAttributes:attributes];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
