//
//  XBHDownloadManager.h
//  gwEdu
//
//  Created by xubh-note on 14-6-12.
//  Copyright (c) 2014年 gwsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XBHDownloadDocument.h"

extern NSString * const XBHHTTPDownloadNotify;
extern NSString * const XBHHTTPDownloadAllRequestCompeleteNotify;

#define kXBHHTTPDownload_UserId        @"userId"
#define kXBHHTTPDownload_DataId        @"dataId"
#define kXBHHTTPDownload_DataType      @"dataType"
#define kXBHHTTPDownload_DataName      @"dataName"
#define kXBHHTTPDownload_Status        @"status"
#define kXBHHTTPDownload_Progress      @"progress"


#define XBHDownloadShareManager         [XBHDownloadManager shareInstance]

#define XBHDownloadShareDocument             XBHDownloadShareManager.mDownloadDocument

@interface XBHDownloadManager : NSObject

@property   (nonatomic)     long long     mUserId;

@property   (nonatomic,strong,readonly) XBHDownloadDocument  *mDownloadDocument;

+ (XBHDownloadManager *)shareInstance;

-(BOOL)isRequesting;
-(void)cancelNetwork;
-(void)pauseRequestWithDataId:(long long )dataId DataType:(NSUInteger)type;
-(void)pauseRequestWithDataId:(long long )dataId DataType:(NSUInteger)type isGoNext:(BOOL)isGo;
-(void)cancelRequestWithDataId:(long long )dataId DataType:(NSUInteger)type;
//取消下载后，调用downloadContinue 防止取消了当前下载后，等候在后面的request 缺少触发
-(void)downloadContinue;
-(void)downloadWithXBHDownloadDoc:(XBHDownloadDoc*)doc;
-(void)downloadWithXBHDownloadDoc:(XBHDownloadDoc*)doc isStart:(BOOL)start;
-(void)start;
@end
