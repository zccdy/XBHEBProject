//
//  fileListViewCell.m
//  gwEdu
//
//  Created by xu banghui on 14-1-8.
//  Copyright (c) 2014年 gwsoft. All rights reserved.
//

#import "fileListViewCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
@implementation fileListViewCell
{
    UIImageView           *mIconView;
    UILabel               *mFirstTextLabel;
    UILabel               *mSecondTextLabel;
    UIButton              *mRightBt1;
    UIButton              *mRightBt2;
    UIProgressView        *mProgressView;
    UILabel               *mProgressLabel;//进度描述 (显示进度的百分之几)
}


@synthesize mIconURL;
@synthesize mDefaultIcon;
@synthesize mFirstText=_mFirstText;
@synthesize mSecondText=_mSecondText;
@synthesize mbShowProgressBar=_mbShowProgressBar;
@synthesize mProgress=_mProgress;
@synthesize mRightText1=_mRightText1;
@synthesize mRightText2=_mRightText2;
@synthesize mTargetId;
@synthesize delegate;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        mIconView=[[UIImageView alloc] init];
        mIconView.userInteractionEnabled=YES;
        
        
        
        mFirstTextLabel=[[UILabel alloc] init];
        mFirstTextLabel.textAlignment=NSTextAlignmentLeft;
        mFirstTextLabel.lineBreakMode=NSLineBreakByWordWrapping;
        mFirstTextLabel.textColor=CELL_TEXT1_COLOR;
        mFirstTextLabel.font=CELL_FIRST_LINE_FONT;
        mFirstTextLabel.backgroundColor=[UIColor clearColor];
        
        
        mSecondTextLabel=[[UILabel alloc] init];
        mSecondTextLabel.textAlignment=NSTextAlignmentLeft;
        mSecondTextLabel.lineBreakMode=NSLineBreakByWordWrapping;
        mSecondTextLabel.textColor=CELL_TEXT2_COLOR;
        mSecondTextLabel.font=CELL_SECOND_LINE_FONT;
        mSecondTextLabel.backgroundColor=[UIColor clearColor];
        
        
        mRightBt1=[UIButton buttonWithType:UIButtonTypeCustom];
        [mRightBt1 addTarget:self action:@selector(button1Press) forControlEvents:UIControlEventTouchUpInside];
        mRightBt1.titleLabel.font=[UIFont systemFontOfSize:12];
       // mRightBt1.backgroundColor=[UIColor redColor];
        
        mRightBt2=[UIButton buttonWithType:UIButtonTypeCustom];
        [mRightBt2 addTarget:self action:@selector(button2Press) forControlEvents:UIControlEventTouchUpInside];
        mRightBt2.titleLabel.font=[UIFont systemFontOfSize:12];
       // mRightBt2.backgroundColor=[UIColor redColor];
        
        [self.contentView addSubview:mIconView];
        [self.contentView addSubview:mFirstTextLabel];
        [self.contentView addSubview:mSecondTextLabel];
        [self.contentView addSubview:mRightBt1];
        [self.contentView addSubview:mRightBt2];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


-(void)setMFirstText:(NSString *)mFirstText{
  
    _mFirstText=mFirstText ;
    [self setNeedsDisplay];
}

-(void)setMSecondText:(NSString *)mSecondText{
    
    _mSecondText=mSecondText ;
    [self setNeedsDisplay];
}

