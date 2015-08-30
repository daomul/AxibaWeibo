//
//  XBEmotionTabBar.m
//  XibaWeibo
//
//  Created by K3CLOUDBOS on 15/8/17.
//  Copyright (c) 2015年 axiba. All rights reserved.
//

#import "XBEmotionTabBar.h"
#import "XBEmotionTabBarButton.h"

@interface XBEmotionTabBar()

/**
 *  作为之前被选中的按钮
 */
@property (nonatomic, weak) XBEmotionTabBarButton *selectedBtn;

@end

@implementation XBEmotionTabBar

#pragma mark -- life cycle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupBtn:@"最近" buttonType:XBEmotionTabBarButtonTypeRecent];
        [self setupBtn:@"默认" buttonType:XBEmotionTabBarButtonTypeDefault];
        //        [self btnClick:[self setupBtn:@"默认" buttonType:HWEmotionTabBarButtonTypeDefault]];
        [self setupBtn:@"Emoji" buttonType:XBEmotionTabBarButtonTypeEmoji];
        [self setupBtn:@"浪小花" buttonType:XBEmotionTabBarButtonTypeLxh];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 设置按钮的frame
    NSUInteger btnCount = self.subviews.count;
    CGFloat btnW = self.width / btnCount;
    CGFloat btnH = self.height;
    for (int i = 0; i<btnCount; i++) {
        XBEmotionTabBarButton *btn = self.subviews[i];
        btn.y = 0;
        btn.width = btnW;
        btn.x = i * btnW;
        btn.height = btnH;
    }
}

/**
 *  创建一个按钮
 *
 *  @param title 按钮文字
 */
- (XBEmotionTabBarButton *)setupBtn:(NSString *)title buttonType:(XBEmotionTabBarButtonType)buttonType
{
    // 创建按钮
    XBEmotionTabBarButton *btn = [[XBEmotionTabBarButton alloc] init];
    [btn addTarget:self action:@selector(tarBarBtnClick:) forControlEvents:UIControlEventTouchDown];
    
    //tag可以知道后面是谁被电击啦
    btn.tag = buttonType;
    [btn setTitle:title forState:UIControlStateNormal];
    [self addSubview:btn];
    
    // 设置背景图片
    NSString *image = @"compose_emotion_table_mid_normal";
    NSString *selectImage = @"compose_emotion_table_mid_selected";
    if (self.subviews.count == 1) {
        image = @"compose_emotion_table_left_normal";
        selectImage = @"compose_emotion_table_left_selected";
    } else if (self.subviews.count == 4) {
        image = @"compose_emotion_table_right_normal";
        selectImage = @"compose_emotion_table_right_selected";
    }
    
    [btn setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:selectImage] forState:UIControlStateDisabled];
    
    return btn;
}

/**
 *  想通过XBEmotionTabBar的协议执行代理方法，会设置delegate = self ,这时候就会自动调用
 *
 *  @param delegate 协议
 */
-(void)setDelegate:(id<XBEmotionTarBarDelegate>)delegate
{
    _delegate = delegate;
    
    // 选中“默认”按钮
    [self tarBarBtnClick:(XBEmotionTabBarButton *)[self viewWithTag:XBEmotionTabBarButtonTypeDefault]];
}

/**
 *  tarBar 点击事件触发
 *
 *  @param btn 按钮
 */
-(void)tarBarBtnClick:(XBEmotionTabBarButton *)btn
{
    self.selectedBtn.enabled = YES;
    btn.enabled = NO;
    self.selectedBtn = btn;
    
    //点击事件的通知代理
    if ([self.delegate respondsToSelector:@selector(emotionTarBar:didSelectTarBarButton:)])
    {
        [self.delegate emotionTarBar:self didSelectTarBarButton:btn.tag];
    }
    
}

@end
