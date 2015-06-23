//
//  XBHUploadManager.m
//  XBHEBProject
//
//  Created by xubh-note on 15/4/21.
//  Copyright (c) 2015年 xu banghui. All rights reserved.
//

#import "XBHUploadManager.h"



NSString * const XBHHTTPUploadNotify=@"XBHHTTPUploadNotify";

NSString * const XBHHTTPUploadAllRequestCompeleteNotify=@"XBHHTTPUploadAllRequestCompeleteNotify";

@interface XBHUploadManager ()

@property   (nonatomic,strong)      XBHUploadRequest        *mCurUploadRequest;


@property   (nonatomic,strong)      NSTimer                 *mProgressTimer;
@end

@implementation XBHUploadManager
{
     NSUInteger                 mRequestTag;
    XBHUploadDocument           *_docment;

}

+ (XBHUploadManager *)shareInstance
{
    static XBHUploadManager *shareManager = nil;
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
        _docment= [[XBHUploadDocument alloc] init];
        self.userId=DefaultUserId;
    }
    return self;
}


-(NSUInteger)requestTag{
    return ++mRequestTag;
    
}


-(XBHUploadDocument *)document{
    return _docment;
}


-(NSUInteger)dispatchDiffrentDataId{
   long long time= [[NSDate date] timeIntervalSinceReferenceDate]*1000;
    return [[XBHUitility md5StringFromString:[NSString stringWithFormat:@"%lld",time]] hash];

}





-(void)removeWithUploadDoc:(XBHUploadDoc *)doc{
    [_docment deleteOneNoteWithUserId:doc.UserId DataId:doc.DataId DataType:doc.DataType];
}




-(void)setUploadStatusWithUploadDoc:(XBHUploadDoc *)doc Status:(XBHUploadStatus)status{
    [_docment setUploadStatusWithUserId:doc.UserId DataId:doc.DataId DataType:doc.DataType UploadStatus:status];
}

#pragma mark -

-(void)notifyRequestStatusWithUploadDoc:(XBHUploadDoc *)doc Status:(XBHUploadStatus)status Progress:(CGFloat)progress{
    
    doc.UploadStatus=status;
    doc.Progress=progress;
 
    [[NSNotificationCenter defaultCenter] postNotificationName:XBHHTTPUploadNotify object:doc userInfo:nil];
    
}



-(void)goNextUploadWithUserId:(long long)userId{
    [self cancelNetwork];
    XBHUploadDoc *doc=[_docment oneXBHUploadDocWithUploadStatus:XBHUploadStatus_UploadWate UserId:userId];
    if (doc) {
        [self startUploadRequestWithXBHUploadDoc:doc XBHUploadDocument:_docment];
    }
    else{
        
        [self UploadAllRequestCompeleteNotify];
        
    }
    
    
}
-(void)UploadAllRequestCompeleteNotify{
    //通知全部下载完
    [[NSNotificationCenter defaultCenter] postNotificationName:XBHHTTPUploadAllRequestCompeleteNotify object:self userInfo:nil];
    
}





-(void)uploadWithXBHUploadDoc:(XBHUploadDoc*)doc{
    
    [self uploadWithXBHUploadDoc:doc isStart:YES];
}




-(void)uploadWithXBHUploadDoc:(XBHUploadDoc*)doc isStart:(BOOL)start{
    
    if (!doc.DataSoucrePath) {
        
        NSLog(@"没有需要上传的文件");
        
        return;
    }
    if (doc.UserId) {
        self.userId=doc.UserId;
    }
    
    
    if (start) {
        if (![self startUploadRequestWithXBHUploadDoc:doc XBHUploadDocument:_docment]) {
            doc.UploadStatus=XBHUploadStatus_UploadWate;
            [_docment addIntoDocumentWithXBHUploadDoc:doc];
            
        }
    }
    else{
        doc.UploadStatus=XBHUploadStatus_UploadWate;
        [_docment addIntoDocumentWithXBHUploadDoc:doc];
        
    }
    
}






-(BOOL)isRequesting{
    return (self.mCurUploadRequest != nil);
}

-(void)resume{
    if (![self isRequesting]){
        [self goNextUploadWithUserId:self.userId];
    }
    
}


