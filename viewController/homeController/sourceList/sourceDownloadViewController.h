//
//  sourceDownloadViewController.h
//  gwEdu
//
//  Created by xubh-note on 14-6-20.
//  Copyright (c) 2014年 gwsoft. All rights reserved.
//
#import "XBHBaseTableViewController.h"



@interface sourceDownloadViewController : XBHBaseTableViewController

@property   (nonatomic,retain)  NSString    *mTitleName;

//是否具有滑动删除功能(左右滑动)
@property   (nonatomic)         BOOL        mbSwipeDelete;


@property   (nonatomic)         BOOL        mbIsDismiss;

//批量操作   全选、删除
@property   (nonatomic)         BOOL        mbIsMutilOperate;


@end
