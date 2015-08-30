//
//  XBEmotionPageView.m
//  XibaWeibo
//
//  Created by zzl on 15/8/29.
//  Copyright (c) 2015年 axiba. All rights reserved.
//

#import "XBEmotionPageView.h"
#import "XBEmotionButton.h"
#import "XBEmotionPopView.h"

@interface XBEmotionPageView()

/** 点击表情后弹出的放大镜 */
@property (nonatomic, strong) XBEmotionPopView *popView;

@end

@implementation XBEmotionPageView

#pragma mark --  lazy load

- (XBEmotionPopView *)popView
{
    if (!_popView) {
        self.popView = [XBEmotionPopView popView];
    }
    return _popView;
}

#pragma mark -- lif cyle
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 内边距(四周)
    CGFloat inset = 20;
    NSUInteger count = self.emotions.count;
    CGFloat btnW = (self.width - 2 * inset) / XBEmotionMaxCols;
    CGFloat btnH = (self.height - inset) / XBEmotionMaxRows;
    for (int i = 0; i<count; i++) {
        UIButton *btn = self.subviews[i];
        btn.width = btnW;
        btn.height = btnH;
        btn.x = inset + (i%XBEmotionMaxCols) * btnW;
        btn.y = inset + (i/XBEmotionMaxCols) * btnH;
    }
}

#pragma mark -- getter and setter 
- (void)setEmotions:(NSArray *)emotions
{
    _emotions = emotions;
    
    NSUInteger count = emotions.count;
    for (int i = 0; i<count; i++) {
        XBEmotionButton *btn = [[XBEmotionButton alloc] init];
        [self addSubview:btn];
        
        // 设置表情数据
        btn.emotion = emotions[i];
        
        // 监听按钮点击
        [btn addTarget:self action:@selector(emotionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

/**
 *  监听表情按钮点击
 *
 *  @param btn 被点击的表情按钮
 */
- (void)emotionBtnClick:(XBEmotionButton *)btn
{
    // 给popView传递数据
    self.popView.emotion = btn.emotion;
    
    // 取得最上面的window
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    [window addSubview:self.popView];
    
    // 计算出被点击的按钮在window中的frame!
    CGRect btnFrame = [btn convertRect:btn.bounds toView:nil];
    self.popView.y = CGRectGetMidY(btnFrame) - self.popView.height; // 100
    self.popView.centerX = CGRectGetMidX(btnFrame);
}

@end
