//
//  ZKDownloader.m
//  ZKStreamMediaUtil
//
//  Created by ZK on 2017/4/29.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import "ZKDownloader.h"
#import "ZKGlobalHeader.h"
#import "ZKFileTool.h"

@implementation ZKDownloader

+ (void)downloadWithUrl:(NSURL *)url {
    NSString *fileName = url.lastPathComponent;
    NSString *downloadedPath = [CachePath stringByAppendingPathComponent:fileName];
    NSString *downloadingPath = [TempPath stringByAppendingPathComponent:fileName];
    
    if ([ZKFileTool fileExists:downloadedPath]) {
        DLog(@"已经存在下载好的文件");
        return;
    }
    if (![ZKFileTool fileExists:downloadingPath]) {
        [self downloadWihUrl:url offset:0];
        return;
    }
    long long tempSize = [ZKFileTool fileSize:downloadingPath];
    
}

+ (void)downloadWihUrl:(NSURL *)url offset:(long long)offset {
    
}

@end
