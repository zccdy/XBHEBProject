//
//  XBHUitility.m
//  XBHEBProject
//
//  Created by xubh-note on 15/3/18.
//  Copyright (c) 2015年 xu banghui. All rights reserved.
//

#import "XBHUitility.h"
#import <CommonCrypto/CommonHMAC.h>
#include <sys/xattr.h>

@implementation XBHUitility




+(NSString*)getDocumentPathWithFileName:(NSString *)filename{
    NSString *filePath=nil;
    NSString *path=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    if(filename){
        filePath= [NSString stringWithString:[path stringByAppendingPathComponent:filename]];
        return filePath;
        
    }
    
    return path;
}


+(NSString *)getLibraryCachesPathWithFileName:(NSString *)filename{
    
    NSString *filePath=nil;
    NSString *path=[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    if(filename){
        filePath= [NSString stringWithString:[path stringByAppendingPathComponent:filename]];
        return filePath;
        
    }
    
    return path;
    
}

+(NSString*)getLibraryWithFileName:(NSString *)filename{
    
    NSString *filePath=nil;
    NSString *path=[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    if(filename){
        filePath= [NSString stringWithString:[path stringByAppendingPathComponent:filename]];
        return filePath;
        
    }
    
    return path;
    
}


+(NSString*)getImagesCachesPath{
    
    NSString *dir=[self getLibraryCachesPathWithFileName:@"ImagesCaches"];
    [self creatDirIfWithPath:dir];
    return dir;
    
}



+(BOOL)creatDirIfWithPath:(NSString *)path{
    BOOL   result=NO;
    BOOL  yn=NO;
    BOOL rn= [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&yn];
    if (!rn || !yn) {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        result=YES;
    }
    return result;
}

+(BOOL) dirIsExistsWithPath:(NSString *)path{
    BOOL  yn=NO;
    BOOL rn= [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&yn];
    if (!rn || !yn) {
        return NO;
    }
    return YES;
}
+(void) removeDirWithPath:(NSString *)path{
    BOOL  isdir=NO;
    if ([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isdir]) {
        if (isdir) {
            [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
            
        }
    }
    
}


+(void)setSkipBackupAttributeWithDirOrFilePath:(NSString *)path{
    NSURL  *pathUrl=[NSURL fileURLWithPath:path];
    if (IOS_SYSTEMVERSION_LATER(@"5.1")) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            
            BOOL rn= [pathUrl setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:nil];
            if (rn) {
                NSLog(@"设置不备份属性 成功");
            }
        }
    }
    else{
        
        const char *filePath=[[pathUrl path] fileSystemRepresentation];
        const char *attrName="com.apple.MobileBackup";
        u_int8_t attrValue=1;
        
        setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
        
        
    }
}

+(UInt64)getFileSizeWithFilePath:(NSString *)path{
    NSError *error=nil;
    NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:&error];
    if (!fileAttributes) {
        return (0);
    }
    return  [[fileAttributes objectForKey:NSFileSize] unsignedLongLongValue];
}


+(NSString*) deleteBlankWithStr:(NSString *)origStr{
    //NSMutableString  *mutStr=[NSMutableString stringWithString:origStr];
    NSUInteger i=[origStr length]-1;
    while(i){
        unichar ch=[origStr characterAtIndex:i];
        if (ch!=' ') {
            break;
        }
        i--;
    }
    if (i == ([origStr length]-1)) {
        return origStr;
    }
    
    return [origStr substringToIndex:i+1];
}

+(NSString *) removePrefixBlankWithStr:(NSString *)str{
    
    NSUInteger len=[str length];
    if (len<1) {
        return str;
    }
    NSUInteger i=0;
    for (; i<len; i++) {
        unichar ch=[str characterAtIndex:i];
        if (ch != ' ') {
            break;
        }
    }
    if (i == len-1) {//全空格
        return nil;
    }
    
    return [str substringFromIndex:i];
    
    
}


+(BOOL) isTotalBlankWithStr:(NSString *)str{
    
    for (NSUInteger i=0; i<[str length]; i++) {
        unichar ch=[str characterAtIndex:i];
        if (ch!=' ') {
            return NO;
        }
    }
    return YES;
}




+(NSString *)oppositePathWithAbsolutePath:(NSString *)absolutePath{
    
    return [absolutePath stringByAbbreviatingWithTildeInPath];
    
}

+(NSString *)absolutePathWithOppositePath:(NSString *)oppositePath{
    
    return [oppositePath stringByExpandingTildeInPath];
}



