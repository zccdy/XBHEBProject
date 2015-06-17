//
//  XBHSearchTableViewController.m
//  XBHEBProject
//
//  Created by xubh-note on 15/4/28.
//  Copyright (c) 2015年 xu banghui. All rights reserved.
//

#import "XBHSearchTableViewController.h"

@interface XBHSearchTableViewController ()<UISearchDisplayDelegate,UISearchBarDelegate>

@end

@implementation XBHSearchTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView=[[UIView alloc] init];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width-50, 40)];
    self.searchBar.delegate=self;
    self.searchBar.placeholder = @"输入查询字段";
    self.searchBar.translucent=YES;
    self.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    
    self.searchBar.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    
    self.searchBar.showsScopeBar = NO;
    
    self.searchBar.keyboardType = UIKeyboardTypeNamePhonePad;
    self.searchBar.barTintColor=[UIColor lightGrayColor];
    
    self.tableView.tableHeaderView = self.searchBar;
    
    if (self.dispalyContentsController) {
        self.searchDispalyCtrl = [[UISearchDisplayController  alloc] initWithSearchBar:self.searchBar contentsController:self.dispalyContentsController];
    }
    else{
        self.searchDispalyCtrl = [[UISearchDisplayController  alloc] initWithSearchBar:self.searchBar contentsController:self];
    }
    
    self.searchDispalyCtrl.active = NO;
    
    self.searchDispalyCtrl.delegate = self;
    
    self.searchDispalyCtrl.searchResultsDelegate=self;
    
    self.searchDispalyCtrl.searchResultsDataSource = self;
    

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
 
 - (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
 [UIView animateWithDuration:0.25 animations:^{
 self.navigationController.navigationBarHidden=YES;
 [searchdispalyCtrl setActive:YES animated:NO];
 
 }];
 return YES;
 }
 */

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    if (IOS7SYSTEMVERSION_OR_LATER) {
        for(id cc in [searchBar.subviews[0] subviews])
        {
            if([cc isKindOfClass:[UIButton class]])
            {
                UIButton *btn = (UIButton *)cc;
                [btn setTitle:@"取消" forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
        }
        
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
    // self.navigationController.navigationBarHidden=NO;
    
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    
}


#pragma mark -

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString

{ for(UIView *subview in controller.searchResultsTableView.subviews) {
    
    if([subview isKindOfClass:[UILabel class]]) {
        
        [(UILabel*)subview setText:@"无结果"];
        
    }
    
}
    return YES;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}



@end
