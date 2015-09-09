//
//  XBTextView.m
//  XibaWeibo
//
//  Created by K3CLOUDBOS on 15/8/9.
//  Copyright (c) 2015年 axiba. All rights reserved.
//

#import "XBTextView.h"

@implementation XBTextView


#pragma mark -- life cycle

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        // 通知
        // 当UITextView的文字发生改变时，UITextView自己会发出一个UITextViewTextDidChangeNotification通知
        [XBNotificationCenter addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
    }
    return self;
}

// 自释放
-(void)dealloc
{
    [XBNotificationCenter removeObserver:self];
}

#pragma mark -- NSNotification 通知

-(void)textDidChange
{
    // 重绘（重新调用）
    [self setNeedsDisplay];
}
#pragma mark -- draw

-(void)drawRect:(CGRect)rect
{
    if (self.hasText)
    {
        return;
    }
    
    // 1、带属性的字典
    NSMutableDictionary *mutDic = [NSMutableDictionary dictionary];
    mutDic[NSFontAttributeName] = self.font;
    mutDic[NSForegroundColorAttributeName] = self.placeholderColor?self.placeholderColor:[UIColor grayColor];
    
    CGFloat Rectx = 5;
    CGFloat Recty = 8;
    CGFloat RectW = rect.size.width - 2 * Rectx;
    CGFloat RectH = rect.size.height - 2 * Recty;
    
    CGRect inrect = CGRectMake(Rectx,Recty,RectW,RectH);
    [self.placeholder drawInRect:inrect withAttributes:mutDic];
}
         

#pragma mark -- setter and getter

- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = [placeholder copy];
    
    [self setNeedsDisplay];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholderColor = placeholderColor;
    
    [self setNeedsDisplay];
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    
    // setNeedsDisplay会在下一个消息循环时刻，调用drawRect:
    [self setNeedsDisplay];
}
-(void)setAttributedText:(NSAttributedString *)attributedText
{
    [super setAttributedText:attributedText];
    
    [self setNeedsDisplay];
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    
    [self setNeedsDisplay];
}

@end
