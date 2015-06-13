//
//  XibaNavigationController.m
//  XibaWeibo
//
//  Created by bos on 15-6-11.
//  Copyright (c) 2015年 axiba. All rights reserved.
//

#import "XBNavigationController.h"


@interface XBNavigationController ()

@end

@implementation XBNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/**
 *  导航控制器初始化时候(第一次使用的时候)
 */
+(void)initialize
{
    //设置主题颜色
    UIBarButtonItem *barItem = [UIBarButtonItem appearance];
    
    //设置普通情况下的文字的颜色和大小
    NSMutableDictionary *textAtrributes = [NSMutableDictionary dictionary];
    textAtrributes[NSForegroundColorAttributeName] = [UIColor orangeColor];
    textAtrributes[NSFontAttributeName] = [UIFont systemFontOfSize:13];
    [barItem setTitleTextAttributes:textAtrributes forState:UIControlStateNormal];
    
    //设置不可用状态下的Baritem
    NSMutableDictionary *disableAtrributes = [NSMutableDictionary dictionary];
    disableAtrributes[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    disableAtrributes[NSFontAttributeName] = [UIFont systemFontOfSize:13];
    [barItem setTitleTextAttributes:disableAtrributes forState:UIControlStateDisabled];
    
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0)
    {
        viewController.hidesBottomBarWhenPushed = YES;
        
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithAction:self action:@selector(backBtnClick) imageName:@"navigationbar_back" highImageName:@"navigationbar_back_highlighted"];
        
        viewController.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithAction:self action:@selector(moreBtnClick) imageName:@"navigationbar_more" highImageName:@"navigationbar_more_highlighted"];
        
    }
    [super pushViewController:viewController animated:YES];
}


#pragma mark - Baritme 点击事件
-(void)backBtnClick
{
    [self popViewControllerAnimated:YES];
}
-(void)moreBtnClick
{
    [self popToRootViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
