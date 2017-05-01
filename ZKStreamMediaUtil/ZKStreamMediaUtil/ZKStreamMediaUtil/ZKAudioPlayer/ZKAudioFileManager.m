//
//  ZKAudioFileManager.m
//  ZKStreamMediaUtil
//
//  Created by ZK on 2017/4/30.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import "ZKAudioFileManager.h"
#import "ZKFileTool.h"
#import <MobileCoreServices/MobileCoreServices.h>

#define CacheDirPath NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, true).firstObject
#define TempPath     NSTemporaryDirectory()

@implementation ZKAudioFileManager

+ (NSString *)cacaheFilePathWithUrl:(NSURL *)url {
    return [CacheDirPath stringByAppendingPathComponent:url.lastPathComponent];
}

+ (BOOL)cacheFileExists:(NSURL *)url {
    NSString *path = [self cacaheFilePathWithUrl:url];
    return [ZKFileTool fileExists:path];
}

+ (long long)cacheFileSize:(NSURL *)url {
    NSString *path = [self cacaheFilePathWithUrl:url];
    if (![ZKFileTool fileExists:path]) {
        return 0;
    }
    return [ZKFileTool fileSize:path];
}

+ (NSString *)contentTypeWithUrl:(NSURL *)url {
    NSString *path = [self cacaheFilePathWithUrl:url];
    NSString *fileExtension = path.pathExtension;
    
    CFStringRef contentType_CF = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef _Nonnull)(fileExtension), NULL);
    NSString *contentType = CFBridgingRelease(contentType_CF);
    return contentType;
}

+ (NSString *)tempFilePathWithUrl:(NSURL *)url {
    return [TempPath stringByAppendingPathComponent:url.lastPathComponent];
}

+ (long long)tempFileSize:(NSURL *)url {
    NSString *path = [self tempFilePathWithUrl:url];
    if (![ZKFileTool fileExists:path]) {
        return 0;
    }
    return [ZKFileTool fileSize:path];
}

+ (void)moveTempFileToCacheWithUrl:(NSURL *)url {
    NSString *tempPath = [self tempFilePathWithUrl:url];
    NSString *cachePath = [self cacaheFilePathWithUrl:url];
    [ZKFileTool moveFile:tempPath toPath:cachePath];
}

+ (void)clearTempFile:(NSURL *)url{
    NSString *tempPath = [self tempFilePathWithUrl:url];
    
    BOOL isDir = true;
    BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:tempPath isDirectory:&isDir];
    if (exists && !isDir) {
        [ZKFileTool removePath:tempPath];
    }
}

@end
