//
//  XBHDownloadManager.m
//  gwEdu
//
//  Created by xubh-note on 14-6-12.
//  Copyright (c) 2014年 gwsoft. All rights reserved.
//

#import "XBHDownloadManager.h"
#import "XBHBaseRequest.h"


NSString * const XBHHTTPDownloadNotify=@"XBHHTTPDownloadNotify";

NSString * const XBHHTTPDownloadAllRequestCompeleteNotify=@"XBHHTTPDownloadAllRequestCompeleteNotify";


@interface XBHDownloadManager ()

@property   (nonatomic,strong)      XBHBaseRequest      *mCurDownloadRequest;

@property   (nonatomic,strong)      XBHDownloadDoc      *mCurDownloadDoc;
@end


@implementation XBHDownloadManager
{
    
    NSUInteger         mRequestTag;
    XBHDownloadDocument     *_mDocument;
    dispatch_queue_t            mQueue;
}
@synthesize mUserId;


+ (XBHDownloadManager *)shareInstance
{
    static XBHDownloadManager *shareManager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        shareManager = [[[self class] alloc] initShareInstance];
    });
    return shareManager;
}

-(id)init
{
    NSAssert(NO, @"单列类，不能通过alloc init方法 来创建");
    return nil;
}



- (id)initShareInstance
{
    self = [super init];
    if (self) {
        _mDocument= [[XBHDownloadDocument alloc] init];
        self.mUserId=DefaultUserId;
        mQueue=dispatch_queue_create([[NSString stringWithFormat:@"com.xubh.gwsoft.xbhhttpdownloadmgr.%@",self] UTF8String], 0);
       // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appIntoBackGround) name:UIApplicationDidEnterBackgroundNotification object:nil];
       //  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    }
    return self;
}


- (void)dealloc
{
        
    [[NSNotificationCenter defaultCenter] removeObserver:self];
  
}



-(NSUInteger)requestTag{
    return ++mRequestTag;
}
-(XBHDownloadDocument *)mDownloadDocument{
    return _mDocument;
}

-(NSDictionary *)buildRequestUserInfo:(long long)userId DataId:(long long)dataId DataType:(NSUInteger)type DataName:(NSString *)dataName{
    NSMutableDictionary *dict=[NSMutableDictionary dictionary];
    [dict setObject:[NSNumber numberWithLongLong:userId] forKey:kXBHHTTPDownload_UserId];
    [dict setObject:[NSNumber numberWithLongLong:dataId] forKey:kXBHHTTPDownload_DataId];
    [dict setObject:[NSNumber numberWithUnsignedInteger:type] forKey:kXBHHTTPDownload_DataType];
    [dict setObject:dataName forKey:kXBHHTTPDownload_DataName];
    return dict;

}

-(void)removeWithUserInfo:(NSDictionary *)userInfo{
    [_mDocument deleteOneNoteWithDataId:[[userInfo objectForKey:kXBHHTTPDownload_DataId] longLongValue] DataType:[[userInfo objectForKey:kXBHHTTPDownload_DataType] longValue] UserId:[[userInfo objectForKey:kXBHHTTPDownload_UserId] longLongValue]  isDeleteFile:YES];

}


-(void)setDownloadStatusWithUserInfo:(NSDictionary *)userInfo Status:(XBHDownloadStatus)status{
    [_mDocument setDownloadStatusWithUserId:[[userInfo objectForKey:kXBHHTTPDownload_UserId] longLongValue] DataId:[[userInfo objectForKey:kXBHHTTPDownload_DataId] longLongValue] DataType:[[userInfo objectForKey:kXBHHTTPDownload_DataType] longValue] DownloadStatus:status];
}

#pragma mark -

-(void)notifyRequestStatusWithRequestUserInfo:(NSDictionary *)userInfo Status:(XBHDownloadStatus)status Progress:(CGFloat)progress{

    NSMutableDictionary   *dict=[NSMutableDictionary dictionaryWithDictionary:userInfo];
    
    [dict setObject:[NSNumber numberWithInteger:status] forKey:kXBHHTTPDownload_Status];
    [dict setObject:[NSNumber numberWithFloat:progress] forKey:kXBHHTTPDownload_Progress];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:XBHHTTPDownloadNotify object:self userInfo:dict];

}



