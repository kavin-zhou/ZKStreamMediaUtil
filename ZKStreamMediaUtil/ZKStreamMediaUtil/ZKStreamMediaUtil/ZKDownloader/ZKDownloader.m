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

@interface ZKDownloader () <NSURLSessionDataDelegate>

@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, assign) long long tempSize;
@property (nonatomic, assign) long long totalSize;
@property (nonatomic, copy) NSString *downloadedPath;
@property (nonatomic, copy) NSString *downloadingPath;
@property (nonatomic, strong) NSOutputStream *outputStream;
@property (nonatomic, weak) NSURLSessionDataTask *dataTask;

@end

@implementation ZKDownloader
    
- (void)downloadWithUrl:(NSURL *)url {
    
    BOOL taskExists =
    [url isEqual:_dataTask.originalRequest.URL] && _state == ZKDownloadStatePause;
    if (taskExists) { // 如果当前任务已经存在
        [self resumeCurrentTask];
        return;
    }
    
    NSString *fileName = url.lastPathComponent;
    _downloadedPath = [CachePath stringByAppendingPathComponent:fileName];
    _downloadingPath = [TempPath stringByAppendingPathComponent:fileName];
    DLog(@"正在下载的文件保存地址\n%@\n", _downloadingPath);
    
    if ([ZKFileTool fileExists:_downloadedPath]) {
        DLog(@"已经存在下载好的文件");
        self.state = ZKDownloadStateSuccess;
        return;
    }
    if (![ZKFileTool fileExists:_downloadingPath]) {
        [self downloadWihUrl:url offset:0];
        return;
    }
    _tempSize = [ZKFileTool fileSize:_downloadingPath];
    [self downloadWihUrl:url offset:_tempSize];
}

- (void)downloadWihUrl:(NSURL *)url offset:(long long)offset {
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    _session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:0];
    
    [request setValue:[NSString stringWithFormat:@"bytes=%lld-", offset] forHTTPHeaderField:@"Range"];
    
    _dataTask = [_session dataTaskWithRequest:request];
    [self resumeCurrentTask];
}

- (void)pauseCurrentTask {
    if (self.state != ZKDownloadStateDownloading) {
        return;
    }
    self.state = ZKDownloadStatePause;
    [_dataTask suspend];
}

- (void)cancelCurrentTask {
    self.state = ZKDownloadStatePause;
    [self.session invalidateAndCancel];
    self.session = nil;
}

- (void)cancelAndClear {
    [self cancelCurrentTask];
    [ZKFileTool removePath:_downloadingPath];
}

- (void)resumeCurrentTask {
    if (!_dataTask || self.state != ZKDownloadStatePause) {
        return;
    }
    [_dataTask resume];
    self.state = ZKDownloadStateDownloading;
}

#pragma mark - <NSURLSessionDataDelegate>

// 仅仅是响应头，并没有具体的资源内容
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    DLog(@"%@", response);
    // 注意：Content-Length 是剩余的字节长度，不是总长度
    // Content-Range 包含总字节长度 （有时候没有这个字段）
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    
    _totalSize = [httpResponse.allHeaderFields[@"Content-Length"] longLongValue];
    NSString *contentRangeStr = httpResponse.allHeaderFields[@"Content-Range"];
    if (contentRangeStr.length) {
        _totalSize = [[contentRangeStr componentsSeparatedByString:@"/"].lastObject longLongValue];
    }
    
    if (_tempSize == _totalSize) {
        DLog(@"下载完整，移动到下载完成文件夹");
        [ZKFileTool moveFile:_downloadingPath toPath:_downloadedPath];
        completionHandler(NSURLSessionResponseCancel);
        self.state = ZKDownloadStateSuccess;
    }
    else if (_tempSize > _totalSize) {
        DLog(@"下载出错，删除并重新下载");
        [ZKFileTool removePath:_downloadingPath];
        [self downloadWithUrl:response.URL];
        completionHandler(NSURLSessionResponseCancel);
    }
    else {
        DLog(@"继续接收数据");
        _outputStream = [NSOutputStream outputStreamToFileAtPath:_downloadingPath append:true];
        [_outputStream open];
        completionHandler(NSURLSessionResponseAllow);
        self.state = ZKDownloadStateDownloading;
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    [_outputStream write:data.bytes maxLength:data.length];
    DLog(@"正在接收数据");
}

// 请求完成，不一定成功
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    [_outputStream close];
    DLog(@"下载完成");
    
    if (error) {
        DLog(@"%@", error);
        if (error.code == -999) { // 用户主动取消
            self.state = ZKDownloadStatePause;
        }
        else {
            self.state = ZKDownloadStateFailed;
        }
        
        return;
    }
    // 注意，到这里不一定成功，如果中间有字节重叠等错误，最后的数据是有问题的
    // 可以用 MD5 验证一下
    [ZKFileTool moveFile:_downloadingPath toPath:_downloadedPath];
    self.state = ZKDownloadStateSuccess;
}

@end
