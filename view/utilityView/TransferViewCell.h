//
//  TransferViewCell.h
//  gwEdu
//
//  Created by xubh-note on 14-6-20.
//  Copyright (c) 2014年 gwsoft. All rights reserved.
//

#import <UIKit/UIKit.h>




@protocol TransferViewCellDelegate;


@interface TransferViewCell : UITableViewCell


@property       (nonatomic,weak)    id<TransferViewCellDelegate> delegate;
@property       (nonatomic)     NSUInteger  mStatus;
@property       (nonatomic)     CGSize      mStatusViewSize;
@property       (nonatomic)     CGSize      mStatusViewHandleSize;

@property       (nonatomic)     CGFloat     mProgress;
@property       (nonatomic)     long long   mDataId;
@property       (nonatomic)     NSUInteger  mDataType;
@property       (nonatomic,strong)  NSString    *mFilePath;
@property       (nonatomic,strong,readonly)     UIView         *mRightView;
@property       (nonatomic)     BOOL          misShowShareButton;

-(void)removeSubView;
-(void)resetText;

-(void)setIcon:(UIImage *)img;
-(void)setIcon:(UIImage *)img imageURL:(NSString *)urlstr;

-(void)setFirstText:(NSString *)text TextColor:(UIColor *)color TextFont:(UIFont *)font;
-(void)setSecondText:(NSString *)text TextColor:(UIColor *)color TextFont:(UIFont *)font;

-(void)setProgress:(CGFloat)progress animated:(BOOL)animated;

@end



@protocol TransferViewCellDelegate <NSObject>

@optional


-(void)TransferViewCellStatusViewDidSelecte:(TransferViewCell*)cell;

-(void)TransferViewCellShareDidSelecte:(TransferViewCell*)cell;




@end