//
//  ZKAudioPlayer.h
//  ZKStreamMediaUtil
//
//  Created by ZK on 2017/4/30.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZKAudioPlayer : NSObject

+ (instancetype)shareInstance;

- (void)playWithUrl:(NSURL *)url;
- (void)pause;
- (void)resume;
- (void)stop;
- (void)seekWithTimeDiffer:(NSTimeInterval)timeDiffer;
- (void)seekToProgress:(CGFloat)progress;
- (void)setRate:(CGFloat)rate;
- (void)setMuted:(BOOL)muted;
- (void)setVolume:(CGFloat)volume;

@end
