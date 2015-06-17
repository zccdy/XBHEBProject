//
//  DocClassifyViewController.m
//  XBHEBProject
//
//  Created by xubh-note on 15/6/17.
//  Copyright (c) 2015年 xu banghui. All rights reserved.
//

#import "DocClassifyViewController.h"
#import "DocClassifyRequest.h"
#import "sourceDownloadViewController.h"



#pragma mark -



@interface DocClassifyViewController ()

@property   (nonatomic,strong)      NSMutableArray  *mClassifyArray;

@property   (nonatomic,strong)      DocClassifyRequest   *mRequest;
@end

@implementation DocClassifyViewController{
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    if ([self isViewLoaded] && self.view.window == nil){
        self.view = nil;
        self.mClassifyArray=nil;
    }
    
}



- (void)viewDidLoad
{
    self.mbRefreshEnable=YES;
    self.mbIsAutoRefreshOnFirst=YES;
    [super viewDidLoad];
    
    
    self.view.backgroundColor=XBHUIPageColor;
    self.mTableView.backgroundColor=XBHUIPageColor;
    // Do any additional setup after loading the view.
    
    self.mTableView.rowHeight=60;
    
    self.mTableView.separatorColor=XBHSeparatorColor;
    
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    CGRect frame= [UIScreen mainScreen].bounds;
    frame.size.height-=self.tabBarController.tabBar.frame.size.height+44+20;
    self.mTableView.frame=frame;
    

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.mRequest) {
        [self.mRequest stop];
    }
    self.mRequest=nil;
}



#pragma mark -  request 处理

-(void)reloadSource{
    self.mRequest=[[DocClassifyRequest alloc] init];
    XBHWeakSelf;
    [self.mRequest startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        XBHStrongSelf;
        [strongSelf resultHandle:request.responseJSONObject success:YES];
    } failure:^(YTKBaseRequest *request) {
        XBHStrongSelf;
        [strongSelf resultHandle:request.responseJSONObject success:NO];
        
    }];
}

-(void)resultHandle:(NSDictionary *)dict success:(BOOL)isSuc{
    if (isSuc) {
        self.mTotalPageCount=[dict[kJSONPageCount] unsignedIntegerValue];
        NSArray *array=dict[kJSONPageData];
        
        if (self.mCurRequestPageIndex ==0) {//刷新
            self.mClassifyArray=nil;
        }
        
        if (self.mClassifyArray) {
            [self.mClassifyArray addObjectsFromArray:array];
        }
        else{
            self.mClassifyArray=[NSMutableArray arrayWithArray:array];
            
        }
        [self.mTableView reloadData];
    }
    else{
        
        
        
        
    }
    
    if ([self.mClassifyArray count]==0) {
        [self setNoDataNotify];
    }
    
    [self endendRefreshing];
    [self endLoadMoreData];
}




//第一次加载或刷新
-(void)willLoadDataSource_refresh{
    NSArray     *array=@[@"分类一",@"分类二",@"分类三",@"分类四",@"分类五",@"分类六",@"分类七",@"分类八"];
    self.mClassifyArray=[NSMutableArray arrayWithArray:array];
    [self.mTableView reloadData];
    [self endendRefreshing];
}


#pragma mark- tableView delegate

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.backgroundColor=[UIColor clearColor];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.mClassifyArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *Identifier = @"MyCells";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:Identifier];
        cell.textLabel.font=XBHSysFont(14);
        cell.textLabel.textAlignment=NSTextAlignmentLeft;
        cell.textLabel.textColor=[UIColor whiteColor];
        
        cell.detailTextLabel.font=XBHSysFont(13);
        cell.detailTextLabel.textAlignment=NSTextAlignmentLeft;
        cell.detailTextLabel.textColor=[UIColor lightGrayColor];
        
    }
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    
    cell.imageView.image=XBHHomeBundleImageWithName(@"ico_09");
    cell.imageView.layer.masksToBounds=YES;
    cell.imageView.layer.cornerRadius=8.0;
    cell.textLabel.text=self.mClassifyArray[indexPath.row];
    cell.detailTextLabel.text=@"共有108个文件";
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController pushViewController:[[sourceDownloadViewController alloc] init] animated:YES];

}




@end
