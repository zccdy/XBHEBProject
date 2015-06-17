//
//  XBHUploadRequest.m
//  XBHEBProject
//
//  Created by xubh-note on 15/4/16.
//  Copyright (c) 2015年 xu banghui. All rights reserved.
//

#import "XBHUploadRequest.h"

@implementation XBHUploadRequest

- (instancetype)initWithUrl:(NSString *)urlstring
{
    self = [super initWithUrl:urlstring];
    if (self) {
        self.requestMethod=XBHRequestMethodPost;
        self.requestType=XBHBackgroundRequestType_Upload;
    }
    return self;
}

/// 当POST的内容带有文件等富文本时使用
- (AFConstructingBlock)constructingBodyBlock{
    NSData *data=nil;
    if ([self.uploadData length]) {
        data=self.uploadData;
    }
    else{
        if (!self.filePath
            &&![[NSFileManager defaultManager] fileExistsAtPath:self.filePath]) {
            return nil;
        }
        data=[NSData dataWithContentsOfFile:self.filePath options:NSDataReadingMappedIfSafe error:nil];;
        self.fileName=[self.filePath lastPathComponent];
    }
    if (self.contentOffset) {
        data=[data subdataWithRange:NSMakeRange(self.contentOffset, [data length]-self.contentOffset)];
    }
    
    NSString *name=[self.fileName stringByDeletingPathExtension];
    
    NSInputStream *stream=[NSInputStream inputStreamWithData:data];
    XBHWeakSelf;
    AFConstructingBlock block=^(id<AFMultipartFormData> formData){
        XBHStrongSelf;
        [formData appendPartWithInputStream:stream name:name fileName:strongSelf.fileName length:[data length] mimeType:strongSelf.mimeType];

    };
    
    
    return [block copy];
}


-(XBHBackgroundRequestNeedNewBodyStreamBlock)newNodyStreamBlock{
    return nil;
/*
    NSInputStream *stream=[NSInputStream inputStreamWithData:_uploadData];
    XBHBackgroundRequestNeedNewBodyStreamBlock block=^(NSURLSession *session, NSURLSessionTask *task){
    
        return stream;
    
    
    };
    return [block copy];
    
    */
}



@end
