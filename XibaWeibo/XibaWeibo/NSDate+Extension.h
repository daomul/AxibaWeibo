//
//  NSDate+Extension.h
//  XibaWeibo
//
//  Created by K3CLOUDBOS on 15/8/7.
//  Copyright (c) 2015年 axiba. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extension)
/**
 *  判断某个时间是否为今年
 */

-(BOOL)isThisYear;
/**
 *  判断某个时间是否为今天
 */

-(BOOL)isToday;
/**
 *  判断某个时间是否为昨天
 */
- (BOOL)isYesterday;
@end