-(void)setMbShowProgressBar:(BOOL)mbShowProgressBar{
    _mbShowProgressBar=mbShowProgressBar;
    if (mbShowProgressBar) {
        if (!mProgressView) {
            mProgressView=[[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
            mProgressView.trackTintColor=[UIColor whiteColor];
            mProgressView.progressTintColor=[UIColor blueColor];
            [self addSubview:mProgressView];
        }
        if (!mProgressLabel) {
            mProgressLabel=[[UILabel alloc] init];
            mProgressLabel.font=[UIFont systemFontOfSize:12];
            [self addSubview:mProgressLabel];
        }
       
    }
    else if(!mbShowProgressBar){
        if (mProgressView) {
            [mProgressView removeFromSuperview];
            mProgressView=nil;
        }
        if (mProgressLabel) {
            [mProgressLabel removeFromSuperview];
            mProgressLabel=nil;
        }
    }
    [self setNeedsDisplay];
}
-(void)setMProgress:(CGFloat)mProgress{
    _mProgress=mProgress;
    if (_mbShowProgressBar) {
        if (mProgressView) {
            mProgressView.progress=_mProgress;
            
            //[mProgressView setProgress:_mProgress animated:YES];
        }
        [self setNeedsDisplay];
    }
}

-(void)setCellProgress:(CGFloat)progress animated:(BOOL)animated{
    _mProgress=progress;
    if (_mbShowProgressBar) {
        if (mProgressView) {
            [mProgressView setProgress:_mProgress animated:YES];
        }
        [self setNeedsDisplay];
    }

}




-(void)setMRightText1:(NSString *)mRightText1{
    _mRightText1=mRightText1;
    if (mRightText1) {
        [mRightBt1 setTitle:mRightText1 forState:UIControlStateNormal];
        [mRightBt1 setTitleColor:FILELISTVIEWCELL_RIGHTBT_COLOR forState:UIControlStateNormal];
         [self setNeedsDisplay];
    }
    
}
-(void)setMRightText2:(NSString *)mRightText2{
   
    _mRightText2=mRightText2;
    if (mRightText2) {
        [mRightBt2 setTitle:mRightText2 forState:UIControlStateNormal];
        [mRightBt2 setTitleColor:FILELISTVIEWCELL_RIGHTBT_COLOR forState:UIControlStateNormal];
         [self setNeedsDisplay];
    }
}


-(void)drawHeadIconAndText{
    CGRect    rect;
    if (_mbShowProgressBar) {
        rect= CGRectMake(CELL_ICON_OFFSET, (CGRectGetHeight(self.bounds)-CELL_ICON_HEIGHT-FILELISTVIEWCELL_PROTEXT_H-4)/2, CELL_ICON_WIDTH, CELL_ICON_HEIGHT);//4pt->进度条与头像的垂直间距
    }
    else{
        rect=CGRectMake(CELL_ICON_OFFSET, (CGRectGetHeight(self.bounds)-CELL_ICON_HEIGHT)/2, CELL_ICON_WIDTH, CELL_ICON_HEIGHT);
    }
       
    
    mIconView.frame=rect;
    [mIconView setImageWithURL:[NSURL URLWithString:self.mIconURL] placeholderImage:self.mDefaultIcon];
    CGFloat    textLabelHeight=CGRectGetHeight(mIconView.frame)/2;
    CGFloat    textLabelWidth=40;
    CGFloat    textMaxWidth=(CGRectGetWidth(self.bounds)-CGRectGetWidth(mIconView.frame)-CELL_ICON_OFFSET-CELL_TEXT_OFFSET-10);
    if (self.mFirstText
        &&[self.mFirstText length]) {
        CGSize  size=[self.mFirstText XBHStringSizeWithFont:CELL_FIRST_LINE_FONT];
        textLabelWidth=size.width+10;
        if (textLabelWidth>textMaxWidth) {
            textLabelWidth=textMaxWidth;
        }
    }
    rect.origin.x+=mIconView.frame.size.width+CELL_TEXT_OFFSET;
    rect.origin.y=mIconView.frame.origin.y;
    rect.size.width=textLabelWidth;
    rect.size.height=textLabelHeight;
    
    mFirstTextLabel.frame=rect;
    mFirstTextLabel.text=self.mFirstText;
    
    textLabelWidth=40;
    if (self.mSecondText
        &&[self.mSecondText length]) {
        CGSize  size=[self.mSecondText XBHStringSizeWithFont:CELL_SECOND_LINE_FONT];
        textLabelWidth=size.width+10;
        if (textLabelWidth>textMaxWidth) {
            textLabelWidth=textMaxWidth;
        }
    }
    rect.origin.y+=rect.size.height;
    rect.size.width=textLabelWidth;
    mSecondTextLabel.frame=rect;
    mSecondTextLabel.text=self.mSecondText;
    
    if (_mbShowProgressBar) {
        CGFloat  progressW=CGRectGetWidth(self.bounds)*4/5;
        CGFloat  proY=mIconView.frame.origin.y+mIconView.frame.size.height+(CGRectGetHeight(self.bounds)- mIconView.frame.origin.y-mIconView.frame.size.height-9)/2;//9 为progressW的高度
        CGRect frame=CGRectMake(CELL_ICON_OFFSET,proY, progressW, 9);
        mProgressView.frame=frame;
        mProgressView.progress=self.mProgress;

        //进度文字描述
        CGFloat  proTextY=mIconView.frame.origin.y+mIconView.frame.size.height+(CGRectGetHeight(self.bounds)- mIconView.frame.origin.y-mIconView.frame.size.height-FILELISTVIEWCELL_PROTEXT_H)/2;
        frame.origin.x=mProgressView.frame.origin.x+mProgressView.frame.size.width;
        frame.origin.y=proTextY;
        frame.size.width=CGRectGetWidth(self.bounds)-frame.origin.x-10;//10为 与右边缘的距离
        frame.size.height=FILELISTVIEWCELL_PROTEXT_H;
        mProgressLabel.frame=frame;
        mProgressLabel.text=[NSString stringWithFormat:@"%d %%",(uint32_t)(self.mProgress*100)];
        mProgressLabel.textAlignment=NSTextAlignmentCenter;
    }
    
}

-(void)drawRightButton{
    CGFloat rightSpace=2;//与右边缘距离
    CGFloat space=4;//两button间距离
    mRightBt1.hidden=NO;
    mRightBt2.hidden=NO;
    if ([self.mRightText1 length]
        &&[self.mRightText2 length]) {
        
        CGRect rect=CGRectMake(CGRectGetWidth(self.bounds)-rightSpace-space-FILELISTVIEWCELL_RIGHTBT1_W-FILELISTVIEWCELL_RIGHTBT2_W, (CGRectGetHeight(self.bounds)-FILELISTVIEWCELL_RIGHTBT_H)/2+4, FILELISTVIEWCELL_RIGHTBT1_W, FILELISTVIEWCELL_RIGHTBT_H);
        mRightBt1.frame=rect;
        
        rect.origin.x+=mRightBt1.frame.size.width+space;
        rect.size.width=FILELISTVIEWCELL_RIGHTBT2_W;
        mRightBt2.frame=rect;
    }
    else if ([self.mRightText1 length]){ //只有一个
        mRightBt2.hidden=YES;
         CGRect rect=CGRectMake(CGRectGetWidth(self.bounds)-rightSpace-FILELISTVIEWCELL_RIGHTBT1_W, (CGRectGetHeight(self.bounds)-FILELISTVIEWCELL_RIGHTBT_H)/2+4, FILELISTVIEWCELL_RIGHTBT1_W, FILELISTVIEWCELL_RIGHTBT_H);
         mRightBt1.frame=rect;
    }
    
}


-(void)drawRect:(CGRect)rect{
    
    [self drawHeadIconAndText];
    
    //右边button
    [self drawRightButton];
   
    
}





-(void)button1Press{
    if ([delegate respondsToSelector:@selector(fileListViewCell:FirstButtonPressWithTargetId:)]) {
        [delegate fileListViewCell:self FirstButtonPressWithTargetId:mTargetId];
    }
    
}
-(void)button2Press{
    if ([delegate respondsToSelector:@selector(fileListViewCell:SecondButtonPressWithTargetId:)]) {
        [delegate fileListViewCell:self SecondButtonPressWithTargetId:mTargetId];
    }
}


@end
