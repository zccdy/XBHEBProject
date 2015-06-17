//
//  XBHUploadDocument.m
//  XBHEBProject
//
//  Created by xubh-note on 15/4/14.
//  Copyright (c) 2015年 xu banghui. All rights reserved.
//

#import "XBHUploadDocument.h"
#import "FMDB.h"


@implementation XBHUploadDoc



@end



#define TableName_UploadList            @"uoloadList"

@implementation XBHUploadDocument
{
    FMDatabaseQueue   *mFMDBQueue;

}

- (void)dealloc
{
    if (mFMDBQueue) {
        [mFMDBQueue close];
    }
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        mFMDBQueue=[FMDatabaseQueue databaseQueueWithPath:[XBHUitility uploadResourceFilePathWithName:@"UploadList.sqlite"]];
        
        [self createTableIf];
    }
    return self;
}


-(void)createTableIf{

    [mFMDBQueue inDatabase:^(FMDatabase *db) {
        
        if (![db tableExists:TableName_UploadList]) {
            NSString *creatSql=[NSString stringWithFormat:@"CREATE TABLE %@ (ID INTEGER PRIMARY KEY AUTOINCREMENT,DataId INTEGER ,DataType INTEGER,UserId INTEGER,DataUploadURL TEXT,DataSoucrePath TEXT,DataName TEXT,IconData BLOD,UploadStatus INTEGER,Progress REAL,ReferenceInfo BLOD,MimeType TEXT)",TableName_UploadList];
            [db executeUpdate:creatSql];
        }
        
    }];
}



-(BOOL)isExistsWithFMDatabase:(FMDatabase*)db ConditionDataId:(long long)dataId ConditionDataType:(NSUInteger)type{
    BOOL  rn=NO;
    NSString * cmd=[NSString  stringWithFormat:@"SELECT * FROM %@ WHERE DataId=%lld AND DataType=%d",TableName_UploadList,dataId,(uint32_t)type];
    
    FMResultSet *set= [db  executeQuery:cmd];
    if ([set next]) {
        rn=YES;
    }
    [set close];
    
    return rn;
}


-(BOOL)isHaveSameNoteWithFMDatabase:(FMDatabase*)db ConditionUserId:(long long)userId ConditionDataId:(long long)dataId ConditionDataType:(NSUInteger)type{
    BOOL  rn=NO;
    NSString * cmd=[NSString  stringWithFormat:@"SELECT * FROM %@ WHERE  UserId=%lld AND DataId=%lld AND DataType=%d",TableName_UploadList,userId,dataId,(uint32_t)type];
    
    FMResultSet *set= [db  executeQuery:cmd];
    if ([set next]) {
        rn=YES;
    }
    [set close];
    
    return rn;
}


-(void)updateUploadStatusWithFMDatabase:(FMDatabase*)db UploadStatus:(XBHUploadStatus)status ConditionUserId:(long long)userId ConditionDataId:(long long)dataId ConditionDataType:(NSUInteger)type{
    NSString *cmd=[NSString  stringWithFormat:@"UPDATE %@ SET UploadStatus=? WHERE UserId=%lld AND DataId=%lld AND DataType=%d",TableName_UploadList,userId,dataId,(uint32_t)type];
    
    [db executeUpdate:cmd,[NSNumber numberWithUnsignedInteger:status]];
    
}

-(void)updateProgressWithFMDatabase:(FMDatabase*)db Progress:(double)progress ConditionUserId:(long long)userId ConditionDataId:(long long)dataId ConditionDataType:(NSUInteger)type{
    NSString *cmd=[NSString  stringWithFormat:@"UPDATE %@ SET Progress=? WHERE UserId=%lld AND DataId=%lld AND DataType=%d",TableName_UploadList,userId,dataId,(uint32_t)type];
    
    [db executeUpdate:cmd,[NSNumber numberWithDouble:progress]];
    
}




/*DataId ,DataType,UserId,DataUploadURL,DataSoucrePath,IconData,UploadStatus,Progress ,ReferenceInfo*/


-(void)insertToDataSourceTableWithFMDatabase:(FMDatabase*)db DataId:(long long)dataId DataType:(NSUInteger)type UserId:(long long)userId DataUploadURL:(NSString *)url DataSoucrePath:(NSString *)path DataName:(NSString*)name IconData:(NSData *)IconData UploadStatus:(XBHUploadStatus)status DataReferenceInfo:(NSData *)ReferenceInfo MimeType:(NSString *)mimeType{
    
    
    NSString *cmd =[NSString stringWithFormat:@"INSERT INTO %@ (DataId ,DataType,UserId,DataUploadURL,DataSoucrePath,DataName,IconData,UploadStatus,Progress ,ReferenceInfo,MimeType) VALUES (?,?,?,?,?,?,?,?,?,?,?)" ,TableName_UploadList];
    [db executeUpdate:cmd
     ,@(dataId)
     ,@(type)
     ,@(userId)
     ,url
     ,path
     ,name
     ,IconData
     ,@(status)
     ,@(0)
     ,ReferenceInfo
     ,mimeType];
   
    
}






