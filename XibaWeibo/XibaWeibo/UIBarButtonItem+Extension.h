//
//  UIBarButtonItem+Extension.h
//  XibaWeibo
//
//  Created by bos on 15-6-13.
//  Copyright (c) 2015年 axiba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)

+(UIBarButtonItem *)itemWithAction:(id)target action:(SEL)action imageName:(NSString *)image highImageName:(NSString *)hightImage;

@end
