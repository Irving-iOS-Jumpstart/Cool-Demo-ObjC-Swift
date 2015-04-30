//
//  NSObject+DelayBlock.h
//  Cool Demo
//
//  Created by Jonathan Lott on 4/28/15.
//  Copyright (c) 2015 A Lott Of Ideas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (DelayBlock)
- (void)performBlockOfCode:(void (^)())block afterDelay:(NSTimeInterval)delayInSeconds;

@end
