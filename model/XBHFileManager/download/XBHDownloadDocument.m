//
//  XBHDownloadDocument.m
//  gwEdu
//
//  Created by xubh-note on 14-6-12.
//  Copyright (c) 2014年 gwsoft. All rights reserved.
//

#import "XBHDownloadDocument.h"
#import "XBHDownloadManager.h"

#define ShareDBQueue     [self shareFMDBQueueWithDBName:@"DataSource.sqlite"]

#define TableName_HTTPDownUser      @"tablename_httpDownUser"

#define TableName_HTTPDownSourceInfo      @"tablename_httpDownSourceInfo"

#define TableName_HTTPDownAssistInfo      @"tablename_httpDownAssistInfo"

@interface XBHDownloadDoc ()

@property (nonatomic,readwrite)  double  Progress;

@end


@implementation XBHDownloadDoc
@synthesize DataId;
@synthesize DataName;
@synthesize DataType;
@synthesize AssistId;
@synthesize DataURL;
@synthesize DataReferenceInfo;
@synthesize AssistReferenceInfo;
@synthesize DownloadStatus;
@synthesize IconURL;
@synthesize Progress=_Progress;

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)dealloc
{
    self.DataName=nil;
    self.DataURL=nil;
    self.DataReferenceInfo=nil;
    self.AssistReferenceInfo=nil;
    self.IconURL=nil;
}

-(void)setProgress:(double)Progress{
    _Progress=Progress;
}

@end






#pragma mark -

@implementation XBHDownloadDocument
{
    FMDatabaseQueue   *mFMDBQueue;
}


- (id)init
{
    self = [super init];
    if (self) {
        [self createTableIf];
    }
    return self;
}
- (void)dealloc
{
    if (mFMDBQueue) {
        [mFMDBQueue close];
    }

}
-(NSData *)userIdArrayDataWithArray:(NSArray*)idArray{
    if (!idArray) {
        return nil;
    }
    return [XBHUitility jsonDataWithObject:idArray];

}

