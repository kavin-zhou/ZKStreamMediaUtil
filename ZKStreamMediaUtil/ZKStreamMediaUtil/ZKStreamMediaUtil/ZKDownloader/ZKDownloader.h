//
//  ZKDownloader.h
//  ZKStreamMediaUtil
//
//  Created by ZK on 2017/4/29.
//  Copyright © 2017年 ZK. All rights reserved.
// 一个下载器对应一个下载任务

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ZKDownloadState) {
    ZKDownloadStatePause = 0,
    ZKDownloadStateDownloading,
    ZKDownloadStateSuccess,
    ZKDownloadStateFailed
};

@interface ZKDownloader : NSObject

@property (nonatomic, assign) ZKDownloadState state;

- (void)downloadWithUrl:(NSURL *)url;
- (void)pauseCurrentTask;
- (void)cancelCurrentTask;
- (void)cancelAndClear;

@end
