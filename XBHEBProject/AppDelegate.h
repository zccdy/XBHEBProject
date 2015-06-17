//
//  AppDelegate.h
//  XBHEBProject
//
//  Created by xubh-note on 15/3/17.
//  Copyright (c) 2015年 xu banghui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (assign,nonatomic)  NSUInteger    shareQX;




-(BOOL)homePageJumpToLoginController;

-(void)startActivityWithView:(UIView *)view;

-(void)stopActivityWithView:(UIView *)view;
@end

