//
//  XBStatusModel.h(微博数据模型)
//  XibaWeibo
//
//  Created by K3CLOUDBOS on 15/7/31.
//  Copyright (c) 2015年 axiba. All rights reserved.
//

#import <Foundation/Foundation.h>
@class XBUserModel;

@interface XBStatusModel : NSObject

/**	string	字符串型的微博ID*/
@property (nonatomic,copy) NSString *idstr;

/**	string	微博信息内容*/
@property (nonatomic,copy)NSString *text;

/**	object	微博作者的用户信息字段 详细*/
@property (nonatomic,strong)XBUserModel *user;

/** 实例方法 初始化模型 只执行一次*/
+(instancetype)initStatusWithDict:(NSDictionary *)dict;

@end
