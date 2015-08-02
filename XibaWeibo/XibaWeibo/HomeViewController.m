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
#import "XBStatusModel.h"
#import "XBUserModel.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD+MJ.h"
#import "MJExtension.h"

@interface HomeViewController () <XBDropdownMenuDelegate>

//微博数据存储数据
@property(nonatomic,strong) NSMutableArray *statusArr;

@end

@implementation HomeViewController

#pragma  mark -- 懒加载
-(NSMutableArray *)statusArr
{
    if (!_statusArr) {
        self.statusArr = [NSMutableArray array];
    }
    return _statusArr;
}

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
    
    //集成刷新控件
    [self refreshStateDatreList];
}

#pragma mark -- 加载微博数据
-(void)refreshStateDatreList
{
    //1.加载刷新控件，下拉刷新
    UIRefreshControl *control = [[UIRefreshControl alloc]init];
    [control addTarget:self action:@selector(refreshStateChange:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:control];
    
    //2.一进来就默认加载刷新
    [control beginRefreshing];
    [self refreshStateChange:control];
    
}
-(void)refreshStateChange:(UIRefreshControl *)control
{
    // 1.请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    // 2.拼接请求参数
    XBAccount *account = [XBAccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    
    // 取出最前面的微博（最新的微博，ID最大的微博）
    XBStatusModel *first = [self.statusArr firstObject];
    if (first) {
        // 若指定此参数，则返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0
        params[@"since_id"] = first.idstr;
    }
    
    // 3.发送请求
    [mgr GET:@"https://api.weibo.com/2/statuses/friends_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation,
                                                                                                   NSDictionary *responseObject) {
        
        //3.1 直接利用MJExtesion.h来构建模型省却一大堆工作量
        NSArray *newStatusArr = [XBStatusModel objectArrayWithKeyValuesArray:responseObject[@"statuses"]];
        
        // 3.2 将最新的微博数据，添加到总数组的最前面
        NSRange range = NSMakeRange(0, newStatusArr.count);
        NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
        [self.statusArr insertObjects:newStatusArr atIndexes:set];
        
        //3.3 c刷新tableView的数据
        [self.tableView reloadData];
        
        //3.4 刷新后要结束刷新动作
        [control endRefreshing];
        
        //3.5 显示最新微博数量
        [self showNewStatusCount:newStatusArr.count];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        XBLog(@"请求数据失败");
        
        //结束刷新
        [control endRefreshing];
    }];
    
}
#pragma mark -- 自定义方法(设置以及获取信息等)
/**
 *  获得导航栏标题处的用户信息（昵称）
 */
-(void)showNewStatusCount:(int)count
{
    //1.创建1个label
    UILabel *label = [[UILabel alloc]init];
    label.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"timeline_new_status_background"]];
    label.width = [UIScreen mainScreen].bounds.size.width;
    label.height = 35;
    
    //2.设置label的其他属性
    if (count == 0) {
        label.text = @"没有新的微博数据，稍后再试";
    }
    else{
        label.text = [NSString stringWithFormat:@"共有%d条新的微博数据",count];
    }
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:16];
    
     //3. 将label添加到导航控制器的view中，并且是盖在导航栏下边
    label.y = 64 - label.height;
    [self.navigationController.view insertSubview:label belowSubview:self.navigationController.navigationBar];
    
     //4.制造动画效果
    CGFloat duration = 1.0;
    
    //4.1 出现动画延迟
    [UIView animateWithDuration:duration animations:^{
        
        label.transform = CGAffineTransformMakeTranslation(0, label.height);
        
    } completion:^(BOOL finished) {
        
        //4.2 消失动画延迟
        [UIView animateWithDuration:duration delay:duration options:UIViewAnimationOptionCurveLinear animations:^{
            
            label.transform = CGAffineTransformIdentity;
            
        } completion:^(BOOL finished) {
            [label removeFromSuperview];
        }];
    }];
}
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
         XBUserModel *model = [XBUserModel objectWithKeyValues:responseObject];
         [tButton setTitle:model.name forState:UIControlStateNormal];
         //将名字写入模型
         account.UserName = model.name;
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
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     // Return the number of rows in the section.
    return self.statusArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //1.构造cell
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    
    //2.取出模型数据
    XBStatusModel *statusM = self.statusArr[indexPath.row];
    XBUserModel *userM = statusM.user;
    
    //3.设置到cell中
    cell.textLabel.text = userM.name;
    cell.detailTextLabel.text = statusM.text;
    
    //4. 利用"UIImageView+WebCache.h"加载图片数据
    UIImage *placeHolderImg = [UIImage imageNamed:@"avatar_default_small"];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:userM.profile_image_url] placeholderImage:placeHolderImg];
    
    return cell;
}

@end
