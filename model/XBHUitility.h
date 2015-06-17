//
//  XBHUitility.h
//  XBHEBProject
//
//  Created by xubh-note on 15/3/18.
//  Copyright (c) 2015年 xu banghui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


#define IOS7SDK_OR_LATER     (__IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1)

#define IOS7SYSTEMVERSION_OR_LATER  IOS_SYSTEMVERSION_LATER(@"7.0")

#define IOS6SYSTEMVERSION_OR_LATER  IOS_SYSTEMVERSION_LATER(@"6.0")

#define IOS_SYSTEMVERSION_LATER(_VerStr)  ([[[UIDevice currentDevice] systemVersion] compare:_VerStr] != NSOrderedAscending)



#define XBHMakeRGB(_R,_G,_B) [UIColor colorWithRed:(_R)/255.0 green:(_G)/255.0 blue:(_B)/255.0 alpha:1.0]

#define XBHMakeRGB_SameValue(_C)  XBHMakeRGB(_C,_C,_C)

#define XBHMakeRGBWithHexString(_V)  [XBHUitility colorWithHexString:_V]

#define XBHWeak(_V,_P)       __weak __typeof(_P) _V =_P

#define XBHStrong(_V,_P)         __strong __typeof(_P) _V=_P

#define XBHWeakSelf             XBHWeak(weakSelf,self)

#define XBHStrongSelf           XBHStrong(strongSelf,weakSelf)

#define XBHImage(_bundleName,_imgName)    [XBHUitility imageWithBundleName:_bundleName imageName:_imgName]

#define XBHHomeBundleImageWithName(_imgName)    XBHImage(@"home",_imgName)

#define XBHSubViewCommonTag                 (9000)

#define XBHSysFont(_V)                  [UIFont systemFontOfSize:_V]

#define XBHBoldSysFont(_V)              [UIFont boldSystemFontOfSize:_V]

@interface XBHUitility : NSObject


//dir
+(BOOL)creatDirIfWithPath:(NSString *)path;
+(BOOL) dirIsExistsWithPath:(NSString *)path;
+(void) removeDirWithPath:(NSString *)path;
+(UInt64)getFileSizeWithFilePath:(NSString *)path;
+(void)setSkipBackupAttributeWithDirOrFilePath:(NSString *)path;

//path
+(NSString *)cachesDirPath;
+(NSString *)fixedDirPath;
+(NSString*)getDocumentPathWithFileName:(NSString *)filename;
+(NSString *)getLibraryCachesPathWithFileName:(NSString *)filename;
+(NSString*)getLibraryWithFileName:(NSString *)filename;
+(NSString*)getImagesCachesPath;
+(NSString *)oppositePathWithAbsolutePath:(NSString *)absolutePath;
+(NSString *)absolutePathWithOppositePath:(NSString *)oppositePath;
+(NSString *)autoRenameWithFileFullPath:(NSString *)path;
+(NSString *)downloadResourceFilePathWithName:(NSString *)fileName;
+(NSString *)uploadResourceFilePathWithName:(NSString *)fileName;


//string
+(NSString*) deleteBlankWithStr:(NSString *)origStr;
+(NSString *) removePrefixBlankWithStr:(NSString *)str;
+(BOOL) isTotalBlankWithStr:(NSString *)str;
+(NSString *)fileSizeStringWithByteSize:(UInt64) size;
+(NSString *)fileNameByCurrentTimeWithExtension:(NSString *)exten;
+(NSString *)fileNameByCurrentTimeWithExtension:(NSString *)exten useHash:(BOOL)hash;


//Data
+ (NSString *)md5StringFromString:(NSString *)string;
+(NSString*)base64Encode:(NSData *)data;
+(NSData *)base64Decode:(NSString *)string;
+(UInt8)writeByte:(char **)p Data:(UInt8) data;
+(UInt8)writeWord:(char **)p Data:(UInt16) data;
+(uint32_t) writeDWord:(char **)p Data:(uint32_t) data;
+(uint32_t) writeCString:(char **)p CString:(const char *)string;
+(UInt8)readByte:(char **)p;
+(UInt16)readWord:(char **)p;
+(uint32_t)readDWord:(char **)p;
+(char*)readCString:(char **)p ptrSkip:(uint32_t *)getSkipLen;
+(NSString *)readNSStringWithUTF8Encoding:(char **)p;
+(NSData *)jsonDataWithObject:(id)obj;
+(UIImage *)imageWithBundleName:(NSString *)bundleName imageName:(NSString *)imgName;

//mail

+(BOOL)isValidateEmail:(NSString *)email;
//手机号码验证
+ (BOOL)isValidateMobile:(NSString *)mobile;

//车牌号验证
+ (BOOL)isValidateCarNumber:(NSString *)carNo;


//车型
+ (BOOL)isValidateCarType:(NSString *)CarType;

//用户名(字母开头，允许字母数字下划线，5-16字节)
+ (BOOL)isValidateUserName:(NSString *)name;


//密码(5--21个字符)
+ (BOOL) isValidatePassword:(NSString *)passWord;

//昵称(5--10个汉字)
+ (BOOL) isValidateNickname:(NSString *)nickname;

//身份证号
+ (BOOL)isValidateIdentityCard: (NSString *)identityCard;

//验证码检测
+(BOOL)authCodeCheck:(NSString *)input  authCode:(NSString *)code;


+(void)showNotifyMessage:(NSString *)message  title:(NSString *)title;



//launchImage
+(NSString*)getLaunchImageNameForOrientation:(UIInterfaceOrientation)orientation;

//uicolor
+ (UIColor *) colorWithHexString: (NSString *)color;

@end
