//
//  XBComposeToolBar.h
//  XibaWeibo
//
//  Created by K3CLOUDBOS on 15/8/9.
//  Copyright (c) 2015年 axiba. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XBComposeToolBar;

typedef enum {
    XBComposeToolbarButtonTypeCamera, // 拍照
    XBComposeToolbarButtonTypePicture, // 相册
    XBComposeToolbarButtonTypeMention, // @
    XBComposeToolbarButtonTypeTrend, // #
    XBComposeToolbarButtonTypeEmotion // 表情
} XBComposeToolbarButtonType;

@protocol XBComposeToolBarDelegate <NSObject>
@optional
-(void)composeToolBar:(XBComposeToolBar *)toolBar didClickButton:(XBComposeToolbarButtonType)buttonType;

@end

@interface XBComposeToolBar : UIView

@property(nonatomic,strong) id<XBComposeToolBarDelegate> delegate;

@end
