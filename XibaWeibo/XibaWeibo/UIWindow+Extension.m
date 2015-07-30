//
//  UIWindow+Extension.m
//  XibaWeibo
//
//  Created by K3CLOUDBOS on 15/7/30.
//  Copyright (c) 2015年 axiba. All rights reserved.
//

#import "UIWindow+Extension.h"
#import "XBTabBarViewController.h"
#import "NewfeatureController.h"

@implementation UIWindow (Extension)

-(void)switchRootViewController
{
    //2.1 取出沙盒中的版本号
    NSString *key = @"CFBundleVersion";
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    
    //2.2 取出当前APP的版本号
    NSString *currnetVersion =[NSBundle mainBundle].infoDictionary[key];
    
    //2.3 比较版本号，如果不相同说明需要显示新特性
    if ([lastVersion isEqualToString:currnetVersion]) {
        
        UITabBarController *tabBarVC = [[XBTabBarViewController alloc]init];
        self.rootViewController = tabBarVC;
        
    }else{
        self.rootViewController = [[NewfeatureController alloc]init];
        
        //版本号不相同，需要将新的版本号存入，但是存入的时间是随机的，所以需要马上执行存入操作
        [[NSUserDefaults standardUserDefaults]setObject:currnetVersion forKey:key];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
}
@end
