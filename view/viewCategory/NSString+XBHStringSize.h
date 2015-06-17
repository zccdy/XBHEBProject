//
//  NSString+XBHStringSize.h
//  gwEdu
//
//  Created by xubh-note on 14-12-12.
//  Copyright (c) 2014年 gwsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (XBHStringSize)


-(CGSize)XBHStringSizeWithFont:(UIFont *)font;

-(CGSize)XBHStringSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;

-(CGSize)XBHStringSizeWithFont:(UIFont *)font RowSpace:(CGFloat)space constrainedToSize:(CGSize)size;
@end
