//
//  TransferViewCell.m
//  gwEdu
//
//  Created by xubh-note on 14-6-20.
//  Copyright (c) 2014年 gwsoft. All rights reserved.
//

#import "TransferViewCell.h"
#import "TransferStatusView.h"
#import "XBHDownloadManager.h"
#import "XBHUploadManager.h"
#import <UIImageView+AFNetworking.h>
@interface TransferViewCell ()

@property   (nonatomic,weak)      id mTarget;
@property   (nonatomic)      SEL mAction;
@end

#define CenterImgWH         (18)

#define CircularWidth       (2)

#define ShareButtonWidth    (30)

#define ShareButtonHeight    (44)


@implementation TransferViewCell
{
    UILabel      *mFirstTextLabel;
    UILabel      *mSecondTextLabel;
    UIView       *mHandlerView;
    TransferStatusView  *mStatusView;
    UIImageView      *mStatusImageView;
    UIImageView     *mIconView;
    
    UIButton        *mShareBt;
}
@synthesize mStatusViewSize;
@synthesize mStatus=_mStatus;
@synthesize mProgress=_mProgress;
@synthesize mDataId;
@synthesize mDataType;
@synthesize mTarget;
@synthesize mAction;
@synthesize mFilePath;
@synthesize mStatusViewHandleSize;
@synthesize misShowShareButton=_misShowShareButton;
- (void)dealloc
{
    self.mFilePath=nil;

}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        mFirstTextLabel=[[UILabel alloc] init];
        mFirstTextLabel.textAlignment=NSTextAlignmentLeft;
       // mFirstTextLabel.lineBreakMode=NSLineBreakByWordWrapping;
        mFirstTextLabel.textColor=[UIColor blackColor];
        mFirstTextLabel.font=[UIFont boldSystemFontOfSize:14];
        mFirstTextLabel.backgroundColor=[UIColor clearColor];
        
        
        mSecondTextLabel=[[UILabel alloc] init];
        mSecondTextLabel.textAlignment=NSTextAlignmentLeft;

      //  mSecondTextLabel.lineBreakMode=NSLineBreakByWordWrapping;
        mSecondTextLabel.textColor=[UIColor blackColor];
        mSecondTextLabel.font=[UIFont systemFontOfSize:14];
        mSecondTextLabel.backgroundColor=[UIColor clearColor];
        
        mStatusImageView=[[UIImageView alloc] init];

        
        mStatusView=[[TransferStatusView alloc] init];
        
        mHandlerView=[[UIView alloc] init];
        mHandlerView.userInteractionEnabled=YES;
        mHandlerView.opaque=NO;
        
        [self.contentView   addSubview:mHandlerView];
        [self.contentView addSubview:mFirstTextLabel];
        [self.contentView addSubview:mSecondTextLabel];
        [mHandlerView addSubview:mStatusImageView];
        [mHandlerView addSubview:mStatusView];
        
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap)];
        [mHandlerView addGestureRecognizer:tap];
    
        self.mStatusViewSize=CGSizeMake(20, 20);
        self.mStatusViewHandleSize=CGSizeMake(25, 25);
        
        
        mShareBt =[UIButton buttonWithType:UIButtonTypeCustom];
        mShareBt.opaque=NO;
        [mShareBt setTitle:@"分享" forState:UIControlStateNormal];
        [mShareBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        mShareBt.titleLabel.font=[UIFont systemFontOfSize:15];
        [mShareBt addTarget:self action:@selector(shareButtonPress) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:mShareBt];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)resetText{
     mFirstTextLabel.text=nil;
     mSecondTextLabel.text=nil;
}

-(void)removeSubView{
    [mHandlerView removeFromSuperview];
    [mFirstTextLabel removeFromSuperview];
    
    [mSecondTextLabel removeFromSuperview];


}
-(UIView *)mRightView{
    return mHandlerView;
}
-(void)setIcon:(UIImage *)img{
    [self setIcon:img imageURL:nil];
}

-(void)setMisShowShareButton:(BOOL)misShowShareButton{

    _misShowShareButton=misShowShareButton;
    mShareBt.hidden=!_misShowShareButton;

}


