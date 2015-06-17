//
//  HomePageViewController.m
//  gwEdu
//
//  Created by xubh-note on 14-7-17.
//  Copyright (c) 2014年 gwsoft. All rights reserved.
//

#import "HomePageViewController.h"
#import "rightViewController.h"
#import "loginShowView.h"
#import "HomePageToolBar.h"
#import "commonInclude.h"
#import "userSchoolInfoView.h"
#import "mySourceViewController.h"

#import "centerViewController.h"
#import "mySetupViewController.h"
#import "XBHPopFadeView.h"

#import "GWMessageManager.h"
#import "GWMessageSessionNotify.h"
#import "sourceClassViewController.h"
#import "GWMessageSession.h"

#import "UIChatViewController.h"
#import "centerViewController.h"
#import "UserCardView.h"
#import "sourceDownloadViewController.h"


@interface HomePageViewController ()<HomePageToolBarDelegate,UserCardViewDelegate>

@property   (nonatomic,retain)  UIView       *mContentView;

@property   (nonatomic,retain)  UIViewController       *mContentController;




@end

@implementation HomePageViewController{
   
    HomePageToolBar     *mToolBar;
    CGRect              mToolBarFrame;
    CGRect              mContentViewFrame;
    UserCardView        *mCardView;
    BOOL                mbFirstInto;
}
@synthesize mShowIndex;
@synthesize mContentController;
@synthesize mContentView;
- (void)dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.mContentView=nil;
    self.mContentController=nil;
    [mToolBar release];
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if (self.isViewLoaded &&!self.view.window) {
        self.view=nil;
        
    }
}

-(void)setTitleWithIndex:(NSUInteger)index{
    if (0==index) {
    
        [gwEdu_APP setNavigtionBarBg:self title:@"校园" titleFont:[UIFont boldSystemFontOfSize:18]];
    }
    else if (1==index){
        [gwEdu_APP setNavigtionBarBg:self title:@"消息" titleFont:[UIFont boldSystemFontOfSize:18] ];
    }
    else if (2==index){
        [gwEdu_APP setNavigtionBarBg:self title:@"资料" titleFont:[UIFont boldSystemFontOfSize:18]];
    }
    else if (3==index){
        [gwEdu_APP setNavigtionBarBg:self title:@"工具" titleFont:[UIFont boldSystemFontOfSize:18]];
    }
    
    
    
    if (index==0) {
        [gwEdu_APP setLeftItemOfNavigationWithImage:GWImageWithNamed(@"ico_set.png") highLightImage:GWImageWithNamed(@"ico_set_hl.png") imageSize:CGSizeMake(25, 25) itemIcon:nil viewController:self title:nil];
    }
    else if(index == 2){
        [gwEdu_APP setRightDownloadEnterItemWithViewController:self];
    }

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    mbFirstInto=YES;
    
    mToolBar=[[HomePageToolBar alloc] init];
    mToolBar.delegate=self;
    mToolBar.backgroundColor=[UIColor colorWithRed:248.0/255.0 green:248.0/255.0 blue:248.0/255.0 alpha:1.0];
    [self.view addSubview:mToolBar];

    mContentViewFrame=self.view.bounds;
    if (IOS7SYSTEMVERSION_OR_LATER) {
        mContentViewFrame.size.height-=20+44+HOMEPAGETOOLBARH;
        mToolBarFrame=CGRectMake(0, self.view.bounds.size.height-HOMEPAGETOOLBARH-20-44, self.view.bounds.size.width, HOMEPAGETOOLBARH);
    }
    else{
        mContentViewFrame.size.height-=44+HOMEPAGETOOLBARH;
        mToolBarFrame=CGRectMake(0, self.view.bounds.size.height-44-HOMEPAGETOOLBARH, self.view.bounds.size.width, HOMEPAGETOOLBARH);
    }
    
    
    
    mToolBar.frame=mToolBarFrame;
    
    
    //消息通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(haveReceiveMessage) name:GWMessageSessionSDKReceiveMessages object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(haveReceiveMessage) name:GWMessageSessionSDKReceiveHistoryMessages object:nil];
    
    
    
    
    
}

-(void)haveReceiveMessage{
    [self refreshMessageNotify];
}

-(NSUInteger)totalMessage{
    NSUInteger  num=0;
    GWMessageManager *mgr=[[GWMessageManager alloc] initWithLoginUserId:[CommunicateBase GetCureentUserId]];
    
    num=[mgr getUnReadMessageNumWithSessionMode:SessionMode_UserChat SpecialId:0];
    num+=[mgr getUnReadMessageNumWithSessionMode:SessionMode_Group SpecialId:0];
    [mgr release];
    return num;
}

