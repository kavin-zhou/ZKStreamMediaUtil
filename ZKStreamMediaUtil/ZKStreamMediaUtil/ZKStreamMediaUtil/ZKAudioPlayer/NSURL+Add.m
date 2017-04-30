//
//  NSURL+Add.m
//  ZKStreamMediaUtil
//
//  Created by ZK on 2017/4/30.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import "NSURL+Add.h"

@implementation NSURL (Add)

- (NSURL *)streamingURL {
    NSURLComponents *components = [NSURLComponents componentsWithString:self.absoluteString];
    // 更换协议头
    components.scheme = @"streaming";
    return components.URL;
}

@end
