//
//  XBHQRScanViewController.m
//  XBHEBProject
//
//  Created by xubh-note on 15/4/27.
//  Copyright (c) 2015年 xu banghui. All rights reserved.
//

#import "XBHQRScanViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "XBHImagePicker.h"
#define QRScanSubViewTag        (9999)

#define QRAlpha                  (0.5)


@interface XBHQRScanViewController ()<AVCaptureMetadataOutputObjectsDelegate>

@property ( strong , nonatomic ) AVCaptureDevice * device;
@property ( strong , nonatomic ) AVCaptureDeviceInput * input;
@property ( strong , nonatomic ) AVCaptureMetadataOutput * output;
@property ( strong , nonatomic ) AVCaptureSession * session;
@property ( strong , nonatomic ) AVCaptureVideoPreviewLayer * preview;
@property (strong,nonatomic)      NSTimer           *lineTimer;
@property (nonatomic, strong)      UIImageView *line;//交互线
@end

@implementation XBHQRScanViewController
{

    CGRect cropRect;

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self clearSubView];
    if ([XBHImagePicker XBHImagePicker_isCameraAvailable ]) {
        [self setupCamera];
        
        [self setOverlayPickerView];
    }
  
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.lineTimer) {
        [self.lineTimer invalidate];
    }
    [self.session stopRunning];

}

- (void)setupCamera
{
    
    //整个区域
    CGRect  drawRect=CGRectMake(0,0,CGRectGetWidth(self.view.bounds),CGRectGetHeight(self.view.frame)-CGRectGetHeight( self.tabBarController.tabBar.frame));
    
    
    // Device
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // Output
    self.output = [[AVCaptureMetadataOutput alloc]init];
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //扫描区域
    cropRect = CGRectMake((CGRectGetWidth(drawRect)-220)/2, (CGRectGetHeight(drawRect)-220)/2, 220, 220);
     CGSize size = self.view.bounds.size;
    CGFloat p1 = size.height/size.width;
    CGFloat p2 = 1920./1080.; //使用了1080p的图像输出
    if (p1 < p2) {
        CGFloat fixHeight = drawRect.size.width * 1920. / 1080.;
        CGFloat fixPadding = (fixHeight -drawRect.size.height)/2;
        self.output.rectOfInterest = CGRectMake((cropRect.origin.y + fixPadding)/fixHeight,
                                                cropRect.origin.x/drawRect.size.width,
                                                cropRect.size.height/fixHeight,
                                                cropRect.size.width/drawRect.size.width);
    } else {
        CGFloat fixWidth = drawRect.size.height * 1080. / 1920.;
        CGFloat fixPadding = (fixWidth - drawRect.size.width)/2;
        self.output.rectOfInterest = CGRectMake(cropRect.origin.y/drawRect.size.height,
                                                (cropRect.origin.x + fixPadding)/fixWidth,
                                                cropRect.size.height/drawRect.size.height,
                                                cropRect.size.width/fixWidth);
    }
    

    
    
    // Session
    self.session = [[AVCaptureSession alloc]init];
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([self.session canAddInput:self.input])
    {
        [self.session addInput:self.input];
    }
    
    if ([self.session canAddOutput:self.output])
    {
        [self.session addOutput:self.output];
    }
    
    /**
        条码类型 AVMetadataObjectTypeEAN13Code
     *  二维码  AVMetadataObjectTypeQRCode
     */
    self.output.metadataObjectTypes =@[ AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeEAN8Code] ;;
    

    
    // Preview
    if (self.preview) {
        [self.preview removeFromSuperlayer];
    }
    self.preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.preview.frame =drawRect;
   
    

    [self.view.layer insertSublayer:self.preview atIndex:0];
    
    // Start
    [self.session startRunning];
    
    self.lineTimer=[NSTimer scheduledTimerWithTimeInterval:1.0 / 20 target:self selector:@selector(animationLine) userInfo:nil repeats:YES];
    
}


#pragma mark 扫描动画
- (void)animationLine
{
    __block CGRect frame = _line.frame;
    
    static BOOL flag = YES;
    
    if (flag)
    {
        frame.origin.y = cropRect.origin.y;
        flag = NO;
        
        [UIView animateWithDuration:1.0 / 20 animations:^{
            
            frame.origin.y += 5;
            _line.frame = frame;
            
        } completion:nil];
    }
    else
    {
        if (_line.frame.origin.y >=  cropRect.origin.y)
        {
            if (_line.frame.origin.y >= CGRectGetMaxY( cropRect) - 12)
            {
                frame.origin.y =  cropRect.origin.y;
                _line.frame = frame;
                
                flag = YES;
            }
            else
            {
                [UIView animateWithDuration:1.0 / 20 animations:^{
                    
                    frame.origin.y += 5;
                    _line.frame = frame;
                    
                } completion:nil];
            }
        }
        else
        {
            flag = !flag;
        }
    }
}



-(void)clearSubView{
    for (UIView *view in self.view.subviews) {
        if (view.tag == QRScanSubViewTag) {
            [view removeFromSuperview];
        }
    }


}

