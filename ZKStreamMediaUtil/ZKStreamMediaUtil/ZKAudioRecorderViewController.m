//
//  ZKAudioRecorderViewController.m
//  ZKStreamMediaUtil
//
//  Created by ZK on 2017/5/1.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import "ZKAudioRecorderViewController.h"
#import "ZKLocalAudioPlayer.h"
#import "ZKAudioRecorder.h"
#import "LameTool.h"

@interface ZKAudioRecorderViewController ()

@end

@implementation ZKAudioRecorderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (NSString *)audioPathWithSurffix:(NSString *)surffix {
    NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, true).lastObject;
    NSString *filePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"zk%@", surffix]];
    return filePath;
}

- (IBAction)startRecord {
    [[ZKAudioRecorder shareInstance] startRecordWithRecordPath:[self audioPathWithSurffix:@".caf"]];
}

- (IBAction)endRecord:(id)sender {
    [[ZKAudioRecorder shareInstance] endRecord];
}

- (IBAction)deleteRecord:(id)sender {
    [[ZKAudioRecorder shareInstance] deleteRecord];
}

- (IBAction)playAudio:(id)sender {
    [[ZKLocalAudioPlayer shareInstance] playAudioWithPath:[self audioPathWithSurffix:@".caf"]];
}

- (IBAction)transferAudio:(id)sender {
    [LameTool audioPCMToMP3:[self audioPathWithSurffix:@".caf"] shouldDeleteSourchFile:false];
}

- (IBAction)playTransferedAudio:(id)sender {
    [[ZKLocalAudioPlayer shareInstance] playAudioWithPath:[self audioPathWithSurffix:@".mp3"]];
}

@end
