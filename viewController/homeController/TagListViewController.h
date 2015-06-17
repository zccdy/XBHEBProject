//
//  TagListViewController.h
//  XBHEBProject
//
//  Created by xubh-note on 15/5/18.
//  Copyright (c) 2015年 xu banghui. All rights reserved.
//

#import "XBHBaseTableViewController.h"


@protocol TagListViewControllerDelegate <NSObject>

@optional

-(void)TagListViewControllerDidSeletionTitles:(NSArray *)titles;

@end



@interface TagListViewController : UITableViewController


@property   (nonatomic,weak)    id<TagListViewControllerDelegate>  delegate;

@property   (nonatomic,strong)      NSString                    *mTagString;

@property   (nonatomic,strong)       NSMutableArray             *aleardySelecteTags;
@end
