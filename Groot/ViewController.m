//
//  ViewController.m
//  Groot
//
//  Created by ZXJ on 2017/5/13.
//  Copyright © 2017年 maodenden. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <GPUImage/GPUImage.h>
#import <GLKit/GLKit.h>
#import "Define.h"


@interface ViewController ()<AVCaptureVideoDataOutputSampleBufferDelegate>
@property (nonatomic, strong) UIView *videoView;
@property (nonatomic, strong) UIButton *startButton;
@property (nonatomic, strong) UIButton *turnButton;

@property (nonatomic, assign) BOOL isFrontCamera;

// 中转器
@property (nonatomic, strong) AVCaptureSession *captureSession;

// 输出屏幕
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

@property (nonatomic, strong) UIImageView *previewImageView;

// --------------------------------GPU------------------------------------------
@property (nonatomic, strong) GPUImageVideoCamera *videoCamera;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.previewImageView];
    
//    CGAffineTransform transform = CGAffineTransformIdentity;
//    self.previewImageView.transform = CGAffineTransformRotate(transform, M_PI_2);
    [self test];
    
    // 获取滤镜
//    NSArray *array = [CIFilter filterNamesInCategories:kCICategoryVideo];
    
//    GLKView *view = 
}

- (void)gpu {
    self.videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPresetHigh cameraPosition:AVCaptureDevicePositionFront];
    self.videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    self.videoCamera.horizontallyMirrorFrontFacingCamera = YES;
    
    GPUImageView *imageView = [[GPUImageView alloc] initWithFrame:self.view.bounds];
    
    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view insertSubview:imageView atIndex:0];
    
    // 创建滤镜：磨皮，美白，组合滤镜
    GPUImageFilterGroup *groupFilter = [[GPUImageFilterGroup alloc] init];
    
    // 磨皮滤镜
    GPUImageBilateralFilter *bilateraFilter = [[GPUImageBilateralFilter alloc] init];
    [groupFilter addTarget:bilateraFilter];
    
    // 美白滤镜
    GPUImageBrightnessFilter *brightnessFilter = [[GPUImageBrightnessFilter alloc] init];
    [groupFilter addTarget:brightnessFilter];
    
    // 设置滤镜组链
    [bilateraFilter addTarget:brightnessFilter];
    [groupFilter setInitialFilters:@[bilateraFilter]];
    groupFilter.terminalFilter = brightnessFilter;
    
    // 设置GPUImage的响应链， 从数据源 ==> 滤镜 ==> 最终界面效果
    [self.videoCamera addTarget:groupFilter];
    [groupFilter addTarget:imageView];
    
    // 必须采用startCameraCapture, 底层才会把采集到的视频源，渲染到GPUImageView中，就能显示了。
    [self.videoCamera startCameraCapture];
}

- (void)test {
    
    [self.view addSubview:self.videoView];
    
    self.captureSession = [[AVCaptureSession alloc] init];
    self.captureSession.sessionPreset = AVCaptureSessionPreset1280x720;
    
    AVCaptureDevice *captureDevice = nil;
    AVCaptureDeviceInput *captureDeviceInput = nil;
    
    captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    NSError *error;
    
    captureDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    
    if ([self.captureSession canAddInput:captureDeviceInput]) {
        [self.captureSession addInput:captureDeviceInput];
    }
    
    AVCaptureVideoDataOutput *output = [[AVCaptureVideoDataOutput alloc] init];
    output.videoSettings = @{(NSString *)kCVPixelBufferPixelFormatTypeKey:@(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)};
    output.minFrameDuration = CMTimeMake(1, 24);
    
    dispatch_queue_t queue = dispatch_queue_create("SERIAL", DISPATCH_QUEUE_SERIAL);
    
    [output setSampleBufferDelegate:self queue:queue];
    
    if ([self.captureSession  canAddOutput:output]) {
        [self.captureSession  addOutput:output];
    }
    [self.captureSession startRunning];
    
    AVCaptureConnection *connect = [output connectionWithMediaType:AVMediaTypeVideo];
    connect.videoOrientation = AVCaptureVideoOrientationPortrait;
    connect.automaticallyAdjustsVideoMirroring = NO;
    connect.videoMirrored = YES;
    
    [self.view addSubview:self.startButton];
    [self.view addSubview:self.turnButton];
}

//- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
//    CMTime time = CMSampleBufferGetDuration(sampleBuffer);
//    CVImageBufferRef image = CMSampleBufferGetImageBuffer(sampleBuffer);
//    CIImage *cImage = [[CIImage alloc] initWithCVImageBuffer:image];
//    UIImage *img = [[UIImage alloc] initWithCIImage:cImage];
//    
//    CIFilter *filter = [CIFilter filterWithName:@""];
//    [filter setValue:cImage forKey:@"inputImage"];
//    cImage = filter.outputImage;
//    
//    dispatch_sync(dispatch_get_main_queue(), ^{
//        self.previewImageView.image = img;
//    });
//}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    CVImageBufferRef image = CMSampleBufferGetImageBuffer(sampleBuffer);
    CIImage *cImage = [[CIImage alloc] initWithCVImageBuffer:image];
    
    EAGLContext *context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    CIContext *cContext = [CIContext contextWithEAGLContext:context];
    
    // create copy retain
    CGImageRef ref = [cContext createCGImage:cImage fromRect:cImage.extent];
    
    UIImage *img = [UIImage imageWithCGImage:ref];
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        self.previewImageView.image = img;
        
        // 主动释放内存
        CGImageRelease(ref);
    });
}

- (IBAction)startButtonClicked:(UIButton *)sender {
    if (self.captureSession.isRunning) {
        [self.captureSession stopRunning];
        [_startButton setTitle:@"开始" forState:UIControlStateNormal];
    }
    else {
        [self.captureSession startRunning];
        [_startButton setTitle:@"结束" forState:UIControlStateNormal];
    }
}

- (IBAction)turnButtonClicked:(UIButton *)sender {
    AVCaptureDevicePosition desiredPosition;
    if (self.isFrontCamera)
        desiredPosition = AVCaptureDevicePositionBack;
    else
        desiredPosition = AVCaptureDevicePositionFront;
    
    for (AVCaptureDevice *d in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo]) {
        if ([d position] == desiredPosition) {
            [[self.previewLayer session] beginConfiguration];
            AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:d error:nil];
            for (AVCaptureInput *oldInput in [[self.previewLayer session] inputs]) {
                [[self.previewLayer session] removeInput:oldInput];
            }
            [[self.previewLayer session] addInput:input];
            [[self.previewLayer session] commitConfiguration];
            break;
        }
    }
    self.isFrontCamera = !self.isFrontCamera;
}


// 选择摄像头 //
- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)positon {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    
    for (AVCaptureDevice *device in devices) {
        if (device.position == positon) {
            NSLog(@"----------------%@", device);
            return device;
        }
    }
    return nil;
}

#pragma mark - 懒加载
- (UIView *)videoView {
    if (_videoView == nil) {
        _videoView = [[UIView alloc] initWithFrame:UIScreen.mainScreen.bounds];
    }
    return _videoView;
}

- (UIButton *)startButton {
    if (_startButton == nil) {
        _startButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _startButton.frame = CGRectMake(0.5*(ZXJ_SW-44), ZXJ_SH - 64, 44, 44);
        _startButton.backgroundColor = [UIColor redColor];
        [_startButton addTarget:self action:@selector(startButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_startButton setTitle:@"开始" forState:UIControlStateNormal];
    }
    return _startButton;
}

- (UIButton *)turnButton {
    if (_turnButton == nil) {
        _turnButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _turnButton.frame = CGRectMake(ZXJ_SW-64, ZXJ_SH-64, 44, 44);
        _turnButton.backgroundColor = [UIColor redColor];
        [_turnButton addTarget:self action:@selector(turnButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_turnButton setTitle:@"翻转" forState:UIControlStateNormal];
    }
    return _turnButton;
}

- (UIImageView *)previewImageView {
    if (_previewImageView == nil) {
        CGFloat a = ZXJ_SH/2;
        CGFloat b = ZXJ_SW/2;
        
        CGFloat cx = ZXJ_SW/2;
        CGFloat cy = ZXJ_SH/2;
        
//        _previewImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-(a-cx), (cy-b), ZXJ_SH, ZXJ_SW)];
        _previewImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ZXJ_SH, ZXJ_SW)];
    }
    return _previewImageView;
}
@end
