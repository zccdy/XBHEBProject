//
//  TagListViewController.m
//  XBHEBProject
//
//  Created by xubh-note on 15/5/18.
//  Copyright (c) 2015年 xu banghui. All rights reserved.
//

#import "TagListViewController.h"
#import "TagViewCell.h"
#import "TagInputView.h"

#define TagSeparator                    @" "



@interface TagListViewController ()<TagViewCellDelegate,TagInputViewDelegate,TagInputViewDelegate>

@end

@implementation TagListViewController
{
    
    NSMutableArray             *_hotTagArray;
   
    TagInputView                *_inputView;
    
}
@synthesize aleardySelecteTags=_aleardySelecteTags;

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"标签";
    self.tableView.backgroundColor=XBHUIPageColor;
    self.tableView.tableFooterView=[[UIView alloc] init];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight=TagViewCell_TagitemHeight+15;
    
    if (!self.aleardySelecteTags) {
        self.aleardySelecteTags=[NSMutableArray array];
    }
    
    
    _hotTagArray=[NSMutableArray arrayWithArray:@[@"中国",@"反腐",@"习近平",@"马克思列宁",@"倚天屠龙记",@"拍案惊奇",@"三国志",@"蜀山",@"孙子兵法",@"本经阴符",@"二十四史",@"出师表",@"孟德新书",@"碟恋花"]];
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //  [[IQKeyboardManager sharedManager] setEnable:NO];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    if ([self.delegate respondsToSelector:@selector(TagListViewControllerDidSeletionTitles:)]) {
        [self.delegate TagListViewControllerDidSeletionTitles:self.aleardySelecteTags];
    }
}

#pragma mark - Table view data source

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.backgroundColor=[UIColor clearColor];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return InputViewHeight;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
   
    UILabel *label=[[UILabel alloc] init];
    label.font=XBHSysFont(14);
    label.textAlignment=NSTextAlignmentLeft;
    label.backgroundColor=XBHSeparatorColor;
    label.textColor=[UIColor whiteColor];
    
    
    if (0== section) {
        
        label.text=@"  已选标签";
        
    }
    else if (1== section){
        label.text=@"  自定义";
        
    }
    else if (2== section){
        label.text=@"  热门标签";
        
    }
        
    
    return label;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat   h=TagViewCell_TagitemHeight+2*TagViewCell_OffsetY;
    if (0==indexPath.section
        &&[_aleardySelecteTags count]) {
        [TagViewCell tagDictArrayWithTitleArray:_aleardySelecteTags layoutWidth:CGRectGetWidth(self.view.bounds) needHeight:&h editable:YES];
        
    }
    else if (1==indexPath.section){
        h= InputViewHeight+10;
    }
    else if (2==indexPath.section
             &&[_hotTagArray count]) {
        [TagViewCell tagDictArrayWithTitleArray:_hotTagArray layoutWidth:CGRectGetWidth(self.view.bounds) needHeight:&h editable:NO];
    }
    
    
    return h;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static  NSString *indentifier=@"tagCells";
    
    static  NSString *indentifier1=@"buildTagCell";
    
    if (1== indexPath.section) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier1 ];
        if (!cell) {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier1];
            if (!_inputView) {
                _inputView= [[TagInputView alloc] initWithFrame:CGRectMake(5, 5, CGRectGetWidth(self.view.bounds)-10, InputViewHeight)];
                _inputView.delegate=self;
            }
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            [cell.contentView addSubview: _inputView];
        }
        return cell;
    }
    
    
    TagViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier ];
    if (!cell) {
        cell=[[TagViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
        cell.delegate=self;
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.tag=indexPath.section;
    if (0 == indexPath.section
        &&[_aleardySelecteTags count]) {
        [cell setTagsTitle:_aleardySelecteTags layoutWidth:CGRectGetWidth(self.view.bounds) editable:YES];
    }
    else  if (2 == indexPath.section) {
        [cell setTagsTitle:_hotTagArray layoutWidth:CGRectGetWidth(self.view.bounds)];
    }
    
    
    
    return cell;
}


-(void)addToSearchArray:(NSString *)text{
    
    if (![_aleardySelecteTags containsObject:text]) {
        [_aleardySelecteTags addObject:text];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    }
    
}

#pragma mark --

-(void)TagViewCell:(TagViewCell *)cell DidSelectString:(NSString *)str editable:(BOOL)edit{
    if (edit) {
        
        [_aleardySelecteTags removeObject:str];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        
    }
    else{
        [self addToSearchArray:str];
        
    }
    
    
}

-(void)TagInputViewDidInput:(NSString *)text{
    [self addToSearchArray:text];
    _inputView.inputField.text=nil;
}




@end


