//
//  ZKAudioPlayerViewController.m
//  ZKStreamMediaUtil
//
//  Created by ZK on 2017/4/30.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import "ZKAudioPlayerViewController.h"
#import "ZKAudioPlayer.h"

#define AudioPlayer  [ZKAudioPlayer shareInstance]

@interface ZKAudioPlayerViewController ()

@property (weak, nonatomic) IBOutlet UIProgressView *loadProgress;
@property (weak, nonatomic) IBOutlet UILabel *playTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;
@property (weak, nonatomic) IBOutlet UISlider *playProgress;
@property (weak, nonatomic) IBOutlet UIButton *mutedBtn;
@property (weak, nonatomic) IBOutlet UISlider *volumeSlider;
@property (nonatomic, weak) NSTimer *timer;

@end

@implementation ZKAudioPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTimer];
}

- (void)setupTimer {
    NSTimer *timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(update) userInfo:nil repeats:true];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    _timer = timer;
}

- (void)update {
    _playTimeLabel.text = AudioPlayer.currentTimeFormat;
    _totalTimeLabel.text = AudioPlayer.totalTimeFormat;
    _playProgress.value = AudioPlayer.progress;
    _volumeSlider.value = AudioPlayer.volume;
    _loadProgress.progress = AudioPlayer.loadDataProgress;
    _mutedBtn.selected = AudioPlayer.muted;
}

#pragma mark - Action

- (IBAction)play {
    NSURL *url = [NSURL URLWithString:@"http://op7sl7tu8.bkt.clouddn.com/08%20%E9%80%86%E9%B3%9E.m4a"];
    [[ZKAudioPlayer shareInstance] playWithUrl:url];
}

- (IBAction)resume {
    [AudioPlayer resume];
}

- (IBAction)pause {
    [AudioPlayer pause];
}

- (IBAction)rate {
    [AudioPlayer setRate:2.f];
}

- (IBAction)seekProgress:(UISlider *)sender {
    [AudioPlayer seekToProgress:sender.value];
}

- (IBAction)muted:(UIButton *)btn {
    btn.selected = !btn.selected;
    [AudioPlayer setMuted:btn.selected];
}

- (IBAction)volume:(UISlider *)sender {
    [AudioPlayer setVolume:sender.value];
}

- (IBAction)forward:(UIButton *)sender {
    [AudioPlayer seekWithTimeDiffer:20];
}

@end