-(NSArray *)userIdArrayWithData:(NSData *)jsonData{
    if (!jsonData) {
        return nil;
    }
    return [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
}
-(FMDatabaseQueue *)shareFMDBQueueWithDBName:(NSString *)DBName{
    if (!mFMDBQueue) {
        mFMDBQueue=[FMDatabaseQueue databaseQueueWithPath:[XBHUitility downloadResourceFilePathWithName:DBName]];
    }
    
    return mFMDBQueue;
}

-(void)createTableIf{
   
    
    [ShareDBQueue inDatabase:^(FMDatabase *db) {
        
        if (![db tableExists:TableName_HTTPDownUser]) {
            NSString *creatSql=[NSString stringWithFormat:@"CREATE TABLE %@ (ID INTEGER PRIMARY KEY AUTOINCREMENT,DataId INTEGER ,DataType INTEGER,UserId INTEGER, AssistId INTEGER, DownloadStatus INTEGER,Progress REAL)",TableName_HTTPDownUser];
            [db executeUpdate:creatSql];
        }
        
        if (![db tableExists:TableName_HTTPDownSourceInfo]) {
            NSString *creatSql=[NSString stringWithFormat:@"CREATE TABLE %@ (ID INTEGER PRIMARY KEY AUTOINCREMENT,DataId INTEGER ,DataType INTEGER,Owners BLOD,DataURL TEXT,DataPath TEXT,IconURL TEXT,DataReferenceInfo BLOD)",TableName_HTTPDownSourceInfo];
            [db executeUpdate:creatSql];
        }
        
        if (![db tableExists:TableName_HTTPDownAssistInfo]) {
            NSString *creatSql=[NSString stringWithFormat:@"CREATE TABLE %@ (ID INTEGER PRIMARY KEY AUTOINCREMENT,AssistId INTEGER,Owners BLOD ,AssistReferenceInfo BLOD)",TableName_HTTPDownAssistInfo];
            [db executeUpdate:creatSql];
        }
       
        
    }];
}

-(BOOL)isExistsInUserTableWithFMDatabase:(FMDatabase*)db ConditionUserId:(long long)userId ConditionDataId:(long long)dataId ConditionDataType:(NSUInteger)type{
    BOOL  rn=NO;
    NSString * cmd=[NSString  stringWithFormat:@"SELECT * FROM %@ WHERE UserId=%lld AND DataId=%lld AND DataType=%d",TableName_HTTPDownUser,userId,dataId,(uint32_t)type];
    
    FMResultSet *set= [db  executeQuery:cmd];
    if ([set next]) {
        rn=YES;
    }
    [set close];
    
    return rn;
}

-(BOOL)isExistsInSourceDataTableWithFMDatabase:(FMDatabase*)db ConditionDataId:(long long)dataId ConditionDataType:(NSUInteger)type{
    BOOL  rn=NO;
    NSString * cmd=[NSString  stringWithFormat:@"SELECT * FROM %@ WHERE DataId=%lld AND DataType=%d",TableName_HTTPDownSourceInfo,dataId,(uint32_t)type];
    
    FMResultSet *set= [db  executeQuery:cmd];
    if ([set next]) {
        rn=YES;
    }
    [set close];
    
    return rn;
}

-(BOOL)isExistsInAssistReferenceTableWithFMDatabase:(FMDatabase*)db ConditionAssistId:(long long)assistId{
    BOOL  rn=NO;
    NSString * cmd=[NSString  stringWithFormat:@"SELECT * FROM %@ WHERE AssistId=%lld ",TableName_HTTPDownAssistInfo,assistId];
    
    FMResultSet *set= [db  executeQuery:cmd];
    if ([set next]) {
        rn=YES;
    }
    [set close];
    
    return rn;
}

-(BOOL)isHaveDataSourceWithFMDatabase:(FMDatabase*)db UserId:(long long)userId ConditionAssistId:(long long)assistId{

    BOOL  rn=NO;
    NSString * cmd=[NSString  stringWithFormat:@"SELECT * FROM %@ WHERE AssistId=%lld  AND UserId=%lld",TableName_HTTPDownUser,assistId,userId];
    
    FMResultSet *set= [db  executeQuery:cmd];
    if ([set next]) {
        rn=YES;
    }
    [set close];
    
    return rn;


}


-(void)updateOwnersWithFMDatabase:(FMDatabase*)db UserIdList:(NSData *)idData ConditionDataId:(long long)dataId ConditionDataType:(NSUInteger)type{
    NSString *cmd=[NSString  stringWithFormat:@"UPDATE %@ SET Owners=? WHERE DataId=%lld AND DataType=%d",TableName_HTTPDownSourceInfo,dataId,(uint32_t)type];
    
    [db executeUpdate:cmd,idData];
    
}

-(void)updateOwnersIntoAssistTableWithFMDatabase:(FMDatabase*)db UserIdList:(NSData *)idData ConditionAssistId:(long long)assistId{
    NSString *cmd=[NSString  stringWithFormat:@"UPDATE %@ SET Owners=? WHERE AssistId=%lld ",TableName_HTTPDownAssistInfo,assistId];
    
    [db executeUpdate:cmd,idData];
    
}



-(void)updateDownloadStatusWithFMDatabase:(FMDatabase*)db XBHDownloadStatus:(XBHDownloadStatus)status ConditionUserId:(long long)userId ConditionDataId:(long long)dataId ConditionDataType:(NSUInteger)type{
    NSString *cmd=[NSString  stringWithFormat:@"UPDATE %@ SET DownloadStatus=? WHERE UserId=%lld AND DataId=%lld AND DataType=%d",TableName_HTTPDownUser,userId,dataId,(uint32_t)type];
    
    [db executeUpdate:cmd,[NSNumber numberWithUnsignedInteger:status]];
    
}

-(void)updateProgressWithFMDatabase:(FMDatabase*)db Progress:(double)progress ConditionUserId:(long long)userId ConditionDataId:(long long)dataId ConditionDataType:(NSUInteger)type{
    NSString *cmd=[NSString  stringWithFormat:@"UPDATE %@ SET Progress=? WHERE UserId=%lld AND DataId=%lld AND DataType=%d",TableName_HTTPDownUser,userId,dataId,(uint32_t)type];
    
    [db executeUpdate:cmd,[NSNumber numberWithDouble:progress]];
    
}

-(void)updateAssistTableWithFMDatabase:(FMDatabase*)db Owners:(NSData *)owners ReferenceInfo:(NSData *)referenceInfo ConditionAssistId:(long long)assistId{
    NSString *cmd=[NSString  stringWithFormat:@"UPDATE %@ SET Owners=?, AssistReferenceInfo=? WHERE AssistId=%lld",TableName_HTTPDownAssistInfo,assistId];
    
    [db executeUpdate:cmd,owners,referenceInfo];
    
}

-(NSArray *)userIdArrayWithFMDatabase:(FMDatabase*)db DataId:(long long)dataId ConditionDataType:(NSUInteger)type{

    NSString *cmd=[NSString stringWithFormat:@"SELECT * FROM %@ WHERE DataId=%lld AND DataType=%d",TableName_HTTPDownSourceInfo,dataId,(uint32_t)type];
    
    FMResultSet *set = [db executeQuery:cmd];
    NSArray *rn=nil;
    if ([set next]) {
        NSData *data=[set dataForColumn:@"Owners"];
        rn=[self userIdArrayWithData:data];
        
    }
    [set close];
    return rn;
}



-(NSArray *)userIdArrayInAssistTableWithFMDatabase:(FMDatabase*)db ConditionAssistId:(long long)assistId{
    
    NSString *cmd=[NSString stringWithFormat:@"SELECT * FROM %@ WHERE AssistId=%lld",TableName_HTTPDownAssistInfo,assistId];
    
    FMResultSet *set = [db executeQuery:cmd];
    NSArray *rn=nil;
    if ([set next]) {
        NSData *data=[set dataForColumn:@"Owners"];
        rn=[self userIdArrayWithData:data];
        
    }
    [set close];
    return rn;
}




-(BOOL)userIsInDataSourceTableOrAddIntoWithFMDatabase:(FMDatabase*)db DataId:(long long)dataId DataType:(NSUInteger)type UserId:(long long)userId {
    
    NSArray *idArray=[self userIdArrayWithFMDatabase:db DataId:dataId ConditionDataType:type];
    BOOL isHave=NO;
    NSMutableArray *array=[NSMutableArray array];
    if (idArray) {
        for (NSNumber *num in idArray) {
            if ([num longLongValue]==userId) {
                isHave=YES;
                break;
            }
        }
        if (!isHave) {
            [array addObjectsFromArray:idArray];
            [array addObject:[NSNumber numberWithLongLong:userId]];
        }
    }
    else
        [array addObject:[NSNumber numberWithLongLong:userId]];
    
    
    if (!isHave
        ||!idArray) {
        
         [self updateOwnersWithFMDatabase:db UserIdList:[self userIdArrayDataWithArray:idArray] ConditionDataId:dataId ConditionDataType:type];
    }

    return isHave;
}





-(NSData *)userDataIsInAssistReferenceInfoTableOrAddIntoWithFMDatabase:(FMDatabase*)db AssistId:(long long)assistId UserId:(long long)userId {
    
    NSArray *idArray=[self userIdArrayInAssistTableWithFMDatabase:db ConditionAssistId:assistId];
    BOOL isHave=NO;
    NSMutableArray *array=[NSMutableArray array];
    if (idArray) {
        for (NSNumber *num in idArray) {
            if ([num longLongValue]==userId) {
                isHave=YES;
                break;
            }
        }
        if (!isHave) {
            [array addObjectsFromArray:idArray];
            [array addObject:[NSNumber numberWithLongLong:userId]];
        }
    }
    else
        [array addObject:[NSNumber numberWithLongLong:userId]];
    
    
    if (!isHave
        ||!idArray) {
        idArray=array;
    }
    if (!idArray) {
        return nil;
    }

    return [self userIdArrayDataWithArray:idArray];
}



-(NSArray *)userDataIsInAssistReferenceInfoTableAndDeleteFMDatabase:(FMDatabase*)db AssistId:(long long)assistId UserId:(long long)userId {
    
    NSArray *idArray=[self userIdArrayInAssistTableWithFMDatabase:db ConditionAssistId:assistId];

   
    if (idArray) {
        NSMutableArray *array=[NSMutableArray arrayWithArray:idArray];
        for (NSNumber *num in array) {
            if ([num longLongValue]==userId) {
                [array removeObject:num];
                break;
            }
        }
        if ([array count]) {
            idArray=array;
        }
        else{
            idArray=nil;
        }
        
    }
    
        
    return idArray;
}









-(void)insertToDataSourceTableWithFMDatabase:(FMDatabase*)db DataId:(long long)dataId DataType:(NSUInteger)type UserId:(long long)userId DataURL:(NSString *)url DataPath:(NSString *)path IconURL:(NSString *)iconUrl DataReferenceInfo:(NSData *)ReferenceInfo{
    
    NSArray *idArray=[self userIdArrayWithFMDatabase:db DataId:dataId ConditionDataType:type];
    BOOL isHave=NO;
    NSMutableArray *array=[NSMutableArray array];
    if (idArray) {
        for (NSNumber *num in idArray) {
            if ([num longLongValue]==userId) {
                isHave=YES;
                break;
            }
        }
        if (!isHave) {
            [array addObjectsFromArray:idArray];
            [array addObject:[NSNumber numberWithLongLong:userId]];
        }
    }
    else
        [array addObject:[NSNumber numberWithLongLong:userId]];

    
    if (!isHave
        ||!idArray) {
        idArray=array;
    }

    NSString *cmd =[NSString stringWithFormat:@"INSERT INTO %@ (DataId ,DataType,Owners ,DataURL ,DataPath,IconURL,DataReferenceInfo ) VALUES (?,?,?,?,?,?,?)" ,TableName_HTTPDownSourceInfo];
    [db executeUpdate:cmd
     ,[NSNumber numberWithLongLong:dataId]
     ,[NSNumber numberWithUnsignedInteger:type]
     ,[self userIdArrayDataWithArray:idArray]
     ,url
     ,path
     ,iconUrl
     ,ReferenceInfo];
    

}



-(void)insertToDownUserTableWithFMDatabase:(FMDatabase*)db DataId:(long long)dataId DataType:(NSUInteger)type UserId:(long long)userId AssistId:(long long)assistId DownloadStatus:(XBHDownloadStatus)status{
    
    NSString *cmd =[NSString stringWithFormat:@"INSERT INTO %@ (DataId ,DataType,UserId ,AssistId,DownloadStatus,Progress) VALUES (?,?,?,?,?,?)" ,TableName_HTTPDownUser];
    [db executeUpdate:cmd
     ,[NSNumber numberWithLongLong:dataId]
     ,[NSNumber numberWithUnsignedInteger:type]
     ,[NSNumber numberWithLongLong:userId]
     ,[NSNumber numberWithLongLong:assistId]
     ,[NSNumber numberWithUnsignedInteger:status]
     ,[NSNumber numberWithDouble:0.0]];
    
}


-(void)insertToAssistInfoTableWithFMDatabase:(FMDatabase*)db AssistId:(long long)assistId Owners :(NSData *)owners ReferenceInfo:(NSData *)referenceInfo{
    
    NSString *cmd =[NSString stringWithFormat:@"INSERT INTO %@ (AssistId,Owners,AssistReferenceInfo) VALUES (?,?,?)" ,TableName_HTTPDownAssistInfo];
    [db executeUpdate:cmd,[NSNumber numberWithLongLong:assistId],owners,referenceInfo];
    
}


#pragma mark -

+(NSString *)downloadDataPathWithFileName:(NSString *)fileName{
   
    return [XBHUitility downloadResourceFilePathWithName:fileName];
}



-(void)addIntoDocumentWithXBHDownloadDoc:(XBHDownloadDoc *)doc{
    if (!doc) {
        return;
    }
    if (!doc.DataURL) {
        doc.DataURL=[NSString string];
    }
    
    
    /*存储到数据库的是相对路径 如/Document/  
     使用绝对路径的话 重烧应用后 应用的home路径会改变(如ios8 /var/mobile/Containers/Data/Application/6E42BED3-1923-47A4-8D67-8BBD56B640A1  后面的“6E42BED3-1923-47A4-8D67-8BBD56B640A1”)
     */
    
    NSString *oppositePath=nil;
    
    if (!doc.DataName) {
        
        
        
        
        oppositePath=[XBHUitility autoRenameWithFileFullPath:[XBHDownloadDocument downloadDataPathWithFileName:@"未命名.data"]];
        doc.DataName=[oppositePath lastPathComponent];
    }
    else{
        oppositePath=[XBHDownloadDocument downloadDataPathWithFileName:doc.DataName];
    }
    
    //获得得到相对路径
    oppositePath=[XBHUitility oppositePathWithAbsolutePath:oppositePath];
    
   
    
    
    if (!doc.IconURL) {
        doc.IconURL=[NSString string];
    }
    if (!doc.DataReferenceInfo) {
        doc.DataReferenceInfo=[NSData data];
    }
    
    
    [ShareDBQueue inDatabase:^(FMDatabase *db) {
        
        //user table
        if ([self isExistsInUserTableWithFMDatabase:db ConditionUserId:doc.UserId ConditionDataId:doc.DataId ConditionDataType:doc.DataType]) {
        
            //更新状态
            [self updateDownloadStatusWithFMDatabase:db XBHDownloadStatus:doc.DownloadStatus ConditionUserId:doc.UserId ConditionDataId:doc.DataId ConditionDataType:doc.DataType];
        }
        else{
            [self insertToDownUserTableWithFMDatabase:db DataId:doc.DataId DataType:doc.DataType UserId:doc.UserId AssistId:doc.AssistId DownloadStatus:doc.DownloadStatus];
        }
        
        //source info table
        if ([self isExistsInSourceDataTableWithFMDatabase:db ConditionDataId:doc.DataId ConditionDataType:doc.DataType]) {
            //添加 user
            [self userIsInDataSourceTableOrAddIntoWithFMDatabase:db DataId:doc.DataId DataType:doc.DataType UserId:doc.UserId];
        }
        else{
            [self insertToDataSourceTableWithFMDatabase:db DataId:doc.DataId DataType:doc.DataType UserId:doc.UserId DataURL:doc.DataURL DataPath:oppositePath IconURL:doc.DataURL DataReferenceInfo:doc.DataReferenceInfo];
        }
        
        //assist info table
        NSData *owners=[self userDataIsInAssistReferenceInfoTableOrAddIntoWithFMDatabase:db AssistId:doc.AssistId UserId:doc.UserId];
        if ([self isExistsInAssistReferenceTableWithFMDatabase:db ConditionAssistId:doc.AssistId]
            &&doc.AssistReferenceInfo) {
            [self updateAssistTableWithFMDatabase:db Owners:owners ReferenceInfo:doc.AssistReferenceInfo ConditionAssistId:doc.AssistId];
        }
        else{

            
            [self insertToAssistInfoTableWithFMDatabase:db AssistId:doc.AssistId Owners:owners ReferenceInfo:doc.AssistReferenceInfo];
        }
    }];
    
}

-(void)addUser:(long long)userId toOwnersWithDataId:(long long)dataId DataType:(long long)type{
    [ShareDBQueue inDatabase:^(FMDatabase *db) {
        [self userIsInDataSourceTableOrAddIntoWithFMDatabase:db DataId:dataId DataType:(NSUInteger)type UserId:userId];
        
    }];

}

-(void)setDownloadStatusWithUserId:(long long)userId DataId:(long long)dataId DataType:(NSUInteger)type DownloadStatus:(XBHDownloadStatus)status{

    [ShareDBQueue inDatabase:^(FMDatabase *db) {
        [self updateDownloadStatusWithFMDatabase:db XBHDownloadStatus:status ConditionUserId:userId ConditionDataId:dataId ConditionDataType:type];
        
    }];
}

-(void)setProgress:(double)progress UserId:(long long)userId DataId:(long long)dataId DataType:(NSUInteger)type{
    [ShareDBQueue inDatabase:^(FMDatabase *db) {
        [self updateProgressWithFMDatabase:db Progress:progress ConditionUserId:userId ConditionDataId:dataId ConditionDataType:type];
        
    }];
}

-(double)progressWithUserId:(long long)userId DataId:(long long)dataId DataType:(NSUInteger)type{

    __block  double  pro=0.00;
    [ShareDBQueue inDatabase:^(FMDatabase *db) {
        NSString *cmd=[NSString stringWithFormat:@"SELECT * FROM %@ WHERE UserId=%lld AND DataId=%lld AND DataType=%d",TableName_HTTPDownUser,userId,dataId,(uint32_t)type];
        FMResultSet *set = [db executeQuery:cmd];
        
        if ([set next]) {
            pro=[set doubleForColumn:@"Progress"];
            
        }
        [set close];
        
        
    }];
    return pro;
}
-(long long)assistIdWithFMDatabaseDB:(FMDatabase *)db UserId:(long long)userId DataId:(long long)dataId DataType:(NSUInteger)type{
    long long assist=0;
    NSString *cmd=[NSString stringWithFormat:@"SELECT * FROM %@ WHERE  UserId=%lld AND DataId=%lld AND DataType=%d",TableName_HTTPDownUser,userId,dataId,(uint32_t)type];
    FMResultSet *set = [db executeQuery:cmd];
    
    if ([set next]) {
        assist=[set longLongIntForColumn:@"AssistId"];
        
    }
    [set close];
    return assist;

}


-(XBHDownloadStatus)downloadStatusWithUserId:(long long)userId DataId:(long long)dataId DataType:(NSUInteger)type{
    
    
   __block  XBHDownloadStatus  status=XBHDownloadStatus_None;
    [ShareDBQueue inDatabase:^(FMDatabase *db) {
        NSString *cmd=[NSString stringWithFormat:@"SELECT * FROM %@ WHERE UserId=%lld AND DataId=%lld AND DataType=%d",TableName_HTTPDownUser,userId,dataId,(uint32_t)type];
        FMResultSet *set = [db executeQuery:cmd];
        
        if ([set next]) {
            status=(XBHDownloadStatus)[set longLongIntForColumn:@"DownloadStatus"];
            
        }
        [set close];

        
    }];
    return status;
}

-(NSString *)dataURLWithDataId:(long long)dataId DataType:(NSUInteger)type{
    
    __block  NSString  *url=nil;
    [ShareDBQueue inDatabase:^(FMDatabase *db) {
        NSString *cmd=[NSString stringWithFormat:@"SELECT * FROM %@ WHERE DataId=%lld AND DataType=%d",TableName_HTTPDownSourceInfo,dataId,(uint32_t)type];
        FMResultSet *set = [db executeQuery:cmd];
        
        if ([set next]) {
            url=[set stringForColumn:@"DataURL"];
            
        }
        [set close];
        
        
    }];
    return url;

}

-(NSString *)dataStorePathWithDataId:(long long)dataId DataType:(NSUInteger)type{
    __block  NSString  *path=nil;
    [ShareDBQueue inDatabase:^(FMDatabase *db) {
        path=[self dataStorePathWithFMDatabase:db DataId:dataId DataType:type];
        
    }];
    return path;


}


-(NSString *)dataStorePathWithFMDatabase:(FMDatabase*)db DataId:(long long)dataId DataType:(NSUInteger)type{
    NSString  *path=nil;
    NSString *cmd=[NSString stringWithFormat:@"SELECT * FROM %@ WHERE DataId=%lld AND DataType=%d",TableName_HTTPDownSourceInfo,dataId,(uint32_t)type];
    FMResultSet *set = [db executeQuery:cmd];
    
    if ([set next]) {
        path=[set stringForColumn:@"DataPath"];
        
    }
    [set close];
    if ([path length]) {
        path=[XBHUitility absolutePathWithOppositePath:path];
    }
    else{
        path=nil;
    }
    return path;
    
    
}



-(void)deleteAssistReferenceInfoWithFMDatabase:(FMDatabase*)db AssistId:(long long)assistId{

    NSString  *cmd=[NSString  stringWithFormat:@"DELETE FROM %@ WHERE AssistId=%lld ",TableName_HTTPDownAssistInfo,assistId];
    [db executeUpdate:cmd];

}


//删除某书籍下的 对应user 所有已经下载成功的条目(dataId,dataType)信息
//返回XBHDownloadDoc结构数组，只有dataId,dataType赋值 表示删除了那些。
-(NSArray *)deleteOneNotWithAssistId:(long long)assistId UserId:(long long)userId {

   //查找到所有对应的dataId dataType
    NSMutableArray *array=[NSMutableArray array];
    
    [ShareDBQueue inDatabase:^(FMDatabase *db) {
        NSString *cmd=[NSString stringWithFormat:@"SELECT * FROM %@ WHERE UserId=%lld AND AssistId=%lld AND DownloadStatus=%d",TableName_HTTPDownUser,userId,assistId,(uint32_t)XBHDownloadStatus_DownloadCompelete];
        FMResultSet *set = [db executeQuery:cmd];
        
        while ([set next]) {
            XBHDownloadDoc *doc=[[XBHDownloadDoc alloc] init];
            
            doc.DataId=[set longLongIntForColumn:@"DataId"];
            doc.DataType=[set longForColumn:@"DataType"];
            [array addObject:doc];
        }
        [set close];
        
    }];
    
    
    //根据 dataId dataType 做具体的删除
    
    for (XBHDownloadDoc *doc in array) {
        [self deleteOneNoteWithDataId:doc.DataId DataType:doc.DataType UserId:userId isDeleteFile:YES];
    }
    
    
    if ([array count]) {
        return array;
    }
    return nil;
}


-(void)deleteOneNoteWithDataId:(long long)dataId DataType:(NSUInteger)type UserId:(long long)userId isDeleteFile:(BOOL)isDelete{
    __block BOOL    delete=NO;
    __block long long assistId=0;
    __block NSString *path=nil;
    
    
    [ShareDBQueue inDatabase:^(FMDatabase *db) {
        assistId=[self assistIdWithFMDatabaseDB:db UserId:userId DataId:dataId DataType:type];
        
    }];
    
    
    
    
    
    [ShareDBQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        //user table
        
        NSString  *cmd=[NSString  stringWithFormat:@"DELETE FROM %@ WHERE UserId=%lld AND DataId=%lld AND DataType=%d",TableName_HTTPDownUser,userId,dataId,(uint32_t)type];
        [db executeUpdate:cmd];
        
        //source info table
        
        NSArray *idArray=[self userIdArrayWithFMDatabase:db DataId:dataId ConditionDataType:type];
        NSMutableArray *array=[NSMutableArray arrayWithArray:idArray];
        for (NSNumber *num in array) {
            if ([num longLongValue] == userId) {
                [array removeObject:num];
                break;
            }
        }
        
        if ([array count]<1) {
            
            path= [self dataStorePathWithFMDatabase:db DataId:dataId DataType:type];
            
            //无人对该文件信息持有 删除
            NSString  *cmd=[NSString  stringWithFormat:@"DELETE FROM %@ WHERE DataId=%lld AND DataType=%d",TableName_HTTPDownSourceInfo,dataId,(uint32_t)type];
            [db executeUpdate:cmd];
            
            delete=YES;
        }
        else{
            [self updateOwnersWithFMDatabase:db UserIdList:[self userIdArrayDataWithArray:array] ConditionDataId:dataId ConditionDataType:type];
        }

        
    }];
    
    if (delete
        &&isDelete
        &&path) {
      
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
        //删除临时文件
        //[[NSFileManager defaultManager] removeItemAtPath:[XBHHTTPDownloadRequest tempFileDownloadPathWithDestinationPath:path] error:nil];
    }
    
    //文件信息
    
    if (assistId==0) {
        return;
    }
    [ShareDBQueue inDatabase:^(FMDatabase *db) {
        //该用户是否还拥有 该书籍的其他条目
        if (![self isHaveDataSourceWithFMDatabase:db UserId:userId ConditionAssistId:assistId]) {
            
            //不拥有,从文件信息中删除该user
            NSArray *array=  [self userDataIsInAssistReferenceInfoTableAndDeleteFMDatabase:db AssistId:assistId UserId:userId];
            if (array) {
                [self updateOwnersIntoAssistTableWithFMDatabase:db UserIdList:[self userIdArrayDataWithArray:array] ConditionAssistId:assistId];
            }
            else{
                //无人拥有该文件信息 删除
                
                [self deleteAssistReferenceInfoWithFMDatabase:db AssistId:assistId];
            }
        }

    }];
    
    
}


