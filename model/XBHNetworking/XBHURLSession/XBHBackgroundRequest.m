//
//  XBHBackgroundRequest.m
//  XBHEBProject
//
//  Created by xubh-note on 15/4/14.
//  Copyright (c) 2015年 xu banghui. All rights reserved.
//

#import "XBHBackgroundRequest.h"
#import "XBHBackgroundSession.h"

@implementation XBHBackgroundRequest


+(instancetype)requestWithURL:(NSString *)urlstring{

    return [[self alloc] initWithUrl:urlstring];
}

+(void)setResponseSerializerType:(XBHResponseSerializerType)type{
   
    [[XBHBackgroundSession sharedBackgroundSession] setResponseSerialzerType:type];
}

- (instancetype)init
{
        return [self initWithUrl:nil];
}

- (instancetype)initWithUrl:(NSString *)urlstring
{
    self = [super init];
    if (self) {
        self.requestMethod=XBHRequestMethodGet;
        self.requestURLString=urlstring;
    }
    return self;
}


-(void)start {
    [[XBHBackgroundSession sharedBackgroundSession] startWithRequest:self];
}

-(void)stop{
    [self clearCompeleteBlock];
    [[XBHBackgroundSession sharedBackgroundSession] stopWithRequest:self];
    
}
-(void)pause{
    [[XBHBackgroundSession sharedBackgroundSession] pauseWithRequest:self];
}
-(void)resume{
    [[XBHBackgroundSession sharedBackgroundSession] resumeWithRequest:self];
}

- (void)startWithCompletionBlockWithSuccess:(void (^)(XBHBackgroundRequest *request))success
                                    failure:(void (^)(XBHBackgroundRequest *request))failure {
    [self setCompletionBlockWithSuccess:success failure:failure];
    [self start];
}


- (void)setCompletionBlockWithSuccess:(void (^)(XBHBackgroundRequest *request))success
                              failure:(void (^)(XBHBackgroundRequest *request))failure {
    self.successCompletionBlock = success;
    self.failureCompletionBlock = failure;
}


-(void)clearCompeleteBlock{
    self.successCompletionBlock=nil;
    self.failureCompletionBlock=nil;
}


- (NSProgress *)uploadProgress{
    if (self.task) {
      return   [[XBHBackgroundSession sharedBackgroundSession] uploadProgressWithRequest:self];
    }
    return nil;

}


/// 当POST的内容带有文件等富文本时使用
- (AFConstructingBlock)constructingBodyBlock{

    return nil;
}


-(XBHBackgroundRequestNeedNewBodyStreamBlock)newNodyStreamBlock{

    return nil;


}

@end
