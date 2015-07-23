//
//  XBDropdownMenuController.m
//  XibaWeibo
//
//  Created by bos on 15-6-14.
//  Copyright (c) 2015年 axiba. All rights reserved.
//

#import "XBDropdownMenuController.h"

@interface XBDropdownMenuController()

//用来展示具体内容的容器
@property (nonatomic,strong) UIImageView *containerView;

@end

@implementation XBDropdownMenuController

#pragma  mark - 初始化构造
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //
    }
    return self;
}

+(instancetype)menu
{
    return  [[self alloc]init];
}

#pragma  mark - 变量的懒加载
-(UIImageView *)containerView
{
    if (!_containerView) {
        
        //灰色的图片控件(高度和宽度由传进来的控制器或者UIView决定：setContent)
        UIImageView *containerImg = [[UIImageView alloc]init];
        containerImg.image = [UIImage imageNamed:@"popover_background"];
        containerImg.userInteractionEnabled = YES;
        
        [self addSubview:containerImg];
        self.containerView = containerImg;
    }
    return _containerView;
}
//如果是UI View直接设置
-(void)setContent:(UIView *)content
{
    _content = content;
    
    //是以父控件为左上角坐标系为原点
    content.x = 10;
    content.y = 15;
    
    // 设置灰色的高度
    self.containerView.height = CGRectGetMaxY(content.frame) +11;
    // 设置灰色的宽度
    self.containerView.width = CGRectGetMaxX(content.frame) + 7;
    
    // 添加内容到灰色图片中
    [self.containerView addSubview:content];
}
//如果是控制器传经来，本质也是设置UI View
-(void)setContentController:(UIViewController *)contentController
{
    _contentController =  contentController;
    self.content = contentController.view;
}

#pragma mark - 显示和隐藏
-(void)showForm:(UIView *)form
{
    //获得最顶的窗口
    UIWindow *topWindow = [[UIApplication sharedApplication].windows lastObject];
    
    //将当前的自己添加到窗口上
    [topWindow addSubview:self];
    
    //设置尺寸
    self.frame = topWindow.bounds;
    
    //转换坐标系为以整个窗体为中心，（默认下，坐标是以父控件左上角微坐标原点的）
    CGRect newFrame = [form convertRect:form.bounds toView:topWindow];
    XBLog(@"%@",NSStringFromCGRect(newFrame));
    
    //调整灰色图片的位置(根据标题按钮的位置定位灰色图片的位置)
    self.containerView.centerX = CGRectGetMidX(newFrame);
    self.containerView.y = CGRectGetMaxY(newFrame);
    
    //通知外面帮他操作的其他控制器，他要出门啦
    if ([self.delegate respondsToSelector:@selector(dropdownMenuShow:)]) {
        [self.delegate dropdownMenuShow:self];
    }
}
-(void)dismiss
{
    [self removeFromSuperview];
    
    //通知外面帮他操作的其他控制器，他要回家消失啦
    if ([self.delegate respondsToSelector:@selector(dropdownMenuDismiss:)]) {
        [self.delegate dropdownMenuDismiss:self];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self dismiss];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
