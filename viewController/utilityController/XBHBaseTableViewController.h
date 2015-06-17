//
//  XBHBaseTableViewController.h
//  XBHMVVMTest
//
//  Created by xubh-note on 15/3/16.
//  Copyright (c) 2015年 xu banghui. All rights reserved.
//

#import "XHPullRefreshTableViewController.h"
#import "XBHTableBaseHandler.h"

#define XBHCellSubViewTag           (99999)


@interface XBHBaseTableViewController : UIViewController

//首次进入，自动加载
@property       (nonatomic)         BOOL        mbIsAutoRefreshOnFirst;

@property       (nonatomic,strong)    UITableView   *mTableView;

@property       (nonatomic,assign)    UITableViewStyle  mTableViewStyle;

//是否开启刷新功能    默认yes
@property       (nonatomic,assign)   BOOL           mbRefreshEnable;

//是否开启加载更多功能 默认不开启
@property       (nonatomic,assign)    BOOL          mbLoadMoreEnable;
/*
 一上拉就加载的次数 ，超过次数将点击再加载
 
 mbLoadMoreEnable==YES 有效
 */
@property       (nonatomic,assign)    NSUInteger    mAutoLoadMoreCount;

@property       (nonatomic,strong)    XBHTableBaseHandler   *mTableHandler;

//已经加载更多 多少次。
@property       (nonatomic,assign)    NSUInteger       mAlreadyLoadCount;

@property       (nonatomic,assign)     NSUInteger       mTotalPageCount;

@property       (nonatomic,assign)      NSUInteger      mCurRequestPageIndex;

@property       (nonatomic,assign)     UIColor          *mLoadMoreTextColor;

- (instancetype)initWithStyle:(UITableViewStyle)style;


-(void)setLoadCompelete;
-(void)setLoadCompeleteWithString:(NSString *)cmpStr;

-(void)setNoDataNotify;
-(void)setNoDataNotifyWithStr:(NSString *)notify;


-(void)setCellSubviewDefaultTag:(UIView *)subview;

-(void)setCellSubview:(UIView *)subview Tag:(NSInteger)tag;

-(void)resetCellViewWhichDefaultTag:(UITableViewCell *)cell;

-(void)resetCellView:(UITableViewCell *)cell Tag:(NSInteger)tag;
//子类覆盖实现 (第一次加载 与 刷新)
-(void)willLoadDataSource_refresh;
//子类覆盖实现 (加载更多)
-(void)willLoadDataSource_loadMore;


-(void)endendRefreshing;
-(void)endLoadMoreData;

@end
