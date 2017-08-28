//
//  CCCameraViewController.m
//  AgilePOPs
//
//  Created by CongCong on 2017/5/19.
//  Copyright © 2017年 CongCong. All rights reserved.
//

#import "CCCameraViewController.h"
#import "CCFile.h"
#import "CCTool.h"
#import "CCDate.h"
#import "CCAlert.h"
#import "CCUserData.h"
#import <SDAutoLayout.h>
#import "CustomIOSAlertView.h"
#import <CoreMotion/CoreMotion.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "ALAssetsLibrary+CustomPhotoAlbum.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface CCCameraViewController ()<AVCaptureMetadataOutputObjectsDelegate,UIGestureRecognizerDelegate>{
    ALAssetsLibrary  * assetsLibrary_;
    dispatch_queue_t serialQueue;
    NSInteger _maxPhotoCount;
    NSInteger _requirePhotoCount;
    NSInteger _currentPhotoCount;
    NSTimer *_autoFoucusTimer;
}
@property (nonatomic, strong) CMDeviceMotion * motion;
@property (nonatomic, strong) UIView * creamView;

@property (nonatomic, strong) ALAssetsLibrary * assetsLibrary;

//捕获设备，通常是前置摄像头，后置摄像头，麦克风（音频输入）
@property(nonatomic)AVCaptureDevice *device;

//AVCaptureDeviceInput 代表输入设备，他使用AVCaptureDevice 来初始化
@property(nonatomic)AVCaptureDeviceInput *input;

//当启动摄像头开始捕获输入
@property(nonatomic)AVCaptureMetadataOutput *output;

@property (nonatomic)AVCaptureStillImageOutput *ImageOutPut;

//session：由他把输入输出结合在一起，并开始启动捕获设备（摄像头）
@property(nonatomic)AVCaptureSession *session;

//图像预览层，实时显示捕获的图像
@property(nonatomic)AVCaptureVideoPreviewLayer *previewLayer;

//操作View
@property (nonatomic)UIView *bottomView;

//拍照按钮
@property (nonatomic)UIButton *PhotoButton;

//闪光灯
@property (nonatomic)UIButton *flashButton;

//拍好的照片
@property (nonatomic)UIImageView *imageView;

//对焦
@property (nonatomic)UIView *focusView;

//闪光灯状态
@property (nonatomic)BOOL isflashOn;

//照片拍照
@property (nonatomic, copy)CameraPhotoCallBack photoCallBack;
@property (nonatomic)UIButton *orangePhoto;

@end

@implementation CCCameraViewController

- (instancetype)initWithPhotoCallBack:(CameraPhotoCallBack)photoCallBack withCurrentPhotoCount:(NSInteger)currentCount requiredPhotoCount:(NSInteger)requireCount andMaxPhotoCount:(NSInteger)maxCount
{
    self = [super init];
    if (self) {
        self.photoCallBack = photoCallBack;
        _currentPhotoCount = currentCount;
        _requirePhotoCount = requireCount;
        _maxPhotoCount = maxCount;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    self.title = @"自定义相机";
    self.view.backgroundColor = [UIColor whiteColor];
    serialQueue=dispatch_queue_create("myThreadQueueImageZip", DISPATCH_QUEUE_SERIAL);
    [self initSession];
    [self initPhotoUI];
    [self startAutoFoucus];
    [self getCompass];
}

- (void)startAutoFoucus{
    _autoFoucusTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(autoFoucus) userInfo:nil repeats:YES];
}

