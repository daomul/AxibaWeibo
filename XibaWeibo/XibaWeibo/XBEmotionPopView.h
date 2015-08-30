//
//  XBEmotionPopView.h
//  XibaWeibo
//
//  Created by zzl on 15/8/29.
//  Copyright (c) 2015年 axiba. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XBEmotion;
@interface XBEmotionPopView : UIView

@property(nonatomic,strong)XBEmotion *emotion;

+ (instancetype)popView;
@end
