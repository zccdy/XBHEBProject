//
//  XBHInputViewHandler.h
//  XBHEBProject
//
//  Created by xubh-note on 15/4/29.
//  Copyright (c) 2015年 xu banghui. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XBHInputViewHeight        INPUTFIELDHEIGHT

#define XBHInputViewItemSpace        (0)

#define XBHInputViewTitleW            (50)

#define CodeImageW          (60)


#define AuthCodeSpace               (0)        //验证码输入框和其他输入框间距

@interface XBHInputViewItem : NSObject

@property   (nonatomic,strong)      NSString        *mTitle;

@property   (nonatomic,strong)      NSString        *mplaceholder;

- (instancetype)initWithPlaceholder:(NSString *)place;

- (instancetype)initWithTitle:(NSString *)title placeholder:(NSString *)place;
@end



#pragma mark-

@protocol XBHInputViewHandlerDelegate <NSObject>

@optional
-(void)XBHInputViewHandlerLastFieldDidEndEdit;
@end






@interface XBHInputViewHandler : NSObject

@property   (nonatomic,weak)    id<XBHInputViewHandlerDelegate> delegate;
@property   (nonatomic,strong)  UIColor                         *textColor;
@property   (nonatomic,strong,readonly)         UIView          *backgroundView;
- (instancetype)initWithSuperController:(UIViewController *)superController Frame:(CGRect)frame Items:(NSArray *)items HaveAuthCode:(BOOL)have;

-(void)clearAllInputField;

-(BOOL)isLastFiled:(NSUInteger )index;

-(BOOL)isLastFiledWithField:(UITextField * )field;

-(UITextField *)firstField;

-(UITextField *)lastField;

-(UITextField *)fieldWithIndex:(NSUInteger)index;

-(void)nextBecomeFirstResponderWithCurIndex:(NSUInteger )curIndex;

-(void)nextBecomeFirstResponderWithCurField:(UITextField* )field;

-(NSString *)fieldTextWithFieldIndex:(NSUInteger)index;

-(NSString *)authCodeText;

-(void)setLeftImage:(UIImage *)img index:(NSUInteger )index;
@end
