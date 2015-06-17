//
//  UploadFileEditViewController.m
//  XBHEBProject
//
//  Created by xubh-note on 15/4/22.
//  Copyright (c) 2015年 xu banghui. All rights reserved.
//

#import "UploadFileEditViewController.h"
#import "XBHUploadManager.h"
#import <Masonry.h>
#import "Toast+UIView.h"
#import "DocTypeViewController.h"
#import "TagListViewController.h"
#import "fileUploadHeaderView.h"
#pragma mark -



#pragma mark -


@interface UploadFileEditViewController ()<DocTypeViewControllerDelegate,TagListViewControllerDelegate>
@property   (nonatomic,strong)      NSString        *mDocTypeString;
@property   (nonatomic,strong)      NSArray          *mTagStringArray;
@end

@implementation UploadFileEditViewController
{
   
    NSString        *_sizeString;
    NSString        *_uploadDate;
    UIButton        *_startbutton;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"文档属性";
    self.tableView.backgroundColor=XBHUIPageColor;
    if (self.uploadFilePath) {
        if (!self.fileName) {//文件名为空
            self.fileName=[self.uploadFilePath lastPathComponent];

        }
        if (self.fileSize==0) {//文件大小为o
            self.fileSize=[XBHUitility getFileSizeWithFilePath:self.uploadFilePath];
        }

        
    }
    _sizeString=[XBHUitility fileSizeStringWithByteSize:self.fileSize];
    
    
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat: @"yyyy-MM-dd"];
    _uploadDate=[formatter stringFromDate:[NSDate date]];
    
    NSString    *name=[self.fileName stringByDeletingPathExtension];
    
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    NSArray *array=@[
                    @{UploadHeaderView_Key_Title:@"文档名 :",UploadHeaderView_Key_Value:name,UploadHeaderView_Key_Editable:@(YES)},
                    @{UploadHeaderView_Key_Title:@"文档大小 :",UploadHeaderView_Key_Value:_sizeString,UploadHeaderView_Key_Editable:@(NO)},
                    
                    @{UploadHeaderView_Key_Title:@"上传日期 :",UploadHeaderView_Key_Value:_uploadDate,UploadHeaderView_Key_Editable:@(NO)},
                    
                    ];
    
    self.tableView.tableHeaderView=[[fileUploadHeaderView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), UploadHeaderView_OptionHeight*array.count+4*UploadHeaderViewOffsetY) KVArray:array];
    self.tableView.bounces=NO;
    
    _startbutton=[UIButton buttonWithType:UIButtonTypeCustom];
    [_startbutton setTitle:@"提交" forState:UIControlStateNormal];
    [_startbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _startbutton.titleLabel.font=XBHSysFont(15);
    [_startbutton addTarget:self action:@selector(startbuttonPress) forControlEvents:UIControlEventTouchUpInside];
    _startbutton.frame=CGRectMake(0, 0, 76, 40);
    _startbutton.backgroundColor=XBHButtonColor;
    _startbutton.layer.masksToBounds=YES;
    _startbutton.layer.cornerRadius=XBHCornerRadius;
    _startbutton.tag=999;
    
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!self.mDocTypeString) {
        self.mDocTypeString=@"合同";
    }
    [self.tableView reloadData];
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}


-(NSString *)buildTagList{
    NSString *string=nil;
    for (NSString *str in self.mTagStringArray) {
        if (string) {
            string=[string stringByAppendingString:@" "];
            string=[string stringByAppendingString:str];
        }
        else{
            string=str;
        }
    }
    return string;
    
}


#pragma mark -
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.backgroundColor=[UIColor clearColor];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    return 4;
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Identifier = @"MyCells";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:Identifier];
        
    }
    cell.selectionStyle=UITableViewCellSelectionStyleDefault;
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.detailTextLabel.textColor=[UIColor whiteColor];
    cell.textLabel.textColor=[UIColor whiteColor];
    
    [_startbutton removeFromSuperview];
    
    if (indexPath.row ==0 ) {
        
        cell.textLabel.text=@"文档类型";
        cell.detailTextLabel.font=XBHSysFont(12);
        cell.detailTextLabel.text=self.mDocTypeString;
    }
    else if (indexPath.row ==1){
        
        cell.textLabel.text=@"文档标签";
        cell.detailTextLabel.font=XBHSysFont(12);
        
        if (self.mTagStringArray) {
            cell.detailTextLabel.text=[self buildTagList];
        }
        else{
            cell.detailTextLabel.text=@"无";
        }
    
    }
    else if (indexPath.row ==2){
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.accessoryType=UITableViewCellAccessoryNone;
    }
    else if (indexPath.row ==3){
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.accessoryType=UITableViewCellAccessoryNone;
        [cell.contentView addSubview:_startbutton];
        _startbutton.frame=CGRectMake((CGRectGetWidth(self.view.bounds)-158)/2, (44-30)/2, 158, 30);
    }
    //子类覆盖实现
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==0) {
        
        DocTypeViewController *controller=[[DocTypeViewController alloc] init];
        controller.delegate=self;
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if (indexPath.row ==1){
    
        TagListViewController *controller=[[TagListViewController alloc] init];
        controller.delegate=self;
        controller.aleardySelecteTags=[NSMutableArray arrayWithArray:self.mTagStringArray];
        [self.navigationController pushViewController:controller animated:YES];
    }
}




-(void)startbuttonPress{

    [self startUploadWithParams:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)startUploadWithParams:(id)param{
    if (!self.uploadFilePath) {
        return;
    }
    
    fileUploadHeaderView *headerView=(fileUploadHeaderView*)self.tableView.tableHeaderView;
    NSString    *fileName=[headerView textWithIndex:0];
   if(![fileName length]){
   
       [self.view makeToast:@"请输入文件名" duration:2.f position:@"center"];
       return;

   }

    XBHUploadDoc    *doc=[[XBHUploadDoc alloc] init];
    doc.DataId=[XBHUploadShareManager dispatchDiffrentDataId];
    doc.DataType=DefaultDataType;
    doc.UserId=DefaultUserId;
    doc.DataUploadURL=@"http://symplasima.eicp.net:8090/fineuploader/FileUploadServlet";
    doc.DataSoucrePath=self.uploadFilePath;

    if (self.thumbImg) {
        doc.IconData=UIImageJPEGRepresentation(self.thumbImg, 1.0f);
    }
    
    if (self.dataType == XBHUploadDataType_Image) {
        doc.mimeType=@"image/png";//[NSString stringWithFormat:@"image/%@",[fileName pathExtension]];
    }
    else if (self.dataType == XBHUploadDataType_Video){
        doc.mimeType=[NSString stringWithFormat:@"video/%@",[doc.DataSoucrePath pathExtension]];
    
    }
    
    if (param
        &&[NSJSONSerialization isValidJSONObject:param]) {
        doc.DataReferenceInfo=[NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:nil];
    }
    
    
    [XBHUploadShareManager uploadWithXBHUploadDoc:doc isStart:YES];
    

}


#pragma mark -

-(void)DocTypeViewControllerDidSelecteTitle:(NSString *)title{

    self.mDocTypeString=title;
 
}

#pragma mark -

-(void)TagListViewControllerDidSeletionTitles:(NSArray *)titles{
    self.mTagStringArray=titles;
}
@end