-(NSArray *)XBHDownloadDocListWithQueryCmd:(NSString *)queryCmd UserId:(long long)userId {

    NSMutableArray   *resultArray=[NSMutableArray array];
    
    [ShareDBQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *set = [db executeQuery:queryCmd];
        
        while ([set next]) {
            XBHDownloadDoc *doc=[[XBHDownloadDoc alloc] init];
            doc.UserId=userId;
            doc.DataId=[set longLongIntForColumn:@"DataId"];
            doc.DataType=[set longForColumn:@"DataType"];
            doc.DownloadStatus=[set longForColumn:@"DownloadStatus"];
            doc.AssistId=[set longLongIntForColumn:@"AssistId"];
            doc.Progress=[set doubleForColumn:@"Progress"];
            [resultArray addObject:doc];
            
        }
        [set close];
        
    }];
    
    [ShareDBQueue inDatabase:^(FMDatabase *db) {
        
        for (XBHDownloadDoc *doc in resultArray) {
            NSString *cmd=[NSString stringWithFormat:@"SELECT * FROM %@ WHERE DataId=%lld AND DataType=%d",TableName_HTTPDownSourceInfo,doc.DataId,(uint32_t)doc.DataType];
            FMResultSet *set = [db executeQuery:cmd];
            if ([set next]) {
                doc.DataURL=[set stringForColumn:@"DataURL"];
                doc.DataName=[[set stringForColumn:@"DataPath"] lastPathComponent];
                doc.DataReferenceInfo=[set dataForColumn:@"DataReferenceInfo"];
                doc.IconURL=[set stringForColumn:@"IconURL"];
            }
            [set close];
        }
        
    }];
    
    [ShareDBQueue inDatabase:^(FMDatabase *db) {
        
        for (XBHDownloadDoc *doc in resultArray) {
            NSString *cmd=[NSString stringWithFormat:@"SELECT * FROM %@ WHERE AssistId=%lld",TableName_HTTPDownAssistInfo,doc.AssistId];
            FMResultSet *set = [db executeQuery:cmd];
            if ([set next]) {
                doc.AssistReferenceInfo=[set dataForColumn:@"AssistReferenceInfo"];
                
            }
            [set close];
        }
        
    }];
    if ([resultArray count]<1) {
        return nil;
    }
    return resultArray;
    
}





