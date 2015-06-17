//
//  XBHBackgroundSession.h
//  XBHEBProject
//
//  Created by xubh-note on 15/4/14.
//  Copyright (c) 2015年 xu banghui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XBHNetworking.h"
/*
 
 
        后台会话，主要用于上传、下载
 
 
 */

@class XBHBackgroundRequest;

@interface XBHBackgroundSession : NSObject

+ (XBHBackgroundSession *)sharedBackgroundSession;

-(void)setResponseSerialzerType:(XBHResponseSerializerType)type;

-(void)startWithRequest:(XBHBackgroundRequest *)request;

-(void)pauseWithRequest:(XBHBackgroundRequest *)request;
-(void)resumeWithRequest:(XBHBackgroundRequest *)request;
-(void)stopWithRequest:(XBHBackgroundRequest *)request;
- (NSProgress *)uploadProgressWithRequest:(XBHBackgroundRequest *)request;
@end

