//
//  AppDelegate.m
//  NetworkRequest
//
//  Created by 郑冰津 on 2016/12/9.
//  Copyright © 2016年 IceGod. All rights reserved.
//

#import "AppDelegate.h"
#import "Nav_Base_VC.h"
#import "MainTabbar.h"
#import "MyToolsHeader.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    Nav_Base_VC *baseNav = [[Nav_Base_VC alloc]initWithRootViewController:[MainTabbar sharedMainTabbar]];
    baseNav.navigationBarHidden = YES;
    self.window.rootViewController = baseNav;
    [self.window makeKeyAndVisible];
    
    /*
     当多次请求之后,数据被缓存到沙盒中,作用是断网情况下仍然有数据存在,请在沙盒中,查看,如下代码:    NSURLCache *urlCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024 diskCapacity:20 * 1024 * 1024 diskPath:nil];[NSURLCache setSharedURLCache:urlCache];
     具体怎么样设置,怎么样使用,有很多细节,此处不一一解释
     //https://github.com/ChenYilong/ParseSourceCodeStudy
     //https://github.com/ChenYilong/ParseSourceCodeStudy/blob/master/02_Parse的网络缓存与离线存储/iOS网络缓存扫盲篇.md
     //http://ios.jobbole.com/91414/
     
     //http://www.jianshu.com/p/b1045c3fc8d0 基于AFNetWorking3.0的图片缓存分析
     
     */
    NSURLCache *urlCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024 diskCapacity:20 * 1024 * 1024 diskPath:nil];
    [NSURLCache setSharedURLCache:urlCache];
    NSLog(@"%@",NSHomeDirectory());
    
    
    
    [AFHTTPRequest netWorkDuplicates:YES status:^(AFHTTPNetworkType type) {
        NSLog(@"%lu",(unsigned long)type);
    }];
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
