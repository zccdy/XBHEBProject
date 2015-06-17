//
//  HomePageViewController.h
//  gwEdu
//
//  Created by xubh-note on 14-7-17.
//  Copyright (c) 2014年 gwsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomePageViewController : UIViewController

@property   (nonatomic)     NSUInteger      mShowIndex;

-(void)hiddenToolBar:(void(^)(void))compelete;
-(void)showContentWithIndex:(NSUInteger)index;
-(void)homePageShowUserCardWithOrientation:(UIDeviceOrientation)orient;
-(void)refreshMessageNotify;
@end
