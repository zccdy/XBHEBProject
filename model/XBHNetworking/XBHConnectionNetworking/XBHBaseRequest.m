//
//  XBHBaseRequest.m
//  XBHEBProject
//
//  Created by xubh-note on 15/4/21.
//  Copyright (c) 2015年 xu banghui. All rights reserved.
//

#import "XBHBaseRequest.h"

@implementation XBHBaseRequest

+(instancetype)requestWithURLString:(NSString *)urlstring{
    
    return  [[[self class] alloc] initWithURlString:urlstring];
}

- (instancetype)init
{
    
    return [self initWithURlString:nil];
}
- (instancetype)initWithURlString:(NSString *)urlString
{
    self = [super init];
    if (self) {
        self.requestUrl=urlString;
        self.requestMethod=YTKRequestMethodGet;
        self.requestTimeoutInterval=60;
        
    }
    return self;
}





- (NSString *)resumableDownloadPath{
    return self.downloadFileStorePath;
}


/// 当需要断点续传时，获得下载进度的回调
- (AFDownloadProgressBlock)resumableDownloadProgressBlock{

    return self.downlooadProgressBlock;
}

- (NSDictionary *)requestHeaderFieldValueDictionary {
    return self.requestHeaders;
}

@end
