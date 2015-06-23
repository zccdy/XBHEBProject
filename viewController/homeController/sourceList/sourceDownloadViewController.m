//
//  sourceDownloadViewController.m
//  gwEdu
//
//  Created by xubh-note on 14-6-20.
//  Copyright (c) 2014年 gwsoft. All rights reserved.
//

#import "sourceDownloadViewController.h"

#import "TransferViewCell.h"
#import "XBHDownloadManager.h"
#import "SourceListRequest.h"
#import "ShareEditViewController.h"
#import "Toast+UIView.h"
#define DownloadListViewH           (56)



#pragma mark -



@interface sourceDownloadViewController ()<TransferViewCellDelegate>

@property   (nonatomic,strong)      NSMutableArray  *mSourceArray;

@property   (nonatomic,strong)      SourceListRequest   *mRequest;
@end

@implementation sourceDownloadViewController{
    
}
@synthesize mTitleName;
@synthesize mbSwipeDelete;
@synthesize mbIsDismiss;
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
  
   
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    if ([self isViewLoaded] && self.view.window == nil){
        self.view = nil;
        self.mSourceArray=nil;
    }
    
}



- (void)viewDidLoad
{
    self.mbRefreshEnable=YES;
    self.mbIsAutoRefreshOnFirst=YES;
    self.mbLoadMoreEnable=YES;
    self.mLoadMoreTextColor=[UIColor whiteColor];
    [super viewDidLoad];
   
    
    self.view.backgroundColor=XBHUIPageColor;
    self.mTableView.backgroundColor=XBHUIPageColor;
	// Do any additional setup after loading the view.
  
    self.mTableView.rowHeight=SOURCE_CELL_HEIGHT;
  
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadCallback:) name:XBHHTTPDownloadNotify object:nil];
  
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(comeBackFromBackground) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    
    
    
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
    self.mRequest=[[SourceListRequest alloc] initWithIndex:self.mCurRequestPageIndex];
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
            self.mSourceArray=nil;
        }
        
        if (self.mSourceArray) {
            [self.mSourceArray addObjectsFromArray:array];
        }
        else{
            self.mSourceArray=[NSMutableArray arrayWithArray:array];
            
        }
        [self.mTableView reloadData];
    }
    else{
    
    
    
    
    }
    
    if ([self.mSourceArray count]==0) {
        [self setNoDataNotify];
    }
    
   [self endendRefreshing];
    [self endLoadMoreData];
}




//第一次加载或刷新
-(void)willLoadDataSource_refresh{
    self.mCurRequestPageIndex=0;
    [self reloadSource];
 
}

//加载更多
-(void)willLoadDataSource_loadMore{
    if (self.mCurRequestPageIndex<self.mTotalPageCount-1) {
        self.mCurRequestPageIndex++;
         [self reloadSource];
    }
    else{
        [self setLoadCompelete];
    }
    
}


