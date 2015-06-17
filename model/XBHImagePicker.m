//
//  XBHImagePicker.m
//  XBHEBProject
//
//  Created by xubh-note on 15/4/20.
//  Copyright (c) 2015年 xu banghui. All rights reserved.
//

#import "XBHImagePicker.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>


@interface XBHImagePicker ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property   (nonatomic,weak)         UIViewController      *controller;
@end


@implementation XBHImagePicker
{
    XBHImagePickerDataMode              _curPickerMode;

}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.thumbImageSize=CGSizeMake(100, 100);
    }
    return self;
}

// 判断设备是否有摄像头

+(BOOL) XBHImagePicker_isCameraAvailable{
    
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    
}



// 前面的摄像头是否可用

+(BOOL) XBHImagePicker_isFrontCameraAvailable{
    
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
    
}

// 后面的摄像头是否可用
+ (BOOL) XBHImagePicker_isRearCameraAvailable{
    
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
    
}


// 判断是否支持某种多媒体类型：拍照，视频

+(BOOL)XBHImagePicker_cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    
    __block BOOL result = NO;
    
    if ([paramMediaType length] == 0){
        
        NSLog(@"Media type is empty.");
        
        return NO;
        
    }
    
    NSArray *availableMediaTypes =[UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    
    [availableMediaTypes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL*stop) {
        
        NSString *mediaType = (NSString *)obj;
        
        if ([mediaType isEqualToString:paramMediaType]){
            
            result = YES;
            
            *stop= YES;
            
        }
        
        
        
    }];
    
    return result;
    
}



// 检查摄像头是否支持录像

