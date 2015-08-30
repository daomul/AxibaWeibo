//
//  XBEmotionPopView.m
//  XibaWeibo
//
//  Created by zzl on 15/8/29.
//  Copyright (c) 2015年 axiba. All rights reserved.
//

#import "XBEmotionPopView.h"
#import "XBEmotionButton.h"

@interface XBEmotionPopView ()
@property (weak, nonatomic) IBOutlet XBEmotionButton *emotionButton;

@end

@implementation XBEmotionPopView

+ (instancetype)popView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"XBEmotionPopView" owner:nil options:nil] lastObject];
}
-(void)setEmotion:(XBEmotion *)emotion
{
    _emotion = emotion;
    
    self.emotionButton.emotion = emotion;
}

@end
