//
//  NSObject+DelayBlock.m
//  Cool Demo
//
//  Created by Jonathan Lott on 4/28/15.
//  Copyright (c) 2015 A Lott Of Ideas. All rights reserved.
//

#import "NSObject+DelayBlock.h"

@implementation NSObject (DelayBlock)
- (void)performBlockOfCode:(void (^)())block afterDelay:(NSTimeInterval)delayInSeconds
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(performBlockOfCode:) object:block];
    [self performSelector:@selector(performBlockOfCode:) withObject:block afterDelay:delayInSeconds];
}

- (void)performBlockOfCode:(void (^)())block
{
    block();
}
@end
