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

@end
