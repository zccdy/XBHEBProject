//
//  fileUploadHeaderView.m
//  XBHEBProject
//
//  Created by xubh-note on 15/6/3.
//  Copyright (c) 2015年 xu banghui. All rights reserved.
//

#import "fileUploadHeaderView.h"
#import <Masonry.h>

@implementation fileUploadHeaderView
{
    NSMutableArray          *_optionArray;

}
- (instancetype)initWithFrame:(CGRect)frame KVArray:(NSArray *)sourceArray
{
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque=NO;
        UIImage       *img=XBHHomeBundleImageWithName(@"headerBg");
        UIImageView   *bg=[[UIImageView alloc] initWithImage:img];
        bg.userInteractionEnabled=YES;
        [self addSubview:bg];
        [bg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).mas_equalTo(UIEdgeInsetsMake(UploadHeaderViewOffsetY, UploadHeaderViewOffsetX, UploadHeaderViewOffsetY, UploadHeaderViewOffsetX));
        }];
        
        if (![sourceArray count]) {
            return self;
        }
        _optionArray=[NSMutableArray   array];
        __block   UITextField       *prevField=nil;
        
        [sourceArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSDictionary   *dict=(NSDictionary  *)obj;
            UITextField   *field=[[UITextField alloc] init];
            field.font = XBHSysFont(12);
            field.textAlignment=NSTextAlignmentLeft;
            field.textColor=[UIColor whiteColor];
            field.text=dict[UploadHeaderView_Key_Value];
            field.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            
            UILabel   *label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 90, 20)];
            label.textColor=[UIColor whiteColor];
            label.text=dict[UploadHeaderView_Key_Title];
            label.font=XBHSysFont(13);
            field.leftViewMode=UITextFieldViewModeAlways;
            field.leftView=label;
            
            
            if ([dict[UploadHeaderView_Key_Editable] boolValue]) {
                field.keyboardType = UIKeyboardTypeDefault;
                field.autocorrectionType = UITextAutocorrectionTypeNo;
                field.autocapitalizationType = UITextAutocapitalizationTypeNone;
                field.returnKeyType = UIReturnKeyDone;
                field.clearButtonMode = UITextFieldViewModeWhileEditing;
            }
            else{
                field.userInteractionEnabled=NO;
            }
            [bg addSubview:field];
            [_optionArray addObject:field];
            
            if (prevField) {
                [field mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(prevField.mas_bottom);
                    make.left.and.right.mas_equalTo(40);
                    make.height.mas_equalTo(UploadHeaderView_OptionHeight);
                }];
            }
            else{
                [field mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(bg.mas_top).mas_equalTo(10);
                    make.left.and.right.mas_equalTo(40);
                    make.height.mas_equalTo(UploadHeaderView_OptionHeight);
                }];

            }
            prevField=field;
        }];
        
        UIView  *line=[[UIView alloc] init];
        line.backgroundColor=XBHSeparatorColor;
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(15));
            make.bottom.equalTo(self.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(CGRectGetWidth(frame)-15, 1));
            
        }];
              
    }
    return self;
}

-(NSString *)textWithIndex:(NSUInteger)index{
    if (index >=_optionArray.count) {
        return nil;
    }
    UITextField *field=_optionArray[index];
    return field.text;
}

@end
