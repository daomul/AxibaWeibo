//
//  XBEmotionKeyboard.m
//  XibaWeibo
//
//  Created by K3CLOUDBOS on 15/8/17.
//  Copyright (c) 2015年 axiba. All rights reserved.
//

#import "XBEmotionKeyboard.h"
#import "XBEmotionListView.h"
#import "XBEmotionTabBar.h"
#import "XBEmotion.h"
#import "MJExtension.h"

@interface XBEmotionKeyboard()<XBEmotionTarBarDelegate>

/** 保存正在显示listView */
@property (nonatomic, weak) XBEmotionListView *showingListView;
/** 表情内容 */
@property (nonatomic, strong) XBEmotionListView *recentListView;
@property (nonatomic, strong) XBEmotionListView *defaultListView;
@property (nonatomic, strong) XBEmotionListView *emojiListView;
@property (nonatomic, strong) XBEmotionListView *lxhListView;
/** tabbar */
@property (nonatomic, weak) XBEmotionTabBar *tabBar;

@end


@implementation XBEmotionKeyboard

#pragma mark -- 懒加载
- (XBEmotionListView *)recentListView
{
    if (!_recentListView) {
        self.recentListView = [[XBEmotionListView alloc] init];
    }
    return _recentListView;
}

- (XBEmotionListView *)defaultListView
{
    if (!_defaultListView) {
        self.defaultListView = [[XBEmotionListView alloc] init];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/default/info.plist" ofType:nil];
        self.defaultListView.emotions = [XBEmotion objectArrayWithKeyValuesArray:[NSArray arrayWithContentsOfFile:path]];
    }
    return _defaultListView;
}

- (XBEmotionListView *)emojiListView
{
    if (!_emojiListView) {
        self.emojiListView = [[XBEmotionListView alloc] init];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/emoji/info.plist" ofType:nil];
        self.emojiListView.emotions = [XBEmotion objectArrayWithKeyValuesArray:[NSArray arrayWithContentsOfFile:path]];
    }
    return _emojiListView;
}

- (XBEmotionListView *)lxhListView
{
    if (!_lxhListView) {
        self.lxhListView = [[XBEmotionListView alloc] init];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/lxh/info.plist" ofType:nil];
        self.lxhListView.emotions = [XBEmotion objectArrayWithKeyValuesArray:[NSArray arrayWithContentsOfFile:path]];
    }
    return _lxhListView;
}

#pragma mark -- life cycle

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        XBEmotionTabBar *tarBar = [[XBEmotionTabBar alloc]init];
        tarBar.delegate = self;
        [self addSubview:tarBar];
        
        self.tabBar = tarBar;
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    //1、 初始化tarBar的尺寸和位置
    self.tabBar.width = self.width;
    self.tabBar.height = 37;
    self.tabBar.y = self.height - self.tabBar.height;
    self.tabBar.x = 0;
    
    //2、初始化表情内容listView的尺寸和位置
    self.showingListView.width = self.width;
    self.showingListView.height = self.tabBar.y;
    self.showingListView.x = self.showingListView.y = 0;
}

#pragma mark -- XBEmotionTarBarDelegate
-(void)emotionTarBar:(XBEmotionTabBar *)tarBar didSelectTarBarButton:(XBEmotionTabBarButtonType)buttonType
{
    // 移除正在显示的listView控件
    [self.showingListView removeFromSuperview];
    
    // 根据按钮类型，切换键盘上面的listview
    switch (buttonType) {
        case XBEmotionTabBarButtonTypeRecent: { // 最近
            [self addSubview:self.recentListView];
            break;
        }
            
        case XBEmotionTabBarButtonTypeDefault: { // 默认
            [self addSubview:self.defaultListView];
            break;
        }
            
        case XBEmotionTabBarButtonTypeEmoji: { // Emoji
            [self addSubview:self.emojiListView];
            break;
        }
            
        case XBEmotionTabBarButtonTypeLxh: { // Lxh
            [self addSubview:self.lxhListView];
            break;
        }
    }
    
    // 设置正在显示的listView
    self.showingListView = [self.subviews lastObject];
    
    // 设置frame,重新调用layoutSubviews
    [self setNeedsLayout];
}

@end
