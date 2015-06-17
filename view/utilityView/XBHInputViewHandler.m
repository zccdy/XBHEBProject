//
//  XBHInputViewHandler.m
//  XBHEBProject
//
//  Created by xubh-note on 15/4/29.
//  Copyright (c) 2015年 xu banghui. All rights reserved.
//

#import "XBHInputViewHandler.h"
#import "XBHAuthCodeView.h"
#import <Masonry.h>
#import <IQKeyboardReturnKeyHandler.h>
#import <IQUIView+IQKeyboardToolbar.h>
#import "XBHTextFieldLRView.h"
@implementation XBHInputViewItem

- (instancetype)initWithPlaceholder:(NSString *)place
{
    return [self initWithTitle:nil placeholder:place];
}


- (instancetype)initWithTitle:(NSString *)title placeholder:(NSString *)place
{
    self = [super init];
    if (self) {
        self.mTitle=title;
        self.mplaceholder=place;
    }
    return self;
}

@end





#pragma mark-


@interface XBHInputViewHandler ()<UITextFieldDelegate,UITextViewDelegate>

@end

@implementation XBHInputViewHandler
{
    NSMutableArray      *_textFieldArray;
    UIView              *_inputBgView;
    UIView              *_authCodeBgView;
     IQKeyboardReturnKeyHandler      *_returnKeyHandler;

    XBHAuthCodeView  *_codeView;
    

}
@synthesize textColor=_textColor;
- (void)dealloc
{
    _returnKeyHandler=nil;
    
}
-(UIView *)backgroundView{
    return _inputBgView;
}
- (instancetype)initWithSuperController:(UIViewController *)superController Frame:(CGRect)frame Items:(NSArray *)items HaveAuthCode:(BOOL)have;
{
    self = [super init];
    if (self) {
        
        NSUInteger  count=[items count];
        _textFieldArray=[NSMutableArray array];

        _inputBgView=[[UIView alloc] initWithFrame:frame];
        _inputBgView.layer.masksToBounds=YES;
        _inputBgView.layer.cornerRadius=XBHCornerRadius;
        _inputBgView.layer.borderColor=XBHMakeRGB(105.0, 110.0, 119.0).CGColor;
        _inputBgView.layer.borderWidth=XBHLineHeight;
        _inputBgView.backgroundColor=XBHMakeRGB(117.0, 123.0, 132.0);
        [superController.view addSubview:_inputBgView];
        
        
        CGFloat    prevMaxY=frame.origin.y;
        
        for (NSUInteger i=0; i<count; i++) {
            XBHInputViewItem    *item=[items objectAtIndex:i];
            UITextField * _inputView=[[UITextField alloc] init];
            //完成按钮事件
            [_inputView addDoneOnKeyboardWithTarget:self action:@selector(IQKeyboardDoneButtonPress:)];
            //  _inputField.delegate = self;
            _inputView.opaque=NO;
            _inputView.keyboardType = UIKeyboardTypeDefault;
            _inputView.font = [UIFont systemFontOfSize:15];
            _inputView.placeholder =item.mplaceholder;
            _inputView.autocorrectionType = UITextAutocorrectionTypeNo;
            _inputView.autocapitalizationType = UITextAutocapitalizationTypeNone;
            
            /*
            if (i <count-1
                ||have) {
                _inputView.returnKeyType = UIReturnKeyNext;
            }
            else{
                _inputView.returnKeyType = UIReturnKeyDone;
            }
             */
            _inputView.clearButtonMode = UITextFieldViewModeWhileEditing;
            _inputView.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            _inputView.textAlignment=NSTextAlignmentLeft;
            [superController.view addSubview:_inputView];
            [_textFieldArray addObject:_inputView];
            
            _inputView.frame=CGRectMake(frame.origin.x, prevMaxY, frame.size.width, XBHInputViewHeight);
            if (i<count-1
                ||have) {
                UIView *line=[[UIView alloc] init];
                line.backgroundColor=XBHMakeRGB(105.0, 110.0, 119.0);
                
                [superController.view addSubview:line];
                line.frame=CGRectMake(_inputView.frame.origin.x, CGRectGetMaxY(_inputView.frame)-XBHLineHeight, CGRectGetWidth(_inputView.frame), XBHLineHeight);

            }
            prevMaxY=CGRectGetMaxY(_inputView.frame);
        }
     
        if (have) {
            
            _authCodeBgView=[[UIView alloc] init];
            _authCodeBgView.opaque=NO;
            /*
            _authCodeBgView.layer.masksToBounds=YES;
            _authCodeBgView.layer.cornerRadius=XBHCornerRadius;
            _authCodeBgView.layer.borderColor=XBHLineColor.CGColor;
            _authCodeBgView.layer.borderWidth=XBHLineHeight;
             */
            [superController.view addSubview:_authCodeBgView];
            

            UITextField *field=[self authCodeInputField];
            //完成按钮事件
            [field addDoneOnKeyboardWithTarget:self action:@selector(IQKeyboardDoneButtonPress:)];

            [superController.view addSubview:field];
            
            _codeView=[[XBHAuthCodeView alloc] init];
            [superController.view addSubview:_codeView];
            
            
            _codeView.frame=CGRectMake(CGRectGetMaxX(frame)-CodeImageW-12.5, prevMaxY+AuthCodeSpace+4, CodeImageW, XBHInputViewHeight-8);
            /*
            _authCodeBgView.frame=CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(_codeView.frame), CGRectGetWidth(frame)-CodeImageW-20, XBHInputViewHeight);
             */
            
            field.frame=CGRectMake(CGRectGetMinX(frame), prevMaxY, CGRectGetWidth(frame)-CodeImageW-12.5, XBHInputViewHeight);
            
            
        }
        
        
        
        
        _returnKeyHandler=[[IQKeyboardReturnKeyHandler alloc] initWithViewController:superController];
        _returnKeyHandler.delegate=self;
        _returnKeyHandler.lastTextFieldReturnKeyType=UIReturnKeyDone;
    }
    return self;
}


