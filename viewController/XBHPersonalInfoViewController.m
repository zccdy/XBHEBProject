//
//  XBHPersonalInfoViewController.m
//  XBHEBProject
//
//  Created by xubh-note on 15/3/23.
//  Copyright (c) 2015年 xu banghui. All rights reserved.
//

#import "XBHPersonalInfoViewController.h"
#import "UITableView+XBHImageParallax.h"
#import "UINavigationBar+XBHDynamicEffect.h"

@interface XBHPersonalInfoViewController ()

@end

@implementation XBHPersonalInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.refreshViewType=XHPullDownRefreshViewTypeActivityIndicator;
    self.indicatorColor=[UIColor redColor];
    
    self.view.backgroundColor=[UIColor grayColor];
    [self.tableView setParallaxImage:[UIImage imageNamed:@"san"] ParallaxMode:XBHImageParallaxMode_Scale];
    [self.navigationController.navigationBar registerScrollerView:self.tableView backgroundColor:[UIColor redColor]];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar de_reset];
    [self.tableView cancelParallax];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    
    cell.textLabel.text = [NSString stringWithFormat:@"Cell %d",(int)indexPath.row + 1];
    
    return cell;
}




@end
