//
//  ZKAudioDownloader.h
//  ZKStreamMediaUtil
//
//  Created by ZK on 2017/5/1.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZKAudioDownloader;

@protocol ZKAudioDownloaderDelegate <NSObject>

- (void)audioDownloaderIsDownloading:(ZKAudioDownloader *)downloader;

@end

@interface ZKAudioDownloader : NSObject

@property (nonatomic, weak) id <ZKAudioDownloaderDelegate> delegate;
@property (nonatomic, assign, readonly) long long totalSize;
@property (nonatomic, copy, readonly) NSString *mimeType;

@property (nonatomic, assign, readonly) long long loadedSize;
@property (nonatomic, assign, readonly) long long offset;

- (void)downloadWithUrl:(NSURL *)url offset:(long long)offset;

@end
