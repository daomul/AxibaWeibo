//
//  XBTabBar.m
//  XibaWeibo
//
//  Created by bos on 15-7-20.
//  Copyright (c) 2015年 axiba. All rights reserved.
//


#import "XBTabBar.h"

@interface XBTabBar()
@property (nonatomic,weak) UIButton *composeBtn;
@end

@implementation XBTabBar

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //添加一个按钮到tabBar中
        UIButton *composeBtn = [[UIButton alloc]init];
        [composeBtn setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button"] forState:UIControlStateNormal];
        [composeBtn setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button_highlighted"] forState:UIControlStateHighlighted];
        
        [composeBtn setImage:[UIImage imageNamed:@"tabbar_compose_icon_add"] forState:UIControlStateNormal];
        [composeBtn setImage:[UIImage imageNamed:@"tabbar_compose_icon_add_highlighted"] forState:UIControlStateHighlighted];
        composeBtn.size = composeBtn.currentBackgroundImage.size;
        [composeBtn addTarget:self action:@selector(plusClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview: composeBtn];
        
        self.composeBtn  = composeBtn;
    }
    return self;
}

-(void)plusClick
{
    //在这里点击如果想弹出一个控制器，通过present是不行的，因为只能通过一个控制器去modal一个新的控制器
    //所以只能采用代理的方式，在调用这个XBTabBar 的时候告诉他有一个点击事件，让他代替我们去点击弹出
    XBLog(@"11");
    
    //先判断是否存在对应的代理方法，然后执行代理的方法
    if ([self.delegate respondsToSelector:@selector(tabBarDidClickButton:)])
    {
        [self.delegate tabBarDidClickButton:self];
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    //1、新增加的中间的按钮
    self.composeBtn.centerX = self.width *0.5;
    self.composeBtn.centerY = self.height *0.5;
    
    //2、设置其他tabbarButton的尺寸和位置
    
    CGFloat tabBarButtonW = self.width / 5;
    CGFloat tabBarButtonIndex = 0;
    for (UIView *childV in self.subviews)
    {
        //先判断是不是UITabBarButton的子控件（打印tarBar的子控件会发现还有其他两个子控件）
        Class class = NSClassFromString(@"UITabBarButton");
        if ([childV isKindOfClass:class]) {
            
            //重新设置TabBarButton子控件的宽度和X值(X值根据索引来定位值)
            childV.width = tabBarButtonW;
            childV.x = tabBarButtonIndex * tabBarButtonW;
            
            //增加索引，如果是第三个位置则跳过空一个位置给上面的Button
            tabBarButtonIndex++;
            if (tabBarButtonIndex == 2) {
                tabBarButtonIndex++;
            }
        }
    }
}

@end
