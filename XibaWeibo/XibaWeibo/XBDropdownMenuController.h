//
//  XBDropdownMenuController.h
//  XibaWeibo
//
//  Created by bos on 15-6-14.
//  Copyright (c) 2015年 axiba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XBDropdownMenuController : UIView

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
