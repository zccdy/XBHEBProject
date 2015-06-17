//
//  XBHBaseTableViewController.m
//  XBHMVVMTest
//
//  Created by xubh-note on 15/3/16.
//  Copyright (c) 2015年 xu banghui. All rights reserved.
//

#import "XBHBaseTableViewController.h"
#import "XBHTableBaseHandler.h"
#import "SDRefresh.h"
#import "XBHLoadMoreView.h"
@interface XBHBaseTableViewController ()<UITableViewDataSource,UITableViewDelegate>

@property   (nonatomic,strong)  SDRefreshHeaderView *mRefreshHeader;

@property   (nonatomic,strong)  XBHLoadMoreView     *mLoadMoreView;
@end

@implementation XBHBaseTableViewController
{
    UILabel         *_noDataNotify;

}

@synthesize mTableView=_mTableView;

- (instancetype)init
{
    return [self initWithStyle:UITableViewStylePlain];
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super init];
    if (self) {
        self.mTableViewStyle=style;
        self.mbIsAutoRefreshOnFirst=YES;
        self.mbRefreshEnable=YES;
    }
    return self;
}
- (void)dealloc
{
    self.mTableHandler=nil;
    [self.mRefreshHeader scrollViewRemoveObserver];
    [self.mLoadMoreView scrollRemoveObserver];
}
-(UITableView *)mTableView{

    if (!_mTableView) {
        CGRect tableViewFrame = self.view.bounds;
        CGFloat heightPanding=0;
        if (!IOS7SYSTEMVERSION_OR_LATER) {
            heightPanding=44;
        }
        //ios7 以前若是存在navigationController height-44-tabBar高度
        tableViewFrame.size.height -= (self.navigationController.viewControllers.count > 1 ? 0 : (CGRectGetHeight(self.navigationController.navigationBar.bounds))) +heightPanding;
        
        if (self.tabBarController) {
           tableViewFrame.size.height -=CGRectGetHeight(self.tabBarController.tabBar.bounds);
        }
        
        _mTableView = [[UITableView alloc] initWithFrame:tableViewFrame style:self.mTableViewStyle];
        if (self.mTableHandler) {
            _mTableView.delegate = self.mTableHandler;
            _mTableView.dataSource = self.mTableHandler;
        }
        else{
            _mTableView.delegate = self;
            _mTableView.dataSource = self;
        }
        
        _mTableView.tableFooterView = [[UIView alloc] init];
        if (!IOS7SYSTEMVERSION_OR_LATER) {
            if (self.mTableViewStyle == UITableViewStyleGrouped) {
                UIView *backgroundView = [[UIView alloc] initWithFrame:_mTableView.bounds];
                backgroundView.backgroundColor = _mTableView.backgroundColor;
                _mTableView.backgroundView = backgroundView;
            }
        }
        /*
        if (self.tabBarController) {
            UIEdgeInsets scrollIndicatorInsets = _mTableView.scrollIndicatorInsets;
            scrollIndicatorInsets.bottom -= CGRectGetHeight(self.tabBarController.tabBar.bounds);
            _mTableView.scrollIndicatorInsets = scrollIndicatorInsets;
        }
         */
        
    }
    return _mTableView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor greenColor];
    [self.view addSubview:self.mTableView];
    self.mAutoLoadMoreCount=3;
    if (self.mbRefreshEnable) {
        [self setupHeader];
    }
    
    if (self.mbLoadMoreEnable) {
        [self setupFooter];
    }
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}
- (void)setupHeader
{
    self.mRefreshHeader =[SDRefreshHeaderView refreshView];
    
    // 默认是在navigationController环境下，如果不是在此环境下，请设置 refreshHeader.isEffectedByNavigationController = NO;
    [self.mRefreshHeader addToScrollView:self.mTableView isEffectedByNavigationController:(self.navigationController!=nil)];
    
  
    XBHWeakSelf;
    
    self.mRefreshHeader.beginRefreshingOperation = ^{
        XBHStrongSelf;
        [strongSelf refreshStart];
    };
    if (self.mbIsAutoRefreshOnFirst) {
        // 进入页面自动加载一次数据
        [self.mRefreshHeader beginRefreshing];
    }
}