+(NSString *)autoRenameWithFileFullPath:(NSString *)path{
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        uint32_t i=1;
        NSString   *renameStr=path;
        NSString   *extension=[path pathExtension];
        if (extension) {
            NSRange range=[path rangeOfString:extension];
            if (range.location>1) {
                renameStr=[path substringToIndex:range.location-1];
            }
            
        }
        
        NSString *checkPath=nil;
        
        if (extension) {
            checkPath=[NSString stringWithFormat:@"%@(%d).%@",renameStr,i,extension];
        }
        else{
            checkPath=[NSString stringWithFormat:@"%@(%d)",renameStr,i];
        }
        while ([[NSFileManager defaultManager] fileExistsAtPath:checkPath]) {
            i++;
            if (extension) {
                checkPath=[NSString stringWithFormat:@"%@(%d).%@",renameStr,i,extension];
            }
            else{
                checkPath=[NSString stringWithFormat:@"%@(%d)",renameStr,i];
            }
            
        }
        return checkPath;
    }
    return path;
}


+(NSString *)cachesDirPath{
    NSString *DirName=[self getLibraryCachesPathWithFileName:@"cacheFiles"];
    [self creatDirIfWithPath:DirName];
    return DirName;
    
}

+(NSString *)fixedDirPath{
    NSString *DirName=[self getLibraryWithFileName:@"fixedFiles"];
    if ([self creatDirIfWithPath:DirName]) {
        [self setSkipBackupAttributeWithDirOrFilePath:DirName];
    }
    
    return DirName;
    
}

+(NSString *)downloadResourceFilePathWithName:(NSString *)fileName{
    NSString *DirName=[[self fixedDirPath] stringByAppendingPathComponent:@"DownloadResource"];
    if ([self creatDirIfWithPath:DirName]) {
        [self setSkipBackupAttributeWithDirOrFilePath:DirName];
    }
    if (!fileName) {
        return DirName;
    }
    return [DirName stringByAppendingPathComponent:fileName];
    
    
    
}



+(NSString *)uploadResourceFilePathWithName:(NSString *)fileName{
    NSString *DirName=[[self fixedDirPath] stringByAppendingPathComponent:@"uploadResource"];
    if ([self creatDirIfWithPath:DirName]) {
        [self setSkipBackupAttributeWithDirOrFilePath:DirName];
    }
    if (!fileName) {
        return DirName;
    }
    return [DirName stringByAppendingPathComponent:fileName];
    
    
    
}

+(NSString *)fileNameByCurrentTimeWithExtension:(NSString *)exten{
        return [self fileNameByCurrentTimeWithExtension:exten useHash:NO];
}


+(NSString *)fileNameByCurrentTimeWithExtension:(NSString *)exten useHash:(BOOL)hash{
    long long time= [[NSDate date] timeIntervalSinceReferenceDate]*1000;
    NSString  *md5Name=[XBHUitility md5StringFromString:[NSString stringWithFormat:@"%lld",time]];
    if (hash) {
        return [[NSString stringWithFormat:@"%lld",(long long)[md5Name hash]] stringByAppendingString:exten];
    }
    return [md5Name stringByAppendingString:exten];
}





+(NSString *)fileSizeStringWithByteSize:(UInt64) size{
    NSString *unit=nil;
    CGFloat  showSize=0;
    if (size>1024*1024) {
        unit=@"MB";
        showSize=size/(1024*1024);
    }
    else if(size>1024){
        unit=@"KB";
        showSize=size/1024;
    }
    else{
        unit=@"Byte";
        showSize=size;
    }
   
    return [NSString stringWithFormat:@"%.1f%@",showSize,unit];
}