- (void)autoFoucus{
    CGPoint focusPoint = CGPointMake( 0.5f,0.5f);
    NSError *error;
    if ([self.device lockForConfiguration:&error]) {
        
        if ([self.device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
            [self.device setFocusPointOfInterest:focusPoint];
            [self.device setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
        }
        
        if ([self.device isExposureModeSupported:AVCaptureExposureModeAutoExpose ]) {
            [self.device setExposurePointOfInterest:focusPoint];
            [self.device setExposureMode:AVCaptureExposureModeAutoExpose];
        }
        
        [self.device unlockForConfiguration];
    }
}
- (BOOL)prefersStatusBarHidden{
    return YES;
}

#pragma mark -----------> 相机session
- (void)initSession{
    //使用AVMediaTypeVideo 指明self.device代表视频，默认使用后置摄像头进行初始化
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //使用设备初始化输入
    self.input = [[AVCaptureDeviceInput alloc]initWithDevice:self.device error:nil];
    //生成输出对象
    self.output = [[AVCaptureMetadataOutput alloc]init];
    self.ImageOutPut = [[AVCaptureStillImageOutput alloc] init];
    
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey,nil];
    [self.ImageOutPut setOutputSettings:outputSettings];
    
    //生成会话，用来结合输入输出
    self.session = [[AVCaptureSession alloc]init];
    
    [self setOrangePhotoSession:isOrangePhoto()];
    
    if ([self.session canAddInput:self.input]) {
        [self.session addInput:self.input];
    }
    if ([self.session canAddOutput:self.ImageOutPut]) {
        [self.session addOutput:self.ImageOutPut];
    }
    
    self.creamView = [[UIView alloc]initWithFrame:CGRectMake(0, 60, SYSTEM_WIDTH, SYSTEM_HEIGHT-160)];
    self.creamView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.creamView];
    
    //使用self.session，初始化预览层，self.session负责驱动input进行信息的采集，layer负责把图像渲染显示
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:self.session];
    self.previewLayer.frame = self.creamView.bounds;
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    [self.creamView.layer addSublayer:self.previewLayer];
    
    //开始启动
    [self.session startRunning];
    
    if ([_device lockForConfiguration:nil]) {
        if ([_device isFlashModeSupported:AVCaptureFlashModeAuto]) {
            [_device setFlashMode:AVCaptureFlashModeAuto];
        }
        //自动白平衡
        if ([_device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeAutoWhiteBalance]) {
            [_device setWhiteBalanceMode:AVCaptureWhiteBalanceModeAutoWhiteBalance];
        }
        [_device unlockForConfiguration];
    }
}


#pragma mark -----------> UI
- (void)initPhotoUI{
    
    UIView * topView = [[UIView alloc]init];
    topView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:topView];

    
    topView.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topEqualToView(self.view)
    .heightIs(60);
    
    self.bottomView = [[UIView alloc]init];
    _bottomView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_bottomView];
    
    _bottomView.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomEqualToView(self.view)
    .heightIs(100);
    
    _PhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_PhotoButton setImage:[UIImage imageNamed:@"photograph"] forState: UIControlStateNormal];
    [_PhotoButton setImage:[UIImage imageNamed:@"photograph_Select"] forState:UIControlStateNormal];
    [_PhotoButton addTarget:self action:@selector(shutterCamera) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_PhotoButton];
    
    _PhotoButton.sd_layout
    .centerXEqualToView(_bottomView)
    .bottomSpaceToView(_bottomView,20)
    .heightIs(60)
    .widthIs(60);
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setTitle:NSLocalizedString(@"c_quit_take_photo", nil) forState:UIControlStateNormal];
    cancelButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [cancelButton addTarget:self action:@selector(cancle) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:cancelButton];
    
    cancelButton.sd_layout
    .leftSpaceToView(_bottomView,0)
    .centerYEqualToView(_PhotoButton)
    .widthIs(100)
    .heightIs(100);
    
    
    self.orangePhoto = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.orangePhoto setTitle:NSLocalizedString(@"c_take_orange_photo", nil) forState:UIControlStateNormal];
    [self.orangePhoto setImage:[UIImage imageNamed:@"normal_pictrue"] forState:UIControlStateNormal];
    [self.orangePhoto setImage:[UIImage imageNamed:@"orange_pictrue"] forState:UIControlStateSelected];
    
    [self.orangePhoto setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, -5)];
    [self.orangePhoto setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 5)];
    [self.orangePhoto addTarget:self action:@selector(isUseOrangePhoto:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:self.orangePhoto];
    
    self.orangePhoto.selected = isOrangePhoto();
    
    UILabel *orangeTip = [[UILabel alloc]init];
    orangeTip.font = [UIFont boldSystemFontOfSize:13];
    orangeTip.textColor = ColorFromRGB(0xcccccc);
    orangeTip.text = NSLocalizedString(@"c_take_muti_photo", nil);
    orangeTip.textAlignment = NSTextAlignmentRight;
    [_bottomView addSubview:orangeTip];
    
    orangeTip.sd_layout
    .rightSpaceToView(_bottomView,15)
    .topSpaceToView(self.orangePhoto,-5)
    .widthIs(120)
    .autoHeightRatio(0);
    
    

    self.orangePhoto.sd_layout
    .rightSpaceToView(_bottomView,15)
    .centerYEqualToView(_bottomView)
    .heightIs(40)
    .widthIs(80);
  
    
    _focusView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
    _focusView.layer.borderWidth = 1.0;
    _focusView.layer.borderColor =[UIColor customYellowColor].CGColor;
    _focusView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_focusView];
    _focusView.hidden = YES;
    //关闭闪光灯
    _isflashOn = YES;
    [self FlashOn];
}