-(XBHDownloadDoc *)oneXBHDownloadDocWithQueryCmd:(NSString *)queryCmd UserId:(long long)userId {
    
   __block  XBHDownloadDoc  *doc=nil;
    [ShareDBQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *set = [db executeQuery:queryCmd];
        
        if  ([set next]) {
            doc=[[XBHDownloadDoc alloc] init];
            doc.UserId=userId;
            doc.DataId=[set longLongIntForColumn:@"DataId"];
            doc.DataType=[set longForColumn:@"DataType"];
            doc.DownloadStatus=[set longForColumn:@"DownloadStatus"];
            doc.AssistId=[set longLongIntForColumn:@"AssistId"];
            doc.Progress=[set doubleForColumn:@"Progress"];
            
        }
        [set close];
        
    }];
    
    [ShareDBQueue inDatabase:^(FMDatabase *db) {
        
   
        NSString *cmd=[NSString stringWithFormat:@"SELECT * FROM %@ WHERE DataId=%lld AND DataType=%d",TableName_HTTPDownSourceInfo,doc.DataId,(uint32_t)doc.DataType];
        FMResultSet *set = [db executeQuery:cmd];
        if ([set next]
            &&doc) {
            doc.DataURL=[set stringForColumn:@"DataURL"];
            doc.DataName=[[set stringForColumn:@"DataPath"] lastPathComponent];
            doc.IconURL=[set stringForColumn:@"IconURL"];
            doc.DataReferenceInfo=[set dataForColumn:@"DataReferenceInfo"];
        }
        [set close];
        
        
    }];
    
    [ShareDBQueue inDatabase:^(FMDatabase *db) {
        
        NSString *cmd=[NSString stringWithFormat:@"SELECT * FROM %@ WHERE AssistId=%lld",TableName_HTTPDownAssistInfo,doc.AssistId];
        FMResultSet *set = [db executeQuery:cmd];
        if ([set next]
            &&doc) {
            doc.AssistReferenceInfo=[set dataForColumn:@"AssistReferenceInfo"];
            
        }
        [set close];
    }];
    return doc;
    
}




