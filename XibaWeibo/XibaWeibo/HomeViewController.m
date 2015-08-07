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
#import "XBAccountTool.h"
#import "XBTitleButton.h"
#import "XBStatusModel.h"
#import "XBUserModel.h"
#import "XBLoadMoreFooter.h"
#import "XBStatusFrameModel.h"
#import "XBStatusTableViewCell.h"

#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD+MJ.h"
#import "MJExtension.h"
#import "MJRefresh.h"

@interface HomeViewController () <XBDropdownMenuDelegate,MJRefreshBaseViewDelegate>

//微博数据存储数据
@property(nonatomic,strong) NSMutableArray *statusFrameArr;

@property (nonatomic, weak) MJRefreshHeaderView *header;
@property (nonatomic, weak) MJRefreshFooterView *footer;

@end

@implementation HomeViewController

#pragma  mark -- 懒加载
-(NSMutableArray *)statusFrameArr
{
    if (!_statusFrameArr) {
        self.statusFrameArr = [NSMutableArray array];
    }
    return _statusFrameArr;
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
    
    self.tableView.backgroundColor = XBColor(211, 211, 211);
    
    //设置导航栏内容
    [self setNavInfo];
    
    //获取用户名称，设置到标题处
    [self setTitleUserName];
    
    //集成上拉下拉刷新控件
    [self refreshStateDateList];
    
    //定时获得未读数据
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(getUnreadCount) userInfo:nil repeats:YES];
    // !!主线程也会抽时间处理一下timer（不管主线程是否正在执行其他事件操作）——不加的
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

#pragma mark -- MJRefresh 的协议方法
/**
 *  刷新控件进入开始刷新状态的时候调用
 */
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if ([refreshView isKindOfClass:[MJRefreshFooterView class]]) { // 上拉刷新
        
        [self loadMoreStatusDateList];
    }
    else
    {
        // 下拉刷新
        [self refreshStateChange];
    }
}

#pragma mark -- 加载微博数据

///**
// *  集成上拉刷新控件
// */
//-(void)refreshUpStateDateList
//{
//    XBLoadMoreFooter *footer = [XBLoadMoreFooter footer];
//    footer.hidden = YES;
//    self.tableView.tableFooterView = footer;
//}

/**
 *  集成上下拉刷新控件
 */
-(void)refreshStateDateList
{
//    //1.加载刷新控件，下拉刷新
//    UIRefreshControl *control = [[UIRefreshControl alloc]init];
//    [control addTarget:self action:@selector(refreshStateChange:) forControlEvents:UIControlEventValueChanged];
//    [self.tableView addSubview:control];
//    
//    //2.一进来就默认加载刷新
//    [control beginRefreshing];
//    [self refreshStateChange:control];
    
    // 1.下拉刷新
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = self.tableView;
    header.delegate = self;
    
    // 自动进入刷新状态
    [header beginRefreshing];
    
    self.header = header;
    
    // 2.上拉刷新(上拉加载更多数据)
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.tableView;
    footer.delegate = self;
    self.footer = footer;
}

/**
 *  刷新数据
 */
//-(void)refreshStateChange:(UIRefreshControl *)control
-(void)refreshStateChange
{
    // 1.请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    // 2.拼接请求参数
    XBAccount *account = [XBAccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    
    // 取出最前面的微博（最新的微博，ID最大的微博）
    XBStatusFrameModel *firstFrame = [self.statusFrameArr firstObject];
    if (firstFrame) {
        // 若指定此参数，则返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0
        params[@"since_id"] = firstFrame.status.idstr;
    }
    
    // 3.发送请求
    [mgr GET:@"https://api.weibo.com/2/statuses/friends_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation,
                                                                                                   NSDictionary *responseObject) {
        
        //3.1 直接利用MJExtesion.h来构建模型省却一大堆工作量
        NSArray *newStatusArr = [XBStatusModel objectArrayWithKeyValuesArray:responseObject[@"statuses"]];
        
        // 3.2 微博数据转坏为微博frame
        NSArray *newStatusFrameArr = [self transFormstatusFrameWithStatues:newStatusArr];
        
        // 3.2 将最新的微博数据，添加到总数组的最前面
        NSRange range = NSMakeRange(0, newStatusArr.count);
        NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
        [self.statusFrameArr insertObjects:newStatusFrameArr atIndexes:set];
        
        //3.3 c刷新tableView的数据
        [self.tableView reloadData];
        
        //3.4 刷新后要结束刷新动作
        //[control endRefreshing];
        [self.header endRefreshing];
        
        //3.5 显示最新微博数量
        [self showNewStatusCount:newStatusArr.count];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        XBLog(@"请求数据失败");
        
        //结束刷新
        //[control endRefreshing];
        [self.header endRefreshing];
    }];
    
}

/**
 *  刷新更多数据
 */