+(BOOL) XBHImagePicker_doesCameraSupportShootingVideos{
    if ([self XBHImagePicker_isCameraAvailable]) {
        return [self XBHImagePicker_cameraSupportsMedia:( NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypeCamera];
    }
    return NO;
}



// 检查摄像头是否支持拍照

+(BOOL) XBHImagePicker_doesCameraSupportTakingPhotos{
    if ([self XBHImagePicker_isCameraAvailable]) {
        return [self XBHImagePicker_cameraSupportsMedia:( NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
    }
    return NO;
}

// 相册是否可用

+ (BOOL) XBHImagePicker_isPhotoLibraryAvailable{
    
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
    
}



// 是否可以在相册中选择视频

+ (BOOL)XBHImagePicker_canPickVideosFromPhotoLibrary{
    if ([self XBHImagePicker_isPhotoLibraryAvailable]) {
        return [self XBHImagePicker_cameraSupportsMedia:( NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    
    return NO;
}



// 是否可以在相册中选择图片

+(BOOL)XBHImagePicker_canUserPickPhotosFromPhotoLibrary{
    if ([self XBHImagePicker_isPhotoLibraryAvailable]) {
        return [self XBHImagePicker_cameraSupportsMedia:( NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        
    }
    return NO;
}



-(void)pickImageWithController:(UIViewController *)controller{
    self.controller=controller;
    if ([XBHImagePicker XBHImagePicker_isPhotoLibraryAvailable]) {
        [self pickPhotoWithMode:UIImagePickerControllerSourceTypePhotoLibrary pickMode:XBHImagePickerDataMode_ImageFromLibrary];
    }
}

-(void)pickVideoWithController:(UIViewController *)controller{
    self.controller=controller;
    if ([XBHImagePicker XBHImagePicker_canPickVideosFromPhotoLibrary]) {
        [self pickPhotoWithMode:UIImagePickerControllerSourceTypePhotoLibrary pickMode:XBHImagePickerDataMode_Video];
        
    }
}

-(void)canmeraWithController:(UIViewController *)controller{
    self.controller=controller;
    if ([XBHImagePicker XBHImagePicker_doesCameraSupportTakingPhotos]) {
        [self pickPhotoWithMode:UIImagePickerControllerSourceTypeCamera pickMode:XBHImagePickerDataMode_ImageByCamera];
    }
}

-(BOOL)pickPhotoWithMode:(UIImagePickerControllerSourceType)type pickMode:(XBHImagePickerDataMode)mode{
    _curPickerMode=mode;
    
    UIImagePickerController *picker=[[UIImagePickerController alloc] init];
   
    picker.delegate=self;
    picker.sourceType=type;
    
    if (mode == XBHImagePickerDataMode_ImageFromLibrary) {//相册
         picker.mediaTypes=@[(NSString *)kUTTypeImage];
    }
    else if (mode == XBHImagePickerDataMode_Video){
        picker.mediaTypes=@[(NSString *)kUTTypeMovie];//视屏
    }
    
  
    
    [self.controller  presentViewController:picker animated:YES completion:nil];
    
    return YES;
    
}



-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    if (IOS7SYSTEMVERSION_OR_LATER) {
        [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
    }
    NSData *data= nil;
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
   __block NSString    *fileName=nil;
    NSURL                *dataURL=nil;
    
    UIImage *theImage = nil;
    // 判断获取类型：图片
    
    if ([mediaType isEqualToString:( NSString *)kUTTypeImage]){
       
        // 判断，图片是否允许修改
        if ([picker allowsEditing]){
            
            //获取用户编辑之后的图像
            
            theImage = [info objectForKey:UIImagePickerControllerEditedImage];
            
        } else {
            // 照片的元数据参数
            theImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
        
        data=UIImageJPEGRepresentation(theImage, 1.0f);
        
        dataURL = [info valueForKey:UIImagePickerControllerReferenceURL];
        
    }else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]){// 判断获取类型：视频

        //获取视频文件的url
        
        dataURL = [info objectForKey:UIImagePickerControllerMediaURL];
        
       
    }
    
    XBHWeakSelf;
    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
    {
        NSString *path=nil;
        ALAssetRepresentation *representation = [myasset defaultRepresentation];
        fileName = [representation filename];
        long long size=0;
        UIImage   *thumbImage=nil;
        
        if (_curPickerMode == XBHImagePickerDataMode_ImageByCamera
            ||_curPickerMode == XBHImagePickerDataMode_ImageFromLibrary) {
            if (![fileName length]) {
                fileName=[XBHUitility fileNameByCurrentTimeWithExtension:@".png" useHash:YES];
            }
            path=[XBHUitility getLibraryCachesPathWithFileName:fileName];
           [data writeToFile:path atomically:NO];
            size=[data length];
            
            thumbImage=[self thumbImageWithImage:theImage];
        }
        else if (_curPickerMode == XBHImagePickerDataMode_Video){
            if (![fileName length]) {
                fileName=[XBHUitility fileNameByCurrentTimeWithExtension:@".MOV" useHash:YES];
            }
            else{
                //视屏名字较长 采用hash值
                NSUInteger  hash=[[fileName stringByDeletingPathExtension] hash];
                fileName=[[NSString stringWithFormat:@"%lu",(unsigned long)hash] stringByAppendingString:[fileName pathExtension]];
            }
           
            path=[XBHUitility getLibraryCachesPathWithFileName:fileName];
            [[NSFileManager defaultManager] linkItemAtURL:dataURL toURL:[NSURL fileURLWithPath:path] error:nil];
            size=[XBHUitility getFileSizeWithFilePath:path];
            thumbImage=[self thumbImageForVideoWithURL:dataURL];
            thumbImage=[self thumbImageWithImage:thumbImage];
        }
        
        
        [picker dismissViewControllerAnimated:YES completion:^{
            XBHStrongSelf;
            if ([strongSelf.delegate respondsToSelector:@selector(XBHImagePickerDidPick:fileName:fileSize:PickMode:thumbImage:)]) {
                [strongSelf.delegate XBHImagePickerDidPick:path fileName:fileName fileSize:size PickMode:_curPickerMode thumbImage:thumbImage];
            }
            
        }];
        
    };
    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
    
    [assetslibrary assetForURL:dataURL  resultBlock:resultblock failureBlock:nil];
    
   
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    if (IOS7SYSTEMVERSION_OR_LATER) {
        [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
}





-(UIImage *)thumbImageForVideoWithURL:(NSURL *)url{

     AVAssetImageGenerator *gen=[AVAssetImageGenerator assetImageGeneratorWithAsset:[AVURLAsset assetWithURL:url]];
    gen.appliesPreferredTrackTransform=YES;
    CGImageRef   img=[gen copyCGImageAtTime:CMTimeMake(0.0, 10) actualTime:nil error:nil];
    return [UIImage imageWithCGImage:img];
}




-(UIImage *)thumbImageWithImage:(UIImage *)orgImage{
    UIGraphicsBeginImageContext(self.thumbImageSize);
    [orgImage drawInRect:CGRectMake(0, 0, self.thumbImageSize.width, self.thumbImageSize.height)];


    UIImage *newImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return newImage;
}




@end
