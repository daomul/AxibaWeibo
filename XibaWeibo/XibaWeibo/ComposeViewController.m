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

@interface ComposeViewController ()

@property(nonatomic,strong)XBTextView *textView;
@end

@implementation ComposeViewController

#pragma mark --life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航控制器
    [self setupNav];
    
    //输入控件
    [self setupTextView];
}

#pragma mark -- private methods

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

-(void)setupTextView
{
    XBTextView *textView = [[XBTextView alloc]init];
    textView.frame = self.view.bounds;
    textView.font = [UIFont systemFontOfSize:15];
    textView.placeholder = @"分享新鲜事...";
    
    [self.view addSubview:textView];
    self.textView = textView;
    
    //监听通知：如果已经输入了文字，就应该放开发送按钮
    [XBNotificationCenter addObserver:self selector:@selector(textDidChanged) name:UITextViewTextDidChangeNotification object:textView];
}

#pragma mark -- 通知

//监听文字是否已经输入
-(void)textDidChanged
{
    self.navigationItem.rightBarButtonItem.enabled = self.textView.hasText;
}
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
