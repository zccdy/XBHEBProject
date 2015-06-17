//
//  ViewController.m
//  XBHEBProject
//
//  Created by xubh-note on 15/3/17.
//  Copyright (c) 2015年 xu banghui. All rights reserved.
//

#import "ViewController.h"

#import <Masonry.h>
@interface ViewController ()

@end

@implementation ViewController
{
    UITextView     *textView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.view.backgroundColor=[UIColor lightGrayColor];
    textView.layer.borderColor=[UIColor whiteColor].CGColor;
    textView.layer.borderWidth=1;
    textView=[[UITextView alloc] initWithFrame:CGRectMake(15, 130, CGRectGetWidth(self.view.bounds)-15*2, 300)];
    
    textView.text=@"Mention @iamjackiecheung if you use JKRichTextView in your project[lol]. Thanks[cry].";
    /*
    [textView setCustomLinkWithLinkDidTappedCallback:^BOOL (NSURL *linkURL) {
        
        [[[UIAlertView alloc] initWithTitle:nil message:@"Thank you for using JKRichTextView" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles: nil] show];
        return YES;
        
    } forTextAtRange:[textView.text rangeOfString:@"JKRichTextView"]];
    
    */
   
    [self.view addSubview:textView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}





@end
