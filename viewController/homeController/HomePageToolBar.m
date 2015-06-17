//
//  HomePageToolBar.m
//  gwEdu
//
//  Created by xubh-note on 14-7-18.
//  Copyright (c) 2014年 gwsoft. All rights reserved.
//

#import "HomePageToolBar.h"
#import <QuartzCore/QuartzCore.h>

#define TEXT_COLOR  [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0]

#define SEL_TEXT_COLOR  [UIColor colorWithRed:237.0/255.0 green:85.0/255.0 blue:101.0/255.0 alpha:1.0]


#define TEXT_FONT_PT           10

#define TEXT_FONT         [UIFont systemFontOfSize:TEXT_FONT_PT]

#define MessageButtonWH         (20)

#define BORDER_BUTTOM           (3)

#define BORDER_UP               (7)

@implementation HomePageToolBar
{
    NSMutableArray          *mButtonArray;
    CGFloat                 mWidth;
    UIView                 *mLine;
    UIButton                *mMessageNumView;
}

@synthesize mCursel=_mCursel;
@synthesize delegate;
@synthesize mMessageNum=_mMessageNum;

- (void)dealloc
{
    [mButtonArray release];
    [super dealloc];
}
- (id)init
{
    return [self initWithFrame:CGRectZero];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        mButtonArray=[[NSMutableArray alloc] initWithCapacity:2];
        
        self.layer.masksToBounds=YES;
        self.layer.borderWidth=1.f;
        self.layer.borderColor=[UIColor colorWithRed:229.0/255.0 green:229.0/255.0 blue:229.0/255.0 alpha:1.0].CGColor;
        self.backgroundColor=[UIColor whiteColor];
        
        
        
        for (int i=0; i<4; i++) {
            UIButton  *butn=[UIButton buttonWithType:UIButtonTypeCustom ];
            butn.tag=i;
            butn.titleLabel.font=TEXT_FONT;
            butn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
            butn.contentVerticalAlignment=UIControlContentVerticalAlignmentTop;
            [butn addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:butn];
            [mButtonArray addObject:butn];
           
        }
        
        
        mMessageNumView=[UIButton buttonWithType:UIButtonTypeCustom];
        mMessageNumView.backgroundColor=NavigationBarColor;
        mMessageNumView.titleLabel.textColor=[UIColor whiteColor];
        mMessageNumView.titleLabel.font=[UIFont systemFontOfSize:10];
        mMessageNumView.titleLabel.adjustsFontSizeToFitWidth=YES;
        mMessageNumView.userInteractionEnabled=NO;
        mMessageNumView.layer.masksToBounds=YES;
        mMessageNumView.layer.cornerRadius=MessageButtonWH/2;
        
        //[mMessageNumView setBackgroundImage:GWImageWithNamed(@"xiaoxi.png") forState:UIControlStateNormal];
        mMessageNumView.hidden=YES;
        [self addSubview:mMessageNumView];
        
        
        //分割线
       mLine=[[UIView alloc] init];
        mLine.backgroundColor=[UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0];
        [self addSubview:mLine];
        [mLine release];
        
        
        
    }
    return self;
}
-(void)buttonPress:(id)sender{
    UIButton *bt=(UIButton*)sender;
    if (_mCursel == bt.tag) {
        return;
    }
    _mCursel=bt.tag;
    
    
    
    if ([delegate respondsToSelector:@selector(HomePageToolBarDidSelect:)]) {
        [delegate HomePageToolBarDidSelect:bt.tag];
        [self setNeedsDisplay];
    }
    

}

-(void)setMCursel:(NSUInteger)mCursel{
    _mCursel=mCursel;
   // [self setOptions];

}

-(void)setMMessageNum:(NSUInteger)mMessageNum{

    _mMessageNum=mMessageNum;
    if (_mMessageNum>0) {
        mMessageNumView.hidden=NO;
    }
    else{
        mMessageNumView.hidden=YES;
       
    }
    [self setNeedsDisplay];
    
    
    
    
}

