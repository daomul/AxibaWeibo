//
//  NSString+Extension.h
//  XibaWeibo
//
//  Created by K3CLOUDBOS on 15/8/8.
//  Copyright (c) 2015年 axiba. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)

/**
 *  根据文字内容和字体大小计算宽度(有限制最大宽度)
 */
-(CGSize)sizeWithTextFont:(UIFont *)font maxW:(CGFloat)maxW;

/**
 *  根据文字内容和字体大小计算宽度(不做限制最大宽度)
 */
-(CGSize)sizeWithTextFont:(UIFont *)font;

@end
