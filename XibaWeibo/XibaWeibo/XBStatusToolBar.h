//
//  XBStatusToolBar.h
//  XibaWeibo
//
//  Created by K3CLOUDBOS on 15/8/6.
//  Copyright (c) 2015年 axiba. All rights reserved.
//

#import <Foundation/Foundation.h>
@class XBStatusModel;

@interface XBStatusToolBar : UIView

+(instancetype)toolBar;

@property (nonatomic, strong) XBStatusModel *status;

@end
