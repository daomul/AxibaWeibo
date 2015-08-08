//
//  NSDate+Extension.m
//  XibaWeibo
//
//  Created by K3CLOUDBOS on 15/8/7.
//  Copyright (c) 2015年 axiba. All rights reserved.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)

/**
 *  判断某个时间是否为今年
 */
-(BOOL)isThisYear
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 获得某个时间的年月日时分秒
    NSDateComponents *dateCmps = [calendar components:NSCalendarUnitYear fromDate:self];
    NSDateComponents *nowCmps = [calendar components:NSCalendarUnitYear fromDate:[NSDate date]];
    
    return dateCmps.year == nowCmps.year;
}

/**
 *  判断某个时间是否为今天
 */
-(BOOL)isToday
{
    // 1、设置日期格式
    NSDateFormatter *formate = [[NSDateFormatter alloc]init];
    formate.dateFormat = @"yyyy-MM-dd";
    NSDate *now = [NSDate date];
    
    //2. 转换成字符串好比较
    NSString *createString = [formate stringFromDate:self];
    NSString *nowStirng = [formate stringFromDate:now];
    
    return [createString isEqualToString:nowStirng];
}

/**
 *  判断某个时间是否为昨天
 */
- (BOOL)isYesterday
{
    //1、 设置日期格式
    NSDateFormatter *formate = [[NSDateFormatter alloc]init];
    formate.dateFormat = @"yyyy-MM--dd";
    NSDate *now = [NSDate date];
    
    //2、转换成字符串
    NSString *createString = [formate stringFromDate:self];
    NSString *nowString  = [formate stringFromDate:now];
    
    // 3、再转化成日期date的类型好比较
    NSDate *createDate = [formate dateFromString:createString];
    NSDate *nowDate = [formate dateFromString:nowString];
    
    // 4、根据本地化的日历计算和微博时间的差距
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitMonth |NSCalendarUnitYear;
    NSDateComponents *componets = [calendar components:unit fromDate:createDate toDate:nowDate options:0];
    
    return componets.year == 0 && componets.month == 0 && componets.day == 1;
}
@end
