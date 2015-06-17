//
//  XBHTIButton.h
//  gwEdu
//
//  Created by xubh-note on 14-6-30.
//  Copyright (c) 2014年 gwsoft. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef  NS_ENUM(NSUInteger, XBHTIButtonMode){

    XBHTIButtonMode_UD=0, //上下结构
    XBHTIButtonMode_LR  //左右结构

};



@interface XBHTIButton : UIView


@property   (nonatomic,strong,readonly)    UIImageView     *mIconView;

@property   (nonatomic,strong,readonly)    NSString    *mText;

@property   (nonatomic,strong,readonly)    UILabel     *mTextLabel;

//自动判断图片的显示区域 (根据图片的大小来显示)
@property   (nonatomic)             BOOL        mbAdjustImageFrame;

@property   (nonatomic)             CGFloat         mITSpace;//文字和图片距离

@property   (nonatomic,strong)       UIImage             *mFlgImg;


- (id)initWithMode:(XBHTIButtonMode)mode;



-(void)setFont:(UIFont *)font TextColor:(UIColor *)color;
-(void)addTarget:(id)target action:(SEL)action;

-(CGSize)setIcon:(UIImage *)icon  Text:(NSString *)text Mode:(XBHTIButtonMode)mode;

-(CGSize)setIconUrlStr:(NSString *)urlStr IconDrawSize:(CGSize)size Text:(NSString *)text Mode:(XBHTIButtonMode)mode ;

-(CGSize)setIconUrlStr:(NSString *)urlStr DefaultImage:(UIImage *)img IconDrawSize:(CGSize)size Text:(NSString *)text Mode:(XBHTIButtonMode)mode ;
@end
