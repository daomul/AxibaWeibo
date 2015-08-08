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
#import "XBPhotoModel.h"
#import "XBStatusToolBar.h"

@interface XBStatusTableViewCell()

    /* 原创微博 */
    /** 原创微博整体 */
    @property (nonatomic, weak) UIView *originalView;
    /** 头像 */
    @property (nonatomic, weak) UIImageView *headIconView;
    /** 会员图标 */
    @property (nonatomic, weak) UIImageView *vipView;
    /** 配图 */
    @property (nonatomic, weak) UIImageView *photoView;
    /** 昵称 */
    @property (nonatomic, weak) UILabel *nameLabel;
    /** 时间 */
    @property (nonatomic, weak) UILabel *timeLabel;
    /** 来源 */
    @property (nonatomic, weak) UILabel *sourceLabel;
    /** 正文 */
    @property (nonatomic, weak) UILabel *contentLabel;


    /* 转发微博 */
    /** 转发微博整体 */
    @property (nonatomic, weak) UIView *retweetView;
    /** 转发微博正文 + 昵称 */
    @property (nonatomic, weak) UILabel *retweetContentLabel;
    /** 转发配图 */
    @property (nonatomic, weak) UIImageView *retweetPhotoView;

    /** 工具条 */
    @property (nonatomic, weak) XBStatusToolBar *toolbar;

@end

@implementation XBStatusTableViewCell

#pragma mark -- init
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
        //点击cell的时候不变色
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //初始化原创微博
        [self setOriginalStatus];
        //初始化转发微博
        [self setRetweetStatus];
        //初始化工具条
        [self setupStatusToolBar];
    }
    return self;
}

#pragma  mark -- private method

/**
 * 初始化原创微博
 */
-(void)setOriginalStatus
{
    /** 原创微博整体 */
    UIView *originalView = [[UIView alloc]init];
    [self.contentView addSubview:originalView];
    originalView.backgroundColor = [UIColor whiteColor];
    self.originalView = originalView;
    
    /** 头像 */
    UIImageView *headIconView = [[UIImageView alloc]init];
    [self.originalView addSubview:headIconView];
    self.headIconView = headIconView;
    
    /** 会员图标*/
    UIImageView *vipView = [[UIImageView alloc]init];
    vipView.contentMode = UIViewContentModeCenter;
    [self.originalView addSubview:vipView];
    self.vipView = vipView;
    
    /** 配图 */
    UIImageView *photosView = [[UIImageView alloc]init];
    [self.originalView addSubview:photosView];
    self.photoView = photosView;
    
    /** 昵称 */
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.font = XBStatusCellNameFont;
    [self.originalView addSubview:nameLabel];
    self.nameLabel =  nameLabel;
    
    /** 时间 */
    UILabel *timeLabel = [[UILabel alloc]init];
    timeLabel.font = XBStatusCellTimeFont;
    timeLabel.textColor = [UIColor orangeColor];
    [self.originalView addSubview:timeLabel];
    self.timeLabel = timeLabel;
    
    /** 来源 */
    UILabel *sourceLabel = [[UILabel alloc] init];
    sourceLabel.font = XBStatusCellSourceFont;
    [originalView addSubview:sourceLabel];
    self.sourceLabel = sourceLabel;
    
    /** 正文 */
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.font = XBStatusCellContentFont;
    contentLabel.numberOfLines = 0;
    [originalView addSubview:contentLabel];
    self.contentLabel = contentLabel;
}


/**
 * 初始化转发微博
 */
-(void)setRetweetStatus
{
    /** 转发微博整体 */
    UIView *retweetView = [[UIView alloc]init];
    retweetView.backgroundColor = XBColor(241, 241, 241);
    [self.contentView addSubview:retweetView];
    self.retweetView = retweetView;
    
    /** 转发微博正文 + 昵称 */
    UILabel *retweetContentLabel = [[UILabel alloc]init];
    retweetContentLabel.numberOfLines = 0;
    retweetContentLabel.font = XBStatusCellRetweetContentFont;
    [self.retweetView addSubview:retweetContentLabel];
    self.retweetContentLabel = retweetContentLabel;
    
    /** 转发微博配图 */
    UIImageView *retweetPhotoImageView = [[UIImageView alloc]init];
    [self.retweetView addSubview:retweetPhotoImageView];
    self.retweetPhotoView = retweetPhotoImageView;
}

