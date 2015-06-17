//
//  DownloadListViewController.m
//  XBHEBProject
//
//  Created by xubh-note on 15/4/24.
//  Copyright (c) 2015年 xu banghui. All rights reserved.
//

#import "DownloadListViewController.h"
#import "XBHDownloadManager.h"
#import "TransferViewCell.h"
#import "ShareEditViewController.h"
@interface DownloadListViewController ()<TransferViewCellDelegate>

@property   (nonatomic,strong)         XBHDownloadDoc            *mCurDownloadDoc;
@property   (nonatomic,strong)         NSMutableArray          *mWateDownloadArray;
@property   (nonatomic,strong)         NSMutableArray          *mCompeleteArray;
@end

@implementation DownloadListViewController{
    UILabel         *noDataNotifyLabel;
    
}

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor=XBHUIPageColor;
    self.tableView.tableFooterView=[[UIView alloc] init];
    self.tableView.rowHeight=SOURCE_CELL_HEIGHT;
    self.tableView.separatorColor=XBHSeparatorColor;
    
    noDataNotifyLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, (CGRectGetHeight(self.view.bounds)-40)/2-60, CGRectGetWidth(self.view.bounds), 40)];
    noDataNotifyLabel.opaque=NO;
    noDataNotifyLabel.hidden=YES;
    noDataNotifyLabel.text=@"暂没有下载文件";
    noDataNotifyLabel.textColor=[UIColor lightGrayColor];
    noDataNotifyLabel.textAlignment=NSTextAlignmentCenter;
    [self.tableView addSubview:noDataNotifyLabel];
    [self loadListSource];
    if (![self.mWateDownloadArray count]
        &&!self.mCompeleteArray) {
        [self showNoDataNotify];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showNoDataNotify{
    //  self.tableView.hidden=YES;
    noDataNotifyLabel.hidden=NO;
}

-(void)loadListSource{
    self.mWateDownloadArray=[NSMutableArray array];
    
    NSArray *pauseArray=[XBHDownloadShareDocument XBHDownloadDocListWithDownloadStatus:XBHDownloadStatus_DownloadPause_ByUser UserId:DefaultUserId];
    
    
    NSArray *array=[XBHDownloadShareDocument XBHDownloadDocListWithDownloadStatus:XBHDownloadStatus_DownloadWate UserId:DefaultUserId];
    
    self.mWateDownloadArray=[NSMutableArray array];
    if (pauseArray) {
        [self.mWateDownloadArray addObjectsFromArray:pauseArray];
    }
    
    if (array) {
        [self.mWateDownloadArray addObjectsFromArray:array];
    }
    
    array=[XBHDownloadShareDocument XBHDownloadDocListWithDownloadStatus:XBHDownloadStatus_DownloadCompelete UserId:DefaultUserId];
    if (array) {
        self.mCompeleteArray=[NSMutableArray arrayWithArray:array];
    }
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DownloadCallBack:) name:XBHHTTPDownloadNotify object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}