-(XBHDownloadDoc *)oneXBHDownloadDocWithUserId:(long long)userId DataId:(long long)dataId DataType:(long)type{
    
    NSString *cmd=[NSString stringWithFormat:@"SELECT * FROM %@ WHERE UserId=%lld AND DataId=%lld AND DataType=%ld ",TableName_HTTPDownUser,userId,dataId,type];
    
    return [self oneXBHDownloadDocWithQueryCmd:cmd UserId:userId];
    
}


-(XBHDownloadDoc *)oneXBHDownloadDocWithDownloadStatus:(XBHDownloadStatus)status UserId:(long long)userId {

    NSString *cmd=[NSString stringWithFormat:@"SELECT * FROM %@ WHERE DownloadStatus=%d AND UserId=%lld ",TableName_HTTPDownUser,(uint32_t)status,userId];
    
    return [self oneXBHDownloadDocWithQueryCmd:cmd UserId:userId];
    
}

-(XBHDownloadDoc *)lastoneXBHDownloadDocWithDownloadStatus:(XBHDownloadStatus)status UserId:(long long)userId {
    
    NSString *cmd=[NSString stringWithFormat:@"SELECT * FROM %@ WHERE DownloadStatus=%d AND UserId=%lld ORDER BY ID DESC ",TableName_HTTPDownUser,(uint32_t)status,userId];
    
    return [self oneXBHDownloadDocWithQueryCmd:cmd UserId:userId];
    
    
}



