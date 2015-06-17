//
//  XBHUploadRequest.h
//  XBHEBProject
//
//  Created by xubh-note on 15/4/16.
//  Copyright (c) 2015年 xu banghui. All rights reserved.
//

#import "XBHBackgroundRequest.h"


@interface XBHUploadRequest : XBHBackgroundRequest
@property   (nonatomic,assign)  NSUInteger      contentOffset;
/**
 *  指定上传文件路径
 */
@property   (nonatomic,strong)  NSString        *filePath;
@property   (nonatomic,strong)  NSString        *mimeType;
/**
 *  指定上传数据,uploadData!=nil,filePath无效
 */
@property   (nonatomic,strong)  NSData          *uploadData;
@property   (nonatomic,strong)  NSString        *fileName;



- (instancetype)initWithUrl:(NSString *)urlstring;
@end
