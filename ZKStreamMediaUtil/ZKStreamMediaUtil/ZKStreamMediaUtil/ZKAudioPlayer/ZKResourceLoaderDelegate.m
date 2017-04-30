//
//  ZKResourceLoaderDelegate.m
//  ZKStreamMediaUtil
//
//  Created by ZK on 2017/4/30.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import "ZKResourceLoaderDelegate.h"

@implementation ZKResourceLoaderDelegate

#pragma mark - <AVAssetResourceLoaderDelegate>

- (BOOL)resourceLoader:(AVAssetResourceLoader *)resourceLoader shouldWaitForLoadingOfRequestedResource:(AVAssetResourceLoadingRequest *)loadingRequest {
    // 填充相应的信息头信息
    loadingRequest.contentInformationRequest.contentLength = 7969162;
    loadingRequest.contentInformationRequest.contentType = @"test.m4a";
    // 将区间分割
    loadingRequest.contentInformationRequest.byteRangeAccessSupported = true;
    
    // 返回相应的数据给外界
    // 注意，option选择NSDataReadingMappedIfSafe是以内存映射方式，防止内存峰值
    NSData *data = [NSData dataWithContentsOfFile:@"/Users/ZK/Desktop/001.m4a" options:NSDataReadingMappedIfSafe error:nil];
    // 注意不能一次性将data传出去，要根据请求字节信息进行传递
    long long requestOffset = loadingRequest.dataRequest.requestedOffset;
    NSInteger requestLength = loadingRequest.dataRequest.requestedLength;
    NSData *subData = [data subdataWithRange:NSMakeRange(requestOffset, requestLength)];
    
    [loadingRequest.dataRequest respondWithData:subData];
    
    return true;
}

- (void)resourceLoader:(AVAssetResourceLoader *)resourceLoader didCancelLoadingRequest:(AVAssetResourceLoadingRequest *)loadingRequest {
    
}

@end
