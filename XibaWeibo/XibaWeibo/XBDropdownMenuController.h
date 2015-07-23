//
//  XBDropdownMenuController.h
//  XibaWeibo
//
//  Created by bos on 15-6-14.
//  Copyright (c) 2015年 axiba. All rights reserved.
//

#import <UIKit/UIKit.h>

//1、引入本身自己的控制器
@class XBDropdownMenuController;
//2、定义一个协议
@protocol XBDropdownMenuDelegate <NSObject>
//3、设置协议的可选择性和协议方法
@optional
-(void)dropdownMenuDismiss:(XBDropdownMenuController *)menu;
-(void)dropdownMenuShow:(XBDropdownMenuController *)menu;



@end

@interface XBDropdownMenuController : UIView

//4、将协议属性放开
@property (nonatomic,weak) id<XBDropdownMenuDelegate>delegate;

+ (instancetype)menu;

/**
 *  显示
 */
- (void)showForm:(UIView *)from;
/**
 *  销毁
 */
- (void)dismiss;

/**
 *  内容
 */
@property (nonatomic, strong) UIView *content;
/**
 *  内容控制器
 */
@property (nonatomic, strong) UIViewController *contentController;

@end
