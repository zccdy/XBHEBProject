//
//  DocTypeViewCell.m
//  XBHEBProject
//
//  Created by xubh-note on 15/5/18.
//  Copyright (c) 2015年 xu banghui. All rights reserved.
//

#import "DocTypeViewCell.h"
#import "XBHTIButton.h"



@implementation DocTypeViewCellInfo



@end




#pragma mark -


@implementation DocTypeViewCell
{
    NSMutableArray         *_buttonArray;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



-(void)setInfoArray:(NSArray *)infos{

    for (UIButton *bt in _buttonArray) {
        [bt removeFromSuperview];
    }
    _buttonArray=[NSMutableArray array];

    for (DocTypeViewCellInfo *info in infos) {
        XBHTIButton  *bt=[[XBHTIButton alloc] init];
        
        [bt setIconUrlStr:info.mIconURL DefaultImage:XBHHomeBundleImageWithName(@"default") IconDrawSize:DocTypeViewCell_IconSize Text:info.mTitle Mode:XBHTIButtonMode_UD];
        bt.mITSpace=DocTypeViewCell_IconTextSpace;
        bt.tag=info.mIndex;
        [_buttonArray addObject:bt];
        [bt addTarget:self action:@selector(buttonDidPress:)];
        [self.contentView addSubview:bt];
    }
    
    if ([_buttonArray count]) {
        [self setNeedsLayout];
    }
    
}

-(void)layoutSubviews{
    [super layoutSubviews];

    NSUInteger count=[_buttonArray count];
    CGFloat    space=(CGRectGetWidth(self.bounds)-DocTypeViewCell_IconSize.width*count)/(count +1);
    CGFloat    y=(CGRectGetHeight(self.bounds)-DocTypeViewCellHeight)/2;
    XBHTIButton   *prev=nil;
    for (XBHTIButton *bt in _buttonArray) {
        if (prev) {
            bt.frame=CGRectMake(CGRectGetMaxX(prev.frame)+space, y, DocTypeViewCell_IconSize.width, DocTypeViewCellHeight);
        }
        else
            bt.frame=CGRectMake(space, y, DocTypeViewCell_IconSize.width, DocTypeViewCellHeight);
        
        prev=bt;
    }
}


-(void)buttonDidPress:(XBHTIButton *)bt{
    if ([self.delegate respondsToSelector:@selector(DocTypeViewCell:didSelectionIndex:title:)]) {
        [self.delegate DocTypeViewCell:self didSelectionIndex:bt.tag title:bt.mText];
    }

}



@end
