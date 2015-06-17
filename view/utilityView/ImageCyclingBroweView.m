//
//  ImageCyclingBroweView.m
//  gwEdu
//
//  Created by xubh-note on 14-11-21.
//  Copyright (c) 2014年 gwsoft. All rights reserved.
//

#import "ImageCyclingBroweView.h"
#import <UIImageView+AFNetworking.h>


@implementation XBHImageBrowseInfo
@synthesize mPlaceholderImage;
@synthesize mImageUrlStr;

- (void)dealloc
{
    self.mPlaceholderImage=nil;
    self.mImageUrlStr=nil;
#if !__has_feature(objc_arc)

    [super dealloc];
#endif
}

@end







@interface ImageCyclingBroweView ()<UIScrollViewDelegate>

@end

@implementation ImageCyclingBroweView
{

    UIScrollView           *mScrollView;
    NSUInteger             _mCurShowIndex;
    NSMutableArray         *mIndicatorArray;
    
    UIImage                *mNormalDot;
    UIImage                *mCurDot;
    NSTimeInterval          mScrollTime;
    
    
}
@synthesize mDefaultImage;
@synthesize mImageBrowseInfoArray=_mImageBrowseInfoArray;
@synthesize mbIsIndicator;
@synthesize delegate;

- (void)dealloc
{
   
    self.mDefaultImage=nil;
    self.mImageBrowseInfoArray=nil;
    [self disableScroll];
#if !__has_feature(objc_arc)
    [mIndicatorArray release];
    [mNormalDot release];
    [mCurDot release];
    [super dealloc];
#endif
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.userInteractionEnabled=YES;
        
        
     
      //  mCurDot=[GWImageWithNamed(@"dot_ad_1.png") retain];
       // mNormalDot=[GWImageWithNamed(@"dot_ad.png") retain];
        
    }
    return self;
}


-(void)removeIndicatorButton{
    for (UIButton *bt in mIndicatorArray) {
        [bt removeFromSuperview];
    }
#if !__has_feature(objc_arc)
    [mIndicatorArray release];
#endif
    mIndicatorArray=nil;
}
-(void)createScrollView{
    if (mScrollView) {
        mScrollView.delegate=nil;
        [mScrollView removeFromSuperview];
    }
    
    NSUInteger  count=1;
    if ([_mImageBrowseInfoArray count]>1) {
        count=3;
    }
    
    mScrollView=[[UIScrollView alloc] initWithFrame:self.bounds];
    mScrollView.delegate=self;
    mScrollView.showsHorizontalScrollIndicator=NO;
    mScrollView.showsVerticalScrollIndicator=NO;
    mScrollView.pagingEnabled=YES;
    mScrollView.backgroundColor=[UIColor clearColor];
    mScrollView.contentSize=CGSizeMake(self.bounds.size.width * count, self.bounds.size.height);
    [self addSubview:mScrollView];
#if !__has_feature(objc_arc)
    [mScrollView release];
#endif
     [self initSubviews];
    
}

-(UIImageView *)imageViewWithTag:(NSInteger)tag{
    for (UIImageView *view in mScrollView.subviews) {
        if (view.tag == tag) {
            return view;
        }
    }
    return nil;
}
-(void)imageViewAddGesture:(UIImageView*)imageView{
    imageView.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellDidTap)];
    [imageView addGestureRecognizer:tap];
#if !__has_feature(objc_arc)
    [tap release];
