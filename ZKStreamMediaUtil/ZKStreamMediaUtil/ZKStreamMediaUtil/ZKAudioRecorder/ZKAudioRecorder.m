//
//  ZKAudioRecorder.m
//  ZKStreamMediaUtil
//
//  Created by ZK on 2017/5/1.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import "ZKAudioRecorder.h"
#import <AVFoundation/AVFoundation.h>

@interface ZKAudioRecorder ()

@property (nonatomic, copy) NSString *recordPath;
@property (nonatomic, strong) AVAudioRecorder *audioRecorder;

@end

@implementation ZKAudioRecorder

#pragma mark - Lazy Loading

- (AVAudioRecorder *)audioRecorder {
    if (!_audioRecorder) {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        [[AVAudioSession sharedInstance] setActive:true error:nil];
        
        NSURL *url = [NSURL URLWithString:self.recordPath];
        NSMutableDictionary *recordSetting = [NSMutableDictionary dictionary];
        recordSetting[AVFormatIDKey] = @(kAudioFormatLinearPCM);
        recordSetting[AVSampleRateKey] = @(11025.0);
        recordSetting[AVNumberOfChannelsKey] = @(2);
        recordSetting[AVEncoderAudioQualityKey] = @(AVAudioQualityMin);
        
        _audioRecorder = [[AVAudioRecorder alloc] initWithURL:url settings:recordSetting error:nil];
        _audioRecorder.meteringEnabled = true;
    }
    return _audioRecorder;
}

- (void)updateMeters {
    [self.audioRecorder updateMeters];
}

- (void)startRecordWithRecordPath:(NSString *)recordPath {
    _recordPath = recordPath;
    [self.audioRecorder prepareToRecord];
    [self.audioRecorder record];
}

- (void)endRecord {
    [self.audioRecorder stop];
}

- (void)pauseRecord {
    [self.audioRecorder pause];
}

- (void)deleteRecord {
    [self.audioRecorder stop];
    [self.audioRecorder deleteRecording];
}

- (void)restartRecord {
    self.audioRecorder = nil;
    [self startRecordWithRecordPath:self.recordPath];
}

- (float)peakPowerForChannel0 {
    [self.audioRecorder updateMeters];
    return [self.audioRecorder peakPowerForChannel:0];
}

@end
