//
//  XBHKVView.h
//  gwEdu
//
//  Created by xubh-note on 15/2/6.
//  Copyright (c) 2015年 gwsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

#define XBHKVView_TitleFontSize       (14)

#define XBHKVView_OffsetX     (15)

#define XBHKVView_OffsetY     (15)

#define XBHKVView_TitleW      (XBHKVView_TitleFontSize*6)

#define XBHKVView_Space       (10)


#define XBHKVView_TitleFont     [UIFont systemFontOfSize:XBHKVView_TitleFontSize]

#define XBHKVView_IntroFont     [UIFont systemFontOfSize:13]


#define XBHKVView_IntroMaxW(_V)   (_V-XBHKVView_OffsetX*2-XBHKVView_Space-XBHKVView_TitleW)

@protocol XBHKVViewDelegate <NSObject>

@optional

-(void)XBHKVViewPhoneNumberDidTap:(NSString *)number;

@end


@interface XBHKVView : UIView


@property   (nonatomic,strong,readonly)      UILabel        *mTitleLabel;

@property   (nonatomic,strong,readonly)      UILabel        *mTextContentLabel;

@property   (nonatomic)             BOOL            mbIsPhone;

@property   (nonatomic,assign)      id<XBHKVViewDelegate>  delegate;
@end
