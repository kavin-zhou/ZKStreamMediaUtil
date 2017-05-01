//
//  ZKLocalAudioPlayer.m
//  ZKStreamMediaUtil
//
//  Created by ZK on 2017/5/1.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import "ZKLocalAudioPlayer.h"

@interface ZKLocalAudioPlayer ()

@property (nonatomic ,strong) AVAudioPlayer *player;

@end

@implementation ZKLocalAudioPlayer

+ (instancetype)shareInstance {
    static ZKLocalAudioPlayer *shareInstance_;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance_ = [ZKLocalAudioPlayer new];
    });
    return shareInstance_;
}

- (AVAudioPlayer *)playAudioWith:(NSString *)audioPath {
    NSURL *url = [NSURL URLWithString:audioPath];
    if (!url) {
        url = [[NSBundle mainBundle] URLForResource:audioPath.lastPathComponent withExtension:nil];
    }
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    [self.player prepareToPlay];
    [self.player play];
    return self.player;
}

- (void)resumeCurrentAudio {
    if (!_player) return;
    [self.player play];
}

- (void)pauseCurrentAudio {
    if (!_player) return;
    [self.player pause];
}

- (void)stopCurrentAudio {
    if (!_player) return;
    [self.player stop];
}

- (void)setVolumn:(CGFloat)volumn {
    if (!_player) return;
    self.player.volume = volumn;
}

- (CGFloat)volumn {
    if (!_player) return .5;
    return self.player.volume;
}

- (CGFloat)progress {
    if (!_player) return .5;
    return self.player.currentTime / self.player.duration;
}

@end
