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
