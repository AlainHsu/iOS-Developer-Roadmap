//
//  MObject.h
//  KVO_test
//
//  Created by Alain Hsu on 2019/5/3.
//  Copyright © 2019 alain.hsu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MObject : NSObject

@property (nonatomic, assign) int value;

- (void)increase;

@end

NS_ASSUME_NONNULL_END
