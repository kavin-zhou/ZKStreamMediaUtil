//
//  ZKAudioPlayer.h
//  ZKStreamMediaUtil
//
//  Created by ZK on 2017/4/30.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

typedef NS_ENUM(NSUInteger, ZKAudioState) {
    ZKAudioStateUnknown = 0,
    ZKAudioStateLoading,
    ZKAudioStatePlaying,
    ZKAudioStateStop,
    ZKAudioStatePause,
    ZKAudioStateFailed
};

@interface ZKAudioPlayer : NSObject

@property (nonatomic, assign, readonly) NSTimeInterval totalTime;
@property (nonatomic, copy, readonly) NSString *totalTimeFormat;
@property (nonatomic, assign, readonly) NSTimeInterval currentTime;
@property (nonatomic, copy, readonly) NSString *currentTimeFormat;

@property (nonatomic, assign, readonly) CGFloat progress;
@property (nonatomic, copy, readonly) NSURL *currentUrl;
@property (nonatomic, assign, readonly) CGFloat loadDataProgress;
@property (nonatomic, assign) BOOL muted;
@property (nonatomic, assign) CGFloat volume;
@property (nonatomic, assign) CGFloat rate;

@property (nonatomic, assign, readonly) ZKAudioState state;

+ (instancetype)shareInstance;

- (AVPlayer *)playWithUrl:(NSURL *)url; // 默认没有缓存数据到本地
- (AVPlayer *)playWithUrl:(NSURL *)url shouldCache:(BOOL)shouldCache;
- (void)pause;
- (void)resume;
- (void)stop;
- (void)seekWithTimeDiffer:(NSTimeInterval)timeDiffer;
- (void)seekToProgress:(CGFloat)progress;

@end
