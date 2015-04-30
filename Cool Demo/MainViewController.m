//
//  MainViewController.m
//  Cool Demo
//
//  Created by Jonathan Lott on 4/25/15.
//  Copyright (c) 2015 A Lott Of Ideas. All rights reserved.
//

#import "MainViewController.h"
#import "DemoPlayerViewController.h"
#import "Cool Demo-Bridging-Header.h"

@import AVFoundation;
@import AVKit;

@implementation NSString (URLCreation)
- (NSURL*)urlValue
{
    NSURL* url = nil;

    if(self.length)
    {
        url = [NSURL URLWithString:self];

        if(!url)
        {
           url = [NSURL fileURLWithPath:self];
        }
    }
    return url;
}

- (NSString*)pathInBundle
{
    NSString* fullPath = nil;
    if(self.length) {
        fullPath = [[NSBundle mainBundle] pathForResource:[self stringByDeletingPathExtension] ofType:self.pathExtension];
    }
    return fullPath;
}
@end

@interface MainViewController ()
@property (strong, nonatomic) IBOutlet UIButton *repeatButton;
@property (strong, nonatomic) IBOutlet UIProgressView* progressView;
@property (strong, nonatomic) IBOutlet UILabel* progressLabel;

@property (nonatomic, strong) NSMutableArray* videoPlayers;
@end

@implementation MainViewController


- (id)init{
    self = [super init];

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.


}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self setupVideos];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self animateVideos];
}

- (void)cleanupVideos {
    for(DemoPlayerViewController* playerVC in self.videoPlayers) {
        [playerVC.view removeFromSuperview];
    }
    self.completedCount = 0;
    [self updateProgressView];
}

- (void)setupVideos
{
    [self cleanupVideos];

    self.videoPlayers = [NSMutableArray array];
    NSArray* filePaths = @[kVideoURL, kVideoURL, kVideoURL, kVideoURL];

    [filePaths enumerateObjectsUsingBlock:^(NSString* filePath, NSUInteger idx, BOOL *stop) {
        NSString* fullPath = filePath.pathInBundle ?: filePath;
        if(fullPath.length) {
            DemoPlayerViewController* playerVC = [[DemoPlayerViewController alloc] init];
            [self.videoPlayers addObject:playerVC];
            [playerVC loadVideoWithURL:fullPath.urlValue delay:(float)idx*2 completion:^{
                self.completedCount++;
                [self videoSetupCompleted:playerVC];
                [playerVC.player play];
            }];
            [self updateProgressView];
        }
    }];

    //start with players outside of bounds and then animate them in on did appear
    [self.videoPlayers enumerateObjectsUsingBlock:^(AVPlayerViewController* playerVC, NSUInteger idx, BOOL *stop) {

        CGFloat width = self.view.frame.size.width / 2;
        CGFloat height = width * 3/4;
        CGFloat offset = (idx / 2.0);
        CGRect playerFrame = CGRectMake(0, offset * height, width, height);
        playerFrame.origin.x = idx % 2 == 0 ? -playerFrame.size.width : self.view.bounds.size.width + playerFrame.size.width;

        playerVC.view.frame = playerFrame;
        [self.view addSubview:playerVC.view];
    }];
}

- (void)updateProgressView
{
    float progress = self.videoPlayers.count > 0 ? (float)((float)self.completedCount / (float)self.videoPlayers.count) : 0;
    self.progressView.progress = progress;
    self.progressLabel.text = [NSString stringWithFormat:@"%.0f%%", progress*100.f];

    // strong vs. weak example
    if(progress == 1.0) {
        [self performBlockOfCode:^{
            [self.progressView removeFromSuperview];
            [self.progressLabel removeFromSuperview];
        } afterDelay:3.0];
    }
    else {
        if(!self.progressLabel.superview){
            [self.view addSubview:self.progressLabel];
        }
        if(!self.progressView.superview){
            [self.view addSubview:self.progressView];
        }
    }
}

- (void)videoSetupCompleted:(DemoPlayerViewController*)playerVC
{
    [self updateProgressView];
}

- (void)animateVideos
{
    //start with players outside of bounds and then animate them in on did appear
    [self.videoPlayers enumerateObjectsUsingBlock:^(AVPlayerViewController* playerVC, NSUInteger idx, BOOL *stop) {
        CGFloat width = self.view.frame.size.width / 2;
        CGFloat height = width * 3/4;
        CGFloat offsetY = (idx % 2);
        CGFloat offsetX = (idx / 2);

        CGRect playerFrame = CGRectMake(offsetX * width, offsetY * height + self.view.center.y/2, width, height);
//        NSLog(@"[%ld] offsetX %f, x = %f", idx, offsetX, playerFrame.origin.x);
//        NSLog(@"[%ld] offsetY %f, x = %f", idx, offsetY, playerFrame.origin.y);
        playerVC.view.autoresizingMask = UIViewAutoresizingNone;
        [playerVC.player play];
        [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            playerVC.view.frame = playerFrame;
        } completion:nil];
    }];
}

- (IBAction)repeatAnimation:(id)sender
{
    [self setupVideos];

    [self performSelector:@selector(animateVideos) withObject:nil afterDelay:1.0];
}

@end
