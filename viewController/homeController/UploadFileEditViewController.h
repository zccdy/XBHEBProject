//
//  UploadFileEditViewController.h
//  XBHEBProject
//
//  Created by xubh-note on 15/4/22.
//  Copyright (c) 2015年 xu banghui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XBHUploadManager.h"



@interface UploadFileEditViewController : UITableViewController

@property  (nonatomic,strong)           NSString    *uploadFilePath;

@property  (nonatomic,assign)          XBHUploadDataType    dataType;

@property  (nonatomic,assign)           UInt64              fileSize;

@property  (nonatomic,strong)           NSString        *fileName;

@property  (nonatomic,strong)           UIImage         *thumbImg;
@end
