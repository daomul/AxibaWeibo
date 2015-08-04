//
//  XBStatusTableViewCell.m
//  XibaWeibo
//
//  Created by K3CLOUDBOS on 15/8/2.
//  Copyright (c) 2015年 axiba. All rights reserved.
//

#import "XBStatusTableViewCell.h"
#import "XBStatusModel.h"
#import "XBStatusFrameModel.h"
#import "XBUserModel.h"
#import "UIImageView+WebCache.h"

@interface XBStatusTableViewCell()

    /* 原创微博 */
    /** 原创微博整体 */
    @property (nonatomic, weak) UIView *originalView;
    /** 头像 */
    @property (nonatomic, weak) UIImageView *headIconView;

@end

@implementation XBStatusTableViewCell

/**
  初始化构造cell
 */
+(instancetype)cellWithTableView:(UITableView *)tableView
{
    //1.构造cell
    static NSString *cellID = @"cellID";
    XBStatusTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[XBStatusTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    return cell;
}

/**
 *  cell的初始化方法，一个cell只会调用一次
 *  一般在这里添加所有可能显示的子控件，以及子控件的一次性设置
 */
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        /** 原创微博整体 */
        UIView *originalView = [[UIView alloc]init];
        [self.contentView addSubview:originalView];
        self.originalView = originalView;
        
        /** 头像 */
        UIImageView *headIconView = [[UIImageView alloc]init];
        [self.originalView addSubview:headIconView];
        self.headIconView = headIconView;
    }
    return self;
}

/**
 * 设置各个子控件的frame 以及对应的一些数据属性: XBStatusFrameModel *statusFrame;这个属性set方法
 */
-(void)setStatusFrame:(XBStatusFrameModel *)statusFrame
{
    _statusFrame = statusFrame;
    
    XBStatusModel *statusM = statusFrame.status;
    XBUserModel *userM = statusM.user;
    
    /** 原创微博整体 */
    self.originalView.frame = statusFrame.originalViewF;
    
    /** 会员图标 */
    self.headIconView.frame = statusFrame.headIconViewF;
    [self.headIconView sd_setImageWithURL:[NSURL URLWithString:userM.profile_image_url] placeholderImage:[UIImage imageNamed:@"avatar_default_small"]];
}


@end
