//
//  DocTypeViewCell.h
//  XBHEBProject
//
//  Created by xubh-note on 15/5/18.
//  Copyright (c) 2015年 xu banghui. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DocTypeViewCell_IconSize            CGSizeMake(80, 80)

#define DocTypeViewCell_IconTextSpace           (0)

#define DocTypeViewCell_TextLabelH           (20)

#define DocTypeViewCellHeight   (DocTypeViewCell_IconSize.height+DocTypeViewCell_IconTextSpace+DocTypeViewCell_TextLabelH)

@interface DocTypeViewCellInfo : NSObject

@property   (nonatomic,strong)      NSString        *mIconURL;

@property   (nonatomic,strong)      UIImage         *mDefaultIcon;

@property   (nonatomic,strong)      NSString        *mTitle;

@property   (nonatomic,assign)      NSInteger       mIndex;

@end




@protocol DocTypeViewCellDelegate ;

#pragma  mark -


@interface DocTypeViewCell : UITableViewCell
@property   (nonatomic,weak)    id<DocTypeViewCellDelegate> delegate;

-(void)setInfoArray:(NSArray *)infos;
@end




@protocol DocTypeViewCellDelegate <NSObject>

@optional

-(void)DocTypeViewCell:(DocTypeViewCell *)cell didSelectionIndex:(NSInteger)index title:(NSString *)title;
@end
