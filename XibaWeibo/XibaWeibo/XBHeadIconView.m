//
//  XBHeadIconView.m
//  XibaWeibo
//
//  Created by K3CLOUDBOS on 15/8/9.
//  Copyright (c) 2015年 axiba. All rights reserved.
//

#import "XBHeadIconView.h"
#import "UIImageView+WebCache.h"
#import "XBUserModel.h"

@interface XBHeadIconView()

/** 头像左下角的标志*/
@property (nonatomic, assign) UIImageView *verifiedView;

@end

@implementation XBHeadIconView

#pragma mark -- life cycle

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        
    }
    return self;
}
-(void)layoutSubviews
{
    self.verifiedView.size = self.verifiedView.image.size;

    self.verifiedView.x = self.width - self.verifiedView.width * 0.6;
    self.verifiedView.y = self.height - self.verifiedView.height * 0.6;}

#pragma mark -- getter and setter
-(void)setUser:(XBUserModel *)user
{
    //1 下载头像
    [self sd_setImageWithURL:[NSURL URLWithString:user.profile_image_url] placeholderImage:[UIImage imageNamed:@"avatar_default_small"]];
    
    //2、设置左下会员标志
    switch (user.verified_type) {
        case XBUserVerifiedPersonal: // 个人认证
            self.verifiedView.hidden = NO;
            self.verifiedView.image = [UIImage imageNamed:@"avatar_vip"];
            break;
            
        case XBUserVerifiedOrgEnterprice:
        case XBUserVerifiedOrgMedia:
        case XBUserVerifiedOrgWebsite: // 官方认证
            self.verifiedView.hidden = NO;
            self.verifiedView.image = [UIImage imageNamed:@"avatar_enterprise_vip"];
            break;
            
        case XBUserVerifiedDaren: // 微博达人
            self.verifiedView.hidden = NO;
            self.verifiedView.image = [UIImage imageNamed:@"avatar_grassroot"];
            break;
            
        default:
            self.verifiedView.hidden = YES; // 当做没有任何认证
            break;
    }
}
-(UIImageView *)verifiedView
{
    if (!_verifiedView)
    {
        UIImageView *image = [[UIImageView alloc]init];
        [self addSubview:image];
        self.verifiedView = image;
    }
    return _verifiedView;
}
@end
