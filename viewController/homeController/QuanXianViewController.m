//
//  QuanXianViewController.m
//  XBHEBProject
//
//  Created by xubh-note on 15/5/8.
//  Copyright (c) 2015年 xu banghui. All rights reserved.
//

#import "QuanXianViewController.h"

@interface QuanXianViewController ()

@end

@implementation QuanXianViewController
{
    UIImageView             *_selectionImage;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor=XBHUIPageColor;
    self.tableView.tableFooterView=[[UIView alloc] init];
    self.tableView.separatorColor=XBHSeparatorColor;
    UIImage *image=XBHHomeBundleImageWithName(@"correct");
    self.title=@"权限";
    _selectionImage=[[UIImageView alloc] initWithImage:image];
    _selectionImage.frame=CGRectMake(CGRectGetWidth(self.view.frame)-image.size.width-50, (44-image.size.height)/2, image.size.width, image.size.height);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.backgroundColor=[UIColor clearColor];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static  NSString  *identifier=@"mycells";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.textLabel.textColor=[UIColor whiteColor];
    if (indexPath.row == 0) {
        cell.textLabel.text=@"公开";
        if (XBHAppDelegateInstance.shareQX == 1) {
            [_selectionImage removeFromSuperview];
            
            [cell.contentView addSubview:_selectionImage];
            
        }
    }
    else if (indexPath.row == 1){
    
        cell.textLabel.text=@"好友可见";
        if (XBHAppDelegateInstance.shareQX == 2) {
            [_selectionImage removeFromSuperview];
            [cell.contentView addSubview:_selectionImage];
            
        }

    }
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
       XBHAppDelegateInstance.shareQX=1;

    }
    else if (indexPath.row == 1){
        XBHAppDelegateInstance.shareQX=2;
    }
    [self.tableView reloadData];
}

@end
