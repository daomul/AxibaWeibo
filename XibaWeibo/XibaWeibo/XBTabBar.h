//
//  XBTabBar.h
//  XibaWeibo
//
//  Created by bos on 15-7-20.
//  Copyright (c) 2015年 axiba. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XBTabBar;

//1、因为XBtabBar继承自UITarBar，所以如果想建立自己的代理，也需要实现UITaBar的代理协议UITabBarDelegate
@protocol XBTabBarDelegate <UITabBarDelegate>

//2、设置可选的代理方法
@optional
-(void)tabBarDidClickButton:(XBTabBar *)tarBar;

@end

@interface XBTabBar : UITabBar

//3、将协议作为一个属性放出来（代理弱指针）
@property (nonatomic,weak) id<XBTabBarDelegate> delegate;

@end
