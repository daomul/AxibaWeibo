//
//  XBTextView.h
//  XibaWeibo
//
//  Created by K3CLOUDBOS on 15/8/9.
//  Copyright (c) 2015年 axiba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XBTextView : UITextView

/** 占位文字 */
@property (nonatomic, copy) NSString *placeholder;
/** 占位文字的颜色 */
@property (nonatomic, strong) UIColor *placeholderColor;

@end
