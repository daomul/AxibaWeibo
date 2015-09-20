//
//  XBEmotionTextView.m
//  XibaWeibo
//
//  Created by zzl on 15/8/30.
//  Copyright (c) 2015年 axiba. All rights reserved.
//

#import "XBEmotionTextView.h"
#import "XBEmotionAttachment.h"
#import "XBEmotion.h"

@implementation XBEmotionTextView


- (void)insertEmotion:(XBEmotion *)emotion
{
    if (emotion.code) {
        // insertText : 将文字插入到光标所在的位置
        [self insertText:emotion.code.emoji];
    }
    else if (emotion.png) {
        
        // 加载图片
        XBEmotionAttachment *attch = [[XBEmotionAttachment alloc] init];
        
        //传递emotion数据源
        attch.emotion = emotion;
        
        //设置图片的高度
        CGFloat attchWH = self.font.lineHeight;
        attch.bounds = CGRectMake(0, -4, attchWH, attchWH);
        
        // 根据附件创建一个属性文字
        NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:attch];
        
        // 插入属性文字到光标位置
        [self insertAttributedText:imageStr settingBlock:^(NSMutableAttributedString *attributedText) {
            
            // 设置字体
            [attributedText addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, attributedText.length)];
        }];
        
        
    }
}
- (NSString *)fullText
{
    NSMutableString *fullText = [NSMutableString string];
    
    // 遍历所有的属性文字（帮你把图片、emoji、普通文字分成一份一份的）
    [self.attributedText enumerateAttributesInRange:NSMakeRange(0, self.attributedText.length) options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
        // 如果是图片表情
        XBEmotionAttachment *attch = attrs[@"NSAttachment"];
        if (attch)
        {   // 图片
            [fullText appendString:attch.emotion.chs];
        }
        else
        {   // emoji、普通文本
            // 获得这个范围内的文字
            NSAttributedString *str = [self.attributedText attributedSubstringFromRange:range];
            [fullText appendString:str.string];
        }
    }];
    
    return fullText;
}
/**
 selectedRange :
 1.本来是用来控制textView的文字选中范围
 2.如果selectedRange.length为0，selectedRange.location就是textView的光标位置
 
 关于textView文字的字体
 1.如果是普通文字（text），文字大小由textView.font控制
 2.如果是属性文字（attributedText），文字大小不受textView.font控制，应该利用NSMutableAttributedString的
        - (void)addAttribute:(NSString *)name value:(id)value range:(NSRange)range;
    方法设置字体
 **/
@end