#pragma mark- tableView delegate

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.backgroundColor=[UIColor clearColor];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.mSourceArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *Identifier = @"MyCells";
    TransferViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (cell == nil){
        cell = [[TransferViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
        cell.delegate=self;
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.misShowShareButton=YES;
     cell.mRightView.hidden=NO;
    NSDictionary    *dict=[self.mSourceArray objectAtIndex:indexPath.row];
    [cell resetText];
    cell.mProgress=0.0f;
    cell.tag=indexPath.row;
    cell.mDataId=[dict[kJSONItemId] longLongValue];
    cell.mDataType=DefaultDataType;
    
    [cell setFirstText:dict[kJSONItemName] TextColor:CELL_TEXT1_COLOR TextFont:CELL_FIRST_LINE_FONT];
    cell.mStatus=[XBHDownloadShareDocument downloadStatusWithUserId:DefaultUserId DataId:[dict[kJSONItemId] longLongValue] DataType:DefaultDataType];
    if (cell.mStatus == XBHDownloadStatus_DownloadCompelete) {
         cell.mRightView.hidden=YES;
    }
    [cell setIcon:nil imageURL:[XBHNetworking fullUrlWithPartUrl:dict[kJSONItemIconUrl]]];
    
  //  [cell setSecondText:@"上传中" TextColor:CELL_TEXT2_COLOR TextFont:CELL_SECOND_LINE_FONT];
    
    return cell;
}




-(void)downloadWithJSONDict:(NSDictionary *)dict{

    XBHDownloadDoc    *doc=[[XBHDownloadDoc alloc] init];
    doc.DataId=[dict[kJSONItemId] longLongValue];
    doc.DataType=DefaultDataType;
    doc.DataName=dict[kJSONItemName];
    doc.DataURL=[XBHNetworking fullUrlWithPartUrl:dict[kJSONItemDownloadUrl]];
    doc.UserId=DefaultUserId;
    doc.DownloadStatus=XBHDownloadStatus_DownloadWate;
    doc.IconURL=[XBHNetworking fullUrlWithPartUrl:dict[kJSONItemIconUrl]];
    doc.DataReferenceInfo=[NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    [XBHDownloadShareManager downloadWithXBHDownloadDoc:doc];
    
}

#pragma mark - 下载状态按钮 press
-(void)TransferViewCellStatusViewDidSelecte:(TransferViewCell *)cell{
   
    

    if (cell.mStatus == XBHDownloadStatus_None
        ||cell.mStatus == XBHDownloadStatus_DownloadFailure
        ||cell.mStatus == XBHDownloadStatus_DownloadPause_ByUser) {
        if ([XBHShareAppDelegate homePageJumpToLoginController]){
            return;
        }
        cell.mStatus=XBHDownloadStatus_DownloadWate;
         NSDictionary    *dict=[self.mSourceArray objectAtIndex:cell.tag];
        [self downloadWithJSONDict:dict];
    }
    else if (cell.mStatus == XBHDownloadStatus_Downloading){
        cell.mStatus = XBHDownloadStatus_DownloadPause_ByUser;
        [XBHDownloadShareManager pauseRequestWithDataId:cell.mDataId DataType:cell.mDataType];
        
    }
    /*
    else if (cell.mStatus == XBHDownloadStatus_DownloadCompelete){
       // [self openSourceWithCell:cell];
    }
    else if (cell.mStatus == XBHDownloadStatus_DownloadWate){
        [XBHDownloadShareManager cancelRequestWithDataId:cell.mDataId DataType:cell.mDataType];
        cell.mStatus=XBHDownloadStatus_None;
        
    }

    else if (cell.mStatus == XBHDownloadStatus_DownloadFailure){
        
    }
     */
    

}
-(void)TransferViewCellShareDidSelecte:(TransferViewCell *)cell{
    if ([XBHShareAppDelegate homePageJumpToLoginController]){
        return;
    }
    // 分享

    NSDictionary    *dict=[self.mSourceArray objectAtIndex:cell.tag];
    
    ShareEditViewController *controller=[[ShareEditViewController alloc] initWithStyle:UITableViewStylePlain];
    controller.fileSize=[dict[kJSONItemDataSize] longLongValue];
    controller.fileName=dict[kJSONItemName];
    controller.uploadDate=dict[kJSONItemUploadtime];
    [self.navigationController pushViewController:controller animated:YES];
}



#pragma mark -  下载事件回调

-(void)downloadCallback:(NSNotification *)notify{
    NSDictionary *dict=notify.userInfo;
    long long userId=[[dict objectForKey:kXBHHTTPDownload_UserId] longLongValue];
    long long dataId=[[dict objectForKey:kXBHHTTPDownload_DataId] longLongValue];
    NSUInteger dataType=[[dict objectForKey:kXBHHTTPDownload_DataType] integerValue];
    NSUInteger status=[[dict objectForKey:kXBHHTTPDownload_Status] integerValue];
    CGFloat    progress=[[dict objectForKey:kXBHHTTPDownload_Progress] floatValue];
    
    
    if (userId != DefaultUserId) {
        return;
    }
    
    TransferViewCell *curCell=nil;
    for (TransferViewCell *cell in [self.mTableView visibleCells]) {
        if (cell.mDataId == dataId
            &&cell.mDataType == dataType) {
            curCell=cell;
            break;
        }
    }
    
    if (status == XBHDownloadStatus_Downloading) {
        if (curCell) {
            if (curCell.mStatus != status) {
                curCell.mStatus=status;
            }
            //curCell.mProgress=progress;
            [curCell setProgress:progress animated:YES];
        }
       
        
    }
    else if (status == XBHDownloadStatus_DownloadCompelete){
        if (curCell) {
            curCell.mStatus=status;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.mTableView reloadData];
        });
        
    }
    else if (status == XBHDownloadStatus_DownloadFailure){
        if (curCell) {
            curCell.mStatus=XBHDownloadStatus_DownloadFailure;
            
        }
        
        [self.view makeToast:[NSString stringWithFormat:@"%@ 下载失败",dict[kXBHHTTPDownload_DataName]] duration:2 position:@"center"];

    }
    
    
}





-(void)comeBackFromBackground{
    if ([self.mSourceArray count]) {
        [self.mTableView reloadData];
    }
    
}




@end