-(UITextField *)authCodeInputField{

   UITextField* _inputField=[[UITextField alloc] init];
    //  _inputField.delegate = self;
    _inputField.backgroundColor = [UIColor clearColor];
    _inputField.keyboardType = UIKeyboardTypeDefault;
    _inputField.font = [UIFont systemFontOfSize:15];
    _inputField.placeholder = @"请输入验证码";
    _inputField.autocorrectionType = UITextAutocorrectionTypeNo;
    _inputField.autocapitalizationType = UITextAutocapitalizationTypeNone;
   // _inputField.returnKeyType = UIReturnKeyDone;
    _inputField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _inputField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _inputField.textAlignment=NSTextAlignmentLeft;
    
    [_textFieldArray addObject:_inputField];
    return _inputField;
}


-(void)clearAllInputField{

    for (UIView *view in _textFieldArray) {
        [view removeFromSuperview];
    }
    _textFieldArray=nil;

}


-(void)setTextColor:(UIColor *)textColor{
    if (_textColor != textColor) {
        _textColor=textColor;
        
        
        for (UITextField *field in _textFieldArray) {
            field.textColor=_textColor;
        }
        
    }

}
-(void)setLeftImage:(UIImage *)img index:(NSUInteger )index{
    UITextField   *field=(UITextField*)[self fieldWithIndex:index];
    if (!field) {
        return;
    }
    field.leftView=[[XBHTextFieldLRView alloc] initWithImage:img LRSpace:12.5];
    field.leftViewMode=UITextFieldViewModeAlways;
   
    

}


-(BOOL)isLastFiled:(NSUInteger )index{
   
    NSUInteger count=[_textFieldArray count];
    return (index == count-1);
    
}



-(BOOL)isLastFiledWithField:(UITextField * )field{
    if (![_textFieldArray containsObject:field]) {
        return NO;
    }
    NSUInteger  index=[_textFieldArray indexOfObject:field];
    NSUInteger count=[_textFieldArray count];
    return (index == count-1);
    
}




-(void)nextBecomeFirstResponderWithCurIndex:(NSUInteger )curIndex{
    
     NSUInteger count=[_textFieldArray count];
    if (curIndex>=(count-1)) {
        return;
    }
    UITextField *field=[_textFieldArray objectAtIndex:curIndex];
    [field resignFirstResponder];
    if (curIndex <count-1) {
        
        UITextField *next=[_textFieldArray objectAtIndex:curIndex+1];
        [next becomeFirstResponder];
    }
    
    
}


-(void)nextBecomeFirstResponderWithCurField:(UITextField* )field{
    
    if (![_textFieldArray containsObject:field]) {
        return ;
    }
    NSUInteger  index=[_textFieldArray indexOfObject:field];
    NSUInteger count=[_textFieldArray count];
    

    [field resignFirstResponder];
    if (index <count-1) {
        
        UITextField *next=[_textFieldArray objectAtIndex:index+1];
        [next becomeFirstResponder];
    }
    
}



-(UITextField *)lastField{

    return [_textFieldArray lastObject];

}

-(UITextField *)firstField{
    
    return [_textFieldArray firstObject];
    
}




-(UITextField *)fieldWithIndex:(NSUInteger)index{
    if (index >([_textFieldArray count]-1)) {
        return nil;
    }
 
    return [_textFieldArray objectAtIndex:index];
    

}


-(NSString *)fieldTextWithFieldIndex:(NSUInteger)index{

    if (index >([_textFieldArray count]-1)) {
        return nil;
    }
    UITextField *field=[_textFieldArray objectAtIndex:index];
    return field.text;

}

-(NSString *)authCodeText{
    if (!_codeView) {
        return nil;
    }

    return _codeView.changeString;
}



-(void)resignFirstResponder{
    for (UITextField *field in _textFieldArray) {
        if ([field isFirstResponder]) {
            [field resignFirstResponder];
        }
    }
}


-(UITextField *)firstResponderTextField{
    for (UITextField *field in _textFieldArray) {
        if ([field isFirstResponder]) {
            return field;
        }
    }
    return nil;
}

-(void)IQKeyboardDoneButtonPress:(id)sender{

    UITextField *firstResponder=[self firstResponderTextField];
    if (firstResponder) {
        [self textFieldDidEndEditing:firstResponder];
    }
}


#pragma mark   -- textFieldDelegate

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    return YES;
    
}


-(void)textFieldDidEndEditing:(UITextField *)textField{
    if ([self isLastFiledWithField:textField]) {
        [textField resignFirstResponder];
        if ([self.delegate respondsToSelector:@selector(XBHInputViewHandlerLastFieldDidEndEdit)]) {
            [self.delegate XBHInputViewHandlerLastFieldDidEndEdit];
        }
    }
    else{
        [self nextBecomeFirstResponderWithCurField:textField];
    }
    
}


@end
