//
//  XBHSearchTableViewController.h
//  XBHEBProject
//
//  Created by xubh-note on 15/4/28.
//  Copyright (c) 2015年 xu banghui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XBHSearchTableViewController : UITableViewController

@property   (nonatomic,strong)      UISearchBar    *searchBar;

@property   (nonatomic,strong)      UISearchDisplayController * searchDispalyCtrl ;

@property   (nonatomic,weak)        UIViewController        *dispalyContentsController;

@end
