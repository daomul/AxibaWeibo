//
//  ComposeViewController.m
//  XibaWeibo
//
//  Created by K3CLOUDBOS on 15/8/9.
//  Copyright (c) 2015年 axiba. All rights reserved.
//

#import "ComposeViewController.h"
#import "XBAccountTool.h"
#import "XBTextView.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "XBComposeToolBar.h"
#import "XBComposeToolBar.h"

@interface ComposeViewController ()<XBComposeToolBarDelegate,UITextViewDelegate>

/** 输入控件 */
@property(nonatomic,strong)XBTextView *textView;
/** 键盘顶部的工具条 */
@property (nonatomic, weak) XBComposeToolBar *toolbar;
/** 相册（存放拍照或者相册中选择的图片） */
//@property (nonatomic, weak) HWComposePhotosView *photosView;

@end

@implementation ComposeViewController

#pragma mark --life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航控制器
    [self setupNav];
    
    //输入控件
    [self setupTextView];
    
    //添加工具条
    [self setupToolBar];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 成为第一响应者（能输入文本的控件一旦成为第一响应者，就会叫出相应的键盘）
    [self.textView becomeFirstResponder];
}

#pragma mark -- private methods

/**
 * 添加导航栏
 */
-(void)setupNav
{
    //1 设置两个BarItem
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(send)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    //2 取到用户的名称
    NSString *userName = [XBAccountTool account].UserName;
    NSString *titleName = @"发微博";
    if (userName)
    {
        //2.1 构造一个标签嵌入titleView 中
        UILabel *titleView = [[UILabel alloc]init];
        titleView.width = 200;
        titleView.height = 100;
        titleView.textAlignment = NSTextAlignmentCenter;
        titleView.numberOfLines = 0;
        
        //2.2 创建带属性的字符串，传入到titleView 中
        NSString *str = [NSString stringWithFormat:@"%@\n%@",titleName,userName];
        NSMutableAttributedString *mutStr = [[NSMutableAttributedString alloc]initWithString:str];
        
        [mutStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:[str rangeOfString:userName]];
        [mutStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16] range:[str rangeOfString:titleName]];
        
        titleView.attributedText = mutStr;
        self.navigationItem.titleView = titleView;
    }
    else
    {
        self.navigationItem.title = titleName;
    }
}

/**
 * 添加文本控件
 */
-(void)setupTextView
{
    XBTextView *textView = [[XBTextView alloc]init];
    textView.frame = self.view.bounds;
    textView.font = [UIFont systemFontOfSize:15];
    textView.placeholder = @"分享新鲜事...";
    textView.alwaysBounceVertical = YES; //垂直方向上拖拽
    
    [self.view addSubview:textView];
    self.textView = textView;
    
    //监听通知：如果已经输入了文字，就应该放开发送按钮
    [XBNotificationCenter addObserver:self selector:@selector(textDidChanged) name:UITextViewTextDidChangeNotification object:textView];
    
    // 键盘通知
    // 键盘的frame发生改变时发出的通知（位置和尺寸）
    //    UIKeyboardWillChangeFrameNotification
    //    UIKeyboardDidChangeFrameNotification
    // 键盘显示时发出的通知
    //    UIKeyboardWillShowNotification
    //    UIKeyboardDidShowNotification
    // 键盘隐藏时发出的通知
    //    UIKeyboardWillHideNotification
    //    UIKeyboardDidHideNotification
    [XBNotificationCenter addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

/**
 *  添加工具条
 */
-(void)setupToolBar
{
    XBComposeToolBar *toolBar = [[XBComposeToolBar alloc]init];
    toolBar.width = self.view.width;
    toolBar.height = 45;
    toolBar.y = self.view.height - toolBar.height;
    toolBar.delegate = self;
    
    [self.view addSubview:toolBar];
    self.toolbar = toolBar;
}

#pragma mark - UITextViewDelegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma mark -- 通知

//监听文字是否已经输入
-(void)textDidChanged
{
    self.navigationItem.rightBarButtonItem.enabled = self.textView.hasText;
}
//键盘的frame发生改变，顺便把通知参数传过来，可以获取通知的上下文
-(void)keyboardWillChangeFrame:(NSNotification *)notification
{
    /**
     notification.userInfo = @{
     // 键盘弹出\隐藏后的frame
     UIKeyboardFrameEndUserInfoKey = NSRect: {{0, 352}, {320, 216}},
     // 键盘弹出\隐藏所耗费的时间
     UIKeyboardAnimationDurationUserInfoKey = 0.25,
     // 键盘弹出\隐藏动画的执行节奏（先快后慢，匀速）
     UIKeyboardAnimationCurveUserInfoKey = 7
     }
     */
    NSDictionary *notiUserInfo = notification.userInfo;
    // 动画的持续时间
    double duration = [notiUserInfo [UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 键盘的frame
    CGRect keyBoardF = [notiUserInfo [UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    [UIView animateWithDuration:duration animations:^{
        if (keyBoardF.origin.y >self.view.height)
        {
            self.toolbar.y = self.view.height - self.toolbar.height;
        }
        else
        {
            self.toolbar.y = keyBoardF.origin.y - self.toolbar.height;
        }
    }];
}
#pragma mark -- resoponse

-(void)cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)send
{
    // URL: https://api.weibo.com/2/statuses/update.json
    // 参数:
    /**	status true string 要发布的微博文本内容，必须做URLencode，内容不超过140个汉字。*/
    /**	pic false binary 微博的配图。*/
    /**	access_token true string*/
    
    // 1.请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    // 2.拼接请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = [XBAccountTool account].access_token;
    params[@"status"] = self.textView.text;
    
    // 3.发送请求
    [mgr POST:@"https://api.weibo.com/2/statuses/update.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD showSuccess:@"发送成功"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"发送失败"];
    }];
    
    //4. 关闭
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