- (void)isUseOrangePhoto:(UIButton *)orangeButton{
    orangeButton.selected = !orangeButton.selected;
    [self setOrangePhotoSession:orangeButton.selected];
}

- (void)setOrangePhotoSession:(BOOL)isOrange{
    
    [UIView animateWithDuration:0.25 animations:^{
        if (isOrange) {
            if ([self.session canSetSessionPreset:AVCaptureSessionPresetPhoto]) {
                self.session.sessionPreset = AVCaptureSessionPresetPhoto;
            }
        }else{
            if ([self.session canSetSessionPreset:AVCaptureSessionPresetHigh]) {
                self.session.sessionPreset = AVCaptureSessionPresetHigh;
            }
        }
    } completion:^(BOOL finished) {
        save_isOrangePhoto(isOrange);
    }];
}

#pragma mark ----------> 闪光灯

- (void)FlashOn{
    if ([_device lockForConfiguration:nil]) {
        if (_isflashOn) {
            if ([_device isFlashModeSupported:AVCaptureFlashModeOff]) {
                [_device setFlashMode:AVCaptureFlashModeOff];
                _isflashOn = NO;
            }
        }else{
            if ([_device isFlashModeSupported:AVCaptureFlashModeOn]) {
                [_device setFlashMode:AVCaptureFlashModeOn];
                _isflashOn = YES;
            }
        }
        [_device unlockForConfiguration];
    }
}

#pragma mark ----------> 对焦

- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for ( AVCaptureDevice *device in devices )
        if ( device.position == position ) return device;
    return nil;
}

- (void)focusGesture:(UITapGestureRecognizer*)gesture{
    
    CGPoint point = [gesture locationInView:gesture.view];
    if (point.y > SYSTEM_HEIGHT - 160 || point.y < 60) {
        return;
    }
    [self focusAtPoint:point];
}

- (void)focusAtPoint:(CGPoint)point{
    CGSize size = self.view.bounds.size;
    CGPoint focusPoint = CGPointMake( point.y /size.height ,1-point.x/size.width );
    NSError *error;
    if ([self.device lockForConfiguration:&error]) {
        
        if ([self.device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
            [self.device setFocusPointOfInterest:focusPoint];
            [self.device setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
        }
        
        if ([self.device isExposureModeSupported:AVCaptureExposureModeAutoExpose ]) {
            [self.device setExposurePointOfInterest:focusPoint];
            [self.device setExposureMode:AVCaptureExposureModeAutoExpose];
        }
        
        [self.device unlockForConfiguration];
        _focusView.center = point;
        _focusView.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            _focusView.transform = CGAffineTransformMakeScale(1.25, 1.25);
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 animations:^{
                _focusView.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                _focusView.hidden = YES;
            }];
        }];
    }
}


#pragma mark ---------> 横竖屏照片
- (void)getCompass{
    CMMotionManager *motionManager = [[CMMotionManager alloc] init];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    // 加速计
    CCWeakSelf(self);
    if (motionManager.accelerometerAvailable) {
        motionManager.accelerometerUpdateInterval = 1;
        [motionManager startDeviceMotionUpdatesToQueue:queue withHandler:^(CMDeviceMotion * __nullable motion, NSError * __nullable error) {
            if (error) {
                [motionManager stopAccelerometerUpdates];
                NSLog(@"error");
            } else {
                weakself.motion = motion;
            }
        }];
    }
}

- (AVCaptureVideoOrientation)handleDeviceMotion:(CMDeviceMotion *)deviceMotion{
    double x = deviceMotion.gravity.x;
    double y = deviceMotion.gravity.y;
    if (fabs(y) >= fabs(x))
    {
        if (y >= 0){
            NSLog(@"屏幕直立，上下顛倒");
            return AVCaptureVideoOrientationPortraitUpsideDown;
        }
        else{
            NSLog(@"屏幕直立");
            return AVCaptureVideoOrientationPortrait;
        }
    }
    else
    {
        if (x >= 0){
            NSLog(@"屏幕向右橫置");
            return AVCaptureVideoOrientationLandscapeLeft;
        }
        else{
            NSLog(@"屏幕向左横置");
            return AVCaptureVideoOrientationLandscapeRight;
        }
    }
}

