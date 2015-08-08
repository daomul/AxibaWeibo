//
//  NSString+Extension.m
//  XibaWeibo
//
//  Created by K3CLOUDBOS on 15/8/8.
//  Copyright (c) 2015年 axiba. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

/**
 *  根据文字内容和字体大小计算宽度(有限制最大宽度)
 */
-(CGSize)sizeWithTextFont:(UIFont *)font maxW:(CGFloat)maxW
{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    
    //MAXFLOAT代表不做限制
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    return  [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}
/**
 *  根据文字内容和字体大小计算宽度(不做限制最大宽度)
 */
-(CGSize)sizeWithTextFont:(UIFont *)font
{
    return [self sizeWithTextFont:font maxW:MAXFLOAT];
}

@end
