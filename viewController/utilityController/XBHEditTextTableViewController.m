//
//  XBHEditTextTableViewController.m
//  XBHEBProject
//
//  Created by xubh-note on 15/5/13.
//  Copyright (c) 2015年 xu banghui. All rights reserved.
//

#import "XBHEditTextTableViewController.h"
#import "XBHEidtTextViewCell.h"

#define DefaultCellHeight           (50)

@interface XBHEditTextTableViewController ()<XBHEidtTextViewCellDelegate>

@end

@implementation XBHEditTextTableViewController
{

    NSMutableDictionary          *_cellHeightDict;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout=UIRectEdgeNone;
    _cellHeightDict=[NSMutableDictionary dictionary];
    self.tableView.tableFooterView=[[UIView alloc] init];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self cellHeightWithRow:indexPath.row];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier=@"myCell";
    
    XBHEidtTextViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell=[[XBHEidtTextViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.delegate=self;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.minHeight=DefaultCellHeight;
       
    }
    cell.tag=indexPath.row;
    
    // Configure the cell...
    
    return cell;
}

-(NSString *)cellHeightKeyWithRow:(NSInteger )row{

    return [NSString stringWithFormat:@"index_%d",(int)row];
}

-(void)setCellHeight:(CGFloat )height indexRow:(NSInteger)row{
    NSString *key=[self cellHeightKeyWithRow:row];
    _cellHeightDict[key]=@(height);
}

-(CGFloat)cellHeightWithRow:(NSInteger)row{
    NSNumber *num=_cellHeightDict[[self cellHeightKeyWithRow:row]];
    if (num) {
        return [num floatValue];
    }
    return DefaultCellHeight;
}

#pragma mark-
-(void)XBHEidtTextViewCell:(XBHEidtTextViewCell *)cell WillChangeHeight:(CGFloat)height{
    if(height<DefaultCellHeight){
        return;
    }

    [self setCellHeight:height indexRow:cell.tag];
    
    CGSize    size=self.tableView.contentSize;
    size.height+=(height -DefaultCellHeight);
    [self.tableView setContentSize:size];
    /*
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:cell.tag inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    });
    
    */
}
@end