-(void)setOptions{
    
    
    for (int i=0; i<[mButtonArray count]; i++) {
        UIButton  *butn=[mButtonArray objectAtIndex:i];
        UIImage    *normalImg=nil;
        UIImage    *selImg=nil;
        NSString   *title=nil;
        if (0==i) {
            title=@"校园";
            normalImg=GWImageWithNamed(@"ico_school.png");
            selImg=GWImageWithNamed(@"ico_school_1.png");
  
        }
        else if (1==i) {
            title=@"消息";
            normalImg=GWImageWithNamed(@"ico_message.png");
            selImg=GWImageWithNamed(@"ico_message_1.png");
            
        }
        else if (2==i) {
            title=@"资料";
            normalImg=GWImageWithNamed(@"ico_source.png");
            selImg=GWImageWithNamed(@"ico_source_1.png");

        }
        else if (3==i) {
            title=@"工具";
            normalImg=GWImageWithNamed(@"ico_tool.png");
            selImg=GWImageWithNamed(@"ico_tool_1.png");
            
        }
        [butn setTitle:title forState:UIControlStateNormal];
        
        butn.imageEdgeInsets=UIEdgeInsetsMake(0,(CGRectGetWidth(butn.frame)-normalImg.size.width/2)/2, CGRectGetHeight(butn.frame)-normalImg.size.height/2, (CGRectGetWidth(butn.frame)-normalImg.size.width/2)/2);
        
        CGSize fontSize=[title XBHStringSizeWithFont:TEXT_FONT];
        
        //text 靠左时(因为文本的起始x 是imgframe的maxX)
        CGFloat textXOffset=-(butn.imageEdgeInsets.left+normalImg.size.width/2);
        
        CGFloat FF=(CGRectGetWidth(butn.frame)-fontSize.width)/2;
       
        CGFloat itOffset=0;
        if (normalImg.size.width/2>fontSize.width) {
            //保证和图片居中(图片比字体宽的话 字体居中在图片中间)
            itOffset=(normalImg.size.width/2-fontSize.width)/2;
        }
        
        butn.titleEdgeInsets=UIEdgeInsetsMake(CGRectGetHeight(butn.frame)-fontSize.height, FF+textXOffset+itOffset, 0, 0);
        
         
        
    
        
        
        if (i == _mCursel) {
            [butn setTitleColor:SEL_TEXT_COLOR forState:UIControlStateNormal];
            [butn setImage:selImg forState:UIControlStateNormal];
        }
        else{
            [butn setTitleColor:TEXT_COLOR forState:UIControlStateNormal];
            [butn setImage:normalImg forState:UIControlStateNormal];
        }
    
    }
    

}

-(void)layoutSubviews{
    [super layoutSubviews];
    mLine.frame=CGRectMake(0, 0, CGRectGetWidth(self.bounds), XBHLineHeight);
    CGFloat w=CGRectGetWidth(self.bounds)/4;
    CGFloat y=CGRectGetMaxY(mLine.frame)+BORDER_UP;
   
    
    
    for (int i=0; i<[mButtonArray count]; i++) {
        UIButton  *butn=[mButtonArray objectAtIndex:i];
        butn.frame=CGRectMake(i*w, y, w, CGRectGetHeight(self.bounds)-y-BORDER_BUTTOM);
        if (1==i) {
            mMessageNumView.frame=CGRectMake(CGRectGetMinX(butn.frame)+(CGRectGetWidth(butn.frame) -MessageButtonWH)/2+10, CGRectGetMinY(butn.frame)+4, MessageButtonWH, MessageButtonWH);
        }
    }

}



-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    [self setOptions];
    if (_mMessageNum>0) {
        [mMessageNumView setTitle:[NSString stringWithFormat:@"%d",(uint32_t)_mMessageNum] forState:UIControlStateNormal];
    }

}


@end