-(NSArray *)XBHDownloadDocListWithDownloadStatus:(XBHDownloadStatus)status UserId:(long long)userId {

    //ORDER BY ID DESC
    NSString *cmd=[NSString stringWithFormat:@"SELECT * FROM %@ WHERE DownloadStatus=%d AND UserId=%lld ",TableName_HTTPDownUser,(uint32_t)status,userId];
    
    return [self XBHDownloadDocListWithQueryCmd:cmd UserId:userId];

}


-(NSArray *)XBHDownloadDocListBettwenBeginStatus:(XBHDownloadStatus)bStatus EndStatus:(XBHDownloadStatus)eStatus UserId:(long long)userId {
    
    NSString *cmd=[NSString stringWithFormat:@"SELECT * FROM %@ WHERE DownloadStatus>=%d AND DownloadStatus <=%d AND UserId=%lld ",TableName_HTTPDownUser,(uint32_t)bStatus,(uint32_t)eStatus,userId];
    
    return [self XBHDownloadDocListWithQueryCmd:cmd UserId:userId];
    
}

-(uint32_t)numberOfBettwenBeginStatus:(XBHDownloadStatus)bStatus EndStatus:(XBHDownloadStatus)eStatus UserId:(long long)userId{

    NSString *cmd=[NSString stringWithFormat:@"SELECT COUNT(*) FROM %@ WHERE DownloadStatus>=%d AND DownloadStatus <=%d AND UserId=%lld ",TableName_HTTPDownUser,(uint32_t)bStatus,(uint32_t)eStatus,userId];
    __block  uint32_t    rn=0;
    [ShareDBQueue inDatabase:^(FMDatabase *db) {
        
        FMResultSet *set = [db executeQuery:cmd];
        if ([set next]) {
            rn=(uint32_t)[set longForColumnIndex:0];
        }
        [set close];
        
    }];
    return rn;
}