//md5 16位加密 （大写）
+ (NSString *)md5StringFromString:(NSString *)string {
    if(string == nil || [string length] == 0)
        return nil;
    
    const char *value = [string UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    
    return outputString;
}



+(NSData *)base64Decode:(NSString *)string{
    unsigned long ixtext, lentext;
    unsigned char ch, inbuf[4] = {0}, outbuf[4] = {0};
    short i, ixinbuf;
    Boolean flignore, flendtext = false;
    const unsigned char *tempcstring;
    NSMutableData *theData;
    
    if (string == nil) {
        return [NSData data];
    }
    
    ixtext = 0;
    tempcstring = (const unsigned char *)[string UTF8String];
    lentext = [string length];
    theData = [NSMutableData dataWithCapacity: lentext];
    ixinbuf = 0;
    while (true) {
        if (ixtext >= lentext){
            break;
        }
        
        ch = tempcstring [ixtext++];
        flignore = false;
        if ((ch >= 'A') && (ch <= 'Z')) {
            ch = ch - 'A';
        } else if ((ch >= 'a') && (ch <= 'z')) {
            ch = ch - 'a' + 26;
        } else if ((ch >= '0') && (ch <= '9')) {
            ch = ch - '0' + 52;
        } else if (ch == '+') {
            ch = 62;
        } else if (ch == '=') {
            flendtext = true;
        } else if (ch == '/') {
            ch = 63;
        } else {
            flignore = true;
        }
        
        if (!flignore) {
            short ctcharsinbuf = 3;
            Boolean flbreak = false;
            
            if (flendtext) {
                if (ixinbuf == 0) {
                    break;
                }
                
                if ((ixinbuf == 1) || (ixinbuf == 2)) {
                    ctcharsinbuf = 1;
                } else {
                    ctcharsinbuf = 2;
                }
                ixinbuf = 3;
                flbreak = true;
            }
            
            inbuf [ixinbuf++] = ch;
            if (ixinbuf == 4) {
                ixinbuf = 0;
                
                outbuf[0] = (inbuf[0] << 2) | ((inbuf[1] & 0x30) >> 4);
                outbuf[1] = ((inbuf[1] & 0x0F) << 4) | ((inbuf[2] & 0x3C) >> 2);
                outbuf[2] = ((inbuf[2] & 0x03) << 6) | (inbuf[3] & 0x3F);
                
                for (i = 0; i < ctcharsinbuf; i++) {
                    [theData appendBytes: &outbuf[i] length: 1];
                }
            }
            if (flbreak) {
                break;
            }
        }
    }
    
    return theData;
}

+(NSString*)base64Encode:(NSData *)data{
    static char base64EncodingTable[64] = {
        'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P',
        'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f',
        'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
        'w', 'x', 'y', 'z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '+', '/'
    };
    NSUInteger length = [data length];
    unsigned long ixtext, lentext;
    long ctremaining;
    unsigned char input[3], output[4];
    short i, charsonline = 0, ctcopy;
    const unsigned char *raw;
    NSMutableString *result;
    
    lentext = [data length];
    if (lentext < 1)
        return @"";
    result = [NSMutableString stringWithCapacity: lentext];
    raw = [data bytes];
    ixtext = 0;
    
    while (true) {
        ctremaining = lentext - ixtext;
        if (ctremaining <= 0)
            break;
        for (i = 0; i < 3; i++) {
            unsigned long ix = ixtext + i;
            if (ix < lentext)
                input[i] = raw[ix];
            else
                input[i] = 0;
        }
        output[0] = (input[0] & 0xFC) >> 2;
        output[1] = ((input[0] & 0x03) << 4) | ((input[1] & 0xF0) >> 4);
        output[2] = ((input[1] & 0x0F) << 2) | ((input[2] & 0xC0) >> 6);
        output[3] = input[2] & 0x3F;
        ctcopy = 4;
        switch (ctremaining) {
            case 1:
                ctcopy = 2;
                break;
            case 2:
                ctcopy = 3;
                break;
        }
        
        for (i = 0; i < ctcopy; i++)
            [result appendString: [NSString stringWithFormat: @"%c", base64EncodingTable[output[i]]]];
        
        for (i = ctcopy; i < 4; i++)
            [result appendString: @"="];
        
        ixtext += 3;
        charsonline += 4;
        
        if ((length > 0) && (charsonline >= length))
            charsonline = 0;
    }     
    return result;
}



+(UInt8)writeByte:(char **)p Data:(UInt8) data{
    memcpy(*p, &data, sizeof(UInt8));
    (*p)+=sizeof(UInt8);
    return sizeof(UInt8);
}

+(UInt8)writeWord:(char **)p Data:(UInt16) data{
    UInt16  ndata;
    ndata=HTONS(data);
    memcpy(*p, &ndata, sizeof(UInt16));
    (*p)+=sizeof(UInt16);
    return sizeof(UInt16);
}


+(uint32_t) writeDWord:(char **)p Data:(uint32_t) data{
    uint32_t  ndata;
    ndata=HTONL(data);
    memcpy(*p, &ndata, sizeof(uint32_t));
    (*p)+=sizeof(uint32_t);
    return sizeof(uint32_t);
}
+(uint32_t) writeCString:(char **)p CString:(const char *)string{
    UInt16 len=strlen(string);
    [self writeWord:p Data:len];
    memcpy(*p, string, len);
    (*p)+=len;
    return (len+sizeof(UInt16));
    
}
+(UInt8)readByte:(char **)p{
    UInt8 data;
    memcpy(&data, *p, sizeof(UInt8));
    (*p)++;
    return data;
    
}
+(UInt16)readWord:(char **)p{
    UInt16  data=0;
    memcpy(&data, *p, sizeof(UInt16));
    (*p)+=sizeof(UInt16);
    return NTOHS(data);
    
}
+(uint32_t)readDWord:(char **)p{
    uint32_t  data=0;
    memcpy(&data, *p, sizeof(uint32_t));
    (*p)+=sizeof(uint32_t);
    return NTOHL(data);
    
}
+(char*)readCString:(char **)p ptrSkip:(uint32_t *)getSkipLen{
    UInt16   len=0;
    char    *pTemp=NULL;
    len=[self readWord:p];
    
    if (getSkipLen) {
        *getSkipLen=sizeof(UInt16)+len;
    }
    
    pTemp=(char *)malloc(len+2);
    if (!pTemp) {
        *p=*p+len;
        return NULL;
    }
    memset(pTemp, 0, len+2);
    memcpy(pTemp, *p, len);
    (*p)+=len;
    
    return pTemp;
    
}
+(NSString *)readNSStringWithUTF8Encoding:(char **)p{
    UInt16    len=0;
    len=[self readWord:p];
    UInt8 *data=(UInt8 *)malloc(len+2);
    memset(data, 0, len+2);
    
    if (data) {
        memcpy(data, *p, len);
    }
    (*p)+=len;
    NSString *str=[NSString stringWithUTF8String:(char *)data];
    
    free(data);
    return str;
    
}


+(NSData *)jsonDataWithObject:(id)obj{
    if (!obj
        ||![NSJSONSerialization isValidJSONObject:obj]) {
        return nil;
    }
  return  [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:nil];

}


+(UIImage *)imageWithBundleName:(NSString *)bundleName imageName:(NSString *)imgName{

    NSString *path=[[NSBundle mainBundle] resourcePath];
    NSString *path1=[path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.bundle/%@",bundleName,imgName]];
    
    return [UIImage imageWithContentsOfFile:path1];
   
}





+(BOOL)isValidateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}


//手机号码验证
+ (BOOL)isValidateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}


