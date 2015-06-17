//
//  ShareEditViewController.h
//  XBHEBProject
//
//  Created by xubh-note on 15/5/4.
//  Copyright (c) 2015年 xu banghui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareEditViewController : UITableViewController


@property  (nonatomic,assign)           UInt64              fileSize;

@property  (nonatomic,strong)           NSString            *fileName;

@property  (nonatomic,strong)           NSString            *uploadDate;
@end
