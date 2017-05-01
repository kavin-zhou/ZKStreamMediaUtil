//
//  ZKAudioRecorder.h
//  ZKStreamMediaUtil
//
//  Created by ZK on 2017/5/1.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZKAudioRecorder : NSObject

- (void)startRecordWithRecordPath:(NSString *)recordPath;
- (void)endRecord;
- (void)pauseRecord;
- (void)deleteRecord;
- (void)restartRecord;

/**
 *  录音文件路径
 */
@property (nonatomic, copy, readonly) NSString *recordPath;
- (void)updateMeters;
- (float)peakPowerForChannel0;

@end
