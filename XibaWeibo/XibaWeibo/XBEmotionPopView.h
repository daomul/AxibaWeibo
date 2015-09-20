//
//  XBEmotionPopView.h
//  XibaWeibo
//
//  Created by zzl on 15/8/29.
//  Copyright (c) 2015年 axiba. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XBEmotion,XBEmotionButton;
@interface XBEmotionPopView : UIView

+ (instancetype)popView;

-(void)showFrom:(XBEmotionButton *)button;
@end
