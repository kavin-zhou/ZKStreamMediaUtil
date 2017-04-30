
//
//  ZKDownloadManager.m
//  ZKStreamMediaUtil
//
//  Created by ZK on 2017/4/30.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import "ZKDownloadManager.h"
#import "NSString+add.h"

@interface ZKDownloadManager () <NSCopying, NSMutableCopying>

@property (nonatomic, strong) NSMutableDictionary *downloadMapper;

@end

static ZKDownloadManager *shareInstance_;

@implementation ZKDownloadManager

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance_ = [ZKDownloadManager new];
    });
    return shareInstance_;
}

- (void)downloadWithUrl:(NSURL *)url progress:(void (^)(CGFloat))progress success:(void (^)(NSString *))success {
    NSString *md5Str = [url.absoluteString md5];
    ZKDownloader *downloader = self.downloadMapper[md5Str];
    if (!downloader) {
        downloader = [ZKDownloader new];
        self.downloadMapper[md5Str] = downloader;
    }
    [downloader downloadWithUrl:url progress:progress success:^(NSString *cachePath) {
        // 拦截block
        [self.downloadMapper removeObjectForKey:md5Str];
        !success?:success(cachePath);
    }];
}

- (void)pauseWithUrl:(NSURL *)url {
    ZKDownloader *value = [self getDownloaderFromMapperWithUrl:url];
    [value pauseCurrentTask];
}

- (void)pauseAll {
    [self.downloadMapper.allValues performSelector:@selector(pauseCurrentTask)];
}

- (void)cancelWithUrl:(NSURL *)url {
    ZKDownloader *value = [self getDownloaderFromMapperWithUrl:url];
    [value cancelCurrentTask];
}

- (void)cancelAll {
    [self.downloadMapper.allValues performSelector:@selector(cancelCurrentTask)];
}

- (void)resumeWithUrl:(NSURL *)url {
    ZKDownloader *value = [self getDownloaderFromMapperWithUrl:url];
    [value resumeCurrentTask];
}

- (void)resumeAll {
    [self.downloadMapper.allValues performSelector:@selector(resumeCurrentTask)];
}

- (ZKDownloader *)getDownloaderFromMapperWithUrl:(NSURL *)url {
    NSString *md5Str = [url.absoluteString md5];
    ZKDownloader *downloader = self.downloadMapper[md5Str];
    return downloader;
}

- (NSMutableDictionary *)downloadMapper {
    if (!_downloadMapper) {
        // key=>md5(url) value=>doanloader
        _downloadMapper = [NSMutableDictionary dictionary];
    }
    return _downloadMapper;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    if (!shareInstance_) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            shareInstance_ = [super allocWithZone:zone];
        });
    }
    return shareInstance_;
}

- (id)copyWithZone:(NSZone *)zone {
    return shareInstance_;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return shareInstance_;
}

@end
