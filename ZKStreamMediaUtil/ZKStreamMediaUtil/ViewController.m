//
//  ViewController.m
//  ZKStreamMediaUtil
//
//  Created by ZK on 2017/4/29.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import "ViewController.h"
#import "ZKDownloadManager.h"

@interface ViewController ()

@property (nonatomic, strong) ZKDownloader *downloader;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // @"http://pinyin.sogou.com/mac/softdown.php"
    
    NSURL *url = [NSURL URLWithString:@"http://down.kuwo.cn/mac/kwplayer_mac.dmg"];
    
    [[ZKDownloadManager shareInstance] downloadWithUrl:url progress:^(CGFloat progress) {
        NSLog(@"进度%f", progress);
    } success:^(NSString *cachePath) {
        NSLog(@"保存路径%@", cachePath);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
