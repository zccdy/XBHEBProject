//
//  ShareEditViewController.m
//  XBHEBProject
//
//  Created by xubh-note on 15/5/4.
//  Copyright (c) 2015年 xu banghui. All rights reserved.
//

#import "ShareEditViewController.h"
#import "QuanXianViewController.h"
#import <Masonry.h>
#import <QuartzCore/QuartzCore.h>
#import "fileUploadHeaderView.h"

#define ShareEditViewRow1Height   (44)

#define ShareEditViewRow2Height   (44)

#define ShareEditViewRow3Height   (138)

#define ShareEditViewTitleWidth   (60)

#define ShareEditViewFontColor      [UIColor whiteColor]





#pragma mark -

#define ShareSubviewTag         (9999)

@interface ShareEditViewController ()

@end

@implementation ShareEditViewController
{

    UILabel             *_titleLabel[3];
    UITextField         *_titleInputField;
    UITextView          *_introTextView;
    UIButton            *_startbutton;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"分享";
    self.tableView.backgroundColor=XBHUIPageColor;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    NSString  *name=[self.fileName stringByDeletingPathExtension];
    NSString *sizeString=[XBHUitility fileSizeStringWithByteSize:self.fileSize];
    NSArray *array=@[
                     @{UploadHeaderView_Key_Title:@"文档名 :",UploadHeaderView_Key_Value:name,UploadHeaderView_Key_Editable:@(NO)},
                     @{UploadHeaderView_Key_Title:@"文档大小 :",UploadHeaderView_Key_Value:sizeString,UploadHeaderView_Key_Editable:@(NO)},
                     
                     @{UploadHeaderView_Key_Title:@"上传日期 :",UploadHeaderView_Key_Value:self.uploadDate,UploadHeaderView_Key_Editable:@(NO)},
                     
                     ];
    
    self.tableView.tableHeaderView=[[fileUploadHeaderView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), UploadHeaderView_OptionHeight*array.count+4*UploadHeaderViewOffsetY) KVArray:array];
    
    
    for (int i=0; i<3; i++) {
        _titleLabel[i]=[[UILabel alloc] init];
        _titleLabel[i].opaque=NO;
        _titleLabel[i].textAlignment=NSTextAlignmentLeft;
        _titleLabel[i].font=[UIFont systemFontOfSize:16];
        _titleLabel[i].tag=ShareSubviewTag;
        _titleLabel[i].textColor=[UIColor whiteColor];
    }
    _titleLabel[0].text=@"权 限";
    _titleLabel[1].text=@"标 题:";
    _titleLabel[2].text=@"概 述:";
    
    _titleInputField=[[UITextField alloc] init];
    _titleInputField.tag=ShareSubviewTag;
    _titleInputField.keyboardType = UIKeyboardTypeDefault;
    _titleInputField.font = [UIFont systemFontOfSize:14];
    _titleInputField.text=[self.fileName stringByDeletingPathExtension];
    _titleInputField.textColor=ShareEditViewFontColor;
    _titleInputField.autocorrectionType = UITextAutocorrectionTypeNo;
    _titleInputField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _titleInputField.returnKeyType = UIReturnKeyDone;
    _titleInputField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _titleInputField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _titleInputField.textAlignment=NSTextAlignmentRight;

    _introTextView=[[UITextView alloc] init];
    _introTextView.tag=ShareSubviewTag;
    _introTextView.font=[UIFont systemFontOfSize:14];
    _introTextView.textColor=ShareEditViewFontColor;
    _introTextView.layer.masksToBounds=YES;
    _introTextView.layer.cornerRadius=XBHCornerRadius;
    _introTextView.layer.borderColor=ShareEditViewFontColor.CGColor;
    _introTextView.layer.borderWidth=1;
    _introTextView.backgroundColor=[UIColor clearColor];
    
    
    
    _startbutton=[UIButton buttonWithType:UIButtonTypeCustom];
    [_startbutton setTitle:@"分享" forState:UIControlStateNormal];
    [_startbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_startbutton addTarget:self action:@selector(startbuttonPress) forControlEvents:UIControlEventTouchUpInside];
    _startbutton.backgroundColor=XBHButtonColor;
    _startbutton.layer.masksToBounds=YES;
    _startbutton.layer.cornerRadius=XBHCornerRadius;
    _startbutton.tag=ShareSubviewTag;

}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

-(void)clearSubView:(UITableViewCell *)cell{
    for (UIView *view in cell.subviews) {
        if (view.tag == ShareSubviewTag) {
            [view removeFromSuperview];
        }
    }

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
        return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat   rn=44;
    if (indexPath.row == 0) {
        rn= ShareEditViewRow1Height;
    }
    else if (indexPath.row == 1) {
        rn= ShareEditViewRow2Height;
    }
    else if(indexPath.row == 2){
         rn= ShareEditViewRow3Height;
    }
    return rn;

    
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Identifier = @"MyCells";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:Identifier];
        
    }
    [self clearSubView:cell];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (indexPath.row ==0 ) {
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle=UITableViewCellSelectionStyleGray;
        _titleLabel[0].frame=CGRectMake(15, 0, ShareEditViewTitleWidth, ShareEditViewRow1Height);
        [cell.contentView addSubview:_titleLabel[0]];
        cell.detailTextLabel.textColor=[UIColor whiteColor];
        cell.detailTextLabel.font=[UIFont systemFontOfSize:14];
        if (XBHAppDelegateInstance.shareQX == 1) {
            cell.detailTextLabel.text=@"公开";
        }
        else if (XBHAppDelegateInstance.shareQX == 2) {
            cell.detailTextLabel.text=@"好友可见";
        }
    }
    else if (indexPath.row ==1){
        _titleLabel[1].frame=CGRectMake(15, 0, ShareEditViewTitleWidth, ShareEditViewRow2Height);
        [cell.contentView addSubview:_titleLabel[1]];
        _titleInputField.frame=CGRectMake(25, 0, CGRectGetWidth(self.view.bounds)-25*2, ShareEditViewRow2Height);
        [cell.contentView addSubview:_titleInputField];
        
    }
    else if (indexPath.row ==2){
        
        _titleLabel[2].frame=CGRectMake(15, 0, ShareEditViewTitleWidth, 28);
        [cell.contentView addSubview:_titleLabel[2]];
        
        _introTextView.frame=CGRectMake(CGRectGetMaxX(_titleLabel[2].frame)+4, 10, CGRectGetWidth(self.view.bounds)-CGRectGetMaxX(_titleLabel[2].frame)-4-15, ShareEditViewRow3Height-2*10);
        [cell.contentView addSubview:_introTextView];
        
    }
    else if (indexPath.row ==4){
    
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
        QuanXianViewController *controller=[[QuanXianViewController alloc] initWithStyle:UITableViewStylePlain];
        [self.navigationController pushViewController:controller animated:YES];
    }

}



#pragma mark  --

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)comitEnd{
    XBHStopActivityWithView(self.view);
    [self.view makeToast:@"分享成功" duration:1.5 position:@"center"];
    [self performSelector:@selector(back) withObject:nil afterDelay:2.1];

}

-(void)startbuttonPress{
    XBHStartActivityWithView(self.view);
    [self performSelector:@selector(comitEnd) withObject:nil afterDelay:1.5];

}


@end
