
#import <Foundation/Foundation.h>

@interface LameTool : NSObject


/**
 注意，格式选择 PCM，后缀 .caf
 */
+ (NSString *)audioPCMToMP3: (NSString *)sourcePath shouldDeleteSourchFile: (BOOL)shouldDelete;

@end
