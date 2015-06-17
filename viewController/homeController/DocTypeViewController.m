//
//  DocTypeViewController.m
//  XBHEBProject
//
//  Created by xubh-note on 15/5/18.
//  Copyright (c) 2015年 xu banghui. All rights reserved.
//

#import "DocTypeViewController.h"
#import "DocTypeViewCell.h"

#define numofline               (3)

@interface DocTypeViewController ()<DocTypeViewCellDelegate>
@property           (nonatomic,strong)      NSMutableArray      *mDocTypeButtonArray;
@end

@implementation DocTypeViewController

- (void)viewDidLoad {
    self.mbLoadMoreEnable=NO;
    self.mTableView.backgroundColor=XBHUIPageColor;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.title=@"文档类型";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)testDidEndload{
    [self endendRefreshing];
}
-(void)willLoadDataSource_refresh{
    NSArray  *array=@[@"小说",@"合同",@"委托书",@"档案",@"国宝",@"保证",@"收据",@"发票",@"图片"];
    
    self.mDocTypeButtonArray=[NSMutableArray array];
    NSInteger  index=0;
    for (NSString *title in array) {
        DocTypeViewCellInfo *info=[[DocTypeViewCellInfo alloc] init];
        info.mTitle=title;
        info.mIndex=index;
        index++;
        [self.mDocTypeButtonArray addObject:info];
    }
    [self.mTableView reloadData];
    [self performSelector:@selector(testDidEndload) withObject:nil afterDelay:2.0];
}


#pragma mark -  tableViewDelegate

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.backgroundColor=[UIColor clearColor];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.mDocTypeButtonArray count]<1) {
        return 0;
    }
    
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return DocTypeViewCellHeight;
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Identifier = @"MyCells";
    DocTypeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (cell == nil){
        cell = [[DocTypeViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:Identifier];
        cell.delegate=self;
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    NSInteger  startIndex=indexPath.row*numofline;
    NSInteger  endIndex=(indexPath.row+1)*numofline-1;
    if (endIndex>[self.mDocTypeButtonArray count]-1) {
        endIndex=[self.mDocTypeButtonArray count]-1;
    }
    
    [cell setInfoArray:[self.mDocTypeButtonArray subarrayWithRange:NSMakeRange(startIndex, numofline)]];
    
    //子类覆盖实现
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)DocTypeViewCell:(DocTypeViewCell *)cell didSelectionIndex:(NSInteger)index title:(NSString *)title{
    
    if ([self.delegate respondsToSelector:@selector(DocTypeViewControllerDidSelecteTitle:)]) {
        [self.delegate DocTypeViewControllerDidSelecteTitle:title];
    }

    [self.navigationController popViewControllerAnimated:YES];
}

@end
