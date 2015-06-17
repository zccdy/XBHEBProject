//
//  XBHHorizontalListView.m
//  XBHEBProject
//
//  Created by xubh-note on 15/5/20.
//  Copyright (c) 2015年 xu banghui. All rights reserved.
//

#import "XBHHorizontalListView.h"



#pragma mark -


@interface LineLayout : UICollectionViewFlowLayout
/**
 *  item之间的间隙
 */
@property   (nonatomic)     CGFloat             mItemSpace;
@property   (nonatomic)     CGFloat             mItemWidth;

@end




@implementation LineLayout

-(id)init
{
    self = [super init];
    if (self) {
        
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        
    }
    return self;
}


-(void)prepareLayout{
    self.minimumLineSpacing = self.mItemSpace;
    CGFloat   height=CGRectGetHeight(self.collectionView.bounds);
    if (self.mItemWidth == 0) {
        self.mItemWidth=CGRectGetWidth(self.collectionView.bounds);
    }
    self.itemSize = CGSizeMake(self.mItemWidth, height);
   
    
}




- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)oldBounds
{
    return YES;
}

@end



#pragma mark -

@interface XBHHorizontalListView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property   (nonatomic,strong)          NSMutableArray          *mItemArray;
@end

@implementation XBHHorizontalListView
{
    UICollectionView        *_collectionView;

}


-(instancetype)initWithFrame:(CGRect)frame{
    if (self =[super initWithFrame:frame]) {
        
    }

    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    if (_collectionView) {
         _collectionView.frame=self.bounds;
        [_collectionView reloadData];
    }
}


-(void)setItems:(NSArray *)items itemWidth:(CGFloat)width itemSpace:(CGFloat)space{

    self.mItemArray=nil;
    if (_collectionView) {
        [_collectionView removeFromSuperview];
        _collectionView=nil;
    }
    
    
    LineLayout     *lout=[[LineLayout alloc] init];
    lout.mItemWidth=width;
    lout.mItemSpace=space;
    _collectionView=[[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:lout];
    _collectionView.backgroundColor=[UIColor clearColor];
    _collectionView.backgroundView.opaque=NO;
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"MY_CELL"];
    [self addSubview:_collectionView];

    
    self.mItemArray=[NSMutableArray arrayWithArray:items];
    
    [self setNeedsLayout];
}


-(void)appendItems:(NSArray *)items{

    if (!self.mItemArray) {
        return;
    }
    [self.mItemArray arrayByAddingObjectsFromArray:items];
    [self setNeedsLayout];
}



-(void)clearSubview:(UICollectionViewCell *)cell{
    for (UIView *view in cell.subviews) {
        if (view.tag == 999) {
            [view removeFromSuperview];
        }
    }

}

#pragma mark --

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section;
{
    return [self.mItemArray count];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"MY_CELL" forIndexPath:indexPath];
    
    [self clearSubview:cell];
    if (indexPath.item < [self.mItemArray count]) {
        UIView *view=[self.mItemArray objectAtIndex:indexPath.item];
        view.tag=999;
        [cell.contentView addSubview:view];
    }
    return cell;
}

@end
