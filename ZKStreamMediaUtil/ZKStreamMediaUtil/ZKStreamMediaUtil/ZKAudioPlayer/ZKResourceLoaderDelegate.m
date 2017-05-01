//
//  ZKResourceLoaderDelegate.m
//  ZKStreamMediaUtil
//
//  Created by ZK on 2017/4/30.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import "ZKResourceLoaderDelegate.h"
#import "ZKAudioFileManager.h"
#import "ZKAudioDownloader.h"
#import "NSURL+Add.h"
#import "ZKAudioDownloader.h"

@interface ZKResourceLoaderDelegate () <ZKAudioDownloaderDelegate>

@property (nonatomic, strong) ZKAudioDownloader *downloader;
@property (nonatomic, strong) NSMutableArray <AVAssetResourceLoadingRequest *> *loadingRequests;

@end

@implementation ZKResourceLoaderDelegate

#pragma mark - <AVAssetResourceLoaderDelegate>

- (BOOL)resourceLoader:(AVAssetResourceLoader *)resourceLoader shouldWaitForLoadingOfRequestedResource:(AVAssetResourceLoadingRequest *)loadingRequest {
    
    NSURL *streamUrl = loadingRequest.request.URL;
    NSURL *httpUrl = [streamUrl httpURL];
    
    // 如果有缓存，直接播放本地缓存
    if ([ZKAudioFileManager cacheFileExists:httpUrl]) {
        [self handleCachedWithLoadingRequest:loadingRequest];
        return true;
    }
    
    [self.loadingRequests addObject:loadingRequest];
    
    // 注意和 requestedOffset 做出区别
    long long currentOffset = loadingRequest.dataRequest.currentOffset;
    
    // 没有缓存，判断有没有在下载，没有在下载就下载
    if (self.downloader.loadedSize == 0) {
        [self.downloader downloadWithUrl:httpUrl offset:currentOffset];
        return true;
    }
    if (currentOffset < self.downloader.offset || currentOffset > (self.downloader.offset + self.downloader.loadedSize + 500)) {
        [self.downloader downloadWithUrl:httpUrl offset:currentOffset];
        return true;
    }
    
    // 在下载过程当中应不断的进行判断
    [self handleAllLoadingRequest];
    
    return true;
}

- (void)resourceLoader:(AVAssetResourceLoader *)resourceLoader didCancelLoadingRequest:(AVAssetResourceLoadingRequest *)loadingRequest {
    NSLog(@"%@", @"取消某个请求");
    if (!self.loadingRequests.count) {
        return;
    }
    [self.loadingRequests removeObject:loadingRequest];
}

- (void)handleAllLoadingRequest {
    NSLog(@"在这里不断处理请求的数据");
    
    NSMutableArray *requestsShouldRemove = [NSMutableArray array];
    
    [self.loadingRequests enumerateObjectsUsingBlock:^(AVAssetResourceLoadingRequest * _Nonnull loadingRequest, NSUInteger idx, BOOL * _Nonnull stop) {
        
        // 填充内容信息头
        NSURL *url = loadingRequest.request.URL;
        loadingRequest.contentInformationRequest.contentLength = self.downloader.totalSize;
        loadingRequest.contentInformationRequest.contentType = self.downloader.mimeType;
        // 将区间分割
        loadingRequest.contentInformationRequest.byteRangeAccessSupported = true;
        
        // 填充数据
        NSData *data = [NSData dataWithContentsOfFile:[ZKAudioFileManager tempFilePathWithUrl:url] options:NSDataReadingMappedIfSafe error:nil];
        if (!data) {
            data = [NSData dataWithContentsOfFile:[ZKAudioFileManager cacheFilePathWithUrl:url] options:NSDataReadingMappedIfSafe error:nil];
        }
        
        long long currentOffset = loadingRequest.dataRequest.currentOffset;
        NSInteger requestLength = loadingRequest.dataRequest.requestedLength;
        
        long long responseOffset = currentOffset - self.downloader.offset;
        long long responseLength = MIN(self.downloader.offset + self.downloader.loadedSize - currentOffset, requestLength);
        
        NSData *subData = [data subdataWithRange:NSMakeRange(responseOffset, responseLength)];
        
        [loadingRequest.dataRequest respondWithData:subData];
        
        // 注意，必须在请求区间所有的数据都返回完之后才能完成这个请求
        if (responseLength == requestLength) {
            [loadingRequest finishLoading];
            [requestsShouldRemove addObject:loadingRequest];
        }
    }];
    [self.loadingRequests removeObjectsInArray:requestsShouldRemove];
}

#pragma mark - Private

- (void)handleCachedWithLoadingRequest:(AVAssetResourceLoadingRequest *)loadingRequest {
    // 填充相应的信息头信息
    NSURL *url = loadingRequest.request.URL;
    loadingRequest.contentInformationRequest.contentLength = [ZKAudioFileManager cacheFileSize:url];
    loadingRequest.contentInformationRequest.contentType = [ZKAudioFileManager contentTypeWithUrl:url];
    // 将区间分割
    loadingRequest.contentInformationRequest.byteRangeAccessSupported = true;
    
    // 返回相应的数据给外界
    // 注意，option选择NSDataReadingMappedIfSafe是以内存映射方式，防止内存峰值
    NSData *data = [NSData dataWithContentsOfFile:[ZKAudioFileManager cacheFilePathWithUrl:url] options:NSDataReadingMappedIfSafe error:nil];
    
    // 注意不能一次性将data传出去，要根据请求字节信息进行传递
    long long requestOffset = loadingRequest.dataRequest.requestedOffset;
    NSInteger requestLength = loadingRequest.dataRequest.requestedLength;
    NSData *subData = [data subdataWithRange:NSMakeRange(requestOffset, requestLength)];
    
    [loadingRequest.dataRequest respondWithData:subData];
}

- (ZKAudioDownloader *)downloader {
    if (!_downloader) {
        _downloader = [ZKAudioDownloader new];
        _downloader.delegate = self;
    }
    return _downloader;
}

- (NSMutableArray *)loadingRequests {
    if (!_loadingRequests) {
        _loadingRequests = [NSMutableArray array];
    }
    return _loadingRequests;
}

#pragma mark - <ZKAudioDownloaderDelegate>

- (void)audioDownloaderIsDownloading:(ZKAudioDownloader *)downloader {
    // 不断处理所有的请求
    [self handleAllLoadingRequest];
}

@end
