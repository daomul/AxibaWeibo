//
//  XBSearchBar.m
//  XibaWeibo
//
//  Created by bos on 15-6-14.
//  Copyright (c) 2015年 axiba. All rights reserved.
//

#import "XBSearchBar.h"

@implementation XBSearchBar

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.font = [UIFont systemFontOfSize:15];
        self.placeholder = @"请输入搜索条件...";
        self.background = [UIImage imageNamed:@"searchbar_textfield_background"];
        
        UIImageView *searchIcon = [[UIImageView alloc]init];
        searchIcon.height = 30;
        searchIcon.width = 30;
        //控制图片控件内部的填充方式
        searchIcon.contentMode = UIViewContentModeCenter;
        searchIcon.image = [UIImage imageNamed:@"searchbar_textfield_search_icon"];
        
        self.leftView = searchIcon;
        self.leftViewMode = UITextFieldViewModeAlways;
        
    }
    return self;
}

+(instancetype)searchBar
{
    return [[self alloc]init];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