-(void)refreshMessageNotify{
   
    if (self.view.window ) {
        mToolBar.mMessageNum=[self totalMessage];
    }

}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (mbFirstInto
        ||(!isOwnerAccountLogin() &&![self.mContentView isKindOfClass:[loginShowView class]] )) {//非用户登录且不是显示登录界面
        mbFirstInto=NO;
        [self showContentWithIndex:self.mShowIndex];
    }
    
    
    if (self.mContentController) {
        [self.mContentController viewWillAppear:animated];
    }
    else if (self.mContentView){
        [self.mContentView setNeedsDisplay];
    }
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    mToolBar.mMessageNum=0;
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self refreshMessageNotify];
    if (!CGRectEqualToRect(mToolBar.frame, mToolBarFrame)) {
        CGRect temp=mToolBarFrame;
        temp.origin.y+=temp.size.height;
        mToolBar.frame=temp;
        mToolBar.alpha=0;
        [UIView animateWithDuration:0.3 animations:^{
            mToolBar.frame=mToolBarFrame;
            mToolBar.alpha=1.0;
            if (self.mContentView) {
                self.mContentView.frame=mContentViewFrame;
            }
            
        } completion:^(BOOL finished) {
            
            
        }];
    }
    
    
    
    if ([self.mContentController isKindOfClass:[sourceClassViewController class]]){
        //刷新下 下载列表个数
        [gwEdu_APP setRightDownloadEnterItemWithViewController:self];
    
    }
   
}

-(void)enabelRightUserCardIcon{
    UIImage *rightImg=GWImageWithNamed(@"ico_userCard.png");
    [gwEdu_APP setRightItemOfNavigationWithImage:rightImg highLightImage:GWImageWithNamed(@"ico_userCard_hl.png") imageSize:CGSizeMake([rightImg size].width/2, [rightImg size].height/2) itemIcon:nil viewController:self title:nil];
    


}


- (void)toggleLeftViewAnimated{
    mySetupViewController  *controller=[[[mySetupViewController alloc] init] autorelease];
 /*
    UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:controller];
    
    nav.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;
    [gwEdu_APP presentModalViewController:nav selfViewController:self animated:YES completion:NULL];
  [nav release];
  */
    [[gwEdu_APP getApp] homePageNavigationControllerPushWithController:controller];

}
- (void)toggleRightViewAnimated{
    if ([self.mContentController isKindOfClass:[sourceClassViewController class]]) {
        sourceDownloadViewController *controller=[[sourceDownloadViewController alloc] init];
        controller.mTitleName=@"下载列表";
        controller.mbIsNotifyNormal=YES;
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];

    }
    else
        [self homePageShowUserCardWithOrientation:UIDeviceOrientationLandscapeLeft];
    

}

-(void)homePageShowUserCardWithOrientation:(UIDeviceOrientation)orient{
    if ([self.mContentView isKindOfClass:[userSchoolInfoView class]]) {
        if (!mCardView) {
            mCardView=[[[UserCardView alloc] init] autorelease];
            mCardView.delegate=self;
            
        }
        UserInfo *uInfo=((userSchoolInfoView *)self.mContentView).mUserInfo;
        UserCardInfo *cInfo=((userSchoolInfoView *)self.mContentView).mCardInfo;
        
        [mCardView setUserInfo:uInfo CardInfo:cInfo];
        [mCardView showUserCardWithPresentedView:self.navigationItem.rightBarButtonItem.customView UIDeviceOrientation:orient];
    }

}
-(void)userCardViewWillDisapper{
    mCardView=nil;
}



-(void)hiddenToolBar:(void(^)(void))compelete{
    CGRect rect=mToolBarFrame;
    rect.origin.y+=rect.size.height;
    
    CGRect temp=mContentViewFrame;
    temp.size.height+=mToolBarFrame.size.height;

    [UIView animateWithDuration:0.2 animations:^{
        mToolBar.frame=rect;
        if (self.mContentView) {
            self.mContentView.frame=temp;
        }

        
    } completion:^(BOOL finished) {
        if (compelete) {
            compelete();
        }
    }];

}

-(void)showContentWithIndex:(NSUInteger)index{
    @autoreleasepool {
        self.mShowIndex=index;
        self.navigationItem.leftBarButtonItem=nil;
        self.navigationItem.rightBarButtonItem=nil;
        [self setTitleWithIndex:index];
        [self.mContentView removeFromSuperview];
        self.mContentController=nil;
        self.mContentView=nil;
       
        if (0==index) {//校园
            if (isOwnerAccountLogin()) {
                self.mContentView=[[[userSchoolInfoView alloc] initWithFrame:mContentViewFrame] autorelease];
                [self enabelRightUserCardIcon];
            }
            else{
                self.mContentView=[[[loginShowView alloc] initWithFrame:mContentViewFrame] autorelease];
                
            }
            [self refreshMessageNotify];
        }
        else if (1==index){//消息
            self.mContentController=[[[centerViewController alloc] init] autorelease];
            self.mContentView=self.mContentController.view;
        }
        else if (2==index){//资源
            self.mContentController=[[[sourceClassViewController alloc] init] autorelease];
            self.mContentView=self.mContentController.view;
            
        }
        else if (3==index){//工具
            self.mContentController=[[[rightViewController alloc] init] autorelease];
            self.mContentView=self.mContentController.view;
            
            
            
        }
        if (self.mContentView) {
            
            [self.view addSubview:self.mContentView];
            self.mContentView.frame=mContentViewFrame;
            mToolBar.mCursel=index;
          
        }

    }
   
   
    
}

#pragma mark

-(void)HomePageToolBarDidSelect:(NSUInteger)index{
      [self showContentWithIndex:index];

}



@end
