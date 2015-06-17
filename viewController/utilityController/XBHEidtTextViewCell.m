//
//  XBHEidtTextViewCell.m
//  XBHEBProject
//
//  Created by xubh-note on 15/5/13.
//  Copyright (c) 2015年 xu banghui. All rights reserved.
//

#import "XBHEidtTextViewCell.h"
#import "HPGrowingTextView.h"

#define   CSGrowingTextViewOffsetY      (8)

#define   CSGrowingTextViewOffsetX      (8)

@interface XBHEidtTextViewCell ()<HPGrowingTextViewDelegate>

@property   (nonatomic,strong)  HPGrowingTextView      *textView;
@end
@implementation XBHEidtTextViewCell
{

}
- (void)awakeFromNib {
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if (self =[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.textView=[[HPGrowingTextView alloc] init];
        self.textView.delegate=self;
        self.textView.maxNumberOfLines=5;
        self.textView.layer.masksToBounds=YES;
        self.textView.layer.cornerRadius=5.0;
        self.textView.layer.borderWidth=0.5;
        self.textView.layer.borderColor=[UIColor lightGrayColor].CGColor;
        
        [self.contentView addSubview:self.textView];
    }

    return self;

}

-(void)setMinHeight:(int)minHeight{
    
    
    self.textView.minHeight=(minHeight-CSGrowingTextViewOffsetY*2);
}

-(NSString *)placeholderStr{
    return self.textView.placeholder;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.textView.frame=CGRectMake(CSGrowingTextViewOffsetX, CSGrowingTextViewOffsetY, CGRectGetWidth(self.bounds)-CSGrowingTextViewOffsetX*2, CGRectGetHeight(self.bounds)-CSGrowingTextViewOffsetY*2);
}

#pragma mark -  CSGrowingTextViewDelegate


-(void)growingTextView:(HPGrowingTextView *)growingTextView didChangeHeight:(float)height{
   
    
    
    if ([self.delegate respondsToSelector:@selector(XBHEidtTextViewCell:WillChangeHeight:)]) {
        [self.delegate XBHEidtTextViewCell:self WillChangeHeight:height+CSGrowingTextViewOffsetY*2];
    }
   /*
    
    XBHWeakSelf;
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         XBHStrongSelf;
                         [strongSelf.textView setNeedsUpdateConstraints];
                         [strongSelf layoutIfNeeded];
                     } completion:^(BOOL finished) {
                         XBHStrongSelf;
                         if ([strongSelf.delegate respondsToSelector:@selector(XBHEidtTextViewCell:WillChangeHeight:)]) {
                             [strongSelf.delegate XBHEidtTextViewCell:strongSelf WillChangeHeight:height];
                         }
                         
                     }];
     
     
*/

}
@end
