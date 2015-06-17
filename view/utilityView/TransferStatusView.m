//
//  TransferStatusView.m
//  gwEdu
//
//  Created by xubh-note on 14-6-23.
//  Copyright (c) 2014年 gwsoft. All rights reserved.
//

#import "TransferStatusView.h"

@implementation TransferStatusView
@synthesize mCenterImage;
@synthesize mCircularBackColor;
@synthesize mCircularColor;
@synthesize mCircularWidth;

@synthesize mProgress=_mProgress;


- (void)dealloc
{
    self.mCircularColor=nil;
    self.mCircularBackColor=nil;
    self.mCenterImage=nil;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor=[UIColor clearColor];
        self.mCircularWidth=4.0f;
        self.mCircularBackColor=[UIColor colorWithRed:210.0/255.0 green:210.0/255.0 blue:210.0/255.0 alpha:0.8];
        self.mCircularColor=[UIColor  colorWithRed:245.0/255.0 green:161/255.0 blue:170.0/255.0 alpha:1.0];
       //self.mCircularColor=[UIColor  colorWithRed:127.0/255.0 green:216.0/255.0 blue:67.0/255.0 alpha:1.0];
        
      
    }
    return self;
}

-(void)setMProgress:(CGFloat)mProgress{
    _mProgress=mProgress;
    if (_mProgress > 0.00
        &&_mProgress < 0.02) {
        _mProgress=0.02;
    }
    
    
    [self setNeedsDisplay];

}


-(void)noProgress{
    _mProgress=0;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    float radius = CGRectGetWidth(rect)/2.0f - self.mCircularWidth/2.0f;
   
    
    //  background
    CGContextSetLineWidth(context, self.mCircularWidth);
    CGContextBeginPath(context);
    CGContextAddArc(context,
                    CGRectGetMidX(rect), CGRectGetMidY(rect),
                    radius,
                    0,
                    2*M_PI,
                    0);
    CGContextSetStrokeColorWithColor(context, [self.mCircularBackColor CGColor]);
    CGContextStrokePath(context);
    
    //
    CGContextSetLineWidth(context, self.mCircularWidth);
    CGContextBeginPath(context);
   // CGFloat startAngle = (((CGFloat)self.currentElapsedTime) /
    //                      ((CGFloat)self.totalTime)*M_PI*2 - angleOffset);
   // CGFloat endAngle = 2*M_PI - angleOffset;
    CGContextAddArc(context,
                    CGRectGetMidX(rect), CGRectGetMidY(rect),
                    radius,
                    (CGFloat)-M_PI_2,
                    (CGFloat)(-M_PI_2+self.mProgress*M_PI*2),
                    0);
    CGContextSetStrokeColorWithColor(context, [self.mCircularColor CGColor]);
    CGContextStrokePath(context);
}


@end
