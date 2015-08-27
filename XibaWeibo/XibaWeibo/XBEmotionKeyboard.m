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

@interface XBEmotionKeyboard()

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

#pragma mark -- life cycle

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        XBEmotionTabBar *tarBar = [[XBEmotionTabBar alloc]init];
        
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

@end
