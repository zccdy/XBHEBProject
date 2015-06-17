//
//  fileListViewCell.h
//  gwEdu
//
//  Created by xu banghui on 14-1-8.
//  Copyright (c) 2014年 gwsoft. All rights reserved.
//

#import <UIKit/UIKit.h>


#define FILELISTVIEWCELL_RIGHTBT1_W          40

#define FILELISTVIEWCELL_RIGHTBT2_W          40

#define FILELISTVIEWCELL_RIGHTBT_H           CELL_ICON_HEIGHT

#define FILELISTVIEWCELL_PROTEXT_H          20    //进度描述文字的高度

#define FILELISTVIEWCELL_HEIGHT           (CELL_ICON_HEIGHT+FILELISTVIEWCELL_PROTEXT_H+8)

#define FILELISTVIEWCELL_RIGHTBT_COLOR      [UIColor blueColor]


@protocol fileListViewCellDelegate ;




@interface fileListViewCell : UITableViewCell

@property       (nonatomic,weak)             id<fileListViewCellDelegate> delegate;

@property       (nonatomic)             int64_t    mTargetId;

@property       (nonatomic,strong)      NSString    *mIconURL;
@property       (nonatomic,strong)      UIImage    *mDefaultIcon;
@property       (nonatomic,strong)      NSString   *mFirstText;
@property       (nonatomic,strong)      NSString   *mSecondText;

@property       (nonatomic,strong)      NSString   *mRightText1;
@property       (nonatomic,strong)      NSString   *mRightText2;
@property       (nonatomic)             BOOL        mbShowProgressBar;
@property       (nonatomic)             CGFloat     mProgress;


-(void)setCellProgress:(CGFloat)progress animated:(BOOL)animated;

@end


@protocol fileListViewCellDelegate <NSObject>

@optional
-(void)fileListViewCell:(fileListViewCell*)cell FirstButtonPressWithTargetId:(int64_t)targetId;

-(void)fileListViewCell:(fileListViewCell*)cell SecondButtonPressWithTargetId:(int64_t)targetId;

@end

