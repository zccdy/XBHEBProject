//
//  UINavigationBar+XBHDynamicEffect.h
//  XBHEBProject
//
//  Created by xubh-note on 15/3/24.
//  Copyright (c) 2015年 xu banghui. All rights reserved.
//

#import <UIKit/UIKit.h>
/*

    NavigationBar   动态效果（透明度变换）
*/

#define XBHDynamicEffectHeight      (50)


@interface UINavigationBar (XBHDynamicEffect)

//- (void)de_setBackgroundColor:(UIColor *)backgroundColor;
//- (void)de_setTranslationY:(CGFloat)translationY;
//- (void)de_setContentAlpha:(CGFloat)alpha;
-(void)registerScrollerView:(UIScrollView *)scrollView backgroundColor:(UIColor *)color;


//记得-(void)viewDidDisappear:(BOOL)animated 时调用
- (void)de_reset;

@end
