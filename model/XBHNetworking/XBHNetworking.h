//
//  XBHNetworking.h
//  XBHEBProject
//
//  Created by xubh-note on 15/4/21.
//  Copyright (c) 2015年 xu banghui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YTKRequest.h"

typedef NS_ENUM(NSInteger , XBHRequestMethod) {
    XBHRequestMethodGet = 0,
    XBHRequestMethodPost,
    XBHRequestMethodHead,
    XBHRequestMethodPut,
    XBHRequestMethodDelete,
    XBHRequestMethodPatch
};

typedef NS_ENUM(NSInteger , XBHRequestSerializerType) {
    XBHRequestSerializerTypeHTTP = 0,
    XBHRequestSerializerTypeJSON,
};


typedef NS_ENUM(NSInteger , XBHResponseSerializerType) {
    XBHResponseSerializerTypeHTTP = 0,
    XBHResponseSerializerTypeJSON,
    XBHResponseSerializerTypeXML,
    XBHResponseSerializerTypePropertyList
};



typedef NS_ENUM(NSInteger , XBHRequestResultStatus) {
    XBHRequestResultStatus_Success = 0,
    XBHRequestResultStatus_ResponseFailure,
    XBHRequestResultStatus_RequestFailure
};





typedef void (^AFConstructingBlock)(id<AFMultipartFormData> formData);
typedef void (^AFDownloadProgressBlock)(AFDownloadRequestOperation *operation, NSInteger bytesRead, long long totalBytesRead, long long totalBytesExpected, long long totalBytesReadForFile, long long totalBytesExpectedToReadForFile);



@interface XBHNetworking : NSObject


+(void)XBHNetworkinginitsetWithBaseURL:(NSString *)baseUrl CDNURL:(NSString *)cdnUrl;

+(NSString *)fullUrlWithPartUrl:(NSString *)ulr;

+(void)responseStatusFilterWithRespJSONObject:(NSDictionary *)json  netWorkingIsSuccess:(BOOL)isYn compeletion:(void(^)(NSDictionary *Json,XBHRequestResultStatus reStatus,NSString *message)) block;
@end