-(BOOL)startUploadRequestWithXBHUploadDoc:(XBHUploadDoc*)doc XBHUploadDocument :(XBHUploadDocument*)document{
    BOOL    rn=NO;
    if (![self isRequesting]) {
        rn=YES;
        [self stopTimer];
        doc.UploadStatus=XBHUploadStatus_Uploading;
        [document addIntoDocumentWithXBHUploadDoc:doc];
        
        XBHWeakSelf;
        XBHUploadRequest *req=[XBHUploadRequest requestWithURL:doc.DataUploadURL];
        req.tag=[self requestTagWithURL:doc.DataUploadURL sourcePath:doc.DataSoucrePath];
        req.requestMethod=YTKRequestMethodPost;
        req.filePath=doc.DataSoucrePath;
        req.mimeType=doc.mimeType;
        if (doc.DataReferenceInfo) {
            //只支持数组 字典形式
            req.requestArgument=[NSJSONSerialization JSONObjectWithData:doc.DataReferenceInfo options:NSJSONReadingMutableContainers error:nil];
            
        }
        /*
        NSDictionary *userInfo=[self buildRequestUserInfo:doc.UserId DataId:doc.DataId DataType:doc.DataType DataPath:doc.DataSoucrePath];
        req.userInfo=userInfo;
         */
        req.object=doc;
        [self XBHUploadRequestWillStart:doc];
        [req startWithCompletionBlockWithSuccess:^(XBHBackgroundRequest *request) {
            XBHStrongSelf;
            [strongSelf XBHUploadRequestSuccessed:request.object];
            
        } failure:^(XBHBackgroundRequest *request) {
            XBHStrongSelf;
            [strongSelf XBHUploadRequestFailed:request.object];
        }];
        
        
        self.mCurUploadRequest=req;

        self.mProgressTimer=[NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(getProgress) userInfo:nil repeats:YES];
    }
    return rn;
    
}
-(void)stopTimer{
    if (self.mProgressTimer) {
        [self.mProgressTimer invalidate];
        self.mProgressTimer=nil;
    }
}

-(void)getProgress{
    if (!self.mCurUploadRequest) {
        return;
    }
    NSProgress *pro=[self.mCurUploadRequest uploadProgress];
    if (pro) {
        XBHUploadDoc *doc=self.mCurUploadRequest.object;
        CGFloat progress=(CGFloat)pro.completedUnitCount/pro.totalUnitCount;
        if (progress >0.000001
            &&progress<1.01) {
            [_docment setProgress:progress UserId:doc.UserId DataId:doc.DataId DataType:doc.DataType];
            [self notifyRequestStatusWithUploadDoc:doc Status:XBHUploadStatus_Uploading Progress:progress];
        }

        
    }
    
}
#pragma mark-

-(void)XBHUploadRequestWillStart:(XBHUploadDoc *)doc{
    [self setUploadStatusWithUploadDoc:doc Status:XBHUploadStatus_Uploading];
    [self notifyRequestStatusWithUploadDoc:doc Status:XBHUploadStatus_Uploading Progress:0];
}

-(void)XBHUploadRequestFailed:(XBHUploadDoc *)doc{
    //提示外面失败
    [self setUploadStatusWithUploadDoc:doc Status:XBHUploadStatus_UploadFailure];
    [self notifyRequestStatusWithUploadDoc:doc Status:XBHUploadStatus_UploadFailure Progress:0];
    
    //继续下一个
    [self goNextUploadWithUserId:doc.UserId];
}

-(void)XBHUploadRequestSuccessed:(XBHUploadDoc *)doc{
    [self setUploadStatusWithUploadDoc:doc Status:XBHUploadStatus_UploadCompelete];
    [self notifyRequestStatusWithUploadDoc:doc Status:XBHUploadStatus_UploadCompelete Progress:1.0];
    //继续下一个
    [self goNextUploadWithUserId:doc.UserId];
}





-(long)requestTagWithURL:(NSString *)url sourcePath:(NSString *)path{
    NSString *urlmd5= [XBHUitility md5StringFromString:url];
    NSString *pathmd5=[XBHUitility md5StringFromString:path];
    
    return [[urlmd5 stringByAppendingString:pathmd5] hash];
}


-(void)pauseRequestWithDataId:(long long )dataId DataType:(NSUInteger)type{
    [self pauseRequestWithDataId:dataId DataType:type isGoNext:YES];
}
-(void)pauseRequestWithDataId:(long long )dataId DataType:(NSUInteger)type isGoNext:(BOOL)isGo{
    [self cancelRequestWithDataId:dataId DataType:type Status:XBHUploadStatus_UploadPause_ByUser];
    if (isGo) {
        [self goNextUploadWithUserId:self.userId];
    }
}


-(void)cancelRequestWithDataId:(long long )dataId DataType:(NSUInteger)type{
    [self cancelRequestWithDataId:dataId DataType:type Status:XBHUploadStatus_None];
}

-(void)cancelRequestWithDataId:(long long )dataId DataType:(NSUInteger)type Status:(XBHUploadStatus)status{
    NSString *url=[_docment dataUploadURLWithUserId:self.userId DataId:dataId DataType:type];
    NSString *sourcePath=[_docment dataSourcePathWithUserId:self.userId DataId:dataId DataType:type];
    
    if (status == XBHUploadStatus_None) {
        //从纪录中取消
        [_docment deleteOneNoteWithUserId:self.userId DataId:dataId DataType:type];
        
        
    }
    else{
        [_docment setUploadStatusWithUserId:self.userId DataId:dataId DataType:type UploadStatus:status];
    }
    
    if (self.mCurUploadRequest
        &&self.mCurUploadRequest.tag == [self requestTagWithURL:url sourcePath:sourcePath]) {
        [self cancelNetwork];
    }
    
    
    
}

-(void)UploadContinue{
    
    if (![self isRequesting]) {
        [self goNextUploadWithUserId:self.userId];
    }
    
}


-(void)cancelNetwork{
    [self stopTimer];

    if (self.mCurUploadRequest) {
        [self.mCurUploadRequest stop];
        self.mCurUploadRequest=nil;
    }
   
}

@end
