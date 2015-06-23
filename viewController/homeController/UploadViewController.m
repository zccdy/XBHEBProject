//
//  UploadViewController.m
//  XBHEBProject
//
//  Created by xubh-note on 15/4/19.
//  Copyright (c) 2015年 xu banghui. All rights reserved.
//

#import "UploadViewController.h"
#import  <Masonry.h>
#import <QuartzCore/QuartzCore.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "XBHUploadRequest.h"
#import "XBHImagePicker.h"
#import "Toast+UIView.h"

#import "UploadFileEditViewController.h"

#define UploadButtonW           (48)

#define UploadButtonH           (48)

#define UploadTopOffset         (100)

#define ProgressViewOffsetX     (25)

#define  OptionButtonColor       XBHUIThemeColor


//XBHMakeRGB(9.0, 187.0, 7.0)

@interface UploadViewController ()<XBHImagePickerDelegate>

@end

@implementation UploadViewController{
    UIProgressView              *_progressView;
    XBHImagePicker              *_picker;
    UILabel                     *_uploadFileNameLabel;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [XBHUploadRequest setResponseSerializerType:XBHResponseSerializerTypeHTTP];
    
    UIButton   *button1=[UIButton buttonWithType:UIButtonTypeCustom];
    button1.backgroundColor=OptionButtonColor;
    [button1 setTitle:@"图片" forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button1.titleLabel.font=XBHSysFont(15);
    [button1 addTarget:self action:@selector(imageUpload) forControlEvents:UIControlEventTouchUpInside];
    button1.layer.masksToBounds=YES;
    button1.layer.cornerRadius=XBHCornerRadius;//UploadButtonW/2;
    
    
    UIButton   *button2=[UIButton buttonWithType:UIButtonTypeCustom];
    button2.backgroundColor=OptionButtonColor;
    [button2 setTitle:@"视频" forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button2.titleLabel.font=XBHSysFont(15);
    [button2 addTarget:self action:@selector(vodeoUpload) forControlEvents:UIControlEventTouchUpInside];
    button2.layer.cornerRadius=UploadButtonW/2;
    
    UIButton   *button3=[UIButton buttonWithType:UIButtonTypeCustom];
     button3.backgroundColor=OptionButtonColor;
    [button3 setTitle:@"拍照" forState:UIControlStateNormal];
    [button3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button3.titleLabel.font=XBHSysFont(15);
    [button3 addTarget:self action:@selector(canmeraUpload) forControlEvents:UIControlEventTouchUpInside];
    button3.layer.cornerRadius=XBHCornerRadius;//UploadButtonW/2;
    
    _uploadFileNameLabel=[[UILabel alloc] init];
    _uploadFileNameLabel.opaque=NO;
    _uploadFileNameLabel.font=[UIFont systemFontOfSize:15];
    _uploadFileNameLabel.textColor=[UIColor whiteColor];
    _uploadFileNameLabel.textAlignment=NSTextAlignmentRight;
    _progressView=[[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
    _progressView.progressTintColor=XBHSeparatorColor;
    _progressView.trackTintColor=[UIColor lightGrayColor];
    _progressView.layer.masksToBounds=YES;
    _progressView.layer.cornerRadius=6.0;
    
    
    button1.alpha=0.6;
    button2.alpha=0.6;
    button3.alpha=0.6;
    [self.view addSubview:button1];
//    [self.view addSubview:button2];
    [self.view addSubview:button3];
    [self.view addSubview:_uploadFileNameLabel];
    [self.view addSubview:_progressView];
    
   
    
    
    [button1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).mas_equalTo(UploadTopOffset);
        make.left.equalTo(self.view.mas_left).mas_equalTo(25);
        make.right.equalTo(self.view.mas_right).mas_equalTo(-25);
        make.height.mas_equalTo(UploadButtonH);
        
    }];
    
    [button3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(button1.mas_bottom).mas_equalTo(50);
        make.left.and.right.equalTo(button1);
        make.height.mas_equalTo(button1.mas_height);
        
    }];
/*视频
    [button3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(button1.mas_bottom).mas_equalTo(25);
        make.left.equalTo(button1.mas_left).mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(UploadButtonW, UploadButtonH));
        
    }];
    
*/
   
    
    [_uploadFileNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(button3.mas_bottom).mas_equalTo(50);
        make.right.equalTo(self.view.mas_right).with.offset(-ProgressViewOffsetX);
        make.size.mas_equalTo(CGSizeMake(210, 20));
        
    }];
    
    
    [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_uploadFileNameLabel.mas_bottom).mas_equalTo(2);
        make.left.mas_equalTo(ProgressViewOffsetX);
        make.size.mas_equalTo(CGSizeMake(CGRectGetWidth(self.view.bounds)-ProgressViewOffsetX*2, 10));
        
    }];
    _progressView.hidden=YES;
   
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
  //  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadCallBack:) name:XBHHTTPUploadNotify object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
  //  [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self uploadProgressHidden];
}




