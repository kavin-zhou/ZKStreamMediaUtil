//
//  NSString+add.m
//  ZKStreamMediaUtil
//
//  Created by ZK on 2017/4/30.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import "NSString+add.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (add)

- (NSString *)md5 {
    const char *data = self.UTF8String;
    unsigned char md[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(data, (CC_LONG)strlen(data), md);
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i ++) {
        [result appendFormat:@"%02x", md[i]];
    }
    return result;
}

@end
