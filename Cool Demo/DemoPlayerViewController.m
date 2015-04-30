//
//  DemoPlayerViewController.m
//  Cool Demo
//
//  Created by Jonathan Lott on 4/26/15.
//  Copyright (c) 2015 A Lott Of Ideas. All rights reserved.
//

#import "DemoPlayerViewController.h"
#import "NSObject+DelayBlock.h"

@import AVKit;
@import AVFoundation;

@interface DemoPlayerViewController ()
@property (nonatomic) BOOL isCompleted;
@end

@implementation DemoPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadVideoWithURL:(NSURL*)url delay:(float)delay completion:(void(^)())completion
{
   // self.showsPlaybackControls = NO;

    [self performBlockOfCode:^{
        AVURLAsset* asset = [AVURLAsset assetWithURL:url];
        if(asset) {
            AVPlayerItem* playerItem = [AVPlayerItem playerItemWithAsset:asset];
            AVPlayer* player = [AVPlayer playerWithPlayerItem:playerItem];
            player.volume = 0.0;
            self.player = player;
            self.videoGravity = AVLayerVideoGravityResizeAspectFill;

            player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
            self.isCompleted = YES;
            [[NSNotificationCenter defaultCenter] addObserverForName:AVPlayerItemDidPlayToEndTimeNotification object:[player currentItem] queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification) {
                AVPlayerItem *pItem = [notification object];
                [pItem seekToTime:kCMTimeZero];
            }];

            if(completion)
                completion();
        }
    } afterDelay:delay];
}

- (void)didFinishLoadingPlayer:(DemoPlayerViewController*)player
{
    NSLog(@"player finished loading - %@", player);
}


- (void)dealloc
{
    NSLog(@"%@ dealloc called", self);
}
@end
