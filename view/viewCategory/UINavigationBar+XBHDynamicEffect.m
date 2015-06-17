//
//  UINavigationBar+XBHDynamicEffect.m
//  XBHEBProject
//
//  Created by xubh-note on 15/3/24.
//  Copyright (c) 2015年 xu banghui. All rights reserved.
//

#import "UINavigationBar+XBHDynamicEffect.h"
#import <objc/runtime.h>

@implementation UINavigationBar (XBHDynamicEffect)
static char overlayKey;
static char emptyImageKey;
static char navBarcolorKey;
static char observeViewKey;

- (UIView *)overlay
{
    return objc_getAssociatedObject(self, &overlayKey);
}

- (void)setOverlay:(UIView *)overlay
{
    objc_setAssociatedObject(self, &overlayKey, overlay, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImage *)emptyImage
{
    return objc_getAssociatedObject(self, &emptyImageKey);
}

- (void)setEmptyImage:(UIImage *)image
{
    objc_setAssociatedObject(self, &emptyImageKey, image, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)navbarColor
{
    return objc_getAssociatedObject(self, &navBarcolorKey);
}

- (void)setNavbarColor:(UIColor *)color
{
    objc_setAssociatedObject(self, &navBarcolorKey, color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (UIScrollView *)observeView
{
    return objc_getAssociatedObject(self, &observeViewKey);
}

- (void)setObserveView:(UIScrollView *)view
{
    objc_setAssociatedObject(self, &observeViewKey, view, OBJC_ASSOCIATION_ASSIGN);
}







- (void)de_setBackgroundColor:(UIColor *)backgroundColor
{
        self.overlay.backgroundColor = backgroundColor;
}

- (void)de_setTranslationY:(CGFloat)translationY
{
    self.transform = CGAffineTransformMakeTranslation(0, translationY);
}

- (void)de_setContentAlpha:(CGFloat)alpha
{
    if (!self.overlay) {
        [self de_setBackgroundColor:self.barTintColor];
    }
    [self setAlpha:alpha forSubviewsOfView:self];
    if (alpha == 1) {
        if (!self.emptyImage) {
            self.emptyImage = [UIImage new];
        }
        self.backIndicatorImage = self.emptyImage;
    }
}

- (void)setAlpha:(CGFloat)alpha forSubviewsOfView:(UIView *)view
{
    for (UIView *subview in view.subviews) {
        if (subview == self.overlay) {
            continue;
        }
        subview.alpha = alpha;
        [self setAlpha:alpha forSubviewsOfView:subview];
    }
}





-(void)registerScrollerView:(UIScrollView *)scrollView backgroundColor:(UIColor *)color{
    self.navbarColor=color;
    self.overlay=nil;
    self.observeView=scrollView;
    
    [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self setShadowImage:[UIImage new]];
    self.overlay = [[UIView alloc] initWithFrame:CGRectMake(0, -20, [UIScreen mainScreen].bounds.size.width, 64)];
    self.overlay.userInteractionEnabled = NO;
    self.overlay.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self insertSubview:self.overlay atIndex:0];


 
    [self.observeView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    

}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        [self transtionWithContentOffset:self.observeView.contentOffset.y];
        
        NSLog(@"<<<<<<<<<%f",self.observeView.contentOffset.y);
    }
    
    
}


-(void)transtionWithContentOffset:(CGFloat)offsetY{
    if (offsetY > XBHDynamicEffectHeight) {
        CGFloat alpha = 1 - ((XBHDynamicEffectHeight + 64 - offsetY) / 64);
        
        [self de_setBackgroundColor:[self.navbarColor colorWithAlphaComponent:alpha]];
    } else {
        [self de_setBackgroundColor:[self.navbarColor colorWithAlphaComponent:0]];
    }

}


- (void)de_reset
{
   
    [self setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self setShadowImage:nil];
    [self.observeView removeObserver:self forKeyPath:@"contentOffset"];
    [self.overlay removeFromSuperview];
    self.overlay = nil;
   
}





@end
