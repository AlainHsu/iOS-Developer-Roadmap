//
//  MObserver.m
//  KVO_test
//
//  Created by Alain Hsu on 2019/5/3.
//  Copyright © 2019 alain.hsu. All rights reserved.
//

#import "MObserver.h"
#import "MObject.h"

@implementation MObserver

- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary<NSKeyValueChangeKey, id> *)change context:(nullable void *)context {
    
    if ([object isKindOfClass:[MObject class]] && [keyPath isEqualToString:@"value"]) {
        NSNumber *valueNum = [change valueForKey:NSKeyValueChangeNewKey];
        NSLog(@"value is %@", valueNum);
    }
}

@end
