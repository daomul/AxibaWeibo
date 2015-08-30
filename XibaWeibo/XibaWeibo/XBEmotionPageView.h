//
//  XBEmotionPageView.h
//  XibaWeibo
//
//  Created by zzl on 15/8/29.
//  Copyright (c) 2015年 axiba. All rights reserved.
// 用来表示一页的表情（里面显示1~20个表情）


#import <UIKit/UIKit.h>

// 一页中最多3行
#define XBEmotionMaxRows 3
// 一行中最多7列
#define XBEmotionMaxCols 7
// 每一页的表情个数
#define XBEmotionPageSize ((XBEmotionMaxRows * XBEmotionMaxCols) - 1)

@interface XBEmotionPageView : UIView

/** 这一页显示的表情（里面都是HWEmotion模型） */
@property (nonatomic, strong) NSArray *emotions;

@end
