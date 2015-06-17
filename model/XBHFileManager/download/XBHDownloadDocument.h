//
//  XBHDownloadDocument.h
//  gwEdu
//
//  Created by xubh-note on 14-6-12.
//  Copyright (c) 2014年 gwsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
/*
 
    数据库中的列 及 含义
 
 
 
 
 表一 、表二都以DataId和DataType的组合 作为唯一标识
 
 
 
 表－：
 
 DataId :  数据源id
 
 DataType: 数据源类型
 
 UserId:   用户id
 
 AssistId: 辅助型id(当只用dataid 不能满足需要,设置该值，如bookId)
 
 DownloadStatus: 下载状态(XBHDownloadStatus)
 
 
 表二:
 
 DataId :  数据源id
 
 DataType: 数据源类型
 
 Owners  : 拥有该数据源的用户ID列表
 
 DataURL : 数据源URL
 
 DataPath: 下载下来的数据存储路径(含文件名与格式)
 
 IconURL  : 数据源 图标URL
 
 DataReferenceInfo : 数据源相关信息(NSData),对应dataId
 
 
 表三：
 
 AssistId :辅助型id(当只用dataid 不能满足需要,设置该值)
 Owners  : 拥有该数据源的用户ID列表
 AssistReferenceInfo: 数据源相关信息(NSData),对应AssistId
 
 */

typedef NS_ENUM(NSUInteger, XBHDownloadStatus){
    XBHDownloadStatus_None=30,
    XBHDownloadStatus_DownloadWate,
    XBHDownloadStatus_Downloading,
    XBHDownloadStatus_DownloadPause_ByUser, //用户自己暂停
    XBHDownloadStatus_DownloadPause_ByApp,  //进入后台等原因 下载中 ，程序暂停-->downloading-->pause
    XBHDownloadStatus_DownloadCompelete,
    XBHDownloadStatus_DownloadFailure,
    XBHDownloadStatus_Delete

};




@interface XBHDownloadDoc : NSObject


@property (nonatomic)  long long  DataId ;

@property (nonatomic)  NSUInteger DataType;

@property (nonatomic)  long long  UserId ;

@property (nonatomic)  long long AssistId;

@property (nonatomic,readonly)  double  Progress;

@property (nonatomic,strong) NSString  *DataURL ;

@property (nonatomic,strong) NSString  *DataName;//带后缀的名字

@property (nonatomic)        XBHDownloadStatus DownloadStatus;

@property (nonatomic,strong)  NSString      *IconURL ;

@property  (nonatomic,strong) NSData        *AssistReferenceInfo;

@property (nonatomic,strong)  NSData        *DataReferenceInfo ;//对应dataId


@end








#pragma mark -






@interface XBHDownloadDocument : NSObject


+(NSString *)downloadDataPathWithFileName:(NSString *)fileName;

-(void)addIntoDocumentWithXBHDownloadDoc:(XBHDownloadDoc *)doc;

-(void)addUser:(long long)userId toOwnersWithDataId:(long long)dataId DataType:(long long)type;

-(XBHDownloadStatus)downloadStatusWithUserId:(long long)userId DataId:(long long)dataId DataType:(NSUInteger)type;

-(void)setDownloadStatusWithUserId:(long long)userId DataId:(long long)dataId DataType:(NSUInteger)type DownloadStatus:(XBHDownloadStatus)status;

-(NSString *)dataURLWithDataId:(long long)dataId DataType:(NSUInteger)type;

-(NSString *)dataStorePathWithDataId:(long long)dataId DataType:(NSUInteger)type;

-(void)setProgress:(double)progress UserId:(long long)userId DataId:(long long)dataId DataType:(NSUInteger)type;
-(double)progressWithUserId:(long long)userId DataId:(long long)dataId DataType:(NSUInteger)type;


-(XBHDownloadDoc *)oneXBHDownloadDocWithUserId:(long long)userId DataId:(long long)dataId DataType:(long)type;

-(XBHDownloadDoc *)oneXBHDownloadDocWithDownloadStatus:(XBHDownloadStatus)status UserId:(long long)userId ;

-(XBHDownloadDoc *)lastoneXBHDownloadDocWithDownloadStatus:(XBHDownloadStatus)status UserId:(long long)userId;

-(NSArray *)XBHDownloadDocListWithDownloadStatus:(XBHDownloadStatus)status UserId:(long long)userId ;

-(uint32_t)numberOfBettwenBeginStatus:(XBHDownloadStatus)bStatus EndStatus:(XBHDownloadStatus)eStatus UserId:(long long)userId;

-(NSArray *)XBHDownloadDocListBettwenBeginStatus:(XBHDownloadStatus)bStatus EndStatus:(XBHDownloadStatus)eStatus UserId:(long long)userId;

-(NSArray *)XBHDownloadDocListWithAssistId:(long long)assistId Status:(XBHDownloadStatus)bStatus  UserId:(long long)userId ;

// 所有符合下载状态的 AssistId不同的 AssistReferenceInfo
-(NSArray *)distinctAssistReferenceInfoListWithDownloadStatus:(XBHDownloadStatus)status UserId:(long long)userId;

// 所有符合下载状态的 AssistId、DataType不同的 AssistReferenceInfo
-(NSArray *)distinctAssistReferenceInfoListWithDownloadStatus:(XBHDownloadStatus)status DataType:(NSUInteger)type UserId:(long long)userId;


-(NSData *)assistReferenceInfoListWithAssistId:(long long)assistId;

//删除某书籍下的 对应user 所有已经下载成功的条目(dataId,dataType)信息
//返回XBHDownloadDoc结构数组，只有dataId,dataType赋值 表示删除了那些。
-(NSArray *)deleteOneNotWithAssistId:(long long)assistId UserId:(long long)userId ;

-(void)deleteOneNoteWithDataId:(long long)dataId DataType:(NSUInteger)type UserId:(long long)userId isDeleteFile:(BOOL)isDelete;

//用在取消所有下载
//设置状态为 None,进度为 0
-(void)cancelAllDownloadWithAssistId:(long long)assistId UserId:(long long)userId;

@end

