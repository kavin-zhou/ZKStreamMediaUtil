//
//  ZKLocalAudioPlayer.h
//  ZKStreamMediaUtil
//
//  Created by ZK on 2017/5/1.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface ZKLocalAudioPlayer : NSObject

+ (instancetype)shareInstance;

- (AVAudioPlayer *)playAudioWithPath:(NSString *)audioPath;

- (void)resumeCurrentAudio;

- (void)pauseCurrentAudio;

- (void)stopCurrentAudio;

@property (nonatomic, assign) CGFloat volumn;

@property (nonatomic, assign, readonly) CGFloat progress;

@end
