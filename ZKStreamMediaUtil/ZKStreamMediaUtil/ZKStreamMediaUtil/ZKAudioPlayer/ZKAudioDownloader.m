//
//  ZKAudioDownloader.m
//  ZKStreamMediaUtil
//
//  Created by ZK on 2017/5/1.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import "ZKAudioDownloader.h"
#import "ZKAudioFileManager.h"

@interface ZKAudioDownloader () <NSURLSessionDataDelegate>

@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSOutputStream *outputStream;
@property (nonatomic, strong) NSURL *currentUrl;

@end

@implementation ZKAudioDownloader

- (void)downloadWithUrl:(NSURL *)url offset:(long long)offset {
    [self cancelAndClear];
    _currentUrl = url;
    _offset = offset;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:0];
    NSString *value = [NSString stringWithFormat:@"bytes=%lld-", offset];
    [request setValue:value forHTTPHeaderField:@"Range"];
    
    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request];
    
    [task resume];
}

- (void)cancelAndClear {
    _loadedSize = 0;
    [self.session invalidateAndCancel];
    self.session = nil;
    // 清空缓存
    
    [ZKAudioFileManager clearTempFile:_currentUrl];
}

- (NSURLSession *)session {
    if (!_session) {
        
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        _session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    }
    return _session;
}

#pragma mark - <NSURLSessionDataDelegate>

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    _mimeType = httpResponse.MIMEType;
    
    _totalSize = [httpResponse.allHeaderFields[@"Content-Length"] longLongValue];
    NSString *contentRangeStr = httpResponse.allHeaderFields[@"Content-Range"];
    if (contentRangeStr.length) {
        _totalSize = [[contentRangeStr componentsSeparatedByString:@"/"].lastObject longLongValue];
    }
    
    _outputStream = [NSOutputStream outputStreamToFileAtPath:[ZKAudioFileManager tempFilePathWithUrl:_currentUrl] append:true];
    [_outputStream open];
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    _loadedSize += data.length;
    [_outputStream write:data.bytes maxLength:data.length];
    if ([self.delegate respondsToSelector:@selector(audioDownloaderIsDownloading:)]) {
        [self.delegate audioDownloaderIsDownloading:self];
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    if (error) {
        NSLog(@"task有错误%@", error);
        return;
    }
    // tempSize == fileSize, temp => cache
    if ([ZKAudioFileManager tempFileSize:_currentUrl] == _totalSize) {
        [ZKAudioFileManager moveTempFileToCacheWithUrl:_currentUrl];
    }
}

@end