-(void)loadMoreStatusDateList
{
    // 1.请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    // 2.拼接请求参数
    XBAccount *account = [XBAccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    
    // 取出最前面的微博（最新的微博，ID最大的微博）
    XBStatusFrameModel *last = [self.statusFrameArr lastObject];
    if (last) {
        // 若指定此参数，则返回ID小于或等于max_id的微博，默认为0。
        // id这种数据一般都是比较大的，一般转成整数的话，最好是long long类型
        long long maxId = last.status.idstr.longLongValue - 1;
        params[@"max_id"] = @(maxId);
    }
    
    // 3.发送请求
    [mgr GET:@"https://api.weibo.com/2/statuses/friends_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation,
                                                                                                   NSDictionary *responseObject) {
        
        //3.1 直接利用MJExtesion.h来构建模型省却一大堆工作量
        NSArray *newStatusArr = [XBStatusModel objectArrayWithKeyValuesArray:responseObject[@"statuses"]];
        
        // 3.2 微博数据转坏为微博frame
        NSArray *newStatusFrameArr = [self transFormstatusFrameWithStatues:newStatusArr];
        
        // 3.2 将最新的微博数据，添加到总数组的最前面
        [self.statusFrameArr addObjectsFromArray:newStatusFrameArr];
        
        //3.3 c刷新tableView的数据
        [self.tableView reloadData];
        
        //3.4  结束刷新footer
        //self.tableView.tableFooterView.hidden = YES;
        [self.footer endRefreshing];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        XBLog(@"网络请求失败,请稍后再试");
        
        //结束刷新
        //self.tableView.tableFooterView.hidden = YES;
        [self.footer endRefreshing];
    }];

}

/**
 *  获得未读微博数据
 */
-(void)getUnreadCount
{
    // 1、请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    // 2、拼接请求参数
    XBAccount *account = [XBAccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    params[@"uid"] = account.uid;
    
    // 3、发送请求
    [mgr GET:@"https://rm.api.weibo.com/2/remind/unread_count.json" parameters:params
     success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
         
         // @20 --> @"20"
         // NSNumber --> NSString
         // 设置提醒数字(微博的未读数)
         NSString *status = [responseObject[@"status"] description];
         if ([status isEqualToString:@"0"]) {
             self.tabBarItem.badgeValue = nil;
             [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
         }else
         {
             self.tabBarItem.badgeValue = status;
             [UIApplication sharedApplication].applicationIconBadgeNumber = status.intValue;
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         XBLog(@"请求失败-%@", error);
     }];
}


#pragma mark -- 自定义方法(设置以及获取信息等)

/**
 *  将微博数据模型转化为Frame模型
 */
-(NSArray *)transFormstatusFrameWithStatues:(NSArray *)statues
{
    NSMutableArray *frames = [NSMutableArray array];
    for (XBStatusModel *status in statues) {
        XBStatusFrameModel *frame = [[XBStatusFrameModel alloc]init];
        frame.status = status;
        [frames addObject:frame];
    }
    return frames;
}

/**
 *  显示刷新了多少条新数据
 */
-(void)showNewStatusCount:(int)count
{
    //刷新成功的时候，去除tabBar的下标和icon的角标
    self.tabBarItem.badgeValue = nil;
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
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
    return self.statusFrameArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    //1.构造cell
//    static NSString *cellID = @"cellID";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
//    if (!cell) {
//        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
//    }
//    
//    //2.取出模型数据
//    XBStatusModel *statusM = self.statusArr[indexPath.row];
//    XBUserModel *userM = statusM.user;
//    
//    //3.设置到cell中
//    cell.textLabel.text = userM.name;
//    cell.detailTextLabel.text = statusM.text;
//    
//    //4. 利用"UIImageView+WebCache.h"加载图片数据
//    UIImage *placeHolderImg = [UIImage imageNamed:@"avatar_default_small"];
//    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:userM.profile_image_url] placeholderImage:placeHolderImg];

    //构造一个新的cell
    XBStatusTableViewCell *cell = [XBStatusTableViewCell cellWithTableView:tableView];

    //给cell传递frame模型(这样才会调用setstatusFrame 方法)
    cell.statusFrame = self.statusFrameArr[indexPath.row];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XBStatusFrameModel *frameModel = self.statusFrameArr[indexPath.row];
    return frameModel.cellHeight;
}
#pragma mark -- scrollView 的协议方法

///**
// * 上拉刷新时调用的协议方法
// */
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    CGFloat offsetY = scrollView.contentOffset.y;
//    
//    //1. 如果没有数据直接返回
//    if (self.statusFrameArr.count == 0 || self.tableView.tableFooterView.hidden == NO) {
//        return;
//    }
//    
//    //2. 当最后一个cell完全显示在眼前时，contentOffset的y值
//    CGFloat lastOffsetY = scrollView.contentSize.height + scrollView.contentInset.bottom - scrollView.height - self.tableView.tableFooterView.height;
//    if (offsetY >= lastOffsetY) {
//        self.tableView.tableFooterView.hidden = NO;
//        
//        // 加载更多的微博数据
//        [self loadMoreStatusDateList];
//    }
//    
//    /*
//     contentInset：除具体内容以外的边框尺寸
//     contentSize: 里面的具体内容（header、cell、footer），除掉contentInset以外的尺寸
//     contentOffset:
//     1.它可以用来判断scrollView滚动到什么位置
//     2.指scrollView的内容超出了scrollView顶部的距离（除掉contentInset以外的尺寸）
//     */
//}

#pragma mark -- dealloc ()
- (void)dealloc
{
    // 上拉刷新和下拉刷新结束后要释放内存
    [self.header free];
    [self.footer free];
}

@end