-(void)setupFooter{
    self.mLoadMoreView=[XBHLoadMoreView loadMoreWithScrollView:self.mTableView];
    self.mLoadMoreView.mAutoLoadingCount=self.mAutoLoadMoreCount;
     XBHWeakSelf;
    self.mLoadMoreView.beginLoadMore=^{
        XBHStrongSelf;
        if (strongSelf.mAlreadyLoadCount < strongSelf.mTotalPageCount) {
            strongSelf.mAlreadyLoadCount++;
            [strongSelf willLoadDataSource_loadMore];
        }
        else{
            [strongSelf.mLoadMoreView setLoadCompeleTeState];
        }
    };
    
    if (self.mLoadMoreTextColor) {
        self.mLoadMoreView.mTextColor=self.mLoadMoreTextColor;
    }
}

-(void)refreshStart{
    _noDataNotify.hidden=YES;
    self.mAlreadyLoadCount=0;
    [self.mLoadMoreView resetAutoLoad];
   // [self.mLoadMoreView setXBHLoadMoreViewState:XBHLoadMoreState_None];
    [self willLoadDataSource_refresh];
}


-(void)endendRefreshing{
    [self.mRefreshHeader endRefreshing];
}
-(void)endLoadMoreData{
     [self.mLoadMoreView endLoadingMore];
}
-(void)willLoadDataSource_refresh{
    
    //子类覆盖实现
    [self endendRefreshing];
}

-(void)willLoadDataSource_loadMore{
    //子类覆盖实现
    [self endLoadMoreData];
}

-(void)setLoadCompelete{
    [self setLoadCompeleteWithString:@"已全部加载"];
}
-(void)setLoadCompeleteWithString:(NSString *)cmpStr{
    if (cmpStr
        &&self.mLoadMoreView) {
        self.mLoadMoreView.mloadCompeleteText=cmpStr;
        [self.mLoadMoreView setLoadCompeleTeState];
    }

}

-(void)setNoDataNotify{
    [self setNoDataNotifyWithStr:@"网络出错，下拉重新加载"];

}


-(void)setNoDataNotifyWithStr:(NSString *)notify{
   
    if (!_noDataNotify) {
        
        CGFloat y=MIN((CGRectGetHeight(self.view.bounds)-44)/2, 120);
        _noDataNotify=[[UILabel alloc] initWithFrame:CGRectMake(0, y, CGRectGetWidth(self.view.bounds), 44)];
        _noDataNotify.numberOfLines=0;
        _noDataNotify.font=[UIFont systemFontOfSize:14];
        _noDataNotify.opaque=NO;
        _noDataNotify.textColor=[UIColor lightGrayColor];
        _noDataNotify.textAlignment=NSTextAlignmentCenter;
        [self.mTableView addSubview:_noDataNotify];
    }
    _noDataNotify.hidden=NO;
    _noDataNotify.text=notify;
    
}


-(void)setCellSubviewDefaultTag:(UIView *)subview{
    subview.tag=XBHCellSubViewTag;

}
-(void)setCellSubview:(UIView *)subview Tag:(NSInteger)tag{

    subview.tag=tag;
}


-(void)resetCellViewWhichDefaultTag:(UITableViewCell *)cell{

    [self resetCellView:cell Tag:XBHCellSubViewTag];
}

-(void)resetCellView:(UITableViewCell *)cell Tag:(NSInteger)tag{

    for (UIView *view in cell.contentView.subviews) {
        if (view.tag == tag) {
            [view removeFromSuperview];
        }
    }

}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    //子类覆盖实现
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
     //子类覆盖实现
    return 0;
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    

 //子类覆盖实现
    return nil;
}


@end
