//
//  DemoPlayerViewController.h
//  Cool Demo
//
//  Created by Jonathan Lott on 4/26/15.
//  Copyright (c) 2015 A Lott Of Ideas. All rights reserved.
//

#import <AVKit/AVKit.h>

@class DemoPlayerViewController;

@interface DemoPlayerViewController : AVPlayerViewController
- (void)loadVideoWithURL:(NSURL*)url delay:(float)delay completion:(void(^)())completion;
@end
