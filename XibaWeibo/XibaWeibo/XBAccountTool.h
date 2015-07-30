//
//  XBAccountTool.h
//  XibaWeibo 用来操作模型（存进沙盒）的业务工具类
//
//  Created by K3CLOUDBOS on 15/7/30.
//  Copyright (c) 2015年 axiba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XBAccount.h"


@interface XBAccountTool : NSObject
/**
 *  存储账号信息
 *
 *  @param account 账号模型
 */
+(void)saveAccount:(XBAccount *)account;
/**
 *  返回账号信息
 *
 *  @return 账号模型（如果账号过期，返回nil）
 */
+(XBAccount *)account;
@end
