//
//  XBAccount.m 账户信息模型
//  XibaWeibo
//
//  Created by K3CLOUDBOS on 15/7/28.
//  Copyright (c) 2015年 axiba. All rights reserved.
//

#import "XBAccount.h"

@implementation XBAccount

+ (instancetype)accountWithDict:(NSDictionary *)dict
{
    XBAccount *account = [[self alloc]init];
    account.access_token = dict[@"access_token"];
    account.uid = dict[@"uid"];
    account.expires_in = dict[@"expires_in"];
    
    return account;
}

/**
 *  当一个对象要归档进沙盒中时，就会调用这个方法(要遵守NSCodeing协议)
 *  目的：在这个方法中说明这个对象的哪些属性要存进沙盒
 */
-(void)encodeWithCoder:(NSCoder *)enCoder
{
    [enCoder encodeObject:self.access_token forKey:@"access_token"];
    [enCoder encodeObject:self.expires_in forKey:@"expires_in"];
    [enCoder encodeObject:self.uid forKey:@"uid"];
    [enCoder encodeObject:self.created_time forKey:@"created_time"];
}

/**
 *  当从沙盒中解档一个对象时（从沙盒中加载一个对象时），就会调用这个方法
 *  目的：在这个方法中说明沙盒中的属性该怎么解析（需要取出哪些属性）
 */
-(id)initWithCoder:(NSCoder *)decoder
{
    if(self = [super init])
    {
        self.access_token = [decoder decodeObjectForKey:@"access_token"];
        self.expires_in = [decoder decodeObjectForKey:@"expires_in"];
        self.uid = [decoder decodeObjectForKey:@"uid"];
        self.created_time = [decoder decodeObjectForKey:@"created_time"];
    }
    return self;
}

@end
