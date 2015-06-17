//
//  fileUploadHeaderView.h
//  XBHEBProject
//
//  Created by xubh-note on 15/6/3.
//  Copyright (c) 2015年 xu banghui. All rights reserved.
//

#import <UIKit/UIKit.h>

#define UploadHeaderView_OptionHeight    (45)

#define UploadHeaderViewOffsetX         (15)
#define UploadHeaderViewOffsetY         (15)

#define UploadHeaderView_Key_Title      @"title"

#define UploadHeaderView_Key_Value      @"value"


#define UploadHeaderView_Key_Editable    @"enable"

@interface fileUploadHeaderView : UIView

- (instancetype)initWithFrame:(CGRect)frame KVArray:(NSArray *)sourceArray;

-(NSString *)textWithIndex:(NSUInteger)index;
@end
