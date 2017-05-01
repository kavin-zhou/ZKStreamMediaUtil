//
//  ViewController.m
//  ZKStreamMediaUtil
//
//  Created by ZK on 2017/4/30.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import "ViewController.h"
#import "ZKAudioPlayerViewController.h"
#import "ZKVideoRecordViewController.h"
#import "ZKAudioRecorderViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)pushToAudioVC {
    ZKAudioPlayerViewController *vc = [ZKAudioPlayerViewController new];
    [self.navigationController pushViewController:vc animated:true];
}

- (IBAction)pushToVideoVC {
    ZKVideoRecordViewController *vc = [ZKVideoRecordViewController new];
    [self.navigationController pushViewController:vc animated:true];
}

- (IBAction)pushToAudioRecordVC:(id)sender {
    ZKAudioRecorderViewController *vc = [ZKAudioRecorderViewController new];
    [self.navigationController pushViewController:vc animated:true];
}

@end
