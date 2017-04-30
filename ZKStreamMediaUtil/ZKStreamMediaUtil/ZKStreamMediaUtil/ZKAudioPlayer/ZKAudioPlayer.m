//
//  ZKAudioPlayer.m
//  ZKStreamMediaUtil
//
//  Created by ZK on 2017/4/30.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import "ZKAudioPlayer.h"
#import <AVFoundation/AVFoundation.h>

@interface ZKAudioPlayer ()

@property (nonatomic, strong) AVPlayer *player;

@end

@implementation ZKAudioPlayer

+ (instancetype)shareInstance {
    static ZKAudioPlayer *shareInstance_;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance_ = [ZKAudioPlayer new];
    });
    return shareInstance_;
}

- (void)playWithUrl:(NSURL *)url {
    _currentUrl = url;
    
    AVURLAsset *asset = [AVURLAsset assetWithURL:url];
    // 资源组织者
    AVPlayerItem *item = [AVPlayerItem playerItemWithAsset:asset];
    
    [item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    
    _player = [AVPlayer playerWithPlayerItem:item];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerStatus status = [change[NSKeyValueChangeNewKey] integerValue];
        if (status == AVPlayerItemStatusReadyToPlay) {
            NSLog(@"资源准备完成，可以播放");
            [_player play];
        }
        else {
            NSLog(@"出错");
        }
    }
}

- (void)pause {
    [_player pause];
}

- (void)resume {
    [_player play];
}

- (void)stop {
    [_player pause];
    self.player = nil;
}

- (void)seekWithTimeDiffer:(NSTimeInterval)timeDiffer {
    NSTimeInterval totalTime_NS = [self totalTime];
    NSTimeInterval playTime_NS = [self currentTime];
    playTime_NS += timeDiffer;
    
    [self seekToProgress:playTime_NS / totalTime_NS];
}

- (void)seekToProgress:(CGFloat)progress {
    
    if (progress < 0 || progress > 1) {
        NSLog(@"progress 不合法");
        return;
    }
    
    NSTimeInterval totlaTime_NS = [self totalTime];
    NSTimeInterval playTime_NS = totlaTime_NS * progress;
    CMTime playTime_CM = CMTimeMake(playTime_NS, 1);
    
    // 指定时间节点播放，CMATime是影片时间
    [_player seekToTime:playTime_CM completionHandler:^(BOOL finished) {
        if (finished) {
            NSLog(@"确定加载这个时间点的资源");
        }
        else {
            // 当用户连续多次拖动的时候，之前的就会取消
            NSLog(@"取消加载这个时间点的资源");
        }
    }];
}

- (void)setRate:(CGFloat)rate {
    [_player setRate:rate];
}

- (CGFloat)rate {
    return _player.rate;
}

- (void)setMuted:(BOOL)muted {
    [_player setMuted:muted];
}

- (BOOL)muted {
    return _player.muted;
}

- (void)setVolume:(CGFloat)volume {
    if (volume < 0 || volume > 1) {
        return;
    }
    [self setMuted:volume > 0];
    [_player setVolume:volume];
}

- (CGFloat)volume {
    return _player.volume;
}

- (NSTimeInterval)totalTime {
    CMTime totalTime_CM = _player.currentItem.duration;
    NSTimeInterval totalTime_NS = CMTimeGetSeconds(totalTime_CM);
    return totalTime_NS;
}

- (NSTimeInterval)currentTime{
    CMTime playTime_CM = _player.currentItem.currentTime;
    NSTimeInterval playTime_NS = CMTimeGetSeconds(playTime_CM);
    return playTime_NS;
}

- (CGFloat)progress {
    return self.currentTime / self.totalTime;
}

- (CGFloat)loadDataProgress {
    CMTimeRange timeRange = [[_player.currentItem loadedTimeRanges].lastObject CMTimeRangeValue];
    CMTime loadTime_CM = CMTimeAdd(timeRange.start, timeRange.duration);
    NSTimeInterval loadTime_NS = CMTimeGetSeconds(loadTime_CM);
    
    return loadTime_NS / self.totalTime;
}

- (NSString *)currentTimeFormat {
    NSString *currentTimeStr = [NSString stringWithFormat:@"%02zd:%02zd", (int)self.currentTime / 60, (int)self.currentTime % 60];
    return currentTimeStr;
}

- (NSString *)totalTimeFormat {
    NSString *totalTimeStr = [NSString stringWithFormat:@"%02zd:%02zd", (int)self.totalTime / 60, (int)self.totalTime % 60];
    return totalTimeStr;
}

@end
