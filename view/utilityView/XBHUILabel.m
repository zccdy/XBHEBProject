//
//  XBHUILabel.m
//  gwEdu
//
//  Created by xubh-note on 15/2/9.
//  Copyright (c) 2015年 gwsoft. All rights reserved.
//

#import "XBHUILabel.h"

@implementation XBHUILabel
@synthesize verticalAlignment=_verticalAlignment;

- (instancetype)init
{
        return [self initWithFrame:CGRectZero];
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.verticalAlignment = XBHVerticalAlignmentMiddle;
    }
    return self;
}

- (void)setVerticalAlignment:(XBHVerticalAlignment)verticalAlignment {
    _verticalAlignment = verticalAlignment;
    [self setNeedsDisplay];
}

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
    CGRect textRect = [super textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
    switch (self.verticalAlignment) {
        case XBHVerticalAlignmentTop:
            textRect.origin.y = bounds.origin.y;
            break;
        case XBHVerticalAlignmentBottom:
            textRect.origin.y = bounds.origin.y + bounds.size.height - textRect.size.height;
            break;
        case XBHVerticalAlignmentMiddle:
            // Fall through.
        default:
            textRect.origin.y = bounds.origin.y + (bounds.size.height - textRect.size.height) / 2.0;
    }
    return textRect;
}

-(void)drawTextInRect:(CGRect)requestedRect {
    CGRect actualRect = [self textRectForBounds:requestedRect limitedToNumberOfLines:self.numberOfLines];
    [super drawTextInRect:actualRect];
}



@end
