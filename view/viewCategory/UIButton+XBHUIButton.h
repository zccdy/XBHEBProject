//
//  UIButton+XBHUIButton.h
//  gwEdu
//
//  Created by xubh-note on 15-1-6.
//  Copyright (c) 2015年 gwsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(uint32_t, XBHUIButtonMode) {

    XBHUIButtonMode_UD,
    XBHUIButtonMode_LR_Center,   //图片文字
    XBHUIButtonMode_LR_Left,
    XBHUIButtonMode_LR_Right,
    XBHUIButtonMode_LR2_Center    // 文字  图片

};



@interface UIButton (XBHUIButton)


+(UIButton *)buttonWithImage:(UIImage *)img Text:(NSString *)text TextFont:(UIFont*)font ButtonSize:(CGSize)buttonSize TISpace:(CGFloat)tiSpace ButtonMode:(XBHUIButtonMode)mode;
@end
