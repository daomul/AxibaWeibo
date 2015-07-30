//
//  UIWindow+Extension.h
//  XibaWeibo
//
//  Created by K3CLOUDBOS on 15/7/30.
//  Copyright (c) 2015年 axiba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWindow (Extension)

/**
 *  UIWindow:切换主控制器
 *  沙盒中版本号存取，根据需要显示新特性，从而切换主控制器
 *  @return nil
 */
-(void)switchRootViewController;
@end