#endif

}
-(void)initSubviews{
    _mCurShowIndex=0;
    NSUInteger    count=[_mImageBrowseInfoArray count];
    UIView  *prev=nil;
    UIImage *defaultImage=nil;

    if (count == 1) {//count== 1
        XBHImageBrowseInfo *firstInfo=[_mImageBrowseInfoArray firstObject];
        UIImageView *view=[[UIImageView alloc] init];
        [self imageViewAddGesture:view];
        view.userInteractionEnabled=YES;
        if (firstInfo.mPlaceholderImage) {
            defaultImage=firstInfo.mPlaceholderImage;
        }
        else{
            defaultImage=self.mDefaultImage;
        }
        [view setImageWithURL:[NSURL URLWithString:firstInfo.mImageUrlStr] placeholderImage:defaultImage];
        
        view.frame=CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
        [mScrollView addSubview:view];
    #if !__has_feature(objc_arc)
        [view release];
#endif
    }
    else{ //count >=2
        for (NSUInteger i=0; i<3; i++) {
            UIImageView *view=[[UIImageView alloc] init];
            
            [self imageViewAddGesture:view];
            view.tag=i;
            if (prev) {
                view.frame=CGRectMake(CGRectGetMaxX(prev.frame), 0, self.bounds.size.width, self.bounds.size.height);
            }
            else{
                view.frame=CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
            }
            prev=view;
            [mScrollView addSubview:view];
      #if !__has_feature(objc_arc)
            [view release];
#endif
            
        }
    
    }
    
    

}
-(void)imageView:(UIImageView *)view SetInfo:(XBHImageBrowseInfo*)info{
    UIImage *defaultImage=nil;
    if (info.mPlaceholderImage) {
        defaultImage=info.mPlaceholderImage;
    }
    else{
        defaultImage=self.mDefaultImage;
    }
    [view setImageWithURL:[NSURL URLWithString:info.mImageUrlStr] placeholderImage:defaultImage];

}

-(void)reloadSubViews{
  
    NSUInteger  count=[self.mImageBrowseInfoArray count];
    if (count<2) {
        return;
    }
    
    UIImageView  *view1=[self imageViewWithTag:0];
    UIImageView  *view2=[self imageViewWithTag:1];
    UIImageView  *view3=[self imageViewWithTag:2];
    
    XBHImageBrowseInfo *prevInfo=nil;
    XBHImageBrowseInfo *centerInfo=nil;
    XBHImageBrowseInfo *nextInfo=nil;
    
    
    if (_mCurShowIndex == 0) {//第一个 在中间
        centerInfo=[_mImageBrowseInfoArray firstObject];
        prevInfo=[_mImageBrowseInfoArray lastObject];
        nextInfo=[_mImageBrowseInfoArray objectAtIndex:_mCurShowIndex+1];
        
    }
    else if(_mCurShowIndex == count-1){//最后一个在中间
        prevInfo=[_mImageBrowseInfoArray objectAtIndex:_mCurShowIndex-1];
        centerInfo=[_mImageBrowseInfoArray lastObject];
        nextInfo=[_mImageBrowseInfoArray firstObject];
        
    }
    else{
        prevInfo=[_mImageBrowseInfoArray objectAtIndex:_mCurShowIndex-1];
        centerInfo=[_mImageBrowseInfoArray objectAtIndex:_mCurShowIndex];
        nextInfo=[_mImageBrowseInfoArray objectAtIndex:_mCurShowIndex+1];
    
    }
    
    if (prevInfo) {
        [self imageView:view1 SetInfo:prevInfo];
    }
    if (centerInfo) {
        [self imageView:view2 SetInfo:centerInfo];
    }
    
    if (nextInfo) {
        [self imageView:view3 SetInfo:nextInfo];
    }
    
    [mScrollView setContentOffset:CGPointMake(self.bounds.size.width, 0) animated:NO];
}

-(void)setMImageBrowseInfoArray:(NSArray *)mImageBrowseInfoArray{
 #if __has_feature(objc_arc)
    _mImageBrowseInfoArray=mImageBrowseInfoArray;
    
#else
    [_mImageBrowseInfoArray release];
    _mImageBrowseInfoArray=[mImageBrowseInfoArray retain];
#endif
    if ([_mImageBrowseInfoArray count]) {
        [self removeIndicatorButton];
        [self createScrollView];
        [self reloadSubViews];
        NSUInteger    count=[_mImageBrowseInfoArray count];
 #if __has_feature(objc_arc)
        mIndicatorArray=[NSMutableArray array];
        
#else
        mIndicatorArray=[[NSMutableArray array] retain];
#endif
        for (NSUInteger i=0; i<count; i++) {
            UIButton *bt=[UIButton buttonWithType:UIButtonTypeCustom];
            bt.tag=i;
            [bt addTarget:self action:@selector(indicatorDidSelect:) forControlEvents:UIControlEventTouchUpInside];
            [mIndicatorArray addObject:bt];
            [self addSubview:bt];
        }
        [self setNeedsDisplay];
    }

}