-(void)setIcon:(UIImage *)img imageURL:(NSString *)urlstr{
    if (!mIconView) {
        mIconView=[[UIImageView alloc] init];
        mIconView.layer.masksToBounds=YES;
        mIconView.layer.cornerRadius=XBHCornerRadius;
        [self.contentView addSubview:mIconView];
    }
    if (urlstr) {
        [mIconView setImageWithURL:[NSURL URLWithString:urlstr] placeholderImage:img];
    }
    else{
        mIconView.image=img;
    }
}

-(void)setFirstText:(NSString *)text TextColor:(UIColor *)color TextFont:(UIFont *)font{
    mFirstTextLabel.text=text;
    mFirstTextLabel.textColor=color;
    mFirstTextLabel.font=font;
}

-(void)setSecondText:(NSString *)text TextColor:(UIColor *)color TextFont:(UIFont *)font{
    mSecondTextLabel.text=text;
    mSecondTextLabel.textColor=color;
    mSecondTextLabel.font=font;
}


-(void)setMStatus:(NSUInteger)mStatus{
    _mStatus = mStatus;
    mStatusView.hidden=NO;
    if (XBHDownloadStatus_DownloadCompelete == mStatus
        ||XBHDownloadStatus_DownloadFailure == mStatus
        ||XBHUploadStatus_UploadCompelete == mStatus
        ||XBHUploadStatus_UploadFailure == mStatus) {
        [mStatusView noProgress];
    }
    else if (XBHDownloadStatus_Delete == mStatus
             ||XBHUploadStatus_Delete == mStatus){
        mStatusView.hidden=YES;
    
    }
    [self statusBackgroundImg];
}
-(void)setMProgress:(CGFloat)mProgress{
    _mProgress=mProgress;
    
    mStatusView.mProgress=mProgress;
}


-(void)setProgress:(CGFloat)progress animated:(BOOL)animated{

    _mProgress=progress;
    if (animated) {
        [UIView animateWithDuration:0.2 animations:^{
            mStatusView.mProgress=progress;
        }];
    }
}
-(void)addStatusViewHandle:(id)target action:(SEL)act{
    self.mTarget=target;
    self.mAction=act;
}


-(void)statusBackgroundImg{
    //下载相关状态
    if (self.mStatus == XBHDownloadStatus_None) {
        mStatusImageView.image=XBHHomeBundleImageWithName(@"downloadNone");
    }
    else if (self.mStatus == XBHDownloadStatus_DownloadWate){
        mStatusImageView.image=XBHHomeBundleImageWithName(@"downloadWate");
    }
    else if (self.mStatus == XBHDownloadStatus_Downloading){
        mStatusImageView.image=XBHHomeBundleImageWithName(@"downloadPause");
    }
    else if (self.mStatus == XBHDownloadStatus_DownloadPause_ByUser
             || self.mStatus == XBHDownloadStatus_DownloadPause_ByApp ){
        mStatusImageView.image=XBHHomeBundleImageWithName(@"downloadNone");
    }
    else if (self.mStatus == XBHDownloadStatus_DownloadCompelete){
        mStatusImageView.image=XBHHomeBundleImageWithName(@"downloadCompelete");
    }
    else if (self.mStatus == XBHDownloadStatus_DownloadFailure){
        mStatusImageView.image=XBHHomeBundleImageWithName(@"downloadNone");
    }
    else if (self.mStatus == XBHDownloadStatus_Delete){
        mStatusImageView.image=XBHHomeBundleImageWithName(@"delete_ico");
    }
    //上传相关状态
    else if (self.mStatus == XBHUploadStatus_None) {
        mStatusImageView.image=XBHHomeBundleImageWithName(@"downloadNone");
    }
    else if (self.mStatus == XBHUploadStatus_UploadWate){
        mStatusImageView.image=XBHHomeBundleImageWithName(@"downloadWate");
    }
    else if (self.mStatus == XBHUploadStatus_Uploading){
        mStatusImageView.image=XBHHomeBundleImageWithName(@"downloadPause");
    }
    else if (self.mStatus == XBHUploadStatus_UploadPause_ByUser
             || self.mStatus == XBHUploadStatus_UploadPause_ByApp ){
        mStatusImageView.image=XBHHomeBundleImageWithName(@"downloadNone");
    }
    else if (self.mStatus == XBHUploadStatus_UploadCompelete){
        mStatusImageView.image=XBHHomeBundleImageWithName(@"downloadCompelete");
    }
    else if (self.mStatus == XBHUploadStatus_UploadFailure){
        mStatusImageView.image=XBHHomeBundleImageWithName(@"delete_ico");
    }
    else if (self.mStatus == XBHUploadStatus_Delete){
        mStatusImageView.image=XBHHomeBundleImageWithName(@"delete_ico");
    }

}

