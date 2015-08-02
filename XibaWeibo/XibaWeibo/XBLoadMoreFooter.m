//
//  XBLoadMoreFooter.m
//  XibaWeibo
//
//  Created by K3CLOUDBOS on 15/8/2.
//  Copyright (c) 2015年 axiba. All rights reserved.
//

#import "XBLoadMoreFooter.h"

@implementation XBLoadMoreFooter

+(instancetype)footer
{
    return  [[[NSBundle mainBundle] loadNibNamed:@"XBLoadMoreFooter" owner:nil options:nil]lastObject];
}

@end
