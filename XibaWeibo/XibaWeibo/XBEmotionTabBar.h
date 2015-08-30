//
//  XBEmotionTabBar.h
//  XibaWeibo
//
//  Created by K3CLOUDBOS on 15/8/17.
//  Copyright (c) 2015年 axiba. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    XBEmotionTabBarButtonTypeRecent, // 最近
    XBEmotionTabBarButtonTypeDefault, // 默认
    XBEmotionTabBarButtonTypeEmoji, // emoji
    XBEmotionTabBarButtonTypeLxh, // 浪小花
} XBEmotionTabBarButtonType;

//构建一个协议，点击tarBar方法
@class XBEmotionTabBar;
@protocol XBEmotionTarBarDelegate <NSObject>

@optional
-(void)emotionTarBar:(XBEmotionTabBar *)tarBar didSelectTarBarButton:(XBEmotionTabBarButtonType)buttonType;

@end

@interface XBEmotionTabBar : UIView

@property(nonatomic,weak)id<XBEmotionTarBarDelegate>  delegate;
@end
