//
//  XBHBackgroundSession.m
//  XBHEBProject
//
//  Created by xubh-note on 15/4/14.
//  Copyright (c) 2015年 xu banghui. All rights reserved.
//

#import "XBHBackgroundSession.h"
#import "AFNetworking.h"
#import "XBHBackgroundRequest.h"

#define SuccessResponseHandle [self handleRequestResult:task responseObj:responseObject isSucceed:YES]

#define FailureResponseHandle [self handleRequestResult:task responseObj:nil isSucceed:NO]

@implementation XBHBackgroundSession
{
    AFHTTPSessionManager        *_manager;
    NSMutableDictionary         *_requestSets;
    XBHResponseSerializerType    _managerRespSerialzerType;
}
+ (XBHBackgroundSession *)sharedBackgroundSession{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    
        NSURLSessionConfiguration     *sessionConfig=nil;
        if (IOS_SYSTEMVERSION_LATER(@"8.0")) {
            [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"com.xubh.fileTrans.session"];
            
        }
        else{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

            sessionConfig=[NSURLSessionConfiguration backgroundSessionConfiguration:@"com.xubh.fileTrans.session"];
#pragma clang diagnostic pop
        }
        

        sessionConfig.timeoutIntervalForRequest=10.f;//请求超时
        sessionConfig.discretionary=YES;//系统选择最佳网络
        sessionConfig.HTTPMaximumConnectionsPerHost=5;//最多5个链接
        _manager=[[AFHTTPSessionManager alloc] initWithBaseURL:nil sessionConfiguration:sessionConfig];
        _managerRespSerialzerType=XBHResponseSerializerTypeJSON;
        _requestSets=[NSMutableDictionary dictionary];
       
    }
    return self;
}
-(void)setResponseSerialzerType:(XBHResponseSerializerType)type{
    if (type != _managerRespSerialzerType) {
        if (type == XBHResponseSerializerTypeHTTP) {
            _manager.responseSerializer=[AFHTTPResponseSerializer serializer];
        }
        else if (type == XBHResponseSerializerTypeJSON) {
            _manager.responseSerializer=[AFJSONResponseSerializer serializer];
        }
        else if (type == XBHResponseSerializerTypeXML) {
            _manager.responseSerializer=[AFXMLParserResponseSerializer serializer];
        }
        else if (type == XBHResponseSerializerTypePropertyList) {
            _manager.responseSerializer=[AFPropertyListResponseSerializer serializer];
        }
        
        _managerRespSerialzerType=type;
    }
    
}


