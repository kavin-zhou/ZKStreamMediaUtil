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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
