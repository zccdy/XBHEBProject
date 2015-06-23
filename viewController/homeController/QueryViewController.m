//
//  QueryViewController.m
//  XBHEBProject
//
//  Created by xubh-note on 15/4/26.
//  Copyright (c) 2015年 xu banghui. All rights reserved.
//

#import "QueryViewController.h"
#import "TagViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import <Masonry.h>
#import "sourceDownloadViewController.h"
//#import <IQKeyboardReturnKeyHandler.h>
#import <IQKeyboardManager.h>
#import "TagInputView.h"
#pragma mark -

@protocol SeacherLabelDelegate <NSObject>

@optional
-(void)SeacherLabelButtonPress;

@end


@interface SeacherLabel : UIView
@property   (nonatomic,strong,readonly)         UIButton        *searcherButton;
@property   (nonatomic,strong,readonly)         UILabel        *textLabel;
@property   (nonatomic,weak)                    id<SeacherLabelDelegate>    delegate;
@end

@implementation SeacherLabel
{
    UILabel         *_label;
    UIButton        *_button;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.userInteractionEnabled=YES;
        self.opaque=NO;
        
        
        
        
        
        _button=[UIButton buttonWithType:UIButtonTypeCustom];
        [_button setImage:XBHHomeBundleImageWithName(@"icon_query") forState:UIControlStateNormal];
        _button.opaque=NO;
        [_button addTarget:self action:@selector(buttonPress) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_button];
        
        
        
        [_button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).mas_equalTo(-12.5);
            make.height.equalTo(self.mas_height);
            make.width.mas_equalTo(60);
            
        }];
        
        
        _label=[[UILabel alloc] init];
        [self addSubview:_label];
        [_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.top.bottom.equalTo(self);
            make.right.equalTo(_button.mas_left);
        }];

        
    }
    return self;
}

-(UILabel *)textLabel{

    return _label;
}


-(UIButton *)searcherButton{

    return _button;
}
-(void)buttonPress{

    if ([self.delegate respondsToSelector:@selector(SeacherLabelButtonPress)]) {
        [self.delegate SeacherLabelButtonPress];
    }

}
-(void)layoutSubviews{
    [super layoutSubviews];
    
    
 //   _button.frame=CGRectMake(CGRectGetWidth(self.bounds)-60-25, 0, 60, CGRectGetHeight(self.bounds));
}

@end


#pragma mark --





@interface QueryViewController ()<TagViewCellDelegate,TagInputViewDelegate,SeacherLabelDelegate,TagInputViewDelegate>

@end

@implementation QueryViewController
{

    NSMutableArray             *_hotTagArray;
    NSMutableArray             *_seachTagArray;
    TagInputView                *_inputView;
    SeacherLabel                *_searchLabel;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor=XBHUIPageColor;
    self.tableView.tableFooterView=[[UIView alloc] init];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight=TagViewCell_TagitemHeight+15;


    _seachTagArray=[NSMutableArray array];
    
    _hotTagArray=[NSMutableArray arrayWithArray:@[@"中国",@"反腐",@"习近平",@"马克思列宁",@"倚天屠龙记",@"拍案惊奇",@"三国志",@"蜀山",@"孙子兵法",@"本经阴符",@"二十四史",@"出师表",@"孟德新书",@"碟恋花"]];

    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    CGRect frame= [UIScreen mainScreen].bounds;
    frame.size.height-=self.tabBarController.tabBar.frame.size.height+44+20;
    self.tableView.frame=frame;
    

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
  //  [[IQKeyboardManager sharedManager] setEnable:NO];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
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
    UIView    *view=nil;
    if (0== section) {
        if (!_searchLabel) {
            _searchLabel=[[SeacherLabel alloc] init];
            
            _searchLabel.textLabel.font=XBHSysFont(14);
            _searchLabel.textLabel.textAlignment=NSTextAlignmentLeft;
            _searchLabel.backgroundColor=XBHSeparatorColor;
            _searchLabel.textLabel.textColor=[UIColor whiteColor];
            _searchLabel.delegate=self;
            _searchLabel.textLabel.text=@"  根据标签查询";
            
          

        }
      
        view=_searchLabel;
    }
    else{
        UILabel *label=[[UILabel alloc] init];
        label.font=XBHSysFont(14);
        label.textAlignment=NSTextAlignmentLeft;
        label.backgroundColor=XBHSeparatorColor;
        label.textColor=[UIColor whiteColor];
        
        

        if (1== section){
            label.text=@"  自定义";
            
        }
        else if (2== section){
            label.text=@"  热门标签";
            
        }

        view=label;
    }
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    CGFloat   h=TagViewCell_TagitemHeight+2*TagViewCell_OffsetY;
    if (0==indexPath.section
        &&[_seachTagArray count]) {
        [TagViewCell tagDictArrayWithTitleArray:_seachTagArray layoutWidth:CGRectGetWidth(self.view.bounds) needHeight:&h editable:YES];
        
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
        cell.mNotifyString=@"编辑或选择查询标签";
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.tag=indexPath.section;
    if (0 == indexPath.section
        &&[_seachTagArray count]) {
        [cell setTagsTitle:_seachTagArray layoutWidth:CGRectGetWidth(self.view.bounds) editable:YES];
    }
    else  if (2 == indexPath.section) {
        [cell setTagsTitle:_hotTagArray layoutWidth:CGRectGetWidth(self.view.bounds)];
    }

    
    
    return cell;
}


-(void)addToSearchArray:(NSString *)text{
    if ([_seachTagArray count]<6) {
        if (![_seachTagArray containsObject:text]) {
            [_seachTagArray addObject:text];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        }

    }
    else{
        UIAlertView    *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"查询标签最多6个" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
        [alert show];
    
    }

}

#pragma mark --

-(void)TagViewCell:(TagViewCell *)cell DidSelectString:(NSString *)str editable:(BOOL)edit{
    if (edit) {
  
       [_seachTagArray removeObject:str];
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

#pragma mark -

-(void)SeacherLabelButtonPress{
    XBHStartActivityWithView(self.view);
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(queryEnd) withObject:nil afterDelay:1.5];
}


-(void)queryEnd{
    XBHStopActivityWithView(self.view);
    [self.navigationController pushViewController:[[sourceDownloadViewController alloc] init] animated:YES];
}





@end
