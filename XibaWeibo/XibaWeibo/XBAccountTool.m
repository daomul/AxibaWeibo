//
//  XBAccountTool.m
//  XibaWeibo
//
//  Created by K3CLOUDBOS on 15/7/30.
//  Copyright (c) 2015年 axiba. All rights reserved.
//

// 账号的存储路径
#define XBAccountPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account.archive"]


#import "XBAccountTool.h"

@implementation XBAccountTool

/**
 *  存储账号信息
 *
 *  @param account 账号模型
 */
+(void)saveAccount:(XBAccount *)account
{
    // 自定义对象的存储必须用NSKeyedArchiver，不再有什么writeToFile方法
    [NSKeyedArchiver archiveRootObject:account toFile:XBAccountPath];
}

/**
 *  返回账号信息
 *
 *  @return 账号模型（如果账号过期，返回nil）
 */

+(XBAccount *)account
{
    //加载模型
    XBAccount *account = [NSKeyedUnarchiver unarchiveObjectWithFile:XBAccountPath];
    
    if (account != nil)
    {
        /* 验证账号是否过期 */
        
        // 过期的秒数
        long long second = [account.expires_in longLongValue];
        // 获得过期时间
        NSDate *date = [account.created_time dateByAddingTimeInterval:second];
        // 获得当前时间
        NSDate *now = [NSDate date];
        
        // 过期返回nil（也就是当前时间超过了过期时间）
        NSComparisonResult result = [date compare:now];
        if (result != NSOrderedDescending) {
            return nil;
        }
    }
    
    return account;
}

@end
