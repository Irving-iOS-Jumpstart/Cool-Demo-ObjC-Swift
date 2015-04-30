//
//  NSObject+Swizzle.m
//  Cool Demo
//
//  Created by Jonathan Lott on 4/28/15.
//  Copyright (c) 2015 A Lott Of Ideas. All rights reserved.
//

#import "NSObject+Swizzle.h"
#import <objc/runtime.h> // Needed for method swizzling

@implementation NSObject (Swizzle)
+ (void)overloadSelector:(SEL)originalSelector withSelector:(SEL)overrideSelector
{
    Method originalMethod = class_getInstanceMethod(self, originalSelector);
    Method overrideMethod = class_getInstanceMethod(self, overrideSelector);

    if (class_addMethod(self, originalSelector, method_getImplementation(overrideMethod), method_getTypeEncoding(overrideMethod))) {
        class_replaceMethod(self, overrideSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, overrideMethod);
    }
}
@end
