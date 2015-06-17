//
//  XBHBaseRequest.h
//  XBHEBProject
//
//  Created by xubh-note on 15/4/21.
//  Copyright (c) 2015年 xu banghui. All rights reserved.
//

#import "YTKBaseRequest.h"
#import "XBHNetworking.h"
@interface XBHBaseRequest : YTKBaseRequest

@property (nonatomic,strong)    NSString            *requestUrl;

@property (nonatomic,assign)    YTKRequestMethod    requestMethod;

@property  (nonatomic,assign)   NSTimeInterval      requestTimeoutInterval;
//需 是 XBHRequestMethodGet
@property (nonatomic,strong)    NSString    *downloadFileStorePath;

@property (nonatomic,copy)      AFDownloadProgressBlock     downlooadProgressBlock;

@property (nonatomic,strong)    NSDictionary            *requestHeaders;


+(instancetype)requestWithURLString:(NSString *)urlstring;


@end