-(void)startWithRequest:(XBHBackgroundRequest *)request{
    if (request.requestSerializerType == XBHRequestSerializerTypeHTTP) {
        _manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    } else if (request.requestSerializerType == XBHRequestSerializerTypeJSON) {
        _manager.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    
    
    
    // if api need server username and password
    NSArray *authorizationHeaderFieldArray = request.requestAuthorizationHeaderFieldArray;
    if (authorizationHeaderFieldArray != nil) {
        [_manager.requestSerializer setAuthorizationHeaderFieldWithUsername:(NSString *)authorizationHeaderFieldArray.firstObject
                                                                   password:(NSString *)authorizationHeaderFieldArray.lastObject];
    }
    
    // if api need add custom value to HTTPHeaderField
    NSDictionary *headerFieldValueDictionary = request.requestHeaders;
    if (headerFieldValueDictionary != nil) {
        for (id httpHeaderField in headerFieldValueDictionary.allKeys) {
            id value = headerFieldValueDictionary[httpHeaderField];
            if ([httpHeaderField isKindOfClass:[NSString class]] && [value isKindOfClass:[NSString class]]) {
                [_manager.requestSerializer setValue:(NSString *)value forHTTPHeaderField:(NSString *)httpHeaderField];
            }
        }
    }
    
  
    
    if (request.requestType == XBHBackgroundRequestType_Upload) {
        AFConstructingBlock constructingBlock = [request constructingBodyBlock];
        XBHBackgroundRequestNeedNewBodyStreamBlock block=[request newNodyStreamBlock];
        if (block) {
            [_manager setTaskNeedNewBodyStreamBlock:block];
        }

        if (constructingBlock) {
            request.task=[_manager POST:request.requestURLString parameters:request.requestArgument constructingBodyWithBlock:constructingBlock success:^(NSURLSessionDataTask *task, id responseObject) {
               
                SuccessResponseHandle;
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                FailureResponseHandle;
                
            }];
        }
    }
    else if (request.requestType == XBHBackgroundRequestType_Download){
    
    
    }
    else if (request.requestType == XBHBackgroundRequestType_Normal){
        request.task=[self normalRequestHandlerWithRequest:request parameters:request.requestArgument];
    
    }
    [self addToRequestSets:request];
    [request.task resume];
}



-(NSURLSessionTask *)normalRequestHandlerWithRequest:(XBHBackgroundRequest *)request parameters:(id)params{

    NSURLSessionTask        *task=nil;


    if (request.requestMethod == XBHRequestMethodGet) {
     
            task= [_manager GET:request.requestURLString parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
                SuccessResponseHandle;
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                FailureResponseHandle;
            }];
    } else if (request.requestMethod  == XBHRequestMethodPost) {
        
            task = [_manager POST:request.requestURLString parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
                SuccessResponseHandle;
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                FailureResponseHandle;
            }];
        
    } else if (request.requestMethod  == XBHRequestMethodHead) {
        task = [_manager HEAD:request.requestURLString parameters:params success:^(NSURLSessionDataTask *task) {
            [self handleRequestResult:task responseObj:nil isSucceed:YES];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            FailureResponseHandle;
        }];
    } else if (request.requestMethod  == XBHRequestMethodPut) {
        task = [_manager PUT:request.requestURLString parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
            SuccessResponseHandle;
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            FailureResponseHandle;
        }];
    } else if (request.requestMethod  == XBHRequestMethodDelete) {
        task = [_manager DELETE:request.requestURLString parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
           SuccessResponseHandle;
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            FailureResponseHandle;
        }];
    } else if (request.requestMethod  == XBHRequestMethodPatch) {
        task = [_manager PATCH:request.requestURLString parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
           SuccessResponseHandle;
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            FailureResponseHandle;
        }];
    }

    return task;

}





- (void)handleRequestResult:(NSURLSessionTask *)task responseObj:(id)reqObj isSucceed:(BOOL)succeed{
    NSString *key = [self requestHashKey:task];
    XBHBackgroundRequest *request = _requestSets[key];
    
    if (request) {
        request.responseObjct=reqObj;
        if (succeed) {
            
            if (request.successCompletionBlock) {
                request.successCompletionBlock(request);
            }
            
        } else {
            if (request.failureCompletionBlock) {
                request.failureCompletionBlock(request);
            }
        }
    }
    [self removeRequestFromSets:task];
    [request clearCompeleteBlock];
}


- (NSString *)requestHashKey:(NSURLSessionTask *)task {
    NSString *key = [NSString stringWithFormat:@"%lu", (unsigned long)task.taskIdentifier];
    return key;
}

- (void)addToRequestSets:(XBHBackgroundRequest *)request{
    if (request.task) {
        NSString *key = [self requestHashKey:request.task];
        _requestSets[key] = request;
    }
    
}

- (void)removeRequestFromSets:(NSURLSessionTask *)task{
    NSString *key = [self requestHashKey:task];
    [_requestSets removeObjectForKey:key];
}


- (NSProgress *)uploadProgressWithRequest:(XBHBackgroundRequest *)request{

    if (request&&request.task) {
        return [_manager uploadProgressForTask:(NSURLSessionUploadTask *)request.task];
    }
    return nil;

}


-(void)pauseWithRequest:(XBHBackgroundRequest *)request{

    [request.task suspend];

}

-(void)resumeWithRequest:(XBHBackgroundRequest *)request{
    [request.task resume];
}

-(void)stopWithRequest:(XBHBackgroundRequest *)request{
    [request.task cancel];
    [self removeRequestFromSets:request.task];

}

@end