//车牌号验证
+ (BOOL)isValidateCarNumber:(NSString *)carNo
{
    NSString *carRegex = @"^[\u4e00-\u9fa5]{1}[a-zA-Z]{1}[a-zA-Z_0-9]{4}[a-zA-Z_0-9_\u4e00-\u9fa5]$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carRegex];
    NSLog(@"carTest is %@",carTest);
    return [carTest evaluateWithObject:carNo];
}


//车型
+ (BOOL)isValidateCarType:(NSString *)CarType
{
    NSString *CarTypeRegex = @"^[\u4E00-\u9FFF]+$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CarTypeRegex];
    return [carTest evaluateWithObject:CarType];
}


//用户名
+ (BOOL)isValidateUserName:(NSString *)name
{
    NSString *userNameRegex = @"^[a-zA-Z][a-zA-Z0-9_]{4,15}$";
    NSPredicate *userNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",userNameRegex];
    BOOL B = [userNamePredicate evaluateWithObject:name];
    return B;
}


//密码
+ (BOOL) isValidatePassword:(NSString *)passWord
{
    NSString *passWordRegex = @"^[a-zA-Z0-9]{6,21}+$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    return [passWordPredicate evaluateWithObject:passWord];
}


//昵称
+ (BOOL) isValidateNickname:(NSString *)nickname
{
    NSString *nicknameRegex = @"^[\u4e00-\u9fa5]{5,10}$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nicknameRegex];
    return [passWordPredicate evaluateWithObject:nickname];
}


//身份证号
+ (BOOL)isValidateIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}

//验证码检测
+(BOOL)authCodeCheck:(NSString *)input  authCode:(NSString *)code{

    return ([input compare:code
                      options:NSCaseInsensitiveSearch | NSNumericSearch] == NSOrderedSame);

}


+(void)showNotifyMessage:(NSString *)message  title:(NSString *)title{

    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];



}








+(NSString*)getLaunchImageNameForOrientation:(UIInterfaceOrientation)orientation
{
   
    CGSize viewSize =[[UIScreen mainScreen] bounds].size;
    NSString* viewOrientation = @"Portrait";
    if (UIDeviceOrientationIsLandscape(orientation)) {
        viewSize = CGSizeMake(viewSize.height, viewSize.width);
        viewOrientation = @"Landscape";
    }
    
    NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for (NSDictionary* dict in imagesDict) {
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        if (CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]])
            return dict[@"UILaunchImageName"];
    }
    
    //没有找到对应尺寸的loading图，寻找大一号的图
    for (NSDictionary* dict in imagesDict) {
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        if (imageSize.height > viewSize.height
            && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]]) {
            return dict[@"UILaunchImageName"];
        }

    }
    //还是没找到
    
    for (NSDictionary* dict in imagesDict) {
        
        if ([viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]]) {
            return dict[@"UILaunchImageName"];
        }
    }

    return nil;
    
}








+ (UIColor *) colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}


@end
