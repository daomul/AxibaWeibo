//
//  XBTitleButton.m
//  XibaWeibo
//
//  Created by K3CLOUDBOS on 15/7/30.
//  Copyright (c) 2015年 axiba. All rights reserved.
//

#import "XBTitleButton.h"

@implementation XBTitleButton


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:17];
        [self setImage: [UIImage imageNamed:@"navigationbar_arrow_down"] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"navigationbar_arrow_up"] forState:UIControlStateSelected];
        
        //[self setBackgroundColor:[UIColor redColor]];
        //[self.titleLabel setBackgroundColor:[UIColor blueColor]];
        [self.imageView setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

#pragma  mark -- 改写子控件调用方法
- (void)layoutSubviews
{
    [super layoutSubviews];
    // 如果仅仅是调整按钮内部titleLabel和imageView的位置，那么在layoutSubviews中单独设置位置即可
    
    // 1.计算titleLabel的frame
    self.titleLabel.x = self.imageView.x;
    
    // 2.计算imageView的frame
    self.imageView.x = CGRectGetMaxX(self.titleLabel.frame);
}

#pragma  mark --  设置UIButton的时候自适应尺寸
-(void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];
    
    //自适应
    [self sizeToFit];
}
-(void)setImage:(UIImage *)image forState:(UIControlState)state
{
    [super setImage:image forState:state];
    
    [self sizeToFit];
}
@end
