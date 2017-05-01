
#import <Foundation/Foundation.h>

@interface LameTool : NSObject

+ (NSString *)audioPCMToMP3: (NSString *)sourcePath shouldDeleteSourchFile: (BOOL)shouldDelete;

@end
