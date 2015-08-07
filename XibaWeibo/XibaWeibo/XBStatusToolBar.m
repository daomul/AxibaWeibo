//
//  XBStatusToolBar.m
//  XibaWeibo
//
//  Created by K3CLOUDBOS on 15/8/6.
//  Copyright (c) 2015年 axiba. All rights reserved.
//

#import "XBStatusToolBar.h"
#import "XBStatusModel.h"

@interface XBStatusToolBar()

/** 里面存放所有的按钮 */
@property (nonatomic, strong) NSMutableArray *btns;
/** 里面存放所有的分割线 */
@property (nonatomic,strong) NSMutableArray *dividers;

@property (nonatomic, weak) UIButton *repostBtn;
@property (nonatomic, weak) UIButton *commentBtn;
@property (nonatomic, weak) UIButton *attitudeBtn;

@end

@implementation XBStatusToolBar

#pragma mark -- init

+(instancetype)toolBar
{
    return [[self alloc]init];
}
-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"timeline_card_bottom_background"]];
        
        // 添加按钮
        self.repostBtn = [self setupStatusButton:@"转发" icon:@"timeline_icon_retweet"];
        self.commentBtn = [self setupStatusButton:@"评论" icon:@"timeline_icon_comment"];
        self.attitudeBtn = [self setupStatusButton:@"赞" icon:@"timeline_icon_unlike"];
        
        //添加分割线
        [self addDivider];
        [self addDivider];

    }
    return self;
}
#pragma mark -- life cycle
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    int btnCount = self.btns.count;
    CGFloat btnW = self.width / btnCount;
    CGFloat btnH = self.height;
    for (int i = 0; i < btnCount; i++)
    {
        UIButton *btn = self.btns[i];
        btn.y = 0;
        btn.x = btnW * i;
        btn.width = btnW;
        btn.height = btnH;
    }
    
    int dividerCount = self.dividers.count;
    for (int i = 0; i < dividerCount; i++)
    {
        UIImageView *img = self.dividers[i];
        img.x = btnW * (i + 1);
        img.y = 0;
        img.width = 1;
        img.height = btnH;
    }
}

#pragma mark -- private methods
/**
 * 添加分割线
 */
-(void)addDivider
{
    UIImageView *line = [[UIImageView alloc]init];
    line.image = [UIImage imageNamed:@"timeline_card_bottom_line"];
    
    [self addSubview:line];
    [self.dividers addObject:line];
}
/**
 *  动态设置三个按钮的基本属性
 */
-(UIButton *)setupStatusButton:(NSString *)title icon:(NSString *)icon
{
    UIButton *btn = [[UIButton alloc]init];
    [btn setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"timeline_card_bottom_background_highlighted"] forState:UIControlStateHighlighted];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    
    [self addSubview:btn];
    [self.btns addObject:btn];
    return btn;
}
/**
 *  动态设置三个按钮的数字
 */
-(void)setBtnCount:(int)count btn:(UIButton *)btn title:(NSString *)title
{
    if (count)
    {
        if (count < 10000)
        {
            title = [NSString stringWithFormat:@"%d",count];
        }
        else
        {
            double wan = count / 10000.0;
            title = [NSString stringWithFormat:@"%.1f万",wan];
            // 将字符串里面的.0去掉
            title = [title stringByReplacingOccurrencesOfString:@".0" withString:@""];
        }
    }
    [btn setTitle:title forState:UIControlStateNormal];
}

#pragma mark -- getter and setter

/**
 *  在cell中将微博模型传值过来，动态计算三个按钮数字
 */
-(void)setStatus:(XBStatusModel *)status
{
    _status = status;
    
    // 转发
    [self setBtnCount:status.reposts_count btn:self.repostBtn title:@"转发"];
    // 评论
    [self setBtnCount:status.comments_count btn:self.commentBtn title:@"评论"];
    // 赞
    [self setBtnCount:status.attitudes_count btn:self.attitudeBtn title:@"赞"];
    
}
-(NSMutableArray *)btns
{
    if (!_btns) {
        self.btns = [[NSMutableArray alloc]init];
    }
    return _btns;
}
-(NSMutableArray *)dividers
{
    if (!_dividers) {
        self.dividers = [[NSMutableArray alloc]init];
    }
    return _dividers;
}

@end
