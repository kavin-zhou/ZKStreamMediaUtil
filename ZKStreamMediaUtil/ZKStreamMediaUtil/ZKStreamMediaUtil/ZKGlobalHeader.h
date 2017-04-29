//
//  ZKGlobalHeader.h
//  ZKStreamMediaUtil
//
//  Created by ZK on 2017/4/29.
//  Copyright © 2017年 ZK. All rights reserved.
//

#ifndef ZKGlobalHeader_h
#define ZKGlobalHeader_h

#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define DLog(...)
#endif

#define CachePath  NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, true).firstObject
#define TempPath   NSTemporaryDirectory()

#define GlobalBlueColor_Normal    [UIColor colorWithRed:63/255.f green:158/255.f blue:214/255.f alpha:1]
#define GlobalBlueColor_HL        [UIColor colorWithRed:43/255.f green:138/255.f blue:194/255.f alpha:1]
#define GlobalBlueColor_Disabled  [UIColor colorWithRed:63/255.f green:158/255.f blue:214/255.f alpha:.4]

#define SCREEN_HEIGHT        ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_WIDTH         ([[UIScreen mainScreen] bounds].size.width)
#define WindowZoomScale      (SCREEN_WIDTH/320.f)

#define KeyboardAnimationCurve  7 << 16
#define TCRandom  ((CGFloat)(1+arc4random()%99)/100) // 0 ~ 1

#define HexColor(hexValue)   [UIColor colorWithRed:((float)(((hexValue) & 0xFF0000) >> 16))/255.0 green:((float)(((hexValue) & 0xFF00) >> 8))/255.0 blue:((float)((hexValue) & 0xFF))/255.0 alpha:1]

#endif /* ZKGlobalHeader_h */
