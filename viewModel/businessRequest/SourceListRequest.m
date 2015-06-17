//
//  SourceListRequest.m
//  XBHEBProject
//
//  Created by xubh-note on 15/5/4.
//  Copyright (c) 2015年 xu banghui. All rights reserved.
//

#import "SourceListRequest.h"

@implementation SourceListRequest
{
    NSUInteger              _pageSize;
    NSUInteger              _index;

}
- (instancetype)initWithIndex:(NSUInteger)index
{
    self = [super init];
    if (self) {
        _pageSize=10;
        _index=index;
    }
    return self;
}



-(NSString *)requestUrl{
    return @"/docmaster/app/document";
}

-(id)requestArgument{

    return @{@"list":@"",@"PageSize":@(_pageSize),@"PageIndex":@(_index)};
}
@end
