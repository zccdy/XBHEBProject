//
//  XBHHorizontalListView.h
//  XBHEBProject
//
//  Created by xubh-note on 15/5/20.
//  Copyright (c) 2015年 xu banghui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XBHHorizontalListView : UIView

/**
 *  设置需要显示的 view
 *
 *  @param items uiview或子类 数组
 *  @param width 宽度，＝＝0 默认为全屏显示
 *  @param space 间隔
 */
-(void)setItems:(NSArray *)items itemWidth:(CGFloat)width itemSpace:(CGFloat)space;
/**
 *  增加需要显示的 view;若是在这之前没有调用setItems:(NSArray *)items itemWidth:(CGFloat)width itemSpace:(CGFloat)space;则不起作用
 *
 *  @param items uiview或子类 数组
 */
-(void)appendItems:(NSArray *)items;
@end
