//
//  ZKFileTool.m
//  ZKStreamMediaUtil
//
//  Created by ZK on 2017/4/29.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import "ZKFileTool.h"

@implementation ZKFileTool

+ (BOOL)fileExists:(NSString *)filePath {
    if (!filePath.length) {
        return false;
    }
    return [[NSFileManager defaultManager] fileExistsAtPath:filePath];
}
+ (long long)fileSize:(NSString *)filePath {
    
    if (![self fileExists:filePath]) {
        return 0;
    }
    
    NSDictionary *fileInfo = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
    return [fileInfo[NSFileSize] longLongValue];
}

+ (void)moveFile:(NSString *)fromPath toPath:(NSString *)toPath {
    if (![self fileExists:fromPath]) {
        NSLog(@"文件不存在");
        return;
    }
    [[NSFileManager defaultManager] moveItemAtPath:fromPath toPath:toPath error:nil];
}

+ (void)removePath:(NSString *)filePath {
    if (![self fileExists:filePath]) {
        NSLog(@"文件不存在");
        return;
    }
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
}

@end