/**
 * 初始化工具条
 */
-(void)setupStatusToolBar
{
    XBStatusToolBar *toolBar = [XBStatusToolBar toolBar];
    [self.contentView addSubview:toolBar];
    self.toolbar = toolBar;
}

#pragma  mark -- getter and setter
/**
 * 设置各个子控件的frame 以及对应的一些数据属性: XBStatusFrameModel *statusFrame;这个属性set方法1
 */
-(void)setStatusFrame:(XBStatusFrameModel *)statusFrame
{
    _statusFrame = statusFrame;
    
    XBStatusModel *statusM = statusFrame.status;
    XBUserModel *userM = statusM.user;
    
    /** 原创微博整体 */
    self.originalView.frame = statusFrame.originalViewF;
    
    /** 会员头像 */
    self.headIconView.frame = statusFrame.headIconViewF;
    [self.headIconView sd_setImageWithURL:[NSURL URLWithString:userM.profile_image_url] placeholderImage:[UIImage imageNamed:@"avatar_default_small"]];
    
    /** 昵称 */
    self.nameLabel.text = userM.name;
    self.nameLabel.frame = statusFrame.nameLabelF;
    
    /** 会员图标 */
    if (userM.isVip) {
        self.vipView.hidden = NO;
        
        self.vipView.frame = statusFrame.vipViewF;
        NSString *vipName = [NSString stringWithFormat:@"common_icon_membership_level%d", userM.mbrank];
        self.vipView.image = [UIImage imageNamed:vipName];
        
        self.nameLabel.textColor = [UIColor orangeColor];
    } else {
        self.nameLabel.textColor = [UIColor blackColor];
        self.vipView.hidden = YES;
    }
    
    /** 配图 */
    if (statusM.pic_urls.count) {
        self.photoView.frame = statusFrame.photoViewF;
        XBPhotoModel *photoM = [statusM.pic_urls firstObject];
        [self.photoView sd_setImageWithURL:[NSURL URLWithString:photoM.thumbnail_pic] placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]];
        self.photoView.hidden = NO;
    }
    else
    {
        self.photoView.hidden = YES;
    }
    
    /** 时间 */
    self.timeLabel.text = statusM.created_at;
    self.timeLabel.frame = statusFrame.timeLabelF;
    
    /** 来源 */
    self.sourceLabel.text = statusM.source;
    self.sourceLabel.frame = statusFrame.sourceLabelF;
    
    /** 正文 */
    self.contentLabel.text = statusM.text;
    self.contentLabel.frame = statusFrame.contentLabelF;
    
    /** 被转发的微博 */
    if (statusM.retweeted_status)
    {
        XBStatusModel *retweetStatus = statusM.retweeted_status;
        XBUserModel *retweetUser = retweetStatus.user;
        /** 被转发的微博整体 */
        self.retweetView.frame = statusFrame.retweetViewF;
        
        /** 被转发的微博正文 */
        NSString *retweetContent = [NSString stringWithFormat:@"%@ : %@",retweetUser.name,retweetStatus.text];
        self.retweetContentLabel.frame = statusFrame.retweetContentLabelF;
        self.retweetContentLabel.text = retweetStatus.text;
        
        /** 被转发的微博配图 */
        if (retweetStatus.pic_urls.count)
        {
            self.retweetPhotoView.frame = statusFrame.retweetPhotoViewF;
            XBPhotoModel *retweetPhoto = [retweetStatus.pic_urls firstObject];
            [self.retweetPhotoView sd_setImageWithURL:[NSURL URLWithString:retweetPhoto.thumbnail_pic] placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]];
            self.retweetPhotoView.hidden = NO;
        }
        else
        {
            self.retweetPhotoView.hidden = YES;
        }
        self.retweetView.hidden = NO;
    }
    else
    {
        self.retweetView.hidden = YES;
    }
    
    /**工具条*/
    self.toolbar.frame = statusFrame.toolbarF;
    self.toolbar.status = statusM;
}


@end