-(NSArray *)XBHDownloadDocListWithAssistId:(long long)assistId Status:(XBHDownloadStatus)bStatus  UserId:(long long)userId {
    
    NSString *cmd=[NSString stringWithFormat:@"SELECT * FROM %@ WHERE DownloadStatus=%d AND AssistId=%lld AND UserId=%lld ",TableName_HTTPDownUser,(uint32_t)bStatus,assistId,userId];
    
    return [self XBHDownloadDocListWithQueryCmd:cmd UserId:userId];
    
}



//用在取消所有下载
//设置状态为 None,进度为 0
-(void)cancelAllDownloadWithAssistId:(long long)assistId UserId:(long long)userId{

    
    [ShareDBQueue inDatabase:^(FMDatabase *db) {
        NSString *cmd=[NSString  stringWithFormat:@"UPDATE %@ SET DownloadStatus=?,Progress=? WHERE UserId=%lld AND AssistId=%lld AND DownloadStatus>=%d AND DownloadStatus<=%d",TableName_HTTPDownUser,userId,assistId,(uint32_t)XBHDownloadStatus_DownloadWate,(uint32_t)XBHDownloadStatus_DownloadPause_ByApp];
        
        [db executeUpdate:cmd,[NSNumber numberWithUnsignedInteger:XBHDownloadStatus_None],[NSNumber numberWithDouble:0.0]];
    }];

}



