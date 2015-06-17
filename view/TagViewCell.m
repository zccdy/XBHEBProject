//
//  TagViewCell.m
//  XBHEBProject
//
//  Created by xubh-note on 15/4/26.
//  Copyright (c) 2015年 xu banghui. All rights reserved.
//

#import "TagViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import <Masonry.h>



#pragma mark -



@protocol TagButtonDelegate;

@interface TagButton : UIButton
@property   (nonatomic,weak)     id<TagButtonDelegate>  delegate;
@property   (nonatomic)         BOOL        editable;
@end

@protocol TagButtonDelegate <NSObject>

@optional
-(void)tagButtonDelete:(TagButton *)button ;
@end




@implementation TagButton
{
    UIImageView           *_deleteImageView;
}
@synthesize editable=_editable;

-(void)setEditable:(BOOL)editable{
    _editable=editable;
    
    if (editable) {
        if (!_deleteImageView) {
            UIImage      *image=XBHHomeBundleImageWithName(@"delete");
            _deleteImageView=[[UIImageView alloc] initWithImage:image];
            _deleteImageView.userInteractionEnabled=YES;
            UITapGestureRecognizer    *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteImagePress)];
            [_deleteImageView addGestureRecognizer:tap];
            [self addSubview:_deleteImageView];
            [_deleteImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.mas_right).mas_equalTo(image.size.width/3);
                make.top.equalTo(self.mas_top).mas_equalTo(-image.size.height/2);
                make.size.mas_equalTo(image.size);
            }];
        }
        else{
            _deleteImageView.hidden=NO;
        }
    }
    else if (_deleteImageView){
        _deleteImageView.hidden=YES;
    }

}

-(void)deleteImagePress{
    if ([self.delegate respondsToSelector:@selector(tagButtonDelete:)]) {
        [self.delegate tagButtonDelete:self];
    }
}

@end





#pragma mark  --


#define TagButtonTag            (9999)


#define kTagView_Width          @"tagviewwidth"

#define kTagView_PointX           @"tagviewpointx"

#define kTagView_PointY           @"tagviewpointY"

#define kTagView_Button           @"tagviewbutton"

@interface TagViewCell ()<TagButtonDelegate>

@end

@implementation TagViewCell
{
    NSMutableArray      *tagDictArray;

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)iden
{
    self = [super initWithStyle:style reuseIdentifier:iden];
    if (self) {
        tagDictArray=[NSMutableArray array];
        
    }
    return self;
}

-(void)clearButton{
    for (UIView *view in self.contentView.subviews) {
        if (view.tag == TagButtonTag) {
            [view removeFromSuperview];
        }
    }
   
}


+(NSMutableArray *)tagDictArrayWithTitleArray:(NSArray *)tagTitleArray layoutWidth:(CGFloat)maxWidth needHeight:(CGFloat *)height editable:(BOOL)edit{
    if ([tagTitleArray count]==0) {
        return nil;
    }

    NSMutableArray *dictArray=[NSMutableArray array];
    CGFloat   tagitemH=TagViewCell_TagitemHeight;
    if (edit) {
        tagitemH=TagViewCell_TagitemHeight_WithDelete;
    }
  
    CGFloat   x=TagViewCell_OffsetX;
    CGFloat   y=TagViewCell_OffsetY;
    CGFloat    width=0;
    CGFloat   h=2*y+tagitemH;
    
    for (NSUInteger i=0;i<tagTitleArray.count;i++) {
        NSString *title=tagTitleArray[i];
        width=[title XBHStringSizeWithFont:TagViewCell_TitleFont constrainedToSize:CGSizeMake(maxWidth, 60)].width+10;
        
        if ((x+width+TagViewCell_TagItemSpaceX+TagViewCell_OffsetX)>maxWidth) {
            
            
            //x == TagViewCell_OffsetX  行的第一个标签,显示不下，换行也无用
            
            if (x != TagViewCell_OffsetX){
                //换行
                x=TagViewCell_OffsetX;
                y+=tagitemH+TagViewCell_TagItemSpaceY;
               
                h+=tagitemH+TagViewCell_TagItemSpaceY;
            }
        }
        else{
            if (x != TagViewCell_OffsetX) {
                x+=TagViewCell_TagItemSpaceX;
            }
            
            
        }
        
        if (!height) {
            TagButton    *bt=[TagButton buttonWithType:UIButtonTypeCustom];
            bt.tag=TagButtonTag;
            [bt setTitle:title forState:UIControlStateNormal];
            bt.titleLabel.font=TagViewCell_TitleFont;
            [bt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            UIImage *img=[XBHHomeBundleImageWithName(@"tagBg") resizableImageWithCapInsets:UIEdgeInsetsMake(2, 10, 2, 10)];
            [bt setBackgroundImage:img forState:UIControlStateNormal];
            
            
            NSDictionary    *dict=@{kTagView_Button:bt,kTagView_PointX:@(x),kTagView_PointY:@(y),kTagView_Width:@(width)};
            [dictArray addObject:dict];
            
        }
        
    
        x+=width;
    }
    
    if (height) {
        *height=h;
    }
    
    return dictArray;
}

-(void)setTagsTitle:(NSArray *)tagTitleArray layoutWidth:(CGFloat)maxWidth {
    [self setTagsTitle:tagTitleArray layoutWidth:maxWidth editable:NO];
}

-(void)setTagsTitle:(NSArray *)tagTitleArray layoutWidth:(CGFloat)maxWidth editable:(BOOL)edit{
   
    [self clearButton];
    
    if (tagTitleArray) {
        tagDictArray=[TagViewCell tagDictArrayWithTitleArray:tagTitleArray layoutWidth:maxWidth needHeight:NULL editable:edit];
      

        [tagDictArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSDictionary *dict=(NSDictionary *)obj;
            TagButton    *bt=dict[kTagView_Button];
            bt.delegate=self;
            bt.editable=edit;
            CGFloat     width=[dict[kTagView_Width] floatValue];
            CGFloat     x=[dict[kTagView_PointX] floatValue];
            CGFloat     y=[dict[kTagView_PointY] floatValue];
            bt.frame=CGRectMake(x, y, width, TagViewCell_TagitemHeight);
            [self.contentView addSubview:bt];
            [bt addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
            
        }];
        
        [self setNeedsLayout];
    }
    
}



-(void)buttonPress:(TagButton *)button{
    if ([self.delegate respondsToSelector:@selector(TagViewCell:DidSelectString:editable:)]) {
        [self.delegate TagViewCell:self DidSelectString:button.titleLabel.text editable:button.editable];
    }
    
}


-(void)tagButtonDelete:(TagButton *)button{
    [self buttonPress:button];

}

@end
