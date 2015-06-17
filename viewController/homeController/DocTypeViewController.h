//
//  DocTypeViewController.h
//  XBHEBProject
//
//  Created by xubh-note on 15/5/18.
//  Copyright (c) 2015年 xu banghui. All rights reserved.
//

#import "XBHBaseTableViewController.h"


@protocol DocTypeViewControllerDelegate <NSObject>

@optional

-(void)DocTypeViewControllerDidSelecteTitle:(NSString *)title;

@end


@interface DocTypeViewController : XBHBaseTableViewController

@property   (nonatomic,weak)       id<DocTypeViewControllerDelegate>   delegate;
@end
