//
//  XBHTextFieldLRView.m
//  XBHEBProject
//
//  Created by xubh-note on 15/6/2.
//  Copyright (c) 2015年 xu banghui. All rights reserved.
//

#import "XBHTextFieldLRView.h"

@implementation XBHTextFieldLRView
{
    UIImageView     *_imageView;
}
- (instancetype)init
{
    
    return [self initWithFrame:CGRectZero];
}

-(instancetype)initWithFrame:(CGRect)frame{
    return [self initWithFrame:frame LRSpace:0 image:nil];
}
-(instancetype)initWithImage:(UIImage *)img LRSpace:(CGFloat)space{

    return [self initWithFrame:CGRectZero LRSpace:space image:img];
}


-(instancetype)initWithFrame:(CGRect)frame LRSpace:(CGFloat)space image:(UIImage *)img{
    CGRect rect=frame;
    if (img) {
        
        rect.size=CGSizeMake(img.size.width+space*2, img.size.height);
    }
    self = [super initWithFrame:rect];
    if (self) {
        self.opaque=NO;
        self.userInteractionEnabled=YES;
        _imageView=[[UIImageView alloc] initWithImage:img];
        [self addSubview:_imageView];
        
    }
    return self;
}


-(void)layoutSubviews{
    
    
    _imageView.center=CGPointMake(CGRectGetWidth(self.bounds)/2, CGRectGetHeight(self.bounds)/2);


}
@end