-(void)goNextDownloadWithUserId:(long long)userId{
   
    XBHDownloadDoc *doc=[_mDocument oneXBHDownloadDocWithDownloadStatus:XBHDownloadStatus_DownloadWate UserId:userId];
    if (doc) {
        [self startDownloadRequestWithXBHDownloadDoc:doc XBHDownloadDocument:_mDocument];
    }
    else{
        self.mCurDownloadRequest=nil;
        self.mCurDownloadDoc=nil;
        [self downloadAllRequestCompeleteNotify];
    
    }
  

}
-(void)downloadAllRequestCompeleteNotify{
    //通知全部下载完
    NSMutableDictionary   *dict=[NSMutableDictionary dictionary];
    [dict setObject:[NSNumber numberWithLongLong:self.mUserId] forKey:kXBHHTTPDownload_UserId];
    [dict setObject:[NSNumber numberWithInteger:XBHDownloadStatus_DownloadCompelete] forKey:kXBHHTTPDownload_Status];
    [dict setObject:[NSNumber numberWithFloat:1.0] forKey:kXBHHTTPDownload_Progress];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:XBHHTTPDownloadAllRequestCompeleteNotify object:self userInfo:dict];

}

#pragma mark-

-(void)XBHDownloadRequestWillStart:(NSDictionary *)userInfo{
    [self setDownloadStatusWithUserInfo:userInfo Status:XBHDownloadStatus_Downloading];
    [self notifyRequestStatusWithRequestUserInfo:userInfo Status:XBHDownloadStatus_Downloading Progress:0];
}

-(void)XBHDownloadRequestFailed:(NSDictionary *)userInfo{
    //，提示外面失败
    [self setDownloadStatusWithUserInfo:userInfo Status:XBHDownloadStatus_DownloadFailure];
    [self notifyRequestStatusWithRequestUserInfo:userInfo Status:XBHDownloadStatus_DownloadFailure Progress:0];
    
    //继续下一个
    [self goNextDownloadWithUserId:[[userInfo objectForKey:kXBHHTTPDownload_UserId] longLongValue]];
}

-(void)XBHDownloadRequestSuccessed:(NSDictionary *)userInfo{
    [self setDownloadStatusWithUserInfo:userInfo Status:XBHDownloadStatus_DownloadCompelete];
     [self notifyRequestStatusWithRequestUserInfo:userInfo Status:XBHDownloadStatus_DownloadCompelete Progress:1.0];
    //继续下一个
    [self goNextDownloadWithUserId:[[userInfo objectForKey:kXBHHTTPDownload_UserId] longLongValue]];
}

-(void)XBHDownloadRequest:(NSDictionary *)userInfo Progress:(CGFloat)progress{
    if (progress > 0.000000) {
        dispatch_async(mQueue, ^{
            [_mDocument setProgress:progress UserId:[[userInfo objectForKey:kXBHHTTPDownload_UserId] longLongValue] DataId:[[userInfo objectForKey:kXBHHTTPDownload_DataId] longLongValue] DataType:[[userInfo objectForKey:kXBHHTTPDownload_DataType] longValue] ];
            
        });
        
        
        [self notifyRequestStatusWithRequestUserInfo:userInfo Status:XBHDownloadStatus_Downloading Progress:progress];
    }
    
    

}

#pragma mark -


-(void)downloadWithXBHDownloadDoc:(XBHDownloadDoc*)doc{
    
    [self downloadWithXBHDownloadDoc:doc isStart:YES];
}




