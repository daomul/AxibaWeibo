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
/** 删除按钮 */
@property (nonatomic, weak) UIButton *deleteButton;

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
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        //1、删除按钮
        UIButton *deleteBtn = [[UIButton alloc]init];
        [deleteBtn setImage:[UIImage imageNamed:@"compose_emotion_delete_highlighted"] forState:UIControlStateHighlighted];
        [deleteBtn setImage:[UIImage imageNamed:@"compose_emotion_delete"] forState:UIControlStateNormal];
        [deleteBtn addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:deleteBtn];
        self.deleteButton = deleteBtn;
        
        //2、添加长按首饰
        [self addGestureRecognizer:[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressPageView:)]];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 内边距(四周)
    CGFloat inset = 20;
    NSUInteger count = self.emotions.count;
    CGFloat btnW = (self.width - 2 * inset) / XBEmotionMaxCols;
    CGFloat btnH = (self.height - inset) / XBEmotionMaxRows;
    for (int i = 0; i<count; i++) {
        UIButton *btn = self.subviews[i+1];
        btn.width = btnW;
        btn.height = btnH;
        btn.x = inset + (i%XBEmotionMaxCols) * btnW;
        btn.y = inset + (i/XBEmotionMaxCols) * btnH;
    }
    
    //删除按钮
    self.deleteButton.width = btnW;
    self.deleteButton.height = btnH;
    self.deleteButton.y = self.height - btnH;
    self.deleteButton.x = self.width - inset - btnW;
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

#pragma  mark -- controll resopnse
/**
 *  监听表情按钮点击
 *
 *  @param btn 被点击的表情按钮
 */
- (void)emotionBtnClick:(XBEmotionButton *)btn
{
    //直接把按钮数据给popView，自己解决弹出问题
    [self.popView showFrom:btn];
    
    // 等会让popView自动消失（定时间，主线城）
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.popView removeFromSuperview];
    });
    
    // 点击de时候发出通知
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[XBSelectEmotionKey] = btn.emotion;
    [XBNotificationCenter postNotificationName:XBEmotionDidSelectNotification object:nil userInfo:userInfo];
}

/**
 *  长按事件处理
 */
-(void)longPressPageView:(UILongPressGestureRecognizer *)recognizer
{
    // 获得手指所在的位置\所在的表情按钮
    CGPoint location = [recognizer locationInView:recognizer.view];
    XBEmotionButton *btn = [self emotionButtonWithLocation:location];
    switch (recognizer.state) {
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded: // 手指已经不再触摸pageView
            // 移除popView
            [self.popView removeFromSuperview];
            
            // 如果手指还在表情按钮上
            if (btn) {
                // 发出通知
                NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
                userInfo[XBSelectEmotionKey] = btn.emotion;
                [XBNotificationCenter postNotificationName:XBEmotionDidSelectNotification object:nil userInfo:userInfo];
            }
            break;
            
        case UIGestureRecognizerStateBegan: // 手势开始（刚检测到长按）
        case UIGestureRecognizerStateChanged: { // 手势改变（手指的位置改变）
            
            //弹出popView
            [self.popView showFrom:btn];
            break;
        }
            
        default:
            break;
    }

}

#pragma mark -- private method

/**
 *  获取根据手指位置所在的表情按钮
 */
- (XBEmotionButton *)emotionButtonWithLocation:(CGPoint)location
{
    NSUInteger count = self.emotions.count;
    for (int i = 0; i<count; i++) {
        XBEmotionButton *btn = self.subviews[i + 1];
        
        //判断按钮frame 范围内是否包含当前手势的位置
        if (CGRectContainsPoint(btn.frame, location)) {
            
            // 已经找到手指所在的表情按钮了，就没必要再往下遍历
            return btn;
        }
    }
    return nil;
}
-(void)deleteClick
{
    [XBNotificationCenter postNotificationName:XBEmotionDidDeleteNotification object:nil];
}
@end
