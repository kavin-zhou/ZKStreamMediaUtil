//
//  MCVideoPlayerView.h
//  MCFriends
//
//  Created by ZK on 2017/5/12.
//  Copyright © 2017年 marujun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol XMGPlayerViewDelegate <NSObject>

@optional
- (void)playerViewDidClickFullScreen:(BOOL)isFull;

@end

@interface MCVideoPlayerView : UIView

+ (instancetype)playerView;

@property (weak, nonatomic) id<XMGPlayerViewDelegate> delegate;
@property (nonatomic, strong) AVPlayerItem *playerItem;

@end
