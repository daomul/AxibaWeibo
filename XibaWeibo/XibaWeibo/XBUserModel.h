//
//  XBUserModel.h(用户信息数据模型)
//  XibaWeibo
//
//  Created by K3CLOUDBOS on 15/7/31.
//  Copyright (c) 2015年 axiba. All rights reserved.
//

#import <UIKit/UIKit.h>

/**	enum  用户类型*/
typedef enum
{
    XBUserVerifiedTypeNone = -1, // 没有任何认证
    XBUserVerifiedPersonal = 0,  // 个人认证
    XBUserVerifiedOrgEnterprice = 2, // 企业官方：CSDN、EOE、搜狐新闻客户端
    XBUserVerifiedOrgMedia = 3, // 媒体官方：程序员杂志、苹果汇
    XBUserVerifiedOrgWebsite = 5, // 网站官方：猫扑
    XBUserVerifiedDaren = 220 // 微博达人
    
}XBUserVerifiedType;

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

/** 认证类型 */
@property (nonatomic, assign) XBUserVerifiedType verified_type;

/** 实例方法 初始化模型 只执行一次*/
//+(instancetype)initUserWithDict:(NSDictionary *)dict;

@end