-(void)layoutSubviews{
    [super layoutSubviews];
    CGFloat     offsetX=11.0;
    CGFloat     bounderY=10.0;//与上下边的距离
    CGRect      frame=self.bounds;
    
    CGFloat     space=8;
    
    if (mIconView) {
        mIconView.frame=CGRectMake(offsetX, (CGRectGetHeight(self.bounds)-CELL_ICON_HEIGHT)/2, CELL_ICON_WIDTH, CELL_ICON_HEIGHT);
        frame.origin.x=CGRectGetMaxX(mIconView.frame)+CELL_TEXT_OFFSET;
        frame.origin.y=CGRectGetMinY(mIconView.frame);
        frame.size.height=CGRectGetHeight(mIconView.frame)/2;
        frame.size.width-=2*offsetX+mStatusViewSize.width+CGRectGetMaxX(mIconView.frame);
    }
    else{
        frame.origin.x=offsetX;
        frame.origin.y=bounderY;
        frame.size.height=(frame.size.height-2*bounderY)/2;
        frame.size.width-=2*offsetX+mStatusViewSize.width;
    }
    
    if (!mShareBt.hidden) {
        frame.size.width-=ShareButtonWidth+space;
    }
    
    
    
    mFirstTextLabel.frame=frame;
    
    frame.origin.y+=frame.size.height;
    mSecondTextLabel.frame=frame;
    
    
    
    [self statusBackgroundImg];
    
    
    mHandlerView.frame=CGRectMake(self.bounds.size.width-self.mStatusViewHandleSize.width-offsetX, (self.bounds.size.height-self.mStatusViewHandleSize.height)/2, self.mStatusViewHandleSize.width, self.mStatusViewHandleSize.height);
    
    if (!mShareBt.hidden) {
        mShareBt.frame=CGRectMake(CGRectGetMinX(mHandlerView.frame)-space-ShareButtonWidth, (self.bounds.size.height-ShareButtonHeight)/2, ShareButtonWidth, ShareButtonHeight);
        

    }
    
    mStatusView.frame=CGRectMake(CGRectGetWidth(mHandlerView.frame)-self.mStatusViewSize.width, (CGRectGetHeight(mHandlerView.frame)-self.mStatusViewSize.height)/2, self.mStatusViewSize.width, self.mStatusViewSize.height);
    mStatusView.mCircularWidth=CircularWidth;
    
    mStatusImageView.frame=CGRectMake(CGRectGetMinX(mStatusView.frame)+(CGRectGetWidth(mStatusView.frame)-mStatusImageView.image.size.width)/2,
            CGRectGetMinY(mStatusView.frame)+(CGRectGetHeight(mStatusView.frame)-mStatusImageView.image.size.height)/2,
            mStatusImageView.image.size.width,
                                      
            mStatusImageView.image.size.height);
    
    
}


-(void)didTap{
    if ([self.delegate respondsToSelector:@selector(TransferViewCellStatusViewDidSelecte:)]) {
        [self.delegate TransferViewCellStatusViewDidSelecte:self];
    }


}

-(void)shareButtonPress{

    if ([self.delegate respondsToSelector:@selector(TransferViewCellShareDidSelecte:)]) {
        [self.delegate TransferViewCellShareDidSelecte:self];
    }


}

@end
