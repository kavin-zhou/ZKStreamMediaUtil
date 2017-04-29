//
//  ZKFileTool.h
//  ZKStreamMediaUtil
//
//  Created by ZK on 2017/4/29.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZKFileTool : NSObject

+ (BOOL)fileExists:(NSString *)filePath;
+ (long long)fileSize:(NSString *)filePath;

@end
