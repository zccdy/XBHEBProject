//
//  XBHLoadMoreView.h
//  XBHEBProject
//
//  Created by xubh-note on 15/3/27.
//  Copyright (c) 2015年 xu banghui. All rights reserved.
//

#import <UIKit/UIKit.h>

#define XBHLoadMoreViewHeight    48


typedef NS_ENUM(NSUInteger, XBHLoadMoreState){
     XBHLoadMoreState_None=0,
    XBHLoadMoreState_Loading,
    XBHLoadMoreState_WateLoading,           //点击加载
    XBHLoadMoreState_LoadCompelete          //已经加载完成
    
};




@interface XBHLoadMoreView : UIView

@property   (nonatomic,copy)    NSString   *mLoadingText;

@property   (nonatomic,copy)    NSString   *mWateLoadingText;

@property   (nonatomic,copy)    NSString   *mloadCompeleteText;

@property   (nonatomic,copy)    UIColor     *mTextColor;

@property   (nonatomic)         NSUInteger  mAutoLoadingCount;


@property   (nonatomic,copy)    void(^beginLoadMore)();

+(XBHLoadMoreView*)loadMoreWithScrollView:(UIScrollView *)sc;

-(void)scrollRemoveObserver;

/*
 
   自动加载 重新计数 
 
 */
-(void)resetAutoLoad;

-(void)endLoadingMore;
//提示已经加载完毕，上拉也木有啦
-(void)setLoadCompeleTeState;

-(void)setXBHLoadMoreViewState:(XBHLoadMoreState)state;

@end
