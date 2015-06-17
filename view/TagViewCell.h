//
//  TagViewCell.h
//  XBHEBProject
//
//  Created by xubh-note on 15/4/26.
//  Copyright (c) 2015年 xu banghui. All rights reserved.
//

#import <UIKit/UIKit.h>



#define TagViewCell_TagitemHeight           (22.5)

#define TagViewCell_TagitemHeight_WithDelete           (TagViewCell_TagitemHeight+12)

#define TagViewCell_OffsetX             (11.5)

#define TagViewCell_OffsetY             (10)

#define TagViewCell_TagItemSpaceX         (11.5)

#define TagViewCell_TagItemSpaceY         (11.5)

#define TagViewCell_TitleFont            [UIFont systemFontOfSize:12.5]


@protocol TagViewCellDelegate ;


@interface TagViewCell : UITableViewCell


@property       (nonatomic,weak)        id<TagViewCellDelegate> delegate;

+(NSMutableArray *)tagDictArrayWithTitleArray:(NSArray *)tagTitleArray layoutWidth:(CGFloat)maxWidth needHeight:(CGFloat *)height editable:(BOOL)edit;

/**
 *  设置显示的标签列表
 *
 *  @param tagTitleArray 标签名称
 *  @param maxWidth      最大显示宽度
 *
 *  
 */
-(void)setTagsTitle:(NSArray *)tagTitleArray layoutWidth:(CGFloat)maxWidth;


-(void)setTagsTitle:(NSArray *)tagTitleArray layoutWidth:(CGFloat)maxWidth editable:(BOOL)edit;
@end




@protocol TagViewCellDelegate <NSObject>

@optional
-(void)TagViewCell:(TagViewCell*)cell DidSelectString:(NSString *)str editable:(BOOL)edit;
@end
