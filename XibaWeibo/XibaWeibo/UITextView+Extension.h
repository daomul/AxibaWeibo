//
//  UITextView+Extension.h
//  XibaWeibo
//
//  Created by zzl on 15/8/31.
//  Copyright (c) 2015年 axiba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (Extension)
- (void)insertAttributedText:(NSAttributedString *)text;
- (void)insertAttributedText:(NSAttributedString *)text settingBlock:(void(^) (NSMutableAttributedString *))settingBlock;
@end
