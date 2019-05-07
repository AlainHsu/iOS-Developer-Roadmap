//
//  MObject.m
//  KVO_test
//
//  Created by Alain Hsu on 2019/5/3.
//  Copyright © 2019 alain.hsu. All rights reserved.
//

#import "MObject.h"

@interface MObject () {
    int _privValue;
}

@end

@implementation MObject

- (instancetype)init
{
    self = [super init];
    if (self) {
        _value = 0;
        _privValue = 0;
    }
    return self;
}

- (void)increase
{
    [self willChangeValueForKey:@"value"];
    _value += 1;
    [self didChangeValueForKey:@"value"];
}

@end
