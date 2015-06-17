//
//  TagInputView.h
//  XBHEBProject
//
//  Created by xubh-note on 15/6/16.
//  Copyright (c) 2015年 xu banghui. All rights reserved.
//

#import <UIKit/UIKit.h>


#define InputViewHeight        (34.5)


@protocol TagInputViewDelegate <NSObject>

@optional
-(void)TagInputViewDidInput:(NSString *)text;
@end



@interface TagInputView : UIView
@property       (nonatomic,weak)                    id<TagInputViewDelegate>    delegate;
@property       (nonatomic,strong,readonly)         UITextField    *inputField;
@end
