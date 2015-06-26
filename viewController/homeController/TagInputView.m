//
//  TagInputView.m
//  XBHEBProject
//
//  Created by xubh-note on 15/6/16.
//  Copyright (c) 2015年 xu banghui. All rights reserved.
//
#import <Masonry.h>
#import "TagInputView.h"

@interface TagInputView ()<UITextFieldDelegate>

@end



@implementation TagInputView
{
    UITextField         *_field;
    

}
-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        
        self.userInteractionEnabled=YES;
        self.opaque=NO;
        _field=[XBHUitility createTextfieldWithTextColor:[UIColor whiteColor] font:XBHSysFont(13) placeholderColor:[UIColor lightGrayColor] placeholder:@"编辑标签"];
        _field.backgroundColor = [UIColor clearColor];
        _field.layer.masksToBounds=YES;
        _field.layer.cornerRadius=6.0;
        _field.layer.borderColor=XBHSeparatorColor.CGColor;
        _field.layer.borderWidth=1;
        _field.delegate=self;

       
        [self addSubview:_field];
        
        UIButton    *bt=[UIButton buttonWithType:UIButtonTypeCustom];
        [bt setTitle:@"添 加" forState:UIControlStateNormal];
        [bt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        bt.titleLabel.font=XBHSysFont(13);
        bt.layer.masksToBounds=YES;
        bt.layer.cornerRadius=6.0;
        bt.backgroundColor=XBHSeparatorColor;
        [self addSubview:bt];
        
        [bt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).mas_equalTo(3.5);
            make.bottom.equalTo(self).mas_equalTo(-3.5);
            make.right.equalTo(self.mas_right).mas_equalTo(-10);
            make.width.mas_equalTo(60);
            
        }];
        
        
        [_field mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.and.top.and.bottom.equalTo(self);
            make.right.equalTo(bt.mas_left).mas_equalTo(-3.5);
        }];
        
        [bt addTarget:self action:@selector(buttonPress) forControlEvents:UIControlEventTouchUpInside];
    }

    return self;
}
-(UITextField *)inputField{
    return _field;
}
-(void)buttonPress{
    if ([_field.text length]) {
        if ([self.delegate respondsToSelector:@selector(TagInputViewDidInput:)]) {
            [self.delegate TagInputViewDidInput:_field.text];
        }
    }


}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.isFirstResponder) {
        [textField resignFirstResponder];
    }

    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{

  //  [self buttonPress];
    if (textField.isFirstResponder) {
        [textField resignFirstResponder];
    }
}

@end