#pragma mark - Table view data source
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.backgroundColor=[UIColor clearColor];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    NSUInteger  rn=0;
    if (section == 0) {
        if (self.mCurDownloadDoc) {
            rn=1;
        }
    }
    else if (section == 1){
        rn=[self.mWateDownloadArray count];
    }
    else if (section == 2){
        rn=[self.mCompeleteArray count];
        
    }
    return rn;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static   NSString     *indentifer=@"mytableViewCell";
    TransferViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifer];
    if (!cell) {
        cell=[[TransferViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifer];
        cell.delegate=self;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    cell.mRightView.hidden=NO;
    cell.misShowShareButton=YES;
    XBHDownloadDoc *doc=nil;
    if (indexPath.section==0) {//正在下载
        doc=self.mCurDownloadDoc;
    }
    else if (indexPath.section == 1)//等待下载
    {
        doc=[self.mWateDownloadArray objectAtIndex:indexPath.row];
    }
    else if (indexPath.section == 2)//下载完成
    {
        doc=[self.mCompeleteArray objectAtIndex:indexPath.row];
    }
    if (!doc) {
        return nil;
    }
     cell.mRightView.hidden=YES;
    [cell setIcon:nil imageURL:doc.IconURL];
    [cell setFirstText:[doc.DataName stringByDeletingPathExtension] TextColor:CELL_TEXT1_COLOR TextFont:CELL_FIRST_LINE_FONT];
    cell.mStatus=[XBHDownloadShareDocument downloadStatusWithUserId:DefaultUserId DataId:doc.DataId DataType:doc.DataType];
    if (cell.mStatus == XBHDownloadStatus_Downloading) {
        cell.mRightView.hidden=NO;
        [cell setSecondText:@"下载中" TextColor:CELL_TEXT2_COLOR TextFont:CELL_SECOND_LINE_FONT];
    }
    else if (cell.mStatus ==XBHDownloadStatus_DownloadWate){
        [cell setSecondText:@"等待下载" TextColor:CELL_TEXT2_COLOR TextFont:CELL_SECOND_LINE_FONT];
    }
    else if (cell.mStatus ==XBHDownloadStatus_DownloadPause_ByApp
             ||cell.mStatus ==XBHDownloadStatus_DownloadPause_ByUser){
        cell.mRightView.hidden=NO;
        [cell setSecondText:@"暂停下载" TextColor:CELL_TEXT2_COLOR TextFont:CELL_SECOND_LINE_FONT];
    }
    else if (cell.mStatus ==XBHDownloadStatus_DownloadCompelete){
       
        [cell setSecondText:@"下载完成" TextColor:CELL_TEXT2_COLOR TextFont:CELL_SECOND_LINE_FONT];
        
    }
    
    cell.mDataId=doc.DataId;
    cell.mDataType=doc.DataType;
   
    
    return cell;
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

-(XBHDownloadDoc *)docWithCell:(TransferViewCell *)cell{
    if (self.mCurDownloadDoc) {
        if (cell.mDataId == self.mCurDownloadDoc.DataId
            &&cell.mDataType == self.mCurDownloadDoc.DataType) {
            return self.mCurDownloadDoc;
        }
    }
    
    for (XBHDownloadDoc *doc in self.mWateDownloadArray) {
        if (doc.DataId == cell.mDataId
            &&doc.DataType == cell.mDataType) {
            return doc;
        }
    }
    
    
    for (XBHDownloadDoc *doc in self.mCompeleteArray) {
        if (doc.DataId == cell.mDataId
            &&doc.DataType == cell.mDataType) {
            return doc;
        }
    }
    return nil;
}




#pragma mark - TransferViewCellDelegate

-(void)TransferViewCellStatusViewDidSelecte:(TransferViewCell *)cell{
    
    if (cell.mStatus == XBHDownloadStatus_Downloading){
        cell.mStatus = XBHDownloadStatus_DownloadPause_ByUser;
        [XBHDownloadShareManager pauseRequestWithDataId:cell.mDataId DataType:cell.mDataType];
        [self loadListSource];
        //下载中 移到等待下载数组，刷新
        [self.tableView reloadData];
    }
    else if (cell.mStatus == XBHDownloadStatus_DownloadPause_ByUser){
       
        cell.mStatus = XBHDownloadStatus_DownloadWate;
        XBHDownloadDoc    *doc=[self docWithCell:cell];
        
        
        [XBHDownloadShareManager downloadWithXBHDownloadDoc:doc];
    }
    else if (cell.mStatus == XBHDownloadStatus_DownloadFailure){
        //重新下载 /移除
    }
    /*
     else if (cell.mStatus == XBHDownloadStatus_DownloadCompelete){
     // [self openSourceWithCell:cell];
     }
     else if (cell.mStatus == XBHDownloadStatus_DownloadWate){
     [XBHDownloadShareManager cancelRequestWithDataId:cell.mDataId DataType:cell.mDataType];
     cell.mStatus=XBHDownloadStatus_None;
     
     }
     
     
     */
    
}
-(void)TransferViewCellShareDidSelecte:(TransferViewCell *)cell{
    // 分享
    XBHDownloadDoc    *doc=[self docWithCell:cell];
    NSDictionary      *dict=nil;
    if (doc) {
        if ([doc.DataReferenceInfo length]) {
            dict=[NSJSONSerialization JSONObjectWithData:doc.DataReferenceInfo options:NSJSONReadingMutableContainers error:nil];
        }
    }
    if (!dict) {
        return;
    }
    
    ShareEditViewController *controller=[[ShareEditViewController alloc] initWithStyle:UITableViewStylePlain];
    controller.fileSize=[dict[kJSONItemDataSize] longLongValue];
    controller.fileName=dict[kJSONItemName];
    controller.uploadDate=dict[kJSONItemUploadtime];
    [self.navigationController pushViewController:controller animated:YES];
}


#pragma mark ---

-(void)DownloadCallBack:(NSNotification *)notify{
    NSDictionary    *userInfo=[notify userInfo];
    XBHDownloadStatus status=[userInfo[kXBHHTTPDownload_Status] unsignedIntegerValue];
    CGFloat         progress=[userInfo[kXBHHTTPDownload_Progress] floatValue];
  
    long long       dataid=[userInfo[kXBHHTTPDownload_DataId] longLongValue];
    NSUInteger      datatype=[userInfo[kXBHHTTPDownload_DataType] unsignedIntegerValue];
    
    BOOL        isRefresh=NO;
    
    
    if (status == XBHDownloadStatus_Downloading) {
        if (!self.mCurDownloadDoc
            ||self.mCurDownloadDoc.DataId!=dataid) {
            self.mCurDownloadDoc=[XBHDownloadShareDocument oneXBHDownloadDocWithUserId:DefaultUserId DataId:dataid DataType:datatype];
            isRefresh=YES;
            
            noDataNotifyLabel.hidden=YES;
        }
        
        self.mCurDownloadDoc.DownloadStatus=status;
        TransferViewCell *cell=(TransferViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        if (cell) {
            [cell setProgress:progress animated:YES];
        }
        
    }
    else if (status == XBHDownloadStatus_DownloadCompelete){
        self.mCurDownloadDoc=nil;
        isRefresh=YES;
    }
    else if (status == XBHDownloadStatus_DownloadFailure){
        self.mCurDownloadDoc=nil;
        isRefresh=YES;
    }
    
    if (isRefresh) {
        [self loadListSource];
        [self.tableView reloadData];
    }
}



@end
