//
//  XBHLoadMoreView.m
//  XBHEBProject
//
//  Created by xubh-note on 15/3/27.
//  Copyright (c) 2015年 xu banghui. All rights reserved.
//

#import "XBHLoadMoreView.h"
#import <Masonry.h>


@interface XBHLoadMoreView ()

@property   (nonatomic,weak)    UIScrollView    *scrollView;


@end


@implementation XBHLoadMoreView{
    UIActivityIndicatorView *_activity;
    UILabel         *_textLabel;
    NSUInteger      _loadMoreCount;
    UIEdgeInsets    _orgEdgeInsets;
    UIEdgeInsets    _stateEdgInsets;
    XBHLoadMoreState    _loadState;
    CGFloat         _originalScrollViewContentHeight;
}
@synthesize scrollView=_scrollView;
@synthesize mTextColor=_mTextColor;
- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.mLoadingText=@"加载中";
        self.mWateLoadingText=@"点击加载更多";
        self.mloadCompeleteText=@"加载完毕";
        _activity= [[UIActivityIndicatorView alloc] init];
        _activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [self addSubview:_activity];
        _activity.hidden=YES;
        
        self.mTextColor=[UIColor blackColor];
        _textLabel=[[UILabel alloc] init];
        _textLabel.backgroundColor=[UIColor clearColor];
        _textLabel.font=[UIFont systemFontOfSize:14];
        _textLabel.textAlignment=NSTextAlignmentCenter;
        [self addSubview:_textLabel];
        
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToLoadmore)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

-(void)resetAutoLoad{
    _loadMoreCount=0;
    _loadState=XBHLoadMoreState_None;
}

