//
//  XBStatusFrameModel.h
//  XibaWeibo
//
//  Created by K3CLOUDBOS on 15/8/2.
//  Copyright (c) 2015年 axiba. All rights reserved.
//

#import <Foundation/Foundation.h>

// 昵称字体
#define XBStatusCellNameFont [UIFont systemFontOfSize:15]
// 时间字体
#define XBStatusCellTimeFont [UIFont systemFontOfSize:12]
// 来源字体
#define XBStatusCellSourceFont XBStatusCellTimeFont
// 正文字体
#define XBStatusCellContentFont [UIFont systemFontOfSize:14]
// 被转发微博的正文字体
#define XBStatusCellRetweetContentFont [UIFont systemFontOfSize:13]

// cell的边框宽度
#define XBStatusCellBorderW 10

@class XBStatusModel;

@interface XBStatusFrameModel : NSObject

/** 微博模型数据 */
@property (nonatomic,strong) XBStatusModel *status;
/** 原创微博整体 */
@property (nonatomic, assign) CGRect originalViewF;
/** 头像 */
@property (nonatomic, assign) CGRect headIconViewF;
/** 会员图标 */
@property (nonatomic, assign) CGRect vipViewF;
/** 配图 */
@property (nonatomic, assign) CGRect photosViewF;
/** 昵称 */
@property (nonatomic, assign) CGRect nameLabelF;
/** 时间 */
@property (nonatomic, assign) CGRect timeLabelF;
/** 来源 */
@property (nonatomic, assign) CGRect sourceLabelF;
/** 正文 */
@property (nonatomic, assign) CGRect contentLabelF;


/** 转发微博整体 */
@property (nonatomic, assign) CGRect retweetViewF;
/** 转发微博正文 + 昵称 */
@property (nonatomic, assign) CGRect retweetContentLabelF;
/** 转发配图 */
@property (nonatomic, assign) CGRect retweetPhotosViewF;

/** 底部工具条 */
@property (nonatomic, assign) CGRect toolbarF;

/** cell的高度 */
@property (nonatomic, assign) CGFloat cellHeight;


@end
