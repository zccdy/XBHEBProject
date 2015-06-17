//
//  XBHUploadManager.h
//  XBHEBProject
//
//  Created by xubh-note on 15/4/21.
//  Copyright (c) 2015年 xu banghui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XBHUploadDocument.h"
#import "XBHUploadRequest.h"

extern NSString * const XBHHTTPUploadNotify;

extern NSString * const XBHHTTPUploadAllRequestCompeleteNotify;


#define kXBHHTTPUpload_UserId        @"userId"
#define kXBHHTTPUpload_DataId        @"dataId"
#define kXBHHTTPUpload_DataType      @"dataType"
#define kXBHHTTPUpload_DataPath      @"dataPath"
#define kXBHHTTPUpload_Status        @"status"
#define kXBHHTTPUpload_Progress      @"progress"




#define XBHUploadShareManager         [XBHUploadManager shareInstance]

#define XBHUploadShareDocument             XBHUploadShareManager.document


@interface XBHUploadManager : NSObject

@property   (nonatomic,strong,readonly)         XBHUploadDocument           *document;

@property   (nonatomic,assign)                  long long                   userId;




+ (XBHUploadManager *)shareInstance;

//根据时间分配出数据id （永不会相同）
-(NSUInteger)dispatchDiffrentDataId;

-(BOOL)isRequesting;

-(void)resume;

-(void)uploadWithXBHUploadDoc:(XBHUploadDoc*)doc;
-(void)uploadWithXBHUploadDoc:(XBHUploadDoc*)doc isStart:(BOOL)start;

-(void)pauseRequestWithDataId:(long long )dataId DataType:(NSUInteger)type;
-(void)pauseRequestWithDataId:(long long )dataId DataType:(NSUInteger)type isGoNext:(BOOL)isGo;
-(void)cancelRequestWithDataId:(long long )dataId DataType:(NSUInteger)type;

-(void)UploadContinue;
-(void)cancelNetwork;

-(XBHUploadDoc *)currentUploadDoc;
@end
