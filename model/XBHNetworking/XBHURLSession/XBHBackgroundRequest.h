//
//  XBHBackgroundRequest.h
//  XBHEBProject
//
//  Created by xubh-note on 15/4/14.
//  Copyright (c) 2015年 xu banghui. All rights reserved.
/*
 
 
    后台请求,上传或下载
 
 
 
 */

#import <Foundation/Foundation.h>

#import "XBHNetworking.h"

typedef NSInputStream * (^XBHBackgroundRequestNeedNewBodyStreamBlock)(NSURLSession *session, NSURLSessionTask *task);



typedef NS_ENUM(NSUInteger, XBHBackgroundRequestType){
    XBHBackgroundRequestType_Normal=0,
    XBHBackgroundRequestType_Download,
    XBHBackgroundRequestType_Upload


};




@interface XBHBackgroundRequest : NSObject

@property (nonatomic)             NSInteger                     tag;

@property   (nonatomic,strong)    NSDictionary                  *userInfo;

@property (nonatomic,assign)      XBHRequestMethod              requestMethod;

@property   (nonatomic,assign)    XBHBackgroundRequestType      requestType;

@property (nonatomic,assign)    XBHRequestSerializerType   requestSerializerType;


@property   (nonatomic,strong)    NSString                      *requestURLString;

@property   (nonatomic,strong)    NSDictionary                  *requestHeaders;

@property   (nonatomic,strong)    id                            responseObjct;

//外部调用 不要设置
@property (nonatomic,strong)       NSURLSessionTask             *task;

//get 加在url后  post  在body
@property   (nonatomic,strong)    id                            requestArgument;
//第一项 用户名 第二项 密码
@property   (nonatomic,strong)    NSArray                       *requestAuthorizationHeaderFieldArray;

@property   (nonatomic,strong)  id               object;

@property (nonatomic, copy) void (^successCompletionBlock)(XBHBackgroundRequest *);

@property (nonatomic, copy) void (^failureCompletionBlock)(XBHBackgroundRequest *);


+(void)setResponseSerializerType:(XBHResponseSerializerType)type;

+(instancetype)requestWithURL:(NSString *)urlstring;

- (instancetype)initWithUrl:(NSString *)urlstring;
/// block回调
- (void)startWithCompletionBlockWithSuccess:(void (^)(XBHBackgroundRequest *request))success
                                    failure:(void (^)(XBHBackgroundRequest *request))failure;

- (void)setCompletionBlockWithSuccess:(void (^)(XBHBackgroundRequest *request))success
                              failure:(void (^)(XBHBackgroundRequest *request))failure;

/// 把block置nil来打破循环引用
- (void)clearCompeleteBlock;
- (NSProgress *)uploadProgress;
-(void)stop;
-(void)pause;
-(void)resume;

/// 当POST的内容带有文件等富文本时使用
- (AFConstructingBlock)constructingBodyBlock;

//

-(XBHBackgroundRequestNeedNewBodyStreamBlock)newNodyStreamBlock;


@end
