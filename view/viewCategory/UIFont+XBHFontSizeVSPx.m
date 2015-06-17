//
//  UIFont+XBHFontSizeVSPx.m
//  gwEdu
//
//  Created by xubh-note on 15-1-4.
//  Copyright (c) 2015年 gwsoft. All rights reserved.
//

#import "UIFont+XBHFontSizeVSPx.h"

@implementation UIFont (XBHFontSizeVSPx)

+(CGFloat)sizeWithPx:(CGFloat )px{
    NSLog(@"<<<<<<<%f",(px/96)*72);
    return (px/96)*72;

}

+(CGFloat)pxWithSize:(CGFloat )size{

    return (size/72)*96;
}

@end
