//
//  SourceListRequest.h
//  XBHEBProject
//
//  Created by xubh-note on 15/5/4.
//  Copyright (c) 2015年 xu banghui. All rights reserved.
//

#import "XBHBaseRequest.h"
#import "XBHNetworking.h"
@interface SourceListRequest : XBHBaseRequest

- (instancetype)initWithIndex:(NSUInteger)index;
@end
