//
//  ImageCyclingBroweView.h
//  gwEdu
//
//  Created by xubh-note on 14-11-21.
//  Copyright (c) 2014年 gwsoft. All rights reserved.
//

#import <UIKit/UIKit.h>


#if __has_feature(objc_arc)

#define ImageCyclingBroweViewRelease(_V)    [_V disableScroll];[_V setDelegate:nil]; _V=nil
#else
#define ImageCyclingBroweViewRelease(_V)    [_V disableScroll];[_V setDelegate:nil]; [_V release]; _V=nil
#endif

@interface XBHImageBrowseInfo : NSObject

@property   (nonatomic,strong)  UIImage     *mPlaceholderImage;

@property   (nonatomic,strong)  NSString    *mImageUrlStr;
@end



@protocol ImageCyclingBroweViewDelegate <NSObject>

@optional

-(void)ImageCyclingBroweViewDidTap:(XBHImageBrowseInfo *)info Index:(NSUInteger)index;

@end





@interface ImageCyclingBroweView : UIView

@property   (nonatomic,assign)   id<ImageCyclingBroweViewDelegate> delegate;
//默认图片
@property   (nonatomic,retain)    UIImage     *mDefaultImage;

//若是结构里面的mPlaceholderImage 将使用mDefaultImage作为默认图片显示
@property   (nonatomic,retain)    NSArray      *mImageBrowseInfoArray;

@property   (nonatomic)           BOOL          mbIsIndicator;


-(void)disableScroll;

-(void)enableScroll:(NSTimeInterval)second;

@end
