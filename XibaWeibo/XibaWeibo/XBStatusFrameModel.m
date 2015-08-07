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
    self.headIconViewF = CGRectMake(headIconXY, headIconXY, headIconWH, headIconWH);
    
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
    
    /**配图*/
    CGFloat originalH = 0;
    if (status.pic_urls.count)
    {
        CGFloat photoX = contentX;
        CGFloat photoY = CGRectGetMaxY(self.contentLabelF) + XBStatusCellBorderW;
        CGSize photoSize = {100,100};
        self.photoViewF = (CGRect){{photoX,photoY},photoSize};
        
        originalH = CGRectGetMaxY(self.photoViewF) + XBStatusCellBorderW;
    }
    else
    {
        originalH = CGRectGetMaxY(self.contentLabelF) + XBStatusCellBorderW;
    }
    
    
    /** 原创微博整体 */
    CGFloat originalX = 0;
    CGFloat originalY = XBStatusCellBorderW;
    CGFloat originalW = cellW;
    
    self.originalViewF = CGRectMake(originalX, originalY, originalW, originalH);
    
    CGFloat toolBarY = 0;//因为被转发微博未必存在，要根据判断来计算Y值
    
    /* 被转发微博 */
    if (status.retweeted_status)
    {
        XBStatusModel *retweeted_status = status.retweeted_status;
        XBUserModel *retweeted_status_user = retweeted_status.user;
        
        /** 1. 被转发微博正文 */
        CGFloat retweetContentX = XBStatusCellBorderW;
        CGFloat retweetContentY = XBStatusCellBorderW;
        NSString *retweetContent = [NSString stringWithFormat:@"@%@ : %@", retweeted_status_user.name, retweeted_status.text];
        CGSize retweetContentSize = [self sizeWithText:retweetContent font:XBStatusCellRetweetContentFont maxW:maxW];
        self.retweetContentLabelF = (CGRect){{retweetContentX, retweetContentY}, retweetContentSize};

        /** 2. 被转发微博配图 */
        CGFloat retweetH = 0;
        if (retweeted_status.pic_urls.count)
        {
            CGFloat retweetPhotoWH = 100;
            CGFloat retweetPhotoX = retweetContentX;
            CGFloat retweetPhotoY =CGRectGetMaxY(self.retweetContentLabelF) + XBStatusCellBorderW;
            self.retweetPhotoViewF = (CGRect){{retweetPhotoX,retweetPhotoY},{retweetPhotoWH,retweetPhotoWH}};
            
            retweetH = CGRectGetMaxY(self.retweetPhotoViewF) + XBStatusCellBorderW;
        }
        else
        {
            retweetH = CGRectGetMaxY(self.retweetContentLabelF) + XBStatusCellBorderW;
        }
        /** 3. 被转发微博整体 */
        CGFloat retweetX = 0;
        CGFloat retweetY = CGRectGetMaxY(self.originalViewF);
        CGFloat retweetW = cellW;
        self.retweetViewF = CGRectMake(retweetX, retweetY, retweetW, retweetH);
        
        toolBarY = CGRectGetMaxY(self.retweetViewF);
    }
    else
    {
        toolBarY = CGRectGetMaxY(self.originalViewF);
    }
    
     /** 工具条 */
    CGFloat toolBarX = 0;
    CGFloat toolBarW = cellW;
    CGFloat toolBarH = 35;
    self.toolbarF = CGRectMake(toolBarX, toolBarY, toolBarW, toolBarH);
    
    /* cell的高度 */
    self.cellHeight = CGRectGetMaxY(self.toolbarF);
}
@end
