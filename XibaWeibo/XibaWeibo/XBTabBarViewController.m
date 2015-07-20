//
//  XBTabBarViewController.m
//  XibaWeibo
//
//  Created by bos on 15-6-10.
//  Copyright (c) 2015年 axiba. All rights reserved.
//


#import "XBTabBarViewController.h"
#import "HomeViewController.h"
#import "MessageViewController.h"
#import "DiscoverViewController.h"
#import "ProfileViewController.h"
#import "XBNavigationController.h"
#import "XBTabBar.h"

@interface XBTabBarViewController ()<XBTabBarDelegate>

@end

@implementation XBTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //3、设置子控制器
    HomeViewController *home = [[HomeViewController alloc] init];
    [self addTabBarVc:home title:@"首页" image:@"tabbar_home" selectedImage:@"tabbar_home_selected"];
    
    MessageViewController *message = [[MessageViewController alloc] init];
    [self addTabBarVc:message title:@"消息" image:@"tabbar_message_center" selectedImage:@"tabbar_message_center_selected"];
    
    DiscoverViewController *discover = [[DiscoverViewController alloc] init];
    [self addTabBarVc:discover title:@"发现" image:@"tabbar_discover" selectedImage:@"tabbar_discover_selected"];

    ProfileViewController *profile = [[ProfileViewController alloc] init];
    [self addTabBarVc:profile title:@"我" image:@"tabbar_profile" selectedImage:@"tabbar_profile_selected"];

    //更换系统的tabBar（KVC的形式，即使是只读的也可以修改）
    XBTabBar *tarBar = [[XBTabBar alloc]init];
    tarBar.delegate = self;
    [self setValue:tarBar forKey:@"tabBar"];
    
}
- (void)addTabBarVc:(UIViewController *)tabBarVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    // 设置子控制器的文字和图片
    tabBarVc.title = title;
    tabBarVc.tabBarItem.image = [UIImage imageNamed:image];
    //设置选中时的背景图片（是永远正常的突破：不需要系统自带的颜色）
    tabBarVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // 设置文字的样式
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = XBColor(123, 123, 123);
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSForegroundColorAttributeName] = [UIColor orangeColor];
    [tabBarVc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [tabBarVc.tabBarItem setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
    
    //tabBarVc.view.backgroundColor =  HWRandomColor;(使用view会造成提前创建View)
    
    XBNavigationController *navVC = [[XBNavigationController alloc]initWithRootViewController:tabBarVc];
     [self addChildViewController:navVC];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma  mark -- XBTarBarDelegate代理方法

-(void)tabBarDidClickButton:(XBTabBar *)tarBar
{
    UIViewController *VC = [[UIViewController alloc]init];
    VC.view.backgroundColor = [UIColor redColor];
    [self presentViewController:VC animated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