#pragma mark -

+(NSString *)uploadDataPathWithFileName:(NSString *)fileName{
    
    return [XBHUitility uploadResourceFilePathWithName:fileName];
}


-(void)addIntoDocumentWithXBHUploadDoc:(XBHUploadDoc *)doc{
    if (!doc
        ||!doc.DataSoucrePath) {
        return;
    }
    if (!doc.DataUploadURL) {
        doc.DataUploadURL=[NSString string];
    }
    
    
    /*存储到数据库的是相对路径 如/Document/
     使用绝对路径的话 重烧应用后 应用的home路径会改变(如ios8 /var/mobile/Containers/Data/Application/6E42BED3-1923-47A4-8D67-8BBD56B640A1  后面的“6E42BED3-1923-47A4-8D67-8BBD56B640A1”)
     */
    
    //获得得到相对路径
    NSString *oppositePath=[XBHUitility oppositePathWithAbsolutePath:doc.DataSoucrePath];
    
    
    
    
    if (!doc.IconData) {
        doc.IconData=[NSData data];
    }
    if (!doc.DataReferenceInfo) {
        doc.DataReferenceInfo=[NSData data];
    }
    if (!doc.DataName) {
        doc.DataName=[[doc.DataSoucrePath lastPathComponent] stringByDeletingPathExtension];
    }
    
    [mFMDBQueue inDatabase:^(FMDatabase *db) {
        
        //user table
        if ([self isHaveSameNoteWithFMDatabase:db ConditionUserId:doc.UserId ConditionDataId:doc.DataId ConditionDataType:doc.DataType]) {
            
            //更新状态
            [self updateUploadStatusWithFMDatabase:db UploadStatus:doc.UploadStatus ConditionUserId:doc.UserId ConditionDataId:doc.DataId ConditionDataType:doc.DataType];
        }
        else{
            [self insertToDataSourceTableWithFMDatabase:db DataId:doc.DataId DataType:doc.DataType UserId:doc.UserId DataUploadURL:doc.DataUploadURL DataSoucrePath:oppositePath DataName:doc.DataName IconData:doc.IconData UploadStatus:doc.UploadStatus DataReferenceInfo:doc.DataReferenceInfo MimeType:doc.mimeType];
        }
        
        
    }];
    
}




-(void)setUploadStatusWithUserId:(long long)userId DataId:(long long)dataId DataType:(NSUInteger)type UploadStatus:(XBHUploadStatus)status{
    
    [mFMDBQueue inDatabase:^(FMDatabase *db) {
        [self updateUploadStatusWithFMDatabase:db UploadStatus:status ConditionUserId:userId ConditionDataId:dataId ConditionDataType:type];
        
    }];
}

-(void)setProgress:(double)progress UserId:(long long)userId DataId:(long long)dataId DataType:(NSUInteger)type{
    [mFMDBQueue inDatabase:^(FMDatabase *db) {
        [self updateProgressWithFMDatabase:db Progress:progress ConditionUserId:userId ConditionDataId:dataId ConditionDataType:type];
        
    }];
}

-(double)progressWithUserId:(long long)userId DataId:(long long)dataId DataType:(NSUInteger)type{
    
    __block  double  pro=0.00;
    [mFMDBQueue inDatabase:^(FMDatabase *db) {
        NSString *cmd=[NSString stringWithFormat:@"SELECT * FROM %@ WHERE UserId=%lld AND DataId=%lld AND DataType=%d",TableName_UploadList,userId,dataId,(uint32_t)type];
        FMResultSet *set = [db executeQuery:cmd];
        
        if ([set next]) {
            pro=[set doubleForColumn:@"Progress"];
            
        }
        [set close];
        
        
    }];
    return pro;
}


-(XBHUploadStatus)uploadStatusWithUserId:(long long)userId DataId:(long long)dataId DataType:(NSUInteger)type{
    
    
    __block  XBHUploadStatus  status=XBHUploadStatus_None;
    [mFMDBQueue inDatabase:^(FMDatabase *db) {
        NSString *cmd=[NSString stringWithFormat:@"SELECT * FROM %@ WHERE UserId=%lld AND DataId=%lld AND DataType=%d",TableName_UploadList,userId,dataId,(uint32_t)type];
        FMResultSet *set = [db executeQuery:cmd];
        
        if ([set next]) {
            status=(XBHUploadStatus)[set longLongIntForColumn:@"UploadStatus"];
            
        }
        [set close];
        
        
    }];
    return status;
}

