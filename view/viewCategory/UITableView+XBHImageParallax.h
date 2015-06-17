//
//  UITableView+XBHImageParallax.h
//  XBHEBProject
//
//  Created by xubh-note on 15/3/24.
//  Copyright (c) 2015年 xu banghui. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 
    拖拽视差效果(只支持 单张图片)
 
    TableView 的headerView 将被占用
 */

#define XBHImageParallaxViewHeight       (160)


typedef NS_ENUM(NSUInteger, XBHImageParallaxMode){

    XBHImageParallaxMode_Scale=0,               //拖拽时，内容放大
    XBHImageParallaxMode_ShowMore               //拖拽时，显示更多. 图片Height必须大于XBHImageParallaxViewHeight

};

@interface UITableView (XBHImageParallax)



-(void)setParallaxImage:(UIImage *)image ParallaxMode:(XBHImageParallaxMode)mode;

//记得-(void)viewDidDisappear:(BOOL)animated 时调用
-(void)cancelParallax;
@end