// 所有符合下载状态的 AssistId不同的 AssistReferenceInfo
-(NSArray *)distinctAssistReferenceInfoListWithDownloadStatus:(XBHDownloadStatus)status UserId:(long long)userId{
    NSMutableArray   *resultArray=[NSMutableArray array];
    NSMutableArray   *assistArray=[NSMutableArray array];
    [ShareDBQueue inDatabase:^(FMDatabase *db) {
        NSString *cmd=[NSString stringWithFormat:@"SELECT DISTINCT AssistId FROM %@ WHERE DownloadStatus=%d AND UserId=%lld ",TableName_HTTPDownUser,(uint32_t)status,userId];
        
        FMResultSet *set = [db executeQuery:cmd];
        
        while  ([set next]) {
            long long assistId=[set longLongIntForColumn:@"AssistId"];
            [assistArray addObject:[NSNumber numberWithLongLong:assistId]];
            
        }
        [set close];
        
    }];
    
    if ([assistArray count]) {
        [ShareDBQueue inDatabase:^(FMDatabase *db) {
            
            for (NSNumber *num in assistArray) {
                NSString *cmd=[NSString stringWithFormat:@"SELECT * FROM %@ WHERE AssistId=%lld ",TableName_HTTPDownAssistInfo,[num longLongValue]];
                
                FMResultSet *set = [db executeQuery:cmd];
                
                if  ([set next]) {
                    NSData *data=[set dataForColumn:@"AssistReferenceInfo"];
                    [resultArray addObject:data];
                    
                }
                [set close];
            }
        }];
    }
    if ([resultArray count]<1) {
        return nil;
    }
    return resultArray;
}




// 所有符合下载状态的 AssistId、DataType不同的 AssistReferenceInfo
-(NSArray *)distinctAssistReferenceInfoListWithDownloadStatus:(XBHDownloadStatus)status DataType:(NSUInteger)type UserId:(long long)userId{
    NSMutableArray   *resultArray=[NSMutableArray array];
    NSMutableArray   *assistArray=[NSMutableArray array];
    [ShareDBQueue inDatabase:^(FMDatabase *db) {
        NSString *cmd=[NSString stringWithFormat:@"SELECT DISTINCT AssistId FROM %@ WHERE DownloadStatus=%d AND UserId=%lld AND DataType=%d ",TableName_HTTPDownUser,(uint32_t)status,userId,(uint32_t)type];
        
        FMResultSet *set = [db executeQuery:cmd];
        
        while  ([set next]) {
            long long assistId=[set longLongIntForColumn:@"AssistId"];
            [assistArray addObject:[NSNumber numberWithLongLong:assistId]];
            
        }
        [set close];
        
    }];
    
    if ([assistArray count]) {
        [ShareDBQueue inDatabase:^(FMDatabase *db) {
            
            for (NSNumber *num in assistArray) {
                NSString *cmd=[NSString stringWithFormat:@"SELECT * FROM %@ WHERE AssistId=%lld ",TableName_HTTPDownAssistInfo,[num longLongValue]];
                
                FMResultSet *set = [db executeQuery:cmd];
                
                if  ([set next]) {
                    NSData *data=[set dataForColumn:@"AssistReferenceInfo"];
                    [resultArray addObject:data];
                    
                }
                [set close];
            }
        }];
    }
    if ([resultArray count]<1) {
        return nil;
    }
    return resultArray;
}



-(NSData *)assistReferenceInfoListWithAssistId:(long long)assistId{

    __block NSData *data=nil;
    
    [ShareDBQueue inDatabase:^(FMDatabase *db) {
        NSString *cmd=[NSString stringWithFormat:@"SELECT * FROM %@ WHERE AssistId=%lld ",TableName_HTTPDownAssistInfo,assistId];
        
        FMResultSet *set = [db executeQuery:cmd];
        
        if  ([set next]) {
            data=[set dataForColumn:@"AssistReferenceInfo"];
        
        }
        [set close];
        
    }];
    return data;
}

@end
