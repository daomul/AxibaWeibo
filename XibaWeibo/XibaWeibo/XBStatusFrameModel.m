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

/*
 *  weibo 模型数据 设置的时候计算各个子控件的frame
 */
-(void)setStatus:(XBStatusModel *)status
{
    _status = status;
    
    XBUserModel *userM = status.user;
    
    /** 头像 **/
    CGFloat headIconWH = 35;
    CGFloat headIconXY = XBStatusCellBorderW;
    self.headIconViewF = CGRectMake(headIconWH, headIconWH, headIconXY, headIconXY);
    
    /** 原创微博整体 */
    CGFloat originalX = 0;
    CGFloat originalY = 0;
    CGFloat originalW = 100;
    CGFloat originalH = 100;
    self.originalViewF = CGRectMake(originalX, originalY, originalW, originalH);
    
}
@end
