//
//  AppDelegate.m
//  XibaWeibo
//
//  Created by bos on 15-6-4.
//  Copyright (c) 2015年 axiba. All rights reserved.
//



#import "AppDelegate.h"
#import "XBTabBarViewController.h"
#import "NewfeatureController.h"
#import "XBOAuthViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //1、创建窗体[当前模拟器的窗体是iOS8.1，所以导致7.1的时候有问题？待考证]
    self.window = [[UIWindow alloc]init];
    self.window.frame = [UIScreen mainScreen].bounds;
    
    //2、设置根控制器
    self.window.rootViewController = [[XBOAuthViewController alloc] init];
    
    /*
    //2、引入新特性的判断
    
    //2.1 取出沙盒中的版本号
    NSString *key = @"CFBundleVersion";
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    
    //2.2 取出当前APP的版本号
    NSString *currnetVersion =[NSBundle mainBundle].infoDictionary[key];
 
    //2.3 比较版本号，如果不相同说明需要显示新特性
    if ([lastVersion isEqualToString:currnetVersion]) {
        
        UITabBarController *tabBarVC = [[XBTabBarViewController alloc]init];
        self.window.rootViewController = tabBarVC;
        
    }else{
        self.window.rootViewController = [[NewfeatureController alloc]init];
        
        //版本号不相同，需要将新的版本号存入，但是存入的时间是随机的，所以需要马上执行存入操作
        [[NSUserDefaults standardUserDefaults]setObject:currnetVersion forKey:key];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    */
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
