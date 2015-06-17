//
//  XBHImagePicker.h
//  XBHEBProject
//
//  Created by xubh-note on 15/4/20.
//  Copyright (c) 2015年 xu banghui. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger, XBHImagePickerDataMode){

    XBHImagePickerDataMode_ImageFromLibrary=0,
    XBHImagePickerDataMode_ImageByCamera,
    XBHImagePickerDataMode_Video

};




@protocol XBHImagePickerDelegate <NSObject>

@optional
//图片 NSData  视屏  NSString
-(void)XBHImagePickerDidPick:(NSString *)dataPath fileName:(NSString *)name fileSize:(long long)size PickMode:(XBHImagePickerDataMode)mode thumbImage:(UIImage *)thumb;

@end


@interface XBHImagePicker : NSObject

@property   (nonatomic,weak)        id<XBHImagePickerDelegate> delegate;
/**
 *      缩略图大小
 */
@property   (nonatomic,assign)      CGSize              thumbImageSize;


// 判断设备是否有摄像头
+(BOOL) XBHImagePicker_isCameraAvailable;

// 前面的摄像头是否可用
+(BOOL) XBHImagePicker_isFrontCameraAvailable;
// 后面的摄像头是否可用
+ (BOOL) XBHImagePicker_isRearCameraAvailable;
// 检查摄像头是否支持录像
+(BOOL) XBHImagePicker_doesCameraSupportShootingVideos;
// 检查摄像头是否支持拍照
+(BOOL) XBHImagePicker_doesCameraSupportTakingPhotos;

// 相册是否可用
+ (BOOL) XBHImagePicker_isPhotoLibraryAvailable;
// 是否可以在相册中选择视频
+ (BOOL)XBHImagePicker_canPickVideosFromPhotoLibrary;
// 是否可以在相册中选择图片
+(BOOL)XBHImagePicker_canUserPickPhotosFromPhotoLibrary;





-(void)pickImageWithController:(UIViewController *)controller;
-(void)pickVideoWithController:(UIViewController *)controller;
-(void)canmeraWithController:(UIViewController *)controller;
@end
