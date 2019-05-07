//
//  AppDelegate.m
//  KVO_test
//
//  Created by Alain Hsu on 2019/5/3.
//  Copyright © 2019 alain.hsu. All rights reserved.
//

#import "AppDelegate.h"
#import "MObject.h"
#import "MObserver.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    MObject *obj = [MObject new];
    MObserver *observer = [MObserver new];
    
    //KVO method to observer obj value change
    [obj addObserver:observer forKeyPath:@"value" options:NSKeyValueObservingOptionNew context:NULL];
    //po object_getClassName(obj)

    //Modify value through setter method
    obj.value = 1;
    //po object_getClassName(obj)
    
    //1. 通过 KVC 设置 value 能否生效?
    //可以, 会调用 setter 方法从而触发 KVO
    [obj setValue:@2 forKey:@"value"];
    
    //2. 通过成员变量直接赋值 value 能否生效?
    //不可以, 需要手动添加 willChangeValueForKey:() 和 didChangeValueForKey:() 来模拟 KVO
    [obj increase];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
