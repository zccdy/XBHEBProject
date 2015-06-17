//
//  XBHUILabel.h
//  gwEdu
//
//  Created by xubh-note on 15/2/9.
//  Copyright (c) 2015年 gwsoft. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef enum
{
    
    XBHVerticalAlignmentMiddle=0, // default
    XBHVerticalAlignmentTop ,
    XBHVerticalAlignmentBottom
    
} XBHVerticalAlignment;



@interface XBHUILabel : UILabel
{
    @private
    XBHVerticalAlignment _verticalAlignment;
}
@property (nonatomic) XBHVerticalAlignment verticalAlignment;


@end
