//
//  XBHKVView.m
//  gwEdu
//
//  Created by xubh-note on 15/2/6.
//  Copyright (c) 2015年 gwsoft. All rights reserved.
//

#import "XBHKVView.h"
#import "XBHUILabel.h"
@implementation XBHKVView
{
    UILabel *_titleLabel;
    XBHUILabel *_IntroLabel;


}


@synthesize mbIsPhone=_mbIsPhone;
@synthesize delegate;

-(instancetype)init{
    return [self initWithFrame:CGRectZero];
}


-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _titleLabel=[[UILabel alloc] init] ;
        _titleLabel.backgroundColor=[UIColor clearColor];
        _titleLabel.font=XBHKVView_TitleFont;
        _titleLabel.textAlignment=NSTextAlignmentLeft;
        
        
        _IntroLabel=[[XBHUILabel alloc] init];
        _IntroLabel.backgroundColor=[UIColor clearColor];
        _IntroLabel.numberOfLines=0;
        _IntroLabel.font=XBHKVView_IntroFont;
        _IntroLabel.textAlignment=NSTextAlignmentLeft;
        _IntroLabel.userInteractionEnabled=YES;
        
        [self addSubview:_titleLabel];
        [self addSubview:_IntroLabel];
        
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(introLabelDidTap)];
        [_IntroLabel addGestureRecognizer:tap];
    }
    return self;
}
-(void)setMbIsPhone:(BOOL)mbIsPhone{
    _mbIsPhone=mbIsPhone;
    if (_mbIsPhone) {
        _IntroLabel.textColor=XBHMakeRGB(39, 135, 234);
        _IntroLabel.verticalAlignment=XBHVerticalAlignmentMiddle;
    }
    else{
        _IntroLabel.verticalAlignment=XBHVerticalAlignmentTop;
        _IntroLabel.textColor=XBHMakeRGB(148, 148, 148);
    }

}
-(UILabel *)mTitleLabel{
    return _titleLabel;
}
-(UILabel *)mTextContentLabel{
    return _IntroLabel;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    if (CGRectEqualToRect(self.bounds, CGRectZero)) {
        return;
    }
    
    CGFloat y=XBHKVView_OffsetY;
    
    if (self.mbIsPhone) {
        _titleLabel.frame=CGRectMake(XBHKVView_OffsetX, 0, XBHKVView_TitleW, CGRectGetHeight(self.bounds));
       
        _IntroLabel.frame=CGRectMake(CGRectGetMaxX(_titleLabel.frame)+XBHKVView_Space, 0, XBHKVView_IntroMaxW(self.bounds.size.width), CGRectGetHeight(self.bounds));
    }
    else{
        _titleLabel.frame=CGRectMake(XBHKVView_OffsetX, y, XBHKVView_TitleW,XBHKVView_TitleFont.lineHeight);
        
        
        _IntroLabel.frame=CGRectMake(CGRectGetMaxX(_titleLabel.frame)+XBHKVView_Space, y, XBHKVView_IntroMaxW(self.bounds.size.width), CGRectGetHeight(self.bounds)-XBHKVView_OffsetY*2);
    }
  
}



-(void)introLabelDidTap{
    if (!self.mbIsPhone) {
        return;
    }
    if ([delegate respondsToSelector:@selector(XBHKVViewPhoneNumberDidTap:)]) {
        [delegate XBHKVViewPhoneNumberDidTap:_IntroLabel.text];
    }

}

@end
