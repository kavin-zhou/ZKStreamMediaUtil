//
//  ZKAudioFileManager.h
//  ZKStreamMediaUtil
//
//  Created by ZK on 2017/4/30.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZKAudioFileManager : NSObject

+ (NSString *)cacaheFilePathWithUrl:(NSURL *)url;
+ (BOOL)cacheFileExists:(NSURL *)url;
+ (long long)cacheFileSize:(NSURL *)url;
+ (NSString *)contentTypeWithUrl:(NSURL *)url;

@end
