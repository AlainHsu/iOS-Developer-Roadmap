//
//  ViewReusePool.m
//  TableVIew_Reuse
//
//  Created by Alain Hsu on 2019/4/23.
//  Copyright © 2019 alain.hsu. All rights reserved.
//

#import "ViewReusePool.h"

@interface ViewReusePool ()

@property (nonatomic, strong) NSMutableSet *waitUsedQueue;

@property (nonatomic, strong) NSMutableSet *usingQueue;

@end

@implementation ViewReusePool

- (id)init {
    self = [super init];
    if (self) {
        _waitUsedQueue = [NSMutableSet set];
        _usingQueue = [NSMutableSet set];
    }
    return self;
}

- (UIView *)dequeueReusableView {
    UIView *view = [_waitUsedQueue anyObject];
    if (!view) {
        return nil;
    }else{
        //Move view between queues
        [_waitUsedQueue removeObject:view];
        [_usingQueue addObject:view];
        return view;
    }
}

- (void)addUsingView:(UIView *)view {
    if (view) {
        [_usingQueue addObject:view];
    }
}


- (void)reset {
    UIView *view = nil;
    while ((view = [_usingQueue anyObject])) {
        [_usingQueue removeObject:view];
        [_waitUsedQueue addObject:view];
    }
}

@end