-(void)refreshIndicator{
    if (!self.mbIsIndicator){return;}
    
    CGFloat space=4;
    CGFloat borderRight=23;
    CGFloat borderDown=5;
    NSUInteger count=[mIndicatorArray count];
    //靠右
    CGFloat orgX=CGRectGetWidth(self.bounds)-count*(mNormalDot.size.width/2)-(count-1)*space-borderRight;
    
    for (int i=0; i<count; i++) {
        UIButton   *bt=[mIndicatorArray objectAtIndex:i];
        UIImage  *dot=nil;
        if (i==_mCurShowIndex) {
            dot=mCurDot;
        }
        else{
            dot=mNormalDot;
        }
        
        bt.frame=CGRectMake(orgX+i*(dot.size.width/2+space), CGRectGetHeight(self.bounds)-dot.size.height/2-borderDown, dot.size.width/2, dot.size.height/2);
        
        [bt setBackgroundImage:dot forState:UIControlStateNormal];
        
    }
}


-(void)layoutSubviews{
    [super layoutSubviews];
    mScrollView.frame=self.bounds;
    
}
-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    [self reloadSubViews];
    [self refreshIndicator];
}


#pragma mark -
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self enableScroll:mScrollTime];

}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self enableScroll:mScrollTime];
    
    CGFloat offset=scrollView.contentOffset.x;
    BOOL        refresh=NO;
    if (offset>self.bounds.size.width) {//向右滑动
      
        if (_mCurShowIndex +1 <[_mImageBrowseInfoArray count]) {
            _mCurShowIndex+=1;
        }
        else{
            _mCurShowIndex=0;
        
        }
        refresh=YES;
    }
    else if(offset<self.bounds.size.width){//向左滑动
        if (_mCurShowIndex >=1) {
            _mCurShowIndex-=1;
        }
        else{
            _mCurShowIndex=[_mImageBrowseInfoArray count]-1;
        }
        refresh=YES;
    }
    
    if (refresh) {
        [self reloadSubViews];
        [self refreshIndicator];
    }
   
  
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
    [self reloadSubViews];
    [self refreshIndicator];

}


-(void)indicatorDidSelect:(id)sender{
/*
    UIButton *bt=(UIButton *)sender;
    if (_mCurShowIndex == bt.tag) {
        return;
    }
    _mCurShowIndex=bt.tag;
    [self reloadSubViews:YES];
    [self refreshIndicator];
*/
}


-(void)cellDidTap{
    if (_mCurShowIndex >= [self.mImageBrowseInfoArray count]) {
        return;
    }
    if ([delegate respondsToSelector:@selector(ImageCyclingBroweViewDidTap:Index:)]) {
        [delegate ImageCyclingBroweViewDidTap:[self.mImageBrowseInfoArray objectAtIndex:_mCurShowIndex] Index:_mCurShowIndex];
    }
 
}


#pragma mark -

#pragma mark - 定时滚动

-(void)disableScroll{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    if (mScrollView) {//动画的时候就跳转页面 mScrollView将被释放
        mScrollView.delegate=nil;
    }
}

-(void)enableScroll:(NSTimeInterval)second{
    if ([_mImageBrowseInfoArray count]<2) {
        return;
    }
    mScrollTime=second;
    [self disableScroll];
    [self performSelector:@selector(scrollToNext) withObject:nil afterDelay:second];
    if (mScrollView) {
        mScrollView.delegate=self;
    }
}

-(void)scrollToNext{
    [self enableScroll:mScrollTime];
    if (mScrollView.isDragging
        ||mScrollView.isDecelerating) {
        return;
    }
    if ((_mCurShowIndex +1)<[self.mImageBrowseInfoArray count]) {
        _mCurShowIndex+=1;
    }
    else{
        _mCurShowIndex=0;
    }
    /*
    GWAsyncImageView *centerView=[self imageViewWithTag:1];
    GWAsyncImageView *nextView=[self imageViewWithTag:2];
    
    [UIView transitionWithView:centerView duration:0.2 options:UIViewAnimationOptionCurveLinear animations:^{
        centerView.m_pDefaultImage=nextView.m_pDefaultImage;
        centerView.m_pImageURLString=nextView.m_pImageURLString;
        
    } completion:^(BOOL finished) {
        [self reloadSubViews];
        [self refreshIndicator];
        
    }];
    */
    
    
    [mScrollView setContentOffset:CGPointMake(2*self.bounds.size.width, 0) animated:YES];

}


@end
