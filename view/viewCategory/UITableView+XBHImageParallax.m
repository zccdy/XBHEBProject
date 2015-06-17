//
//  UITableView+XBHImageParallax.m
//  XBHEBProject
//
//  Created by xubh-note on 15/3/24.
//  Copyright (c) 2015年 xu banghui. All rights reserved.
//

#import "UITableView+XBHImageParallax.h"
#import "UIImage+XBHBlurImage.h"
#import <objc/runtime.h>

@interface XBHCoverImageView : UIImageView
@property (nonatomic, weak) UIScrollView *scrollView;

- (void)setImage:(UIImage *)image isBlurImage:(BOOL)yn ParallaxMode:(XBHImageParallaxMode)mode;
@end


@implementation XBHCoverImageView
{
    NSMutableArray *blurImages_;
    CGRect  orgFrame;
    XBHImageParallaxMode  _parallaxMode;
    BOOL    _isBlurImage;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // self.contentMode = UIViewContentModeScaleAspectFill;
        // self.clipsToBounds = YES;
        
        orgFrame=frame;
    }
    return self;

}


- (void)setImage:(UIImage *)image isBlurImage:(BOOL)yn ParallaxMode:(XBHImageParallaxMode)mode
{
    self.image=image;
    _parallaxMode=mode;
    _isBlurImage=yn;
    if (yn) {
        blurImages_=nil;
        blurImages_ = [[NSMutableArray alloc] initWithCapacity:20];
        [self prepareForBlurImages];
    }
    if (_parallaxMode == XBHImageParallaxMode_ShowMore) {
        
    }
}

- (void)prepareForBlurImages
{
    CGFloat factor = 0.1;
    [blurImages_ addObject:self.image];
    for (NSUInteger i = 0; i < 20; i++) {
        [blurImages_ addObject:[self.image boxblurImageWithBlur:factor]];
        factor+=0.04;
    }
}



- (void)setScrollView:(UIScrollView *)scrollView
{
    
    [_scrollView removeObserver:self forKeyPath:@"contentOffset"];
    _scrollView = scrollView;
    [_scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeFromSuperview
{
    [_scrollView removeObserver:self forKeyPath:@"contentOffset"];
  
    [super removeFromSuperview];
}

-(void)scaleLayout{

    if (self.scrollView.contentOffset.y < 0) {
        
        CGFloat offset = -self.scrollView.contentOffset.y;
        
        self.frame = CGRectMake(-offset,-offset, orgFrame.size.width+ offset * 2, XBHImageParallaxViewHeight + offset);
        
        if (_isBlurImage) {
            NSInteger index = offset / 10;
            if (index < 0) {
                index = 0;
            }
            else if(index >= blurImages_.count) {
                index = blurImages_.count - 1;
            }
            UIImage *image = blurImages_[index];
            if (self.image != image) {
                [super setImage:image];
            }
        }
        
        
    }
    else {
        CGRect frame= CGRectMake(0,0, orgFrame.size.width, XBHImageParallaxViewHeight);
       // frame.origin.y-=self.scrollView.contentOffset.y*0.5;
        self.frame =frame;
        if (_isBlurImage) {
            UIImage *image = blurImages_[0];
            
            if (self.image != image) {
                [super setImage:image];
            }
        }
       
    }

}

-(void)showMoreLayout{

    CGFloat factor=1.0;
    if (self.scrollView.contentOffset.y < 0) {
        factor=0.5;
    }
    CGRect   frame=orgFrame;
    frame.origin.y-=self.scrollView.contentOffset.y*factor;
    self.frame = frame;


}


- (void)layoutSubviews
{
    [super layoutSubviews];
    if (_parallaxMode == XBHImageParallaxMode_Scale) {
        [self scaleLayout];
    }
    else{
        [self showMoreLayout];
    
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self setNeedsLayout];
}

@end



@implementation UITableView (XBHImageParallax)

-(void)setParallaxView:(XBHCoverImageView *)view{

    objc_setAssociatedObject(self, @selector(parallaxView), view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

}
-(XBHCoverImageView *)parallaxView{
    return objc_getAssociatedObject(self, @selector(parallaxView));
}


-(void)setParallaxImage:(UIImage *)image ParallaxMode:(XBHImageParallaxMode)mode{
    if (!image) {
        return;
    }
    CGRect  showFrame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, XBHImageParallaxViewHeight);
    
    CGRect  imageViewFrame=showFrame;
    imageViewFrame.size.height=image.size.height;
    if (mode == XBHImageParallaxMode_ShowMore) {
        //按宽等比
        if (image.size.width>imageViewFrame.size.width
            || image.size.width<imageViewFrame.size.width) {
            imageViewFrame.size.height*=imageViewFrame.size.width/image.size.width;
        }
        
        //确定y
        imageViewFrame.origin.y=(showFrame.size.height-imageViewFrame.size.height)/2;
        
    }
    
    self.parallaxView=[[XBHCoverImageView alloc] initWithFrame:imageViewFrame];
    [self.parallaxView setImage:image isBlurImage:NO ParallaxMode:mode];
    self.parallaxView.scrollView=self;
    self.tableHeaderView=[[UIView alloc] initWithFrame:showFrame];
    self.tableHeaderView.backgroundColor=[UIColor clearColor];
    
    if (mode == XBHImageParallaxMode_ShowMore) {
        [self.superview insertSubview:self.parallaxView atIndex:0];
        
        self.backgroundColor=[UIColor clearColor];
        self.backgroundView=nil;
    }
    else{
        [self addSubview:self.parallaxView];
    
    }
    
}


-(void)cancelParallax{
    [self.parallaxView removeFromSuperview];
    self.parallaxView=nil;

}





@end
