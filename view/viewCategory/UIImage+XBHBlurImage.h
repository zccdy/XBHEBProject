//
//  UIImage+XBHBlurImage.h
//  XBHEBProject
//
//  Created by xubh-note on 15/3/24.
//  Copyright (c) 2015年 xu banghui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (XBHBlurImage)

/**
    图片模糊
 
    blur 模糊因子  0--1
 
 */
-(UIImage *)boxblurImageWithBlur:(CGFloat)blur ;
@end
