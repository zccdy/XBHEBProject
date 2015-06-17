//
//  NSString+XBHStringSize.m
//  gwEdu
//
//  Created by xubh-note on 14-12-12.
//  Copyright (c) 2014年 gwsoft. All rights reserved.
//

#import "NSString+XBHStringSize.h"

@implementation NSString (XBHStringSize)

-(CGSize)XBHStringSizeWithFont:(UIFont *)font{

    return [self XBHStringSizeWithFont:font constrainedToSize:CGSizeZero];
}


-(CGSize)XBHStringSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size {
    return [self XBHStringSizeWithFont:font RowSpace:0 constrainedToSize:size];
}


-(CGSize)XBHStringSizeWithFont:(UIFont *)font RowSpace:(CGFloat)space constrainedToSize:(CGSize)size {
  
    CGSize   rn=CGSizeMake(0, 0);
    CGSize   constrainedSize=size;
    if (CGSizeEqualToSize(constrainedSize, CGSizeZero)) {
        constrainedSize=CGSizeMake(3000, 3000);
    }
    if (IOS7SYSTEMVERSION_OR_LATER) {
        if (space) {
            NSMutableDictionary *mAttributes=[NSMutableDictionary dictionary];
            [mAttributes setObject:font forKey:NSFontAttributeName];
            
            NSMutableParagraphStyle    *style=[[NSMutableParagraphStyle alloc] init];
            style.lineSpacing=space;
            [mAttributes setObject:style forKey:NSParagraphStyleAttributeName];
#if    IOS7SDK_OR_LATER
            rn= [self boundingRectWithSize:constrainedSize options:NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:mAttributes context:nil].size;
#endif
        }
        else{
#if    IOS7SDK_OR_LATER
            
            
            rn= [self boundingRectWithSize:constrainedSize options:NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil].size;
#endif
            
        }
    }
    else{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        

        rn=[self sizeWithFont:font constrainedToSize:constrainedSize];
#pragma clang diagnostic pop
        if (space) {
            int line=rn.height/font.lineHeight;
            rn.height+=(line-1)*space;
        }
    }
    
    return rn;
    
}


@end
