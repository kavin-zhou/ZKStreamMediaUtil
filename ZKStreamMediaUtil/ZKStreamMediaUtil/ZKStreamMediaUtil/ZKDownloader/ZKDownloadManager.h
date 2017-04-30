//
//  ZKDownloadManager.h
//  ZKStreamMediaUtil
//
//  Created by ZK on 2017/4/30.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZKDownloader.h"

@interface ZKDownloadManager : NSObject

+ (instancetype)shareInstance;

- (void)downloadWithUrl:(NSURL *)url progress:(void(^)(CGFloat progress))progress success:(void(^)(NSString *cachePath))success;

- (void)pauseWithUrl:(NSURL *)url;
- (void)resumeWithUrl:(NSURL *)url;
- (void)cancelWithUrl:(NSURL *)url;
- (void)pauseAll;
- (void)resumeAll;
- (void)cancelAll;

@end
