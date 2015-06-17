//
//  XBHTIButton.m
//  gwEdu
//
//  Created by xubh-note on 14-6-30.
//  Copyright (c) 2014年 gwsoft. All rights reserved.
//

#import "XBHTIButton.h"
#import <UIImageView+AFNetworking.h>
#define SPACE       (6)


@interface XBHTIButton ()
@property   (nonatomic,assign)  id      mTarget;
@property   (nonatomic,assign)  SEL     mAction;
@end

@implementation XBHTIButton{
    UIImageView     *mImgView;
    UILabel         *mLabel;
    CGSize          imgSize;
    CGSize          textSize;
    XBHTIButtonMode mMode;
    UIImageView     *mFlgImageView;
}
@synthesize mTarget;
@synthesize mAction;
@synthesize mText;
@synthesize mIconView;
@synthesize mTextLabel;
@synthesize mbAdjustImageFrame;
@synthesize mITSpace;
@synthesize mFlgImg=_mFlgImg;

- (id)init
{
    return [self initWithMode:XBHTIButtonMode_LR];
}

- (id)initWithMode:(XBHTIButtonMode)mode
{
    self = [super init];
    if (self) {
        
        mMode=mode;
        
        mImgView=[[UIImageView alloc] init];
        [self addSubview:mImgView];
       
        self.mITSpace=SPACE;
        
        mLabel=[[UILabel alloc] init];
        mLabel.font=[UIFont systemFontOfSize:14];
       
        mLabel.backgroundColor=[UIColor clearColor];
        [self addSubview:mLabel];
        self.userInteractionEnabled=YES;
        self.backgroundColor=[UIColor clearColor];
        
        
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonTap)];
        [self addGestureRecognizer:tap];
        self.mbAdjustImageFrame=YES;
    }
    return self;
}

- (void)dealloc
{
    mImgView=nil;
    mLabel=nil;
    self.mFlgImg=nil;
}

-(void)addTarget:(id)target action:(SEL)action{
    self.mTarget=target;
    self.mAction=action;

}

-(void)setFont:(UIFont *)font TextColor:(UIColor *)color{
    mLabel.font=font;
    mLabel.textColor=color;
}

-(NSString *)mText{
    return mLabel.text;
}
-(UILabel *)mTextLabel{
    return mLabel;
}
-(UIImageView *)mIconView{
    return mImgView;
}
-(void)setMFlgImg:(UIImage *)mFlgImg{
   
    _mFlgImg=mFlgImg;
    if (_mFlgImg) {
        if (!mFlgImageView) {
            mFlgImageView= [[UIImageView alloc] init];
            mFlgImageView.backgroundColor=[UIColor clearColor];
            [self addSubview:mFlgImageView];
        }
        
         mFlgImageView.image=_mFlgImg;
        [self setNeedsLayout];
    }
}


-(CGSize)setIconUrlStr:(NSString *)urlStr DefaultImage:(UIImage *)img IconDrawSize:(CGSize)size Text:(NSString *)text Mode:(XBHTIButtonMode)mode {
    
    CGFloat h=0,w=0;
    CGFloat tW=0.0;
    [mImgView setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:img];
    mLabel.text=text;
    mMode=mode;
    if (text) {
        textSize=[text XBHStringSizeWithFont:mLabel.font];
        tW=textSize.width;
        w=tW;
        h=textSize.height;
    }
    imgSize=size;
    
    
    if (mode == XBHTIButtonMode_LR) {
        w=imgSize.width+tW+self.mITSpace;
        h=imgSize.height>textSize.height?imgSize.height:textSize.height;
    }
    else{
        w=tW>imgSize.width?tW:imgSize.width;
        h+=imgSize.height+self.mITSpace;
    }
        
    
    
    
    
    
    

    if (mMode == XBHTIButtonMode_LR) {
        mLabel.textAlignment=NSTextAlignmentLeft;
    }
    else{
        mLabel.textAlignment=NSTextAlignmentCenter;
    }
    
    
    
    
    [self setNeedsLayout];
    return CGSizeMake(w, h);


}


-(CGSize)setIconUrlStr:(NSString *)urlStr IconDrawSize:(CGSize)size Text:(NSString *)text Mode:(XBHTIButtonMode)mode {
    return [self setIconUrlStr:urlStr DefaultImage:nil IconDrawSize:size Text:text Mode:mode];
    
}



-(CGSize)setIcon:(UIImage *)icon  Text:(NSString *)text Mode:(XBHTIButtonMode)mode{
    
    return [self setIconUrlStr:nil DefaultImage:icon IconDrawSize:CGSizeMake(icon.size.width/2, icon.size.height/2) Text:text Mode:mode];
}



-(void)layoutSubviews{
    [super layoutSubviews];
    CGRect  frame=self.bounds;
    if (mMode==XBHTIButtonMode_UD) {
        if (self.mbAdjustImageFrame) {
            mImgView.frame=CGRectMake((frame.size.width-imgSize.width)/2,(CGRectGetHeight(self.bounds)-imgSize.height-self.mITSpace-textSize.height)/2, imgSize.width, imgSize.height);
        }
        else{
            
            
            mImgView.frame=CGRectMake((CGRectGetWidth(frame)-imgSize.width)/2,0, imgSize.width, imgSize.height);
           
        }
        mLabel.frame=CGRectMake(0, CGRectGetMaxY(mImgView.frame)+self.mITSpace, frame.size.width, textSize.height);
     
        if (mFlgImageView
            &&mFlgImageView.image) {
            mFlgImageView.frame=CGRectMake(CGRectGetMaxX(mImgView.frame)-mFlgImageView.image.size.width, CGRectGetMinY(mImgView.frame), mFlgImageView.image.size.width, mFlgImageView.image.size.height);
        }
        
        
    }
    else{
        
        if (mImgView.image) {
            
            mImgView.frame=CGRectMake(0,(frame.size.height - imgSize.height-self.mITSpace)/2, imgSize.width, imgSize.height);
            mLabel.frame=CGRectMake(mImgView.frame.origin.x+mImgView.frame.size.width+self.mITSpace , 0, frame.size.width-mImgView.frame.size.width-self.mITSpace-mImgView.frame.origin.x, frame.size.height);
        }
        else{
            mLabel.frame=CGRectMake(0 ,0, frame.size.width, frame.size.height);
        }
    }
    
}


-(void)buttonTap{
    if (self.mTarget
        &&self.mAction) {
        
        [self.mTarget performSelector:self.mAction withObject:self];
    }

}


@end
