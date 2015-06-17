

//
//
//  调用该类提供的接口，结果使用消息通知方式返回



#import <Foundation/Foundation.h>
#import "ShareInterfaceDefine.h"

@protocol ShareInterfaceDelegate <NSObject>

@optional

-(void)ShareInterface_SinaShareDidCancel;
-(void)ShareInterface_SinaShareDidFinish;
-(void)ShareInterface_SinaShareDidFailure:(NSString *)error;

// 分享结果返回(新浪分享除外)
-(void)ShareInterface_IsShareSuccessed:(BOOL)yn  PlatformName:(NSString *)pName NotifyStr:(NSString *)str;
@end


@interface ShareInterface : NSObject



@property   (nonatomic,assign)      id<ShareInterfaceDelegate>    delegate;

+ (ShareInterface *)defaultInstance;

+(void)ShareInterfaceDidFinishLaunching;

+(BOOL)ShareInterface_handleOpenURL:(NSURL *)url;

+(BOOL)ShareInterface_openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;

-(void)shareWithView:(UIView *)sender;


@end




