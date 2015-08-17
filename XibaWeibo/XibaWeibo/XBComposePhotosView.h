//
//  XBComposePhotosView.h
//  XibaWeibo
//
//  Created by K3CLOUDBOS on 15/8/17.
//  Copyright (c) 2015年 axiba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XBComposePhotosView : UIView

//@property(nonatomic,strong) NSMutableArray *photos;
// 默认会自动生成setter和getter的声明和实现、_开头的成员变量
// 如果手动实现了setter和getter，那么就不会再生成settter、getter的实现、_开头的成员变量

@property(nonatomic,strong,readonly) NSMutableArray *photos;
// 默认会自动生成getter的声明和实现、_开头的成员变量
// 如果手动实现了getter，那么就不会再生成getter的实现、_开头的成员变量

/** 添加一个张图片的图片控件中*/
-(void)addPhoto:(UIImage *)photo;


@end
