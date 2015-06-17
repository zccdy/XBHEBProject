//
//  TransferStatusView.h
//  gwEdu
//
//  Created by xubh-note on 14-6-23.
//  Copyright (c) 2014年 gwsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransferStatusView : UIView

@property       (nonatomic,retain)  UIImage *   mCenterImage;

@property       (nonatomic,retain)  UIColor *   mCircularBackColor;

@property       (nonatomic,retain)  UIColor *   mCircularColor;

@property       (nonatomic)         CGFloat     mCircularWidth;

@property       (nonatomic)         CGFloat     mProgress;

-(void)noProgress;

@end
