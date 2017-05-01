
#import <Foundation/Foundation.h>

@interface LameTool : NSObject

+ (NSString *)audioToMP3: (NSString *)sourcePath shouldDeleteSourchFile: (BOOL)shouldDelete;

@end
