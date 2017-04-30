//
//  ZKResourceLoaderDelegate.m
//  ZKStreamMediaUtil
//
//  Created by ZK on 2017/4/30.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import "ZKResourceLoaderDelegate.h"
#import "ZKAudioFileManager.h"

@implementation ZKResourceLoaderDelegate

#pragma mark - <AVAssetResourceLoaderDelegate>

- (BOOL)resourceLoader:(AVAssetResourceLoader *)resourceLoader shouldWaitForLoadingOfRequestedResource:(AVAssetResourceLoadingRequest *)loadingRequest {
    
    // 如果有缓存，直接播放本地缓存
    // 没有缓存，判断有没有在下载，没有在下载就下载
    NSURL *url = loadingRequest.request.URL;
    if ([ZKAudioFileManager cacheFileExists:url]) {
        [self handleCachedWithLoadingRequest:loadingRequest];
    }
    
    
    return true;
}

- (void)resourceLoader:(AVAssetResourceLoader *)resourceLoader didCancelLoadingRequest:(AVAssetResourceLoadingRequest *)loadingRequest {
    
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
    NSData *data = [NSData dataWithContentsOfFile:[ZKAudioFileManager cacaheFilePathWithUrl:url] options:NSDataReadingMappedIfSafe error:nil];
    // 注意不能一次性将data传出去，要根据请求字节信息进行传递
    long long requestOffset = loadingRequest.dataRequest.requestedOffset;
    NSInteger requestLength = loadingRequest.dataRequest.requestedLength;
    NSData *subData = [data subdataWithRange:NSMakeRange(requestOffset, requestLength)];
    
    [loadingRequest.dataRequest respondWithData:subData];
}

@end
