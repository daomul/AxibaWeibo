//
//  UIBarButtonItem+Extension.m
//  XibaWeibo
//
//  Created by bos on 15-6-13.
//  Copyright (c) 2015年 axiba. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"

@implementation UIBarButtonItem (Extension)


+(UIBarButtonItem *)itemWithAction:(id)target action:(SEL)action imageName:(NSString *)image highImageName:(NSString *)hightImage
{
    //自定义一个按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:hightImage] forState:UIControlStateHighlighted];
    
    //设置baritem 的frame大小[这里通过给UIView增加一个类别，用来增加一个控制frame的类，所以这里可以直接赋值]
    //CGSize size = backBtn.currentBackgroundImage.size;
    //backBtn.frame  = CGRectMake(0, 0, size.width, size.height);
    btn.size= btn.currentBackgroundImage.size;
    
    return [[UIBarButtonItem alloc]initWithCustomView:btn];
}

@end
