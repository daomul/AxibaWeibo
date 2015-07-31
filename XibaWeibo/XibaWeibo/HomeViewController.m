//
//  HomeViewController.m
//  XibaWeibo
//
//  Created by bos on 15-6-4.
//  Copyright (c) 2015年 axiba. All rights reserved.
//

#import "HomeViewController.h"
#import "XBDropdownMenuController.h"
#import "XBTiTleMeumController.h"
#import "AFNetworking.h"
#import "XBAccountTool.h"
#import "XBTitleButton.h"

@interface HomeViewController () <XBDropdownMenuDelegate>

@end

@implementation HomeViewController

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
       // Custom initialization
    }
     return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航栏内容
    [self setNavInfo];
    
    //获取用户名称，设置到标题处
    [self setTitleUserName];
}

#pragma mark -- 自定义方法(设置以及获取信息等)

/**
 *  获得导航栏标题处的用户信息（昵称）
 */
-(void)setTitleUserName
{
    // 1、请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    // 2、拼接请求参数
    XBAccount *account = [XBAccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    params[@"uid"] = account.uid;
    
    // 3、发送请求
    [mgr GET:@"https://api.weibo.com/2/users/show.json" parameters:params
     success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        
         //标题按钮
         UIButton *tButton = (UIButton *)self.navigationItem.titleView;
         //设置名字
         [tButton setTitle:responseObject[@"name"] forState:UIControlStateNormal];
         //将名字写入模型
         account.UserName = responseObject[@"name"];
         //将模型数据重新写入沙盒
         [XBAccountTool saveAccount:account];
         
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        XBLog(@"请求失败-%@", error); 
    }];
}

/**
 *  设置导航栏内容（包括标题按钮等）
 */
-(void)setNavInfo
{
    //1. 设置导航栏
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithAction:self action:@selector(friendSearch) imageName:@"navigationbar_friendsearch" highImageName:@"navigationbar_friendsearch_highlighted"];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithAction:self action:@selector(scanPop) imageName:@"navigationbar_pop" highImageName:@"navigationbar_pop_highlighted"];
    
    //2.设置中间的下拉按钮
    XBTitleButton *hButton = [[XBTitleButton alloc]init];
    
    //3. 取得用户数据昵称
    NSString *userName = [XBAccountTool account].UserName;
    [hButton setTitle:userName?userName:@"首页" forState:UIControlStateNormal];
    
    [hButton addTarget:self action:@selector(titleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = hButton;
}

#pragma mark - 点击事件
-(void)titleBtnClick:(UIButton *)titleButton
{
    XBDropdownMenuController *dropMenu = [XBDropdownMenuController menu];
    dropMenu.delegate = self;
    
    XBTiTleMeumController *titleMenu = [[XBTiTleMeumController alloc]init];
    titleMenu.view.height = 150;
    titleMenu.view.width = 150;
    dropMenu.contentController = titleMenu;
    
    [dropMenu showForm:titleButton];
}

#pragma mark - baritem 点击事件
-(void)friendSearch
{
    NSLog(@"friendSearch");
}

-(void)scanPop
{
    NSLog(@"scanPop");
}

#pragma mark -- dropDowndelegate协议方法
-(void)dropdownMenuDismiss:(XBDropdownMenuController *)menu
{
    UIButton *btn = (UIButton *)self.navigationItem.titleView;
    btn.selected = NO;
}
-(void)dropdownMenuShow:(XBDropdownMenuController *)menu
{
    UIButton *btn = (UIButton *)self.navigationItem.titleView;
    btn.selected = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}


@end
