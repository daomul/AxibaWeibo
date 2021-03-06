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
#import "XBStatusPhotosView.h"


@implementation XBStatusFrameModel

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
    CGSize nameSize = [status.user.name sizeWithTextFont:XBStatusCellNameFont];
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
    CGSize timeSize = [status.created_at sizeWithTextFont:XBStatusCellTimeFont];
    self.timeLabelF = (CGRect){{timeX, timeY}, timeSize};
    
    /** 来源 */
    CGFloat sourceX = CGRectGetMaxX(self.timeLabelF) + XBStatusCellBorderW;
    CGFloat sourceY = timeY;
    CGSize sourceSize = [status.source sizeWithTextFont:XBStatusCellSourceFont];
    self.sourceLabelF = (CGRect){{sourceX, sourceY}, sourceSize};
    
    /** 正文 */
    CGFloat contentX = headIconXY;
    CGFloat contentY = MAX(CGRectGetMaxY(self.headIconViewF), CGRectGetMaxY(self.timeLabelF)) + XBStatusCellBorderW;
    CGFloat maxW = cellW - 2 * contentX;
    CGSize contentSize = [status.text sizeWithTextFont:XBStatusCellContentFont maxW:maxW];
    self.contentLabelF = (CGRect){{contentX, contentY}, contentSize};
    
    /**配图*/
    CGFloat originalH = 0;
    if (status.pic_urls.count)
    {
        CGFloat photoX = contentX;
        CGFloat photoY = CGRectGetMaxY(self.contentLabelF) + XBStatusCellBorderW;
        CGSize photosSize = [XBStatusPhotosView sizeWithCount:status.pic_urls.count];
        self.photosViewF = (CGRect){{photoX,photoY},photosSize};
        
        originalH = CGRectGetMaxY(self.photosViewF) + XBStatusCellBorderW;
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
        CGSize retweetContentSize = [retweetContent sizeWithTextFont:XBStatusCellRetweetContentFont maxW:maxW];
        self.retweetContentLabelF = (CGRect){{retweetContentX, retweetContentY}, retweetContentSize};

        /** 2. 被转发微博配图 */
        CGFloat retweetH = 0;
        if (retweeted_status.pic_urls.count)
        {
            CGFloat retweetPhotoWH = 100;
            CGFloat retweetPhotoX = retweetContentX;
            CGFloat retweetPhotoY =CGRectGetMaxY(self.retweetContentLabelF) + XBStatusCellBorderW;
            CGSize retweetPhotosSize = [XBStatusPhotosView sizeWithCount:retweeted_status.pic_urls.count];
            self.retweetPhotosViewF = (CGRect){{retweetPhotoX,retweetPhotoY},retweetPhotosSize};
            
            retweetH = CGRectGetMaxY(self.retweetPhotosViewF) + XBStatusCellBorderW;
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
