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

/**
 *  弹出图片
 *
 *  @param button 当前位置的图片按钮
 */
-(void)showFrom:(XBEmotionButton *)button
{
    if (!button) {
        return;
    }

    // 给popView传递数据
    self.emotionButton.emotion = button.emotion;
    
    // 取得最上面的window
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    [window addSubview:self];
    
    // 计算出被点击的按钮在window中的frame!
    CGRect btnFrame = [button convertRect:button.bounds toView:nil];
    self.y = CGRectGetMidY(btnFrame) - self.height; // 100
    self.centerX = CGRectGetMidX(btnFrame);

}

@end
