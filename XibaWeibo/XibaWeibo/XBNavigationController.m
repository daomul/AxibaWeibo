//
//  XibaNavigationController.m
//  XibaWeibo
//
//  Created by bos on 15-6-11.
//  Copyright (c) 2015年 axiba. All rights reserved.
//

#import "XBNavigationController.h"
#import "UIView+Extension.h"


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
        
        //自定义一个按钮
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [backBtn setBackgroundImage:[UIImage imageNamed:@"navigationbar_back"] forState:UIControlStateNormal];
        [backBtn setBackgroundImage:[UIImage imageNamed:@"navigationbar_back_highlighted"] forState:UIControlStateHighlighted];
        
        //设置baritem 的frame大小[这里通过给UIView增加一个类别，用来增加一个控制frame的类，所以这里可以直接赋值]
        //CGSize size = backBtn.currentBackgroundImage.size;
        //backBtn.frame  = CGRectMake(0, 0, size.width, size.height);
        backBtn.size= backBtn.currentBackgroundImage.size;
        
        //自定义一个按钮
        UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [moreBtn addTarget:self action:@selector(moreBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [moreBtn setBackgroundImage:[UIImage imageNamed:@"navigationbar_more"] forState:UIControlStateNormal];
        [moreBtn setBackgroundImage:[UIImage imageNamed:@"navigationbar_more_highlighted"] forState:UIControlStateHighlighted];
        
        moreBtn.size= moreBtn.currentBackgroundImage.size;
        
        
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
        viewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:moreBtn];
        
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
    [self popViewControllerAnimated:YES];
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
