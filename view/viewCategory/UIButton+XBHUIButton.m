//
//  UIButton+XBHUIButton.m
//  gwEdu
//
//  Created by xubh-note on 15-1-6.
//  Copyright (c) 2015年 gwsoft. All rights reserved.
//

#import "UIButton+XBHUIButton.h"

@implementation UIButton (XBHUIButton)




+(UIButton *)buttonWithImage:(UIImage *)img Text:(NSString *)text TextFont:(UIFont*)font ButtonSize:(CGSize)buttonSize TISpace:(CGFloat)tiSpace ButtonMode:(XBHUIButtonMode)mode{
    UIButton  *bt=[UIButton buttonWithType:UIButtonTypeCustom];
    bt.titleLabel.font=font;
    [bt setTitle:text forState:UIControlStateNormal];
    [bt setImage:img forState:UIControlStateNormal];
    [bt setImage:img forState:UIControlStateHighlighted];
    CGSize strSize=[text XBHStringSizeWithFont:font];
    bt.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    bt.contentVerticalAlignment=UIControlContentVerticalAlignmentTop;
    
    if (mode == XBHUIButtonMode_LR_Center) {
        
        bt.imageEdgeInsets=UIEdgeInsetsMake((buttonSize.height-img.size.height)/2, (buttonSize.width-img.size.width-strSize.width-tiSpace)/2,(buttonSize.height-img.size.height)/2,0);
        bt.titleEdgeInsets=UIEdgeInsetsMake((buttonSize.height-strSize.height)/2,  bt.imageEdgeInsets.left+tiSpace, 0, 0);
    }
    else if (mode == XBHUIButtonMode_LR_Left) {
        bt.imageEdgeInsets=UIEdgeInsetsMake((buttonSize.height-img.size.height)/2, 0,(buttonSize.height-img.size.height)/2,0);
        bt.titleEdgeInsets=UIEdgeInsetsMake((buttonSize.height-strSize.height)/2,  bt.imageEdgeInsets.left+tiSpace, 0, 0);
    }
    else if (mode == XBHUIButtonMode_LR_Right) {
        bt.imageEdgeInsets=UIEdgeInsetsMake((buttonSize.height-img.size.height)/2, buttonSize.width-img.size.width-strSize.width-tiSpace,(buttonSize.height-img.size.height)/2,0);
        bt.titleEdgeInsets=UIEdgeInsetsMake((buttonSize.height-strSize.height)/2,  bt.imageEdgeInsets.left+tiSpace, 0, 0);
    }
    else if (mode == XBHUIButtonMode_LR2_Center){
        bt.imageEdgeInsets=UIEdgeInsetsMake((buttonSize.height-img.size.height)/2, (buttonSize.width-img.size.width-strSize.width-tiSpace)/2+strSize.width+tiSpace,(buttonSize.height-img.size.height)/2,0);
        bt.titleEdgeInsets=UIEdgeInsetsMake((buttonSize.height-strSize.height)/2,  bt.imageEdgeInsets.left-tiSpace-strSize.width-img.size.width, 0, 0);
        
    }
    else if (mode == XBHUIButtonMode_UD){
    
        bt.imageEdgeInsets=UIEdgeInsetsMake(0,(buttonSize.width-img.size.width)/2, buttonSize.height-img.size.height, (buttonSize.width-img.size.width)/2);
        
        //text 靠左时(因为文本的起始x 是imgframe的maxX(原始位置的maxX ))
        CGFloat textXOffset=-img.size.width;//靠左
        
        CGFloat FF=(buttonSize.width-strSize.width)/2;
        bt.titleEdgeInsets=UIEdgeInsetsMake(img.size.height+tiSpace, FF+textXOffset, 0, 0);
        
    }
   
    


    
    
    return bt;
}


@end
