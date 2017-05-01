//
//  ZKAudioEditTool.h
//  ZKStreamMediaUtil
//
//  Created by ZK on 2017/5/1.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZKAudioEditTool : NSObject

+ (void)addAudio:(NSString *)fromPath toAudio:(NSString *)toPath outputPath:(NSString *)outputPath;

+ (void)cutAudio:(NSString *)audioPath fromTime:(NSTimeInterval)fromTime toTime:(NSTimeInterval)toTime outputPath:(NSString *)outputPath;

@end