-(void)createPickerIf{
    if (!_picker) {
        _picker=[[XBHImagePicker alloc] init];
        _picker.delegate=self;
    }
}

-(void)imageUpload{
    if (![XBHShareAppDelegate homePageJumpToLoginController]) {
        [self createPickerIf];
        [_picker pickImageWithController:self];
    }
    

}

-(void)vodeoUpload{
    if (![XBHShareAppDelegate homePageJumpToLoginController]) {
        [self createPickerIf];
        [_picker pickVideoWithController:self];
    }

    
    
}

-(void)canmeraUpload{
    if (![XBHShareAppDelegate homePageJumpToLoginController]) {
        [self createPickerIf];
        [_picker canmeraWithController:self];
    }

    
    
}



#pragma mark --

-(void)XBHImagePickerDidPick:(NSString *)dataPath fileName:(NSString *)name fileSize:(long long)size PickMode:(XBHImagePickerDataMode)mode thumbImage:(UIImage *)thumb{
    XBHUploadDataType    upType=0;
    if (mode == XBHImagePickerDataMode_ImageFromLibrary
        ||mode== XBHImagePickerDataMode_ImageByCamera) {
        upType=XBHUploadDataType_Image;
    }
    else if (mode ==XBHImagePickerDataMode_Video){
         upType=XBHUploadDataType_Video;
    }
        
    UploadFileEditViewController  *controller=[[UploadFileEditViewController alloc] init];
    controller.uploadFilePath=dataPath;
    controller.dataType=upType;
    controller.fileName=name;
    controller.fileSize=size;
    controller.thumbImg=thumb;
    [self.navigationController pushViewController:controller animated:YES];
}


#pragma mark ---

-(void)uploadCallBack:(NSNotification *)notify{
    XBHUploadDoc    *doc=[notify object];
    XBHUploadStatus status=doc.UploadStatus;
    CGFloat         progress=doc.Progress;
    NSString        *path=doc.DataSoucrePath;
    NSString        *fileName=nil;
    if ([path length]) {
        fileName=[path lastPathComponent];
    }
    if (status == XBHUploadStatus_Uploading) {
        [self uploadProgressShowWithProgress:progress];
        if (fileName) {
            _uploadFileNameLabel.text=fileName;
        }
    }
    else if (status == XBHUploadStatus_UploadCompelete){
        [self uploadSuccess];
    }
    else if (status == XBHUploadStatus_UploadFailure){
        [self uploadFailure];
    }


}


-(void)uploadProgressShowWithProgress:(CGFloat)progress{
    if (_progressView.hidden) {
        _progressView.hidden=NO;
    }
    [_progressView setProgress:progress animated:YES];
}

-(void)uploadProgressHidden{
    if (!_progressView.hidden) {
        _progressView.hidden=YES;
    }
    
    _uploadFileNameLabel.text=nil;
}

-(void)uploadEnd{

    _progressView.progress=0;
    [self uploadProgressHidden];

}
-(void)uploadSuccess{
   
    [self.view makeToast:[_uploadFileNameLabel.text stringByAppendingString:@"上传完成"] DownMoveToCenterDuration:0.3 NotifyAppearDelay:0 HideDelay:1.5];
    [self uploadEnd];
}

-(void)uploadFailure{
    
    [self.view makeToast:[_uploadFileNameLabel.text stringByAppendingString:@"上传失败"] DownMoveToCenterDuration:0.3 NotifyAppearDelay:0 HideDelay:1.5];
    [self uploadEnd];
}


@end
