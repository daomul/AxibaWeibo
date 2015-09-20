//
//  XBEmotionAttachment.m
//  XibaWeibo
//
//  Created by zzl on 15/9/17.
//  Copyright (c) 2015年 axiba. All rights reserved.
//

#import "XBEmotionAttachment.h"
#import "XBEmotion.h"

@implementation XBEmotionAttachment

-(void)setEmotion:(XBEmotion *)emotion
{
    _emotion = emotion;
    
    self.image = [UIImage imageNamed:emotion.png];
}

@end