-(void)downloadWithXBHDownloadDoc:(XBHDownloadDoc*)doc isStart:(BOOL)start{
    
    if (!doc.DataName) {
        
        NSLog(@"未命名 文件名字，可能会导致不可预料的问题");
        
        doc.DataName=@"未命名.dat";
    }
    if (doc.UserId) {
        self.mUserId=doc.UserId;
    }
    
    
    if (start) {
        if (![self startDownloadRequestWithXBHDownloadDoc:doc XBHDownloadDocument:_mDocument]) {
            doc.DownloadStatus=XBHDownloadStatus_DownloadWate;
            [_mDocument addIntoDocumentWithXBHDownloadDoc:doc];
            
        }
    }
    else{
        doc.DownloadStatus=XBHDownloadStatus_DownloadWate;
        [_mDocument addIntoDocumentWithXBHDownloadDoc:doc];
        
    }
    
}

-(BOOL)isRequesting{
    return (self.mCurDownloadRequest != nil);
}

-(void)start{
    if (![self isRequesting]){
        [self goNextDownloadWithUserId:mUserId];
    }

}


-(BOOL)startDownloadRequestWithXBHDownloadDoc:(XBHDownloadDoc*)doc XBHDownloadDocument :(XBHDownloadDocument*)document{
    BOOL    rn=NO;
    if (![self isRequesting]) {
        rn=YES;
         NSString        *storePath=[XBHDownloadDocument downloadDataPathWithFileName:doc.DataName];
        if ([[NSFileManager defaultManager] fileExistsAtPath:storePath]) {
            //文件已经存在
            doc.DownloadStatus=XBHDownloadStatus_DownloadCompelete;
            [document addIntoDocumentWithXBHDownloadDoc:doc];
            [document setProgress:1.0 UserId:doc.UserId DataId:doc.DataId DataType:doc.DataType];
            //通知下载完
            NSMutableDictionary   *dict=[NSMutableDictionary dictionary];
            [dict setObject:[NSNumber numberWithLongLong:doc.UserId] forKey:kXBHHTTPDownload_UserId];
            [dict setObject:[NSNumber numberWithLongLong:doc.DataId] forKey:kXBHHTTPDownload_DataId];
            [dict setObject:[NSNumber numberWithUnsignedInteger:doc.DataType] forKey:kXBHHTTPDownload_DataType];
            [dict setObject:doc.DataName forKey:kXBHHTTPDownload_DataName];
            [dict setObject:[NSNumber numberWithInteger:XBHDownloadStatus_DownloadCompelete] forKey:kXBHHTTPDownload_Status];
            [dict setObject:[NSNumber numberWithFloat:1.0] forKey:kXBHHTTPDownload_Progress];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:XBHHTTPDownloadNotify object:self userInfo:dict];
            
            [self goNextDownloadWithUserId:doc.UserId];
            return rn;
        }
        
        doc.DownloadStatus=XBHDownloadStatus_DownloadWate;
        [document addIntoDocumentWithXBHDownloadDoc:doc];
        

        XBHWeakSelf;
        XBHBaseRequest *req=[XBHBaseRequest requestWithURLString:doc.DataURL];
        req.tag=[self requestTagWithURL:doc.DataURL storePath:storePath];
        req.requestMethod=YTKRequestMethodGet;
        req.downloadFileStorePath=storePath;
        NSDictionary *userInfo=[self buildRequestUserInfo:doc.UserId DataId:doc.DataId DataType:doc.DataType DataName:doc.DataName];
        req.userInfo=userInfo;
        req.downlooadProgressBlock=^(AFDownloadRequestOperation *operation, NSInteger bytesRead, long long totalBytesRead, long long totalBytesExpected, long long totalBytesReadForFile, long long totalBytesExpectedToReadForFile){
            XBHStrongSelf;
            [strongSelf XBHDownloadRequest:userInfo Progress:(CGFloat)totalBytesReadForFile/(CGFloat)totalBytesExpectedToReadForFile];
        };
        
        [self XBHDownloadRequestWillStart:userInfo];
        [req startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
            XBHStrongSelf;
            [strongSelf XBHDownloadRequestSuccessed:request.userInfo];
            
        } failure:^(YTKBaseRequest *request) {
            XBHStrongSelf;
            [strongSelf XBHDownloadRequestFailed:request.userInfo];
        }];
      
        
        self.mCurDownloadRequest=req;
        self.mCurDownloadDoc=doc;
        /*
        [self.mCurDownloadRequest.afOperation setShouldExecuteAsBackgroundTaskWithExpirationHandler:^{
            XBHStrong(strongSelf, weakself);
            [strongSelf pauseRequestWithDataId:doc.DataId DataType:doc.DataType isGoNext:NO];
        }];
        */
        
    }
    return rn;

}

