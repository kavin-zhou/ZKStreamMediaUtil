//
//  ZKAudioFileManager.h
//  ZKStreamMediaUtil
//
//  Created by ZK on 2017/4/30.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZKAudioFileManager : NSObject

+ (NSString *)cacheFilePathWithUrl:(NSURL *)url;
+ (BOOL)cacheFileExists:(NSURL *)url;
+ (long long)cacheFileSize:(NSURL *)url;

+ (NSString *)tempFilePathWithUrl:(NSURL *)url;
+ (long long)tempFileSize:(NSURL *)url;

+ (NSString *)contentTypeWithUrl:(NSURL *)url;
+ (void)moveTempFileToCacheWithUrl:(NSURL *)url;

+ (void)clearTempFile:(NSURL *)url;

@end