- (void)setOverlayPickerView
{
    //画中间的基准线
    _line = [[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.view.frame) - 300) / 2.0, cropRect.origin.y, 300, 12 * 300 / 320.0)];
    _line.tag=QRScanSubViewTag;
    [_line setImage:[UIImage imageNamed:@"QRCodeLine"]];
    [self.view addSubview:_line];
    
    //最上部view
    UIView* upView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), cropRect.origin.y)];//80
    upView.tag=QRScanSubViewTag;
    upView.alpha = QRAlpha;
    upView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:upView];
    
    //左侧的view
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, cropRect.origin.y, (CGRectGetWidth(self.view.bounds) - cropRect.size.width) / 2.0, cropRect.size.height)];
    leftView.tag=QRScanSubViewTag;
    leftView.alpha =QRAlpha;
    leftView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:leftView];
    
    //右侧的view
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.bounds) - CGRectGetMaxX(leftView.frame), cropRect.origin.y, CGRectGetMaxX(leftView.frame), cropRect.size.height)];
    rightView.tag=QRScanSubViewTag;
    rightView.alpha =QRAlpha;
    rightView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:rightView];
    
    CGFloat space_h = CGRectGetHeight(self.view.frame) - CGRectGetMaxY(cropRect);
    
    //底部view
    UIView *downView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(cropRect),  CGRectGetWidth(self.view.frame), space_h)];
    downView.tag=QRScanSubViewTag;
    downView.alpha = QRAlpha;
    downView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:downView];
    
    //四个边角
    UIImage *cornerImage = [UIImage imageNamed:@"QRCodeTopLeft"];
    
    //左侧的view
    UIImageView *leftView_image = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(leftView.frame) - cornerImage.size.width / 2.0, CGRectGetMaxY(upView.frame) - cornerImage.size.height / 2.0, cornerImage.size.width, cornerImage.size.height)];
    leftView_image.tag=QRScanSubViewTag;
    leftView_image.image = cornerImage;
    [self.view addSubview:leftView_image];
    
    cornerImage = [UIImage imageNamed:@"QRCodeTopRight"];
    
    //右侧的view
    UIImageView *rightView_image = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(rightView.frame) - cornerImage.size.width / 2.0, CGRectGetMaxY(upView.frame) - cornerImage.size.height / 2.0, cornerImage.size.width, cornerImage.size.height)];
    rightView_image.tag=QRScanSubViewTag;
    rightView_image.image = cornerImage;
    [self.view addSubview:rightView_image];
    
    cornerImage = [UIImage imageNamed:@"QRCodeBottomLeft"];
    
    //底部view
    UIImageView *downView_image = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(leftView.frame) - cornerImage.size.width / 2.0, CGRectGetMinY(downView.frame) - cornerImage.size.height / 2.0, cornerImage.size.width, cornerImage.size.height)];
    downView_image.tag=QRScanSubViewTag;
    downView_image.image = cornerImage;
    //downView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:downView_image];
    
    cornerImage = [UIImage imageNamed:@"QRCodeBottomRight"];
    
    UIImageView *downViewRight_image = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(rightView.frame) - cornerImage.size.width / 2.0, CGRectGetMinY(downView.frame) - cornerImage.size.height / 2.0, cornerImage.size.width, cornerImage.size.height)];
    downViewRight_image.tag=QRScanSubViewTag;
    downViewRight_image.image = cornerImage;
    //downView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:downViewRight_image];
    
    //说明label
    UILabel *labIntroudction = [[UILabel alloc] init];
    labIntroudction.tag=QRScanSubViewTag;
    labIntroudction.backgroundColor = [UIColor clearColor];
    labIntroudction.frame = CGRectMake(CGRectGetMaxX(leftView.frame), CGRectGetMinY(downView.frame) + 25, cropRect.size.width, 20);
    labIntroudction.textAlignment = NSTextAlignmentCenter;
    labIntroudction.font = [UIFont boldSystemFontOfSize:13.0];
    labIntroudction.textColor = [UIColor whiteColor];
    labIntroudction.text = @"将二维码置于框内,即可自动扫描";
    [self.view addSubview:labIntroudction];
    
    UIView *scanCropView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(leftView.frame) - 1,cropRect.origin.y,self.view.frame.size.width - 2 * CGRectGetMaxX(leftView.frame) + 2, cropRect.size.height + 2)];
    scanCropView.tag=QRScanSubViewTag;
    scanCropView.layer.borderColor = [UIColor greenColor].CGColor;
    scanCropView.layer.borderWidth = 2.0;
    [self.view addSubview:scanCropView];
}





#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    
    NSString *stringValue;
    
    if ([metadataObjects count] >0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
    }
    
    [self.session stopRunning];
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"结果：%@",stringValue] delegate:self cancelButtonTitle:nil otherButtonTitles:@"知道了",@"重新扫描", nil];
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        [self.lineTimer  invalidate];
    }
    else{
         [self.session startRunning];
    }
}
@end
