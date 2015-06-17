//
//  HomePageToolBar.h
//  gwEdu
//
//  Created by xubh-note on 14-7-18.
//  Copyright (c) 2014年 gwsoft. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol HomePageToolBarDelegate <NSObject>

@optional
-(void)HomePageToolBarDidSelect:(NSUInteger)index;
@end



@interface HomePageToolBar : UIView


@property   (nonatomic,assign)  id<HomePageToolBarDelegate> delegate;


@property   (nonatomic)     NSUInteger  mCursel;

@property   (nonatomic)     NSUInteger  mMessageNum;


@end
