//
//  ZKAudioDownloader.h
//  ZKStreamMediaUtil
//
//  Created by ZK on 2017/5/1.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZKAudioDownloader : NSObject

@property (nonatomic, assign, readonly) long long loadedSize;

- (void)downloadWithUrl:(NSURL *)url offset:(long long)offset;

@end
