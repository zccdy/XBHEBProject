//
//  XBHUploadDocument.h
//  XBHEBProject
//
//  Created by xubh-note on 15/4/14.
//  Copyright (c) 2015年 xu banghui. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 
 表：
 
 DataId :  数据源id
 
 DataType: 数据源类型
 
 DataUploadURL : 数据源上传URL
 
 DataSoucrePath: 数据源地址
 
 IconData  : 数据源 图标URL
 
 UserId:   用户id
 
 UploadStatus: 上传状态(XBHUploadStatus)
 
 UploadProgress: 上传进度
 
 ReferenceInfo : 数据源相关信息(NSData),对应dataId.  JSON <-> NSData
 

 */




typedef NS_ENUM(NSUInteger, XBHUploadStatus){
    XBHUploadStatus_None=0,
    XBHUploadStatus_UploadWate,
    XBHUploadStatus_Uploading,
    XBHUploadStatus_UploadPause_ByUser, //用户自己暂停
    XBHUploadStatus_UploadPause_ByApp=XBHUploadStatus_UploadPause_ByUser+1,  //进入后台等原因 下载中 ，程序暂停-->Uploading-->pause
    XBHUploadStatus_UploadCompelete,
    XBHUploadStatus_UploadFailure,
    XBHUploadStatus_Delete
    
};

typedef NS_ENUM(NSUInteger, XBHUploadDataType){

    XBHUploadDataType_Image=0,
    XBHUploadDataType_Video
};





@interface XBHUploadDoc : NSObject


@property (nonatomic)  long long  DataId ;

@property (nonatomic)  NSUInteger DataType;

@property (nonatomic)  long long  UserId ;

@property  (nonatomic,strong)   NSString    *mimeType;

@property (nonatomic,strong)  NSString *DataUploadURL;

@property (nonatomic)  double  Progress;

@property (nonatomic,strong) NSString  *DataSoucrePath ;


@property (nonatomic)        XBHUploadStatus UploadStatus;

@property (nonatomic,strong)  NSData      *IconData;

@property (nonatomic,strong)  NSData        *DataReferenceInfo ;//对应dataId

@property  (nonatomic,strong)   NSString    *DataName;
@end





@interface XBHUploadDocument : NSObject

/*
 
    UserId ,DataId,DataType 组成唯一标识
 
 
 */


-(void)addIntoDocumentWithXBHUploadDoc:(XBHUploadDoc *)doc;

-(void)setUploadStatusWithUserId:(long long)userId DataId:(long long)dataId DataType:(NSUInteger)type UploadStatus:(XBHUploadStatus)status;

-(void)setProgress:(double)progress UserId:(long long)userId DataId:(long long)dataId DataType:(NSUInteger)type;


-(void)deleteOneNoteWithUserId:(long long)userId DataId:(long long)dataId DataType:(NSUInteger)type;

//获取
-(double)progressWithUserId:(long long)userId DataId:(long long)dataId DataType:(NSUInteger)type;

-(XBHUploadStatus)uploadStatusWithUserId:(long long)userId DataId:(long long)dataId DataType:(NSUInteger)type;

-(NSData *)referenceInfoWithUserId:(long long)userId DataId:(long long)dataId DataType:(NSUInteger)type;


-(NSData *)iconDataWithUserId:(long long)userId DataId:(long long)dataId DataType:(NSUInteger)type;


-(NSString *)dataUploadURLWithUserId:(long long)userId DataId:(long long)dataId DataType:(NSUInteger)type;

-(NSString *)dataSourcePathWithUserId:(long long)userId DataId:(long long)dataId DataType:(NSUInteger)type;

-(XBHUploadDoc *)oneXBHUploadDocWithUploadStatus:(XBHUploadStatus)status UserId:(long long)userId;

-(NSArray *)XBHUploadDocListWithUploadStatus:(XBHUploadStatus)status UserId:(long long)userId ;

-(NSArray *)XBHUploadDocListBettwenBeginStatus:(XBHUploadStatus)bStatus EndStatus:(XBHUploadStatus)eStatus UserId:(long long)userId ;

-(uint32_t)numberOfBettwenBeginStatus:(XBHUploadStatus)bStatus EndStatus:(XBHUploadStatus)eStatus UserId:(long long)userId;

@end