-(NSInteger)requestTagWithURL:(NSString *)url storePath:(NSString *)path{
   NSString *urlmd5= [XBHUitility md5StringFromString:url];
    NSString *pathmd5=[XBHUitility md5StringFromString:path];
    
     return [[urlmd5 stringByAppendingString:pathmd5] hash];
}


-(void)pauseRequestWithDataId:(long long )dataId DataType:(NSUInteger)type{
    [self pauseRequestWithDataId:dataId DataType:type isGoNext:NO];
}
-(void)pauseRequestWithDataId:(long long )dataId DataType:(NSUInteger)type isGoNext:(BOOL)isGo{
    [self cancelRequestWithDataId:dataId DataType:type Status:XBHDownloadStatus_DownloadPause_ByUser];
    if (isGo) {
        [self goNextDownloadWithUserId:self.mUserId];
    }
}


-(void)cancelRequestWithDataId:(long long )dataId DataType:(NSUInteger)type{
    [self cancelRequestWithDataId:dataId DataType:type Status:XBHDownloadStatus_None];
}

-(void)cancelRequestWithDataId:(long long )dataId DataType:(NSUInteger)type Status:(XBHDownloadStatus)status{
    NSString *url=[_mDocument dataURLWithDataId:dataId DataType:type];
    NSString *storePath=[_mDocument dataStorePathWithDataId:dataId DataType:type];
    
    if (status == XBHDownloadStatus_None) {
        //从纪录中取消
        [_mDocument deleteOneNoteWithDataId:dataId DataType:type UserId:self.mUserId isDeleteFile:YES];
      
        
    }
    else{
        [_mDocument setDownloadStatusWithUserId:self.mUserId DataId:dataId DataType:type DownloadStatus:status];
    }
    
    if (self.mCurDownloadRequest
        &&self.mCurDownloadRequest.tag == [self requestTagWithURL:url storePath:storePath]) {
        [self.mCurDownloadRequest stop];
        self.mCurDownloadRequest=nil;
    }

    

}

-(void)downloadContinue{
    
    if (![self isRequesting]) {
        [self goNextDownloadWithUserId:self.mUserId];
    }

}


-(void)cancelNetwork{
    if (self.mCurDownloadRequest) {
        [self.mCurDownloadRequest stop];
        self.mCurDownloadRequest=nil;
       
    }
     self.mCurDownloadDoc=nil;
}


-(void)appEnterForeground{

    if (self.mCurDownloadDoc) {
        [self startDownloadRequestWithXBHDownloadDoc:self.mCurDownloadDoc XBHDownloadDocument:_mDocument];
    }
}

-(void)appIntoBackGround{
   
    if (self.mCurDownloadRequest) {
        [self pauseRequestWithDataId:[[self.mCurDownloadRequest.userInfo objectForKey:kXBHHTTPDownload_DataId] longLongValue] DataType:[[self.mCurDownloadRequest.userInfo objectForKey:kXBHHTTPDownload_DataType] longValue] isGoNext:NO];
    }

}

@end
