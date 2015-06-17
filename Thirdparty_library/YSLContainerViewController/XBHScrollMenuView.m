//
//  XBHScrollMenuView.m
//  XBHContainerViewController
//
//  Created by yamaguchi on 2015/03/03.
//  Copyright (c) 2015年 h.yamaguchi. All rights reserved.
//

#import "XBHScrollMenuView.h"
#import "UIButton+XBHUIButton.h"
static const CGFloat kXBHIndicatorHeight = 3;
static const CGFloat kXBHIndicatorWidth=90;

 NSString   *const kXBHMenuItemTitle=@"kxbhmenuitemtitlename";
 NSString   *const kXBHMenuItemIcon=@"kxbhmenuitemiconname";

@interface XBHScrollMenuView ()


@property (nonatomic, strong) UIView *indicatorView;

@end

@implementation XBHScrollMenuView
{
    NSUInteger          _selectonIndex;
  
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // default
        _viewbackgroudColor = [UIColor whiteColor];
        _itemfont = [UIFont systemFontOfSize:16];
        _itemTitleColor = [UIColor colorWithRed:0.866667 green:0.866667 blue:0.866667 alpha:1.0];
        _itemSelectedTitleColor = [UIColor colorWithRed:0.333333 green:0.333333 blue:0.333333 alpha:1.0];
        _itemIndicatorColor = [UIColor colorWithRed:0.168627 green:0.498039 blue:0.839216 alpha:1.0];
        
        self.backgroundColor = _viewbackgroudColor;
        _scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.layer.masksToBounds=YES;
        _scrollView.layer.cornerRadius=5;
        _scrollView.backgroundColor=[UIColor colorWithRed:111.0/255.0 green:119.0/255.0 blue:130.0/255.0 alpha:1.0];
        [self addSubview:_scrollView];
    }
    return self;
}

#pragma mark -- Setter

- (void)setViewbackgroudColor:(UIColor *)viewbackgroudColor
{
    if (!viewbackgroudColor) { return; }
    _viewbackgroudColor = viewbackgroudColor;
    self.backgroundColor = viewbackgroudColor;
}

- (void)setItemfont:(UIFont *)itemfont
{
    if (!itemfont) { return; }
    _itemfont = itemfont;
    for (UIButton  *button in _itemViewArray) {
        button.titleLabel.font = itemfont;
    }
}

- (void)setItemTitleColor:(UIColor *)itemTitleColor
{
    if (!itemTitleColor) { return; }
    _itemTitleColor = itemTitleColor;
    for (UIButton *button in _itemViewArray) {
        [button setTitleColor:itemTitleColor forState:UIControlStateNormal];
    }
}

- (void)setItemIndicatorColor:(UIColor *)itemIndicatorColor
{
    if (!itemIndicatorColor) { return; }
    _itemIndicatorColor = itemIndicatorColor;
    _indicatorView.backgroundColor = itemIndicatorColor;
}


