//
//  XBHEidtTextViewCell.h
//  XBHEBProject
//
//  Created by xubh-note on 15/5/13.
//  Copyright (c) 2015年 xu banghui. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol XBHEidtTextViewCellDelegate;

@interface XBHEidtTextViewCell : UITableViewCell

@property (nonatomic,weak)      id<XBHEidtTextViewCellDelegate>    delegate;
@property (nonatomic, strong, readonly) NSString *placeholderStr;
@property (nonatomic,assign)        int                 minHeight;
@end



@protocol XBHEidtTextViewCellDelegate <NSObject>

@optional

-(void)XBHEidtTextViewCell:(XBHEidtTextViewCell *)cell WillChangeHeight:(CGFloat)height;
@end