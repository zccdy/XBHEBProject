//
//  XBHScrollMenuView.h
//  XBHContainerViewController
//
//  Created by yamaguchi on 2015/03/03.
//  Copyright (c) 2015年 h.yamaguchi. All rights reserved.
//

#import <UIKit/UIKit.h>



extern NSString   *const kXBHMenuItemTitle;
extern NSString   *const kXBHMenuItemIcon;



static const CGFloat kXBHScrollMenuViewHeight = 49;

static const CGFloat kXBHMenuViewContentOffsetX = 5;

static const CGFloat kXBHMenuViewContentHeight = kXBHScrollMenuViewHeight-14;





@protocol XBHScrollMenuViewDelegate <NSObject>

- (void)scrollMenuViewSelectedIndex:(NSInteger)index;

@end

@interface XBHScrollMenuView : UIView

@property (nonatomic, weak) id <XBHScrollMenuViewDelegate> delegate;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSArray *itemViewArray;
/**
 *  每一项字典结构  
 *  kXBHMenuItemTitle   --》item titile
 *  kXBHMenuItemIcon   --》item icon
 */
@property (nonatomic, strong) NSArray *itemInfoArray;

@property (nonatomic, strong) UIColor *viewbackgroudColor;
@property (nonatomic, strong) UIFont *itemfont;
@property (nonatomic, strong) UIColor *itemTitleColor;
@property (nonatomic, strong) UIColor *itemSelectedTitleColor;
@property (nonatomic, strong) UIColor *itemIndicatorColor;
@property (nonatomic, strong) UIImage *itemSelectedBackgroundImage;
@property (nonatomic, strong) UIImage *itemNormalBackgroundImage;


- (void)setShadowView;

- (void)setIndicatorViewFrameWithRatio:(CGFloat)ratio isNextItem:(BOOL)isNextItem toIndex:(NSInteger)toIndex;

- (void)setItemTextColor:(UIColor *)itemTextColor
    seletedItemTextColor:(UIColor *)selectedItemTextColor
            currentIndex:(NSInteger)currentIndex;
@end