#pragma mark  ---------->  截取照片
- (void)shutterCamera{
    
    if (!self.PhotoButton.enabled) {
        return;
    }
    if (_currentPhotoCount >= _maxPhotoCount) {
        toast_showInfoMsg(NSLocalizedString(@"q_reached_max_photos", nil), 200);
        return;
    }
    
    AVCaptureConnection * videoConnection = [self.ImageOutPut connectionWithMediaType:AVMediaTypeVideo];
    videoConnection.videoOrientation = [self handleDeviceMotion:_motion];
    if (!videoConnection) {
        NSLog(@"take photo failed!");
        return;
    }
    
    self.bottomView.userInteractionEnabled = NO;
    self.PhotoButton.enabled = NO;
    CCWeakSelf(self);
    
    [self.ImageOutPut captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        
        if (imageDataSampleBuffer == NULL) {
            return;
        }
        NSData * imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        UIImage *orangeImage = [UIImage imageWithData:imageData];
        NSLog(@"ImageSize---------> x:%f y:%f", orangeImage.size.width,orangeImage.size.height);
        [weakself zipPhotoWithImage:orangeImage andOrangeImageData:imageData];
    }];
}

- (void)zipPhotoWithImage:(UIImage *)orangeImage andOrangeImageData:(NSData*)orangeImageData{
    
    NSString* fileName=[NSString stringWithFormat:@"ios_image_%@%ld.jpg", accessToken(),
                        (long)[[NSDate  date] timeIntervalSince1970]];
    NSLog(@"压缩前--------->%ld", (unsigned long)orangeImageData.length);
    if (saveOrginImg(orangeImageData, fileName)) {
        NSLog(@"压缩后--------->%ld", (unsigned long)orangeImageData.length);
//        [self saveImageToPhotoAlbum:orangeImage];
        [self takePhotoSucceed:fileName];
    }else{
        toast_showInfoMsg(NSLocalizedString(@"w_photo_save_failed", nil), 200);
    }
}

#pragma mark --------> 单个拍照成功回调
- (void)takePhotoSucceed:(NSString *)fileName{
    
    if (self.photoCallBack) {
        self.photoCallBack(fileName);
    }
    _currentPhotoCount ++;
    
    if (_currentPhotoCount >= _maxPhotoCount) {
        toast_showInfoMsg(NSLocalizedString(@"q_reached_max_photos", nil), 200);
        [self cancle];
        return;
    }
    
    [self reStartCamera];
}

- (void)reStartCamera{
    
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
    [UIView animateWithDuration:0.25 animations:^{
        self.imageView.alpha = 0;
    }completion:^(BOOL finished) {
        [self.imageView removeFromSuperview];
        
        self.bottomView.userInteractionEnabled = YES;
        self.PhotoButton.enabled = YES;
        [self autoFoucus];
    }];
}


//#pragma ----------> 保存至相册
//- (void)saveImageToPhotoAlbum:(UIImage*)savedImage{
//#if AGILEPOPS_VERSION
//    [self.assetsLibrary saveImage:savedImage toAlbum:@"顺手赚钱" completion:^(NSURL *assetURL, NSError *error) {
//        NSLog(@"%@",assetURL);
//    } failure:^(NSError *error) {
//        NSLog(@"%@",error.localizedDescription);
//    }];
//#else
//    [self.assetsLibrary saveImage:savedImage toAlbum:@"AgilePOPs" completion:^(NSURL *assetURL, NSError *error) {
//        NSLog(@"%@",assetURL);
//    } failure:^(NSError *error) {
//        NSLog(@"%@",error.localizedDescription);
//    }];
//#endif
//}

#pragma mark ----------> 其他

- (void)cancle{
    [_autoFoucusTimer invalidate];
    _autoFoucusTimer = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc{
    [_autoFoucusTimer invalidate];
    _autoFoucusTimer = nil;
}

#pragma mark - Custom Getter

- (ALAssetsLibrary *)assetsLibrary
{
    if (assetsLibrary_) {
        return assetsLibrary_;
    }
    assetsLibrary_ = [[ALAssetsLibrary alloc] init];
    return assetsLibrary_;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    assetsLibrary_ = nil;
}
// 支持横竖屏显示
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end
