//
//  XBEmotionTextView.h
//  XibaWeibo
//
//  Created by zzl on 15/8/30.
//  Copyright (c) 2015年 axiba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XBTextView.h"

@class XBEmotion;

@interface XBEmotionTextView : XBTextView

- (void)insertEmotion:(XBEmotion *)emotion;

@end
