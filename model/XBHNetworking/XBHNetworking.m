//
//  XBHNetworking.m
//  XBHEBProject
//
//  Created by xubh-note on 15/4/21.
//  Copyright (c) 2015年 xu banghui. All rights reserved.
//

#import "XBHNetworking.h"
#import "YTKNetworkConfig.h"
@implementation XBHNetworking

+(void)XBHNetworkinginitsetWithBaseURL:(NSString *)baseUrl CDNURL:(NSString *)cdnUrl{

    YTKNetworkConfig *config = [YTKNetworkConfig sharedInstance];
    config.baseUrl =baseUrl;// @"http://symplasima.eicp.net:8090";
    config.cdnUrl = cdnUrl;
        
}

+(NSString *)fullUrlWithPartUrl:(NSString *)ulr{
    if ([[YTKNetworkConfig sharedInstance].baseUrl length]) {
        return [[YTKNetworkConfig sharedInstance].baseUrl stringByAppendingString:ulr];
    }
    return ulr;
}

+(void)responseStatusFilterWithRespJSONObject:(NSDictionary *)json  netWorkingIsSuccess:(BOOL)isYn compeletion:(void(^)(NSDictionary *Json,XBHRequestResultStatus reStatus,NSString *message)) block{

    NSString *status=json[kJSONResponseStatus];
   
    XBHRequestResultStatus  rStatus=XBHRequestResultStatus_RequestFailure;
    
    NSString *notifyMessage=json[kJSONResponseMessage];
    if (isYn) {
        
        if ([status isEqualToString:kJSONResponseStatus_Success]) {
            
            rStatus=XBHRequestResultStatus_Success;
        }
        else{
            rStatus=XBHRequestResultStatus_ResponseFailure;
        }
    }
    else {
        if (![notifyMessage length]) {
            notifyMessage=@"网络出错，请稍候再试";
        }
        
    }

    if (block) {
        block(json,rStatus,notifyMessage);
    }


}


@end