-(NSData *)referenceInfoWithUserId:(long long)userId DataId:(long long)dataId DataType:(NSUInteger)type{
    
    
    __block  NSData  *data=nil;
    [mFMDBQueue inDatabase:^(FMDatabase *db) {
        NSString *cmd=[NSString stringWithFormat:@"SELECT * FROM %@ WHERE UserId=%lld AND DataId=%lld AND DataType=%d",TableName_UploadList,userId,dataId,(uint32_t)type];
        FMResultSet *set = [db executeQuery:cmd];
        
        if ([set next]) {
            data=[set dataForColumn:@"ReferenceInfo"];
            
        }
        [set close];
        
        
    }];
    return data;
}


-(NSData *)iconDataWithUserId:(long long)userId DataId:(long long)dataId DataType:(NSUInteger)type{
    
    
    __block  NSData  *data=nil;
    [mFMDBQueue inDatabase:^(FMDatabase *db) {
        NSString *cmd=[NSString stringWithFormat:@"SELECT * FROM %@ WHERE UserId=%lld AND DataId=%lld AND DataType=%d",TableName_UploadList,userId,dataId,(uint32_t)type];
        FMResultSet *set = [db executeQuery:cmd];
        
        if ([set next]) {
            data=[set dataForColumn:@"IconData"];
            
        }
        [set close];
        
        
    }];
    return data;
}





-(NSString *)dataUploadURLWithUserId:(long long)userId DataId:(long long)dataId DataType:(NSUInteger)type{
    
    __block  NSString  *url=nil;
    [mFMDBQueue inDatabase:^(FMDatabase *db) {
        NSString *cmd=[NSString stringWithFormat:@"SELECT * FROM %@ WHERE UserId=%lld AND DataId=%lld AND DataType=%d",TableName_UploadList,userId,dataId,(uint32_t)type];
        FMResultSet *set = [db executeQuery:cmd];
        
        if ([set next]) {
            url=[set stringForColumn:@"DataUploadURL"];
            
        }
        [set close];
        
        
    }];
    return url;
    
}

-(NSString *)dataSourcePathWithUserId:(long long)userId DataId:(long long)dataId DataType:(NSUInteger)type{
    __block  NSString  *path=nil;
    [mFMDBQueue inDatabase:^(FMDatabase *db) {
        path=[self dataSourcePathWithFMDatabase:db UserId:userId DataId:dataId DataType:type];
        
    }];
    return path;
    
    
}

/*DataId ,DataType,UserId,DataUploadURL,DataSoucrePath,IconData,UploadStatus,Progress ,ReferenceInfo,MimeType*/


