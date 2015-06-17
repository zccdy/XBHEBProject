//
//  XBHContainerViewController.h
//  XBHContainerViewController
//
//  Created by yamaguchi on 2015/02/10.
//  Copyright (c) 2015年 h.yamaguchi. All rights reserved.
//

#import "XBHScrollMenuView.h"


@protocol XBHContainerViewControllerDelegate <NSObject>

- (void)containerViewItemIndex:(NSInteger)index currentController:(UIViewController *)controller;

@end

@interface XBHContainerViewController : UIViewController

@property (nonatomic, weak) id <XBHContainerViewControllerDelegate> delegate;

@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong, readonly) NSMutableArray *childControllers;


/**
 *  每一项字典结构
 *  kXBHMenuItemTitle   --》item titile -->NSString
 *  kXBHMenuItemIcon   --》item icon -->UIImage
 */

@property (nonatomic,strong)  NSArray *menuItemInfoArray;
@property (nonatomic, strong) UIFont  *menuItemFont;
@property (nonatomic, strong) UIColor *menuItemTitleColor;
@property (nonatomic, strong) UIColor *menuItemSelectedTitleColor;
@property (nonatomic, strong) UIColor *menuBackGroudColor;
@property (nonatomic, strong) UIColor *menuIndicatorColor;
@property (nonatomic, strong) UIImage *itemSelectedBackgroundImage;
@property (nonatomic, strong) UIImage *itemNormalBackgroundImage;


- (id)initWithControllers:(NSArray *)controllers
             topBarHeight:(CGFloat)topBarHeight
     parentViewController:(UIViewController *)parentViewController;

@end
