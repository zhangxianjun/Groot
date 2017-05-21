//
//  GPUViewController.m
//  Groot
//
//  Created by ZXJ on 2017/5/21.
//  Copyright © 2017年 maodenden. All rights reserved.
//

#import "GPUViewController.h"
#import <GPUImage.h>

@interface GPUViewController ()
@property (nonatomic, strong) GPUImageVideoCamera *videoCamera;
@end

@implementation GPUViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setupCamera {
    self.videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPresetHigh cameraPosition:AVCaptureDevicePositionFront];
    self.videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    self.videoCamera.horizontallyMirrorFrontFacingCamera = YES;
    
    GPUImageView *imageView = [[GPUImageView alloc] initWithFrame:self.view.bounds];
    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view insertSubview:imageView atIndex:0];
    
    // 创建滤镜：磨皮，美白，组合滤镜
    GPUImageFilterGroup *groupFilter = [[GPUImageFilterGroup alloc] init];

    GPUImageBilateralFilter *bilateraFilter = [[GPUImageBilateralFilter alloc] init];
    [groupFilter addTarget:bilateraFilter];
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
