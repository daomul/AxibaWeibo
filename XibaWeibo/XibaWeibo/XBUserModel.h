//
//  XBUserModel.h(用户信息数据模型)
//  XibaWeibo
//
//  Created by K3CLOUDBOS on 15/7/31.
//  Copyright (c) 2015年 axiba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XBUserModel : NSObject

/**	string	字符串型的用户UID*/
@property(nonatomic,copy) NSString *idstr;

/**	string	友好显示名称*/
@property (nonatomic,strong) NSString *name;

/**	string	用户头像地址，50×50像素*/
@property (nonatomic, copy) NSString *profile_image_url;

/** 会员类型 > 2代表是会员 */
@property(nonatomic,assign) int mbtype;

/** 会员等级*/
@property(nonatomic,assign) int mbrank;
@property(nonatomic,assign,getter=isVip) BOOL isVip;

/** 实例方法 初始化模型 只执行一次*/
//+(instancetype)initUserWithDict:(NSDictionary *)dict;

@end
