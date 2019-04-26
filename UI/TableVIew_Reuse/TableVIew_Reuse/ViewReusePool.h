//
//  ViewReusePool.h
//  TableVIew_Reuse
//
//  Created by Alain Hsu on 2019/4/23.
//  Copyright © 2019 alain.hsu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//Class for view reuse
@interface ViewReusePool : NSObject

//Retrive a reusable view from reuse-pool
- (UIView *)dequeueReusableView;

//Add a view to reuse-pool
- (void)addUsingView:(UIView *)view;

//Move all current views to reusable queue
- (void)reset;

@end

NS_ASSUME_NONNULL_END
