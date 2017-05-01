//
//  ZKVideoRecordViewController.m
//  ZKStreamMediaUtil
//
//  Created by ZK on 2017/5/1.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import "ZKVideoRecordViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import <GPUImage/GPUImage.h>
#import "GPUImageBeautifyFilter.h"

@interface ZKVideoRecordViewController ()

@property (nonatomic, strong) GPUImageVideoCamera *videoCamera;
@property (nonatomic, strong) GPUImageOutput <GPUImageInput> *filter;
@property (nonatomic, strong) GPUImageMovieWriter *movieWriter;
@property (nonatomic, strong) GPUImageView *filterView;
@property (nonatomic, strong) UIButton *recordBtn;
@property (nonatomic, strong) UIButton *rotateBtn;

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
        make.left.mas_equalTo(20);
        make.size.mas_equalTo(CGSizeMake(100, 30));
    }];
    [_recordBtn addTarget:self action:@selector(recordBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _rotateBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [_rotateBtn setTitle:@"旋转摄像头" forState:UIControlStateNormal];
    [self.view addSubview:_rotateBtn];
    [_rotateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_recordBtn.mas_bottom).offset(10);
        make.left.mas_equalTo(20);
        make.size.mas_equalTo(CGSizeMake(100, 30));
    }];
    [_rotateBtn addTarget:self action:@selector(rotateBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupVideoCamera {
    _videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPresetHigh cameraPosition:AVCaptureDevicePositionFront];
    _videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    _videoCamera.horizontallyMirrorFrontFacingCamera = true;
    
    _filter = [[GPUImageBeautifyFilter alloc] init];
    _filterView = [[GPUImageView alloc] init];
    [self.view insertSubview:_filterView atIndex:0];
    _filterView.frame = self.view.bounds;
    
    [_videoCamera addTarget:_filter];
    [_filter addTarget:_filterView];
    [_videoCamera startCameraCapture];
}

- (void)rotateBtnClick {
    [_videoCamera rotateCamera];
}

- (void)recordBtnClick:(UIButton *)btn {
    btn.selected = !btn.selected;
    
    NSString *moviePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Movie4.mp4"];
    NSURL *movieURL = [NSURL fileURLWithPath:moviePath];
    
    if (btn.selected) {
        unlink([moviePath UTF8String]);
        _movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:self.view.bounds.size];
        // 对视频进行编码，否则会非常大
        _movieWriter.encodingLiveVideo = true;
        [_filter addTarget:_movieWriter];
        _videoCamera.audioEncodingTarget = _movieWriter;
        [_movieWriter startRecording];
    }
    else {
        [_filter removeTarget:_movieWriter];
        _videoCamera.audioEncodingTarget = nil;
        [_movieWriter finishRecording];
        [self writeVideoToLibraryWithPath:moviePath];
    }
}

- (void)writeVideoToLibraryWithPath:(NSString *)moviePath {
    
    NSURL *movieURL = [NSURL fileURLWithPath:moviePath];
    
    if ([UIDevice currentDevice].systemVersion.floatValue < 9) {
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(moviePath)) {
            [library writeVideoAtPathToSavedPhotosAlbum:movieURL completionBlock:^(NSURL *assetURL, NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSString *msg = @"";
                    if (error) {
                        msg = @"视频保存失败";
                    } else {
                        msg = @"视频保存成功";
                    }
                    UIAlertView *alert =
                    [[UIAlertView alloc] initWithTitle:msg message:nil
                                              delegate:self
                                     cancelButtonTitle:@"OK"
                                     otherButtonTitles:nil];
                    [alert show];
                });
            }];
        }
    }
    else {
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:movieURL];
        } completionHandler:^(BOOL success, NSError *error) {
            NSString *msg = @"";
            if (!success) {
                msg = @"保存失败";
            }
            else {
                msg = @"保存成功";
            }
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alertController animated:true completion:nil];
        }];
    }
}

@end
