//
//  NSObject+Swizzle.h
//  Cool Demo
//
//  Created by Jonathan Lott on 4/28/15.
//  Copyright (c) 2015 A Lott Of Ideas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Swizzle)
+ (void)overloadSelector:(SEL)originalSelector withSelector:(SEL)overrideSelector;

@end
