//
//  XBUserModel.m
//  XibaWeibo
//
//  Created by K3CLOUDBOS on 15/7/31.
//  Copyright (c) 2015年 axiba. All rights reserved.
//

#import "XBUserModel.h"

@implementation XBUserModel

+(instancetype)initUserWithDict:(NSDictionary *)dict
{
    XBUserModel *model = [[self alloc]init];
    model.idstr = dict[@"idstr"];
    model.name = dict[@"name"];
    model.profile_image_url = dict[@"profile_image_url"];
    
    return model;
}

@end
