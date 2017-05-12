//
//  MCVideoPlayerController.m
//  MCFriends
//
//  Created by ZK on 2017/5/12.
//  Copyright © 2017年 marujun. All rights reserved.
//

#import "MCVideoPlayerController.h"
#import "MCVideoPlayerView.h"

@interface MCVideoPlayerController ()

@property (nonatomic, weak) MCVideoPlayerView *playerView;

@end

@implementation MCVideoPlayerController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    MCVideoPlayerView *playerView = [MCVideoPlayerView playerView];
    [self.view addSubview:playerView];
    self.playerView = playerView;
    
//    NSURL *url = [NSURL URLWithString:@"http://hc.yinyuetai.com/uploads/videos/common/331C015823B0F4E886170714CD9062FD.flv?sc=8f526db9deea29c8"];
    
    NSString *moviePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/ZKTest.mp4"];
    NSURL *url = [NSURL fileURLWithPath:moviePath];
    
    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:url];
    self.playerView.playerItem = item;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _playerView.frame = self.view.bounds;
}

@end
