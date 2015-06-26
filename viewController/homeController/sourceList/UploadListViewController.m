//
//  UploadListViewController.m
//  XBHEBProject
//
//  Created by xubh-note on 15/4/24.
//  Copyright (c) 2015年 xu banghui. All rights reserved.
//

#import "UploadListViewController.h"
#import "XBHUploadManager.h"
#import "TransferViewCell.h"
@interface UploadListViewController ()<TransferViewCellDelegate>

@property   (nonatomic,strong)         XBHUploadDoc            *mCurUploadDoc;
@property   (nonatomic,strong)         NSMutableArray          *mWateUploadArray;
@property   (nonatomic,strong)         NSMutableArray          *mCompeleteArray;
@end

@implementation UploadListViewController{
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
    noDataNotifyLabel.text=@"暂没有上传文件";
    noDataNotifyLabel.textColor=[UIColor lightGrayColor];
    noDataNotifyLabel.textAlignment=NSTextAlignmentCenter;
    [self.tableView addSubview:noDataNotifyLabel];
    [self loadListSource];
    if (0==[self.mWateUploadArray count]
        &&0==[self.mCompeleteArray count]) {
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
    
    self.mCurUploadDoc=[XBHUploadShareDocument oneXBHUploadDocWithUploadStatus:XBHUploadStatus_UploadWate UserId:DefaultUserId];
    
    NSArray *array=[XBHUploadShareDocument XBHUploadDocListWithUploadStatus:XBHUploadStatus_UploadWate UserId:DefaultUserId];
    
    NSArray *pauseArray=[XBHUploadShareDocument XBHUploadDocListBettwenBeginStatus:XBHUploadStatus_UploadPause_ByUser EndStatus:XBHUploadStatus_UploadPause_ByApp UserId:DefaultUserId];
    self.mWateUploadArray=[NSMutableArray array];
    if (array) {
        [self.mWateUploadArray addObjectsFromArray:array];
    }
    if (pauseArray) {
        [self.mWateUploadArray addObjectsFromArray:array];
    }
    
    array=[XBHUploadShareDocument XBHUploadDocListWithUploadStatus:XBHUploadStatus_UploadCompelete UserId:DefaultUserId];
    if (array) {
        self.mCompeleteArray=[NSMutableArray arrayWithArray:array];
    }
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadCallBack:) name:XBHHTTPUploadNotify object:nil];
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
        if (self.mCurUploadDoc) {
            rn=1;
        }
    }
    else if (section == 1){
        rn=[self.mWateUploadArray count];
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
     cell.mRightView.hidden=YES;
    cell.misShowShareButton=NO;
    XBHUploadDoc *doc=nil;
    if (indexPath.section==0) {//正在上传
        doc=self.mCurUploadDoc;
    }
    else if (indexPath.section == 1)//等待上传
    {
        doc=[self.mWateUploadArray objectAtIndex:indexPath.row];
    }
    else if (indexPath.section == 2)//上传完成
    {
        doc=[self.mCompeleteArray objectAtIndex:indexPath.row];
    }
    if (!doc) {
        return cell;
    }
    
    [cell setIcon:[UIImage imageWithData:doc.IconData]];
    [cell setFirstText:[[doc.DataSoucrePath lastPathComponent] stringByDeletingPathExtension] TextColor:CELL_TEXT1_COLOR TextFont:CELL_FIRST_LINE_FONT];
    cell.mStatus=[XBHUploadShareDocument uploadStatusWithUserId:DefaultUserId DataId:doc.DataId DataType:doc.DataType];
    if (cell.mStatus == XBHUploadStatus_Uploading) {
        cell.mRightView.hidden=NO;
        [cell setSecondText:@"上传中" TextColor:CELL_TEXT2_COLOR TextFont:CELL_SECOND_LINE_FONT];
    }
    else if (cell.mStatus ==XBHUploadStatus_UploadWate){
        [cell setSecondText:@"等待上传" TextColor:CELL_TEXT2_COLOR TextFont:CELL_SECOND_LINE_FONT];
    }
    else if (cell.mStatus ==XBHUploadStatus_UploadPause_ByApp
             ||cell.mStatus ==XBHUploadStatus_UploadPause_ByUser){
         cell.mRightView.hidden=NO;
        [cell setSecondText:@"暂停上传" TextColor:CELL_TEXT2_COLOR TextFont:CELL_SECOND_LINE_FONT];
    }
    else if (cell.mStatus ==XBHUploadStatus_UploadCompelete){
        [cell setSecondText:@"上传完成" TextColor:CELL_TEXT2_COLOR TextFont:CELL_SECOND_LINE_FONT];
       
    }
    
    cell.mDataId=doc.DataId;
    cell.mDataType=doc.DataType;
    cell.mFilePath=doc.DataSoucrePath;
    
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


#pragma mark ---

-(void)uploadCallBack:(NSNotification *)notify{
    XBHUploadDoc    *doc=[notify object];
    XBHUploadStatus status=doc.UploadStatus;
    CGFloat         progress=doc.Progress;
    NSString        *path=doc.DataSoucrePath;
    NSString        *fileName=nil;
    long long       dataid=doc.DataId;
   
    if ([path length]) {
        fileName=[path lastPathComponent];
    }
    
    BOOL        isRefresh=NO;
    
    
    if (status == XBHUploadStatus_Uploading) {
        if (!self.mCurUploadDoc
            ||self.mCurUploadDoc.DataId!=dataid) {
            self.mCurUploadDoc=doc;
            isRefresh=YES;
            
            noDataNotifyLabel.hidden=YES;
        }
        
        
        TransferViewCell *cell=(TransferViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        if (cell) {
            if (cell.mStatus !=XBHUploadStatus_Uploading) {
                cell.mStatus=XBHUploadStatus_Uploading;
                [cell setSecondText:@"上传中" TextColor:CELL_TEXT2_COLOR TextFont:CELL_SECOND_LINE_FONT];
            }
            [cell setProgress:progress animated:YES];
        }
        
    }
    else if (status == XBHUploadStatus_UploadCompelete){
        isRefresh=YES;
    }
    else if (status == XBHUploadStatus_UploadFailure){
        [self.view makeToast:[NSString stringWithFormat:@"%@ 上传失败!",fileName] DownMoveToCenterDuration:0.5 NotifyAppearDelay:0 HideDelay:2.0];
        self.mCurUploadDoc=nil;
        isRefresh=YES;
    }
    
    if (isRefresh) {
        [self loadListSource];
        [self.tableView reloadData];
    }
}


-(XBHUploadDoc *)docWithCell:(TransferViewCell *)cell{
    if (self.mCurUploadDoc) {
        if (cell.mDataId == self.mCurUploadDoc.DataId
            &&cell.mDataType == self.mCurUploadDoc.DataType) {
            return self.mCurUploadDoc;
        }
    }
    
    for (XBHUploadDoc *doc in self.mWateUploadArray) {
        if (doc.DataId == cell.mDataId
            &&doc.DataType == cell.mDataType) {
            return doc;
        }
    }
    
    
    for (XBHUploadDoc *doc in self.mCompeleteArray) {
        if (doc.DataId == cell.mDataId
            &&doc.DataType == cell.mDataType) {
            return doc;
        }
    }
    return nil;
}



#pragma mark - TransferViewCellDelegate

-(void)TransferViewCellStatusViewDidSelecte:(TransferViewCell *)cell{
#if 0
    if (cell.mStatus == XBHUploadStatus_Uploading){
        cell.mStatus = XBHUploadStatus_UploadPause_ByUser;
        [XBHUploadShareManager pauseRequestWithDataId:cell.mDataId DataType:cell.mDataType];
        [self loadListSource];
        //上传中 移到等待上传数组，刷新
        [self.tableView reloadData];
    }
    else if (cell.mStatus == XBHUploadStatus_UploadPause_ByUser){
        cell.mStatus = XBHUploadStatus_UploadWate;
        XBHUploadDoc    *doc=[self docWithCell:cell];
        
        
        [XBHUploadShareManager uploadWithXBHUploadDoc:doc];
    }
    else if (cell.mStatus == XBHUploadStatus_UploadFailure){
        //重新上传 /移除
        
    }
#endif
}
-(void)TransferViewCellShareDidSelecte:(TransferViewCell *)cell{
    // 分享
    
    
    
}


@end