-(void)itemButtonCreateAndLayout{
    
    for (UIView *view in self.scrollView.subviews) {
        [view removeFromSuperview];
    }
    
    
    //
    NSMutableArray *views = [NSMutableArray array];
    
    CGFloat width = CGRectGetWidth(self.scrollView.bounds)/self.itemInfoArray.count;
    CGSize   buttonSize=CGSizeMake(width, CGRectGetHeight(self.scrollView.bounds));
    for (int i = 0; i < _itemInfoArray.count; i++) {
        
        UIButton *itemView = [UIButton buttonWithImage:_itemInfoArray[i][kXBHMenuItemIcon] Text:_itemInfoArray[i][kXBHMenuItemTitle] TextFont:self.itemfont ButtonSize:buttonSize TISpace:6 ButtonMode:XBHUIButtonMode_LR_Center];
        [self.scrollView addSubview:itemView];
        itemView.tag = i;
        [itemView setTitleColor:_itemTitleColor forState:UIControlStateNormal];
        [views addObject:itemView];
        
        itemView.frame=CGRectMake(i*width, 0, buttonSize.width, buttonSize.height);
       
        [itemView addTarget:self action:@selector(itemViewTapAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    self.itemViewArray = [NSArray arrayWithArray:views];
    
    // indicator
    _indicatorView = [[UIView alloc]init];
    
    _indicatorView.backgroundColor = self.itemIndicatorColor;
    [_scrollView addSubview:_indicatorView];
    
  }


-(CGFloat)indicatorOrgX:(NSUInteger)index{

    if (index>self.itemViewArray.count) {
        return 0;
    }
    UIView *view=self.itemViewArray[index];
    return CGRectGetMinX(view.frame)+(CGRectGetWidth(view.frame)-kXBHIndicatorWidth)/2;

};

#pragma mark -- public

- (void)setIndicatorViewFrameWithRatio:(CGFloat)ratio isNextItem:(BOOL)isNextItem toIndex:(NSInteger)toIndex
{
    CGFloat indicatorX = 0.0;
    
    CGFloat orgx=0;
    CGFloat targetx=0;
  
    if (isNextItem) {
        orgx=[self indicatorOrgX:toIndex-1];
        targetx=[self indicatorOrgX:toIndex];
        
        indicatorX = orgx+(targetx-orgx) * ratio;
    } else {
         orgx=[self indicatorOrgX:toIndex+1];
         targetx=[self indicatorOrgX:toIndex];
        indicatorX = orgx+(targetx-orgx) *ratio;
    }
    _indicatorView.frame = CGRectMake(indicatorX, _scrollView.frame.size.height - kXBHIndicatorHeight, kXBHIndicatorWidth, kXBHIndicatorHeight);
    //  NSLog(@"retio : %f",_indicatorView.frame.origin.x);
}




-(void)adjustSelectionItem{ 
    
    for (int i = 0; i < self.itemViewArray.count; i++) {
        UIButton *button = self.itemViewArray[i];
        if (i == _selectonIndex) {
            [button setTitleColor:_itemSelectedTitleColor forState:UIControlStateNormal];
            
            [button setBackgroundImage:_itemSelectedBackgroundImage forState:UIControlStateNormal];
            
            
            //动画
#if 0
            button.alpha = 0.0;
            [UIView animateWithDuration:0.75
                                  delay:0.0
                                options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                             animations:^{
                                 button.alpha = 1.0;
                                 [button setTitleColor:_itemSelectedTitleColor forState:UIControlStateNormal];
                             } completion:^(BOOL finished) {
                             }];
#endif
        } else {
            [button setTitleColor:_itemTitleColor forState:UIControlStateNormal];
            [button setBackgroundImage:_itemNormalBackgroundImage forState:UIControlStateNormal];
        }
    }

}

- (void)setItemTextColor:(UIColor *)itemTextColor
    seletedItemTextColor:(UIColor *)selectedItemTextColor
            currentIndex:(NSInteger)currentIndex
{
    if (itemTextColor) { _itemTitleColor = itemTextColor; }
    if (selectedItemTextColor) { _itemSelectedTitleColor = selectedItemTextColor; }
    _selectonIndex=currentIndex;
    [self adjustSelectionItem];
}

#pragma mark -- private

// menu shadow
- (void)setShadowView
{
    UIView *view = [[UIView alloc]init];
    view.frame = CGRectMake(0, self.frame.size.height - 0.5, CGRectGetWidth(self.frame), 0.5);
    view.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:view];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect frame=self.bounds;
    frame.origin.x+=kXBHMenuViewContentOffsetX;
    frame.size.width=CGRectGetWidth(self.bounds)-2*kXBHMenuViewContentOffsetX;
    frame.size.height=kXBHMenuViewContentHeight;
    frame.origin.y=(CGRectGetHeight(self.bounds)-frame.size.height)/2;
    self.scrollView.frame=frame;
    self.scrollView.contentSize=self.scrollView.frame.size;
    
    
    
   [self itemButtonCreateAndLayout];
   [self adjustSelectionItem];
   
    _indicatorView.frame = CGRectMake([self indicatorOrgX:_selectonIndex], _scrollView.frame.size.height - kXBHIndicatorHeight, kXBHIndicatorWidth, kXBHIndicatorHeight);
    

    
    
   
}

#pragma mark -- Selector --------------------------------------- //
- (void)itemViewTapAction:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(scrollMenuViewSelectedIndex:)]) {
        [self.delegate scrollMenuViewSelectedIndex:sender.tag];
    }
}

@end
