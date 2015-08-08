//
//  XBStatusModel.m
//  XibaWeibo
//
//  Created by K3CLOUDBOS on 15/7/31.
//  Copyright (c) 2015年 axiba. All rights reserved.
//

#import "XBStatusModel.h"
#import "MJExtension.h"
#import "XBPhotoModel.h"
//#import "XBUserModel.h"

@implementation XBStatusModel

/**
 *  通过设置数组字段和模型的对应关系，MJExtension才知道这个数组存放的是什么玩意
 */
-(NSDictionary *)objectClassInArray
{
    return @{@"pic_urls" : [XBPhotoModel class]};
}

#pragma mark -- getter and setter

/*
 *  在cell中取“时间“字段的值，自然会调用它的get方法
 */
-(NSString *)created_at
{
    // 设置日期格式（声明字符串里面每个数字和单词的含义）
    // E:星期几
    // M:月份
    // d:几号(这个月的第几天)
    // H:24小时制的小时
    // m:分钟
    // s:秒
    // y:年
    
    //1、设置日期格式以及国际化
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    
    //  1.1 如果是真机调试，转换这种欧美时间，需要设置locale
    format.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
    //  1.2 根据服务端返回的数据格式转化_created_at = @"Tue Sep 30 17:06:25 +0800 2014";
    format.dateFormat = @"EEE MMM dd HH:mm:ss Z yyyy";
    
    //2、计算当前日期和来源日期的时间差
    NSDate *createDate = [format dateFromString:_created_at];
    NSDate *nowDate = [NSDate date];
    
    //  2.1 创建一个日历对象以及对应需要对比的枚举值，例如年月日 （方便比较两个日期之间的差值）
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *components = [calendar components:unit fromDate:createDate toDate:nowDate options:0];
    
    //3、 判断逻辑，判断是否今年、是否今天、昨天、是否大于一小时、是否1-59分钟内，是否1分钟内（刚刚）
    if ([createDate isThisYear])
    {
        if ([createDate isToday])
        {
            if (components.hour >= 1)
            {
                return [NSString stringWithFormat:@"%ld小时前",(long)components.hour];
            }
            else if (components.minute >= 1)
            {
                return [NSString stringWithFormat:@"%ld分钟前",(long)components.minute];
            }
            else
            {
                return [NSString stringWithFormat:@"刚刚"];
            }
        }
        else if([createDate isYesterday])
        {
            format.dateFormat = @"昨天 HH:mm";
            return [format stringFromDate:createDate];
        }
        else
        {
            format.dateFormat = @"mm-dd HH:mm";
            return  [format stringFromDate:createDate];
        }
    }
    else
    {
        format.dateFormat = @"yyyy-mm-dd HH:mm";
        return [format stringFromDate:createDate];
    }
}

/*
 *  在cell中取“来源“字段的值，自然会调用它的get方法
 *  为什么用set方法不用get方法，因为cell滑动复用的时候get方法会不断调用，
 *  来源是固定的，基本不会改变所以set一次就够了，时间会根据日期不断变化，会改变，所以用get方法
 */
-(void)setSource:(NSString *)source
{
    // source == <a href="http://app.weibo.com/t/feed/2llosp" rel="nofollow">OPPO_N1mini</a>
    NSRange range;
    
    if (![source isEqualToString:@""]) {
        range.location = [source rangeOfString:@">"].location + 1;
        range.length = [source rangeOfString:@"<" options:NSBackwardsSearch].location - range.location;
        _source = [NSString stringWithFormat:@"来自 %@",[source substringWithRange:range]];
    }
}

//+(instancetype)initStatusWithDict:(NSDictionary *)dict
//{
//    XBStatusModel *model = [[self alloc]init];
//    model.idstr = dict[@"idstr"];
//    model.text = dict[@"text"];
//    
//    //这里需要注意的是user字段也是一个模型
//    model.user = [XBUserModel initUserWithDict:dict[@"user"]];
//    
//    return model;
//}

@end