-(NSString *)dataSourcePathWithFMDatabase:(FMDatabase*)db UserId:(long long)userId DataId:(long long)dataId DataType:(NSUInteger)type{
    NSString  *path=nil;
    NSString *cmd=[NSString stringWithFormat:@"SELECT * FROM %@ WHERE UserId=%lld AND DataId=%lld AND DataType=%d",TableName_UploadList,userId,dataId,(uint32_t)type];
    FMResultSet *set = [db executeQuery:cmd];
    
    if ([set next]) {
        path=[set stringForColumn:@"DataSoucrePath"];
        
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


-(void)deleteOneNoteWithUserId:(long long)userId DataId:(long long)dataId DataType:(NSUInteger)type{
    [mFMDBQueue inDatabase:^(FMDatabase *db) {
        
        NSString  *cmd=[NSString  stringWithFormat:@"DELETE FROM %@ WHERE UserId=%lld AND DataId=%lld AND DataType=%d",TableName_UploadList,userId,dataId,(uint32_t)type];
        [db executeUpdate:cmd];
        
    }];
 
    
}


/*DataId ,DataType,UserId,DataUploadURL,DataSoucrePath,IconData,UploadStatus,Progress ,ReferenceInfo*/

-(NSArray *)XBHUploadDocListWithQueryCmd:(NSString *)queryCmd UserId:(long long)userId{
    
    NSMutableArray   *resultArray=[NSMutableArray array];
    
    [mFMDBQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *set = [db executeQuery:queryCmd];
        
        while ([set next]) {
            XBHUploadDoc *doc=[[XBHUploadDoc alloc] init];
            doc.UserId=userId;
            doc.DataId=[set longLongIntForColumn:@"DataId"];
            doc.DataType=[set longForColumn:@"DataType"];
            doc.DataUploadURL=[set stringForColumn:@"DataUploadURL"];
            doc.DataSoucrePath=[set stringForColumn:@"DataSoucrePath"];
            doc.DataName=[set stringForColumn:@"DataName"];
            doc.DataSoucrePath=[XBHUitility absolutePathWithOppositePath:doc.DataSoucrePath];
            doc.IconData=[set dataForColumn:@"IconData"];
            doc.UploadStatus=[set longForColumn:@"UploadStatus"];
            doc.Progress=[set doubleForColumn:@"Progress"];
            doc.DataReferenceInfo=[set dataForColumn:@"ReferenceInfo"];
            doc.mimeType=[set stringForColumn:@"MimeType"];
            [resultArray addObject:doc];
            
        }
        [set close];
        
    }];
   
    if ([resultArray count]<1) {
        return nil;
    }
    return resultArray;
    
}


-(NSArray *)XBHUploadDocListWithUploadStatus:(XBHUploadStatus)status UserId:(long long)userId {
   
    NSString *cmd=[NSString stringWithFormat:@"SELECT * FROM %@ WHERE UploadStatus=%d AND UserId=%lld ",TableName_UploadList,(uint32_t)status,userId];
    
    return [self XBHUploadDocListWithQueryCmd:cmd UserId:userId];
    
}




-(XBHUploadDoc *)oneXBHUploadDocWithQueryCmd:(NSString *)queryCmd UserId:(long long)userId {
    
    __block  XBHUploadDoc  *doc=nil;
    [mFMDBQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *set = [db executeQuery:queryCmd];
        
        if  ([set next]) {
            doc=[[XBHUploadDoc alloc] init];
            doc.UserId=userId;
            doc.DataId=[set longLongIntForColumn:@"DataId"];
            doc.DataType=[set longForColumn:@"DataType"];
            doc.DataUploadURL=[set stringForColumn:@"DataUploadURL"];
            doc.DataSoucrePath=[set stringForColumn:@"DataSoucrePath"];
            doc.DataName=[set stringForColumn:@"DataName"];
            doc.DataSoucrePath=[XBHUitility absolutePathWithOppositePath:doc.DataSoucrePath];
            doc.IconData=[set dataForColumn:@"IconData"];
            doc.UploadStatus=[set longForColumn:@"UploadStatus"];
            doc.Progress=[set doubleForColumn:@"Progress"];
            doc.DataReferenceInfo=[set dataForColumn:@"ReferenceInfo"];
            doc.mimeType=[set stringForColumn:@"MimeType"];

        }
        [set close];
        
    }];
    
    
    return doc;
    
}



-(XBHUploadDoc *)oneXBHUploadDocWithUploadStatus:(XBHUploadStatus)status UserId:(long long)userId {
    
    NSString *cmd=[NSString stringWithFormat:@"SELECT * FROM %@ WHERE UploadStatus=%d AND UserId=%lld ",TableName_UploadList,(uint32_t)status,userId];
    
    return [self oneXBHUploadDocWithQueryCmd:cmd UserId:userId];
    
}





-(NSArray *)XBHUploadDocListBettwenBeginStatus:(XBHUploadStatus)bStatus EndStatus:(XBHUploadStatus)eStatus UserId:(long long)userId {
    
    NSString *cmd=[NSString stringWithFormat:@"SELECT * FROM %@ WHERE UploadStatus>=%d AND UploadStatus <=%d AND UserId=%lld ",TableName_UploadList,(uint32_t)bStatus,(uint32_t)eStatus,userId];
    
    return [self XBHUploadDocListWithQueryCmd:cmd UserId:userId];
    
}

-(uint32_t)numberOfBettwenBeginStatus:(XBHUploadStatus)bStatus EndStatus:(XBHUploadStatus)eStatus UserId:(long long)userId{
    
    NSString *cmd=[NSString stringWithFormat:@"SELECT COUNT(*) FROM %@ WHERE UploadStatus>=%d AND UploadStatus <=%d AND UserId=%lld ",TableName_UploadList,(uint32_t)bStatus,(uint32_t)eStatus,userId];
    __block  uint32_t    rn=0;
    [mFMDBQueue inDatabase:^(FMDatabase *db) {
        
        FMResultSet *set = [db executeQuery:cmd];
        if ([set next]) {
            rn=(uint32_t)[set longForColumnIndex:0];
        }
        [set close];
        
    }];
    return rn;
}





@end
