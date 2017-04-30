//
//  ZKAudioPlayerViewController.m
//  ZKStreamMediaUtil
//
//  Created by ZK on 2017/4/30.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import "ZKAudioPlayerViewController.h"
#import "ZKAudioPlayer.h"

@interface ZKAudioPlayerViewController ()
@property (weak, nonatomic) IBOutlet UIProgressView *loadProgress;
@property (weak, nonatomic) IBOutlet UILabel *playTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;

@end

@implementation ZKAudioPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Action

- (IBAction)play {
    NSURL *url = [NSURL URLWithString:@"http://op7sl7tu8.bkt.clouddn.com/08%20%E9%80%86%E9%B3%9E.m4a"];
    [[ZKAudioPlayer shareInstance] playWithUrl:url];
}

- (IBAction)resume {
    [[ZKAudioPlayer shareInstance] resume];
}

- (IBAction)pause {
    [[ZKAudioPlayer shareInstance] pause];
}

- (IBAction)rate {
    [[ZKAudioPlayer shareInstance] setRate:2.f];
}

- (IBAction)seekProgress:(UISlider *)sender {
    [[ZKAudioPlayer shareInstance] seekToProgress:sender.value];
}

- (IBAction)muted:(UIButton *)btn {
    btn.selected = !btn.selected;
    [[ZKAudioPlayer shareInstance] setMuted:btn.selected];
}

- (IBAction)volume:(UISlider *)sender {
    [[ZKAudioPlayer shareInstance] setVolume:sender.value];
}

- (IBAction)forward:(UIButton *)sender {
    [[ZKAudioPlayer shareInstance] seekWithTimeDiffer:20];
}

@end
