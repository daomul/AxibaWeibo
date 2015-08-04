//
//  XBStatusFrameModel.m
//  XibaWeibo
//
//  Created by K3CLOUDBOS on 15/8/2.
//  Copyright (c) 2015年 axiba. All rights reserved.
//

#import "XBStatusFrameModel.h"
#import "XBUserModel.h"
#import "XBStatusModel.h"

// cell的边框宽度
#define XBStatusCellBorderW 10

@implementation XBStatusFrameModel

#pragma mark -- 自定义方法

/**
 *  根据文字内容和字体大小计算宽度(有限制最大宽度)
 */
-(CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxW:(CGFloat)maxW
{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    
    //MAXFLOAT代表不做限制
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    return  [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}
/**
 *  根据文字内容和字体大小计算宽度(不做限制最大宽度)
 */
-(CGSize)sizeWithText:(NSString *)text font:(UIFont *)font
{
    return [self sizeWithText:text font:font maxW:MAXFLOAT];
}

#pragma mark -- getter and setter
/*
 *  weibo 模型数据 设置的时候计算各个子控件的frame
 */
-(void)setStatus:(XBStatusModel *)status
{
    _status = status;
    
    XBUserModel *userM = status.user;
    
    //cell的宽度
    CGFloat cellW = [UIScreen mainScreen].bounds.size.width;
    
    /** 头像 **/
    CGFloat headIconWH = 50;
    CGFloat headIconXY = XBStatusCellBorderW;
    self.headIconViewF = CGRectMake(headIconWH, headIconWH, headIconXY, headIconXY);
    
    /** 昵称*/
    CGFloat nameX = CGRectGetMaxX(self.headIconViewF) + XBStatusCellBorderW;
    CGFloat nameY = headIconXY;
    CGSize nameSize = [self sizeWithText:status.user.name font:XBStatusCellNameFont];
    self.nameLabelF = (CGRect){{nameX, nameY}, nameSize};
    
    /** 会员图标 */
    if (userM.isVip) {
        CGFloat vipX = CGRectGetMaxX(self.nameLabelF) + XBStatusCellBorderW;
        CGFloat vipY = nameY;
        CGFloat vipH = nameSize.height;
        CGFloat vipW = 14;
        self.vipViewF = CGRectMake(vipX, vipY, vipW, vipH);
    }
    /** 时间 */
    CGFloat timeX = nameX;
    CGFloat timeY = CGRectGetMaxY(self.nameLabelF) + XBStatusCellBorderW;
    CGSize timeSize = [self sizeWithText:status.created_at font:XBStatusCellTimeFont];
    self.timeLabelF = (CGRect){{timeX, timeY}, timeSize};
    
    /** 来源 */
    CGFloat sourceX = CGRectGetMaxX(self.timeLabelF) + XBStatusCellBorderW;
    CGFloat sourceY = timeY;
    CGSize sourceSize = [self sizeWithText:status.source font:XBStatusCellSourceFont];
    self.sourceLabelF = (CGRect){{sourceX, sourceY}, sourceSize};
    
    /** 正文 */
    CGFloat contentX = headIconXY;
    CGFloat contentY = MAX(CGRectGetMaxY(self.headIconViewF), CGRectGetMaxY(self.timeLabelF)) + XBStatusCellBorderW;
    CGFloat maxW = cellW - 2 * contentX;
    CGSize contentSize = [self sizeWithText:status.text font:XBStatusCellContentFont maxW:maxW];
    self.contentLabelF = (CGRect){{contentX, contentY}, contentSize};
    
    
    /** 原创微博整体 */
    CGFloat originalX = 0;
    CGFloat originalY = 0;
    CGFloat originalW = cellW;
    CGFloat originalH = CGRectGetMaxY(self.contentLabelF) + XBStatusCellBorderW;
    self.originalViewF = CGRectMake(originalX, originalY, originalW, originalH);
    
    
    self.cellHeight = CGRectGetMaxY(self.originalViewF);
}
@end
