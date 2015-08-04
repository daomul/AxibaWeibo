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
