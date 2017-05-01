//
//  ZKVideoRecordViewController.m
//  ZKStreamMediaUtil
//
//  Created by ZK on 2017/5/1.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import "ZKVideoRecordViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <GPUImage/GPUImage.h>
#import "GPUImageBeautifyFilter.h"

@interface ZKVideoRecordViewController ()

@property (nonatomic, strong) GPUImageVideoCamera *videoCamera;
@property (nonatomic, strong) GPUImageOutput <GPUImageInput> *filter;
@property (nonatomic, strong) GPUImageMovieWriter *movieWriter;
@property (nonatomic, strong) GPUImageView *filterView;
@property (nonatomic, strong) UIButton *recordBtn;

@end

@implementation ZKVideoRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
    [self setupVideoCamera];
}

- (void)setupUI {
    _recordBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [_recordBtn setTitle:@"开始录制" forState:UIControlStateNormal];
    [_recordBtn setTitle:@"结束录制" forState:UIControlStateSelected];
    [self.view addSubview:_recordBtn];
    
    [_recordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(100);
        make.right.mas_equalTo(20);
        make.size.mas_equalTo(CGSizeMake(100, 30));
    }];
    [_recordBtn addTarget:self action:@selector(recordBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupVideoCamera {
    _videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPresetHigh cameraPosition:AVCaptureDevicePositionFront];
    _videoCamera.outputImageOrientation = [UIApplication sharedApplication].statusBarOrientation;
    
    _filter = [[GPUImageBeautifyFilter alloc] init];
    _filterView = [[GPUImageView alloc] init];
    [self.view insertSubview:_filterView atIndex:0];
    _filterView.frame = self.view.bounds;
    
    [_videoCamera addTarget:_filter];
    [_filter addTarget:_filterView];
    [_videoCamera startCameraCapture];
}

- (void)recordBtnClick:(UIButton *)btn {
    btn.selected = !btn.selected;
    
    NSString *pathToMovie = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Movie4.mp4"];
    NSURL *movieURL = [NSURL fileURLWithPath:pathToMovie];
    
    if (btn.selected) {
        unlink([pathToMovie UTF8String]);
        _movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:CGSizeMake(480.0, 640.0)];
        _movieWriter.encodingLiveVideo = true;
        [_filter addTarget:_movieWriter];
        _videoCamera.audioEncodingTarget = _movieWriter;
        [_movieWriter startRecording];
    }
    else {
        [_filter removeTarget:_movieWriter];
        _videoCamera.audioEncodingTarget = nil;
        [_movieWriter finishRecording];
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(pathToMovie))
        {
            [library writeVideoAtPathToSavedPhotosAlbum:movieURL completionBlock:^(NSURL *assetURL, NSError *error)
             {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     
                     if (error) {
                         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"视频保存失败" message:nil
                                                                        delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                         [alert show];
                     } else {
                         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"视频保存成功" message:nil
                                                                        delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                         [alert show];
                     }
                 });
             }];
        }
    }
}

@end
