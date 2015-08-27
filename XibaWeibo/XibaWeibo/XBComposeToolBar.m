//
//  XBComposeToolBar.m
//  XibaWeibo
//
//  Created by K3CLOUDBOS on 15/8/9.
//  Copyright (c) 2015年 axiba. All rights reserved.
//

#import "XBComposeToolBar.h"

@interface XBComposeToolBar()

/** 表情的按钮*/
@property (nonatomic, weak) UIButton *emotionButton;

@end

@implementation XBComposeToolBar

#pragma mark -- life cycle
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"compose_toolbar_background"]];
        
        // 初始化按钮
        [self setupBtn:@"compose_camerabutton_background" highImage:@"compose_camerabutton_background_highlighted" type:XBComposeToolbarButtonTypeCamera];
        
        [self setupBtn:@"compose_toolbar_picture" highImage:@"compose_toolbar_picture_highlighted" type:XBComposeToolbarButtonTypePicture];
        
        [self setupBtn:@"compose_mentionbutton_background" highImage:@"compose_mentionbutton_background_highlighted" type:XBComposeToolbarButtonTypeMention];
        
        [self setupBtn:@"compose_trendbutton_background" highImage:@"compose_trendbutton_background_highlighted" type:XBComposeToolbarButtonTypeTrend];
        
        self.emotionButton = [self setupBtn:@"compose_emoticonbutton_background" highImage:@"compose_emoticonbutton_background_highlighted" type:XBComposeToolbarButtonTypeEmotion];
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    NSUInteger count = self.subviews.count;
    CGFloat btnW = self.width/count;
    CGFloat btnH = self.height;
    for (int i = 0; i < count; i++) {
        UIButton *btn = self.subviews[i];
        btn.frame = CGRectMake(i * btnW, 0, btnW, btnH);
    }
}

#pragma mark -- getter and setter
-(void)setShowKeyboardButton:(BOOL)showKeyboardButton
{
    _showKeyboardButton = showKeyboardButton;
    
    // 默认的图片名
    NSString *image = @"compose_emoticonbutton_background";
    NSString *highImage = @"compose_emoticonbutton_background_highlighted";
    
    // 显示键盘图标
    if (showKeyboardButton) {
        image = @"compose_keyboardbutton_background";
        highImage = @"compose_keyboardbutton_background_highlighted";
    }
    
    // 设置图片
    [self.emotionButton setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [self.emotionButton setImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
}

#pragma mark -- private methods
/**
 * 创建一个按钮
 */
- (UIButton *)setupBtn:(NSString *)image highImage:(NSString *)highImage type:(XBComposeToolbarButtonType)type
{
    UIButton *btn = [[UIButton alloc] init];
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = type;
    [self addSubview:btn];
    
    return btn;
}

-(void)btnClick:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(composeToolBar:didClickButton:)])
    {
        [self.delegate composeToolBar:self didClickButton:btn.tag];
    }
}
@end