-(void)scrollRemoveObserver{
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
    [self.scrollView removeObserver:self forKeyPath:@"contentSize"];
}
-(void)scrollAddObserver{

    [_scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    [_scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
}

-(void)setMTextColor:(UIColor *)mTextColor{
    _mTextColor=mTextColor;
    if (_mTextColor) {
        _textLabel.textColor=_mTextColor;
    }

}

+(XBHLoadMoreView*)loadMoreWithScrollView:(UIScrollView *)sc{
    XBHLoadMoreView *view=[[XBHLoadMoreView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(sc.frame), XBHLoadMoreViewHeight)];
    [view addToScrollView:sc];
    return view;
}


-(void)addToScrollView:(UIScrollView *)sc{
    self.scrollView=sc;
    [_scrollView addSubview:self];
    [self scrollAddObserver];
    _orgEdgeInsets=sc.contentInset;
    _stateEdgInsets=UIEdgeInsetsMake(_orgEdgeInsets.top, _orgEdgeInsets.left, _orgEdgeInsets.bottom+XBHLoadMoreViewHeight, _orgEdgeInsets.right);
   
    self.backgroundColor=[UIColor clearColor];

}


- (void)layoutSubviews
{
    [super layoutSubviews];
    //显示菊花转  加载中
    CGRect frame=_activity.frame;
    frame.origin.x=20;
    frame.origin.y=(self.bounds.size.height -frame.size.height)/2;
    _activity.frame=frame;
    
   
    _textLabel.frame=CGRectMake(CGRectGetMaxX(_activity.frame), 0, CGRectGetWidth(self.bounds)-CGRectGetMaxX(_activity.frame), CGRectGetHeight(self.bounds));
    /*
    if (_loadState == XBHLoadMoreState_Loading) {
        //显示菊花转  加载中
        CGRect frame=_activity.frame;
        frame.origin.x=20;
        frame.origin.y=(self.bounds.size.height -frame.size.height)/2;
        _activity.frame=frame;
        
        _textLabel.frame=CGRectMake(CGRectGetMaxX(_activity.frame), 0, CGRectGetWidth(self.bounds)-CGRectGetMaxX(_activity.frame), CGRectGetHeight(self.bounds));
    }
    else{
        //显示 点击加载/加载完毕/出错
        _textLabel.frame=self.bounds;
    
    
    }
*/
    
    _originalScrollViewContentHeight=_scrollView.contentSize.height;
    if (_scrollView.contentSize.height>0) {
        self.hidden=NO;
        self.center =CGPointMake(CGRectGetWidth(_scrollView.frame) * 0.5, _scrollView.contentSize.height + CGRectGetHeight(self.bounds) * 0.5 );
    }
    else{
        self.hidden=YES;
    }
    
   
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        CGFloat offset = [change[NSKeyValueChangeNewKey] CGPointValue].y;
        
        // 只有在 y>0 以及 scrollview的高度不为0 时才判断
        if ((offset<= 0) || (_scrollView.bounds.size.height == 0)) return;
        
        
        CGRect bounds = self.scrollView.bounds;//边界
        
        CGSize size = self.scrollView.contentSize;//滚动视图内容区域size
        
        
        float y = offset-size.height+bounds.size.height-_orgEdgeInsets.bottom; //拖动时与视图底部的间歇高度
        
        
        //开始加载状态
        
        if ( _loadState == XBHLoadMoreState_None
            &&y > XBHLoadMoreViewHeight/2) {
                if (_loadMoreCount<self.mAutoLoadingCount) {//自动加载
                    _loadMoreCount++;
                    [self setXBHLoadMoreViewState:XBHLoadMoreState_Loading];
                }
                else{
                    [self setXBHLoadMoreViewState:XBHLoadMoreState_WateLoading];
                }
            
            
        }
        
    }
    else if ([keyPath isEqualToString:@"contentSize"]){
        // 如果scrollView内容有增减，重新调整refreshFooter位置
       if (self.scrollView.contentSize.height != _originalScrollViewContentHeight) {
            [self layoutSubviews];
        }
    
    }
    
    
    
  

}



-(void)setXBHLoadMoreViewState:(XBHLoadMoreState)state{
    self.userInteractionEnabled=NO;
    _loadState=state;
    _activity.hidden=YES;
    switch (state) {

            // 进入刷新状态
        case XBHLoadMoreState_Loading:
        {
             self.scrollView.contentInset=_stateEdgInsets;
             _activity.hidden=NO;
            [_activity startAnimating];
            _textLabel.text=self.mLoadingText;
            if (self.beginLoadMore) {
                self.beginLoadMore();
            }
           // [self setNeedsLayout];
        }
            break;
        case XBHLoadMoreState_WateLoading:
        {
             self.scrollView.contentInset=_stateEdgInsets;
            self.userInteractionEnabled=YES;
            [_activity stopAnimating];
            _textLabel.text=self.mWateLoadingText;
            
        
        }
            break;
        case XBHLoadMoreState_LoadCompelete:{
             [_activity stopAnimating];
            self.userInteractionEnabled=NO;
             self.scrollView.contentInset=_stateEdgInsets;
            _textLabel.text=self.mloadCompeleteText;
        }
            break;
        case XBHLoadMoreState_None:
        default:
            self.userInteractionEnabled=NO;
            [_activity stopAnimating];
            _activity.hidden=YES;
            XBHWeakSelf;
            if (!UIEdgeInsetsEqualToEdgeInsets(_scrollView.contentInset, _orgEdgeInsets)) {
                [UIView animateWithDuration:0.5 animations:^{
                    XBHStrongSelf;
                     strongSelf.scrollView.contentInset =_orgEdgeInsets;
                }];
            }
            break;
    }


}

-(void)endLoadingMore{
    if (_loadState == XBHLoadMoreState_Loading) {
        [self setXBHLoadMoreViewState:XBHLoadMoreState_None];
    }
    
  //  _loadState=XBHLoadMoreState_Normal;
}

-(void)setLoadCompeleTeState{
    [self setXBHLoadMoreViewState:XBHLoadMoreState_LoadCompelete];

}
-(void)tapToLoadmore{
    [self setXBHLoadMoreViewState:XBHLoadMoreState_Loading];
}



@end
