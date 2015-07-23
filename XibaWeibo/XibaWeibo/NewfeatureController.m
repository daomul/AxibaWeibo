//
//  NewfeatureController.m
//  XibaWeibo
//
//  Created by K3CLOUDBOS on 15/7/23.
//  Copyright (c) 2015年 axiba. All rights reserved.
//

#import "NewfeatureController.h"
#define NFcount 4

@interface NewfeatureController () <UIScrollViewDelegate>

@property (nonatomic,weak) UIPageControl *pageC;
@property (nonatomic,weak) UIScrollView *scrollV;

@end

@implementation NewfeatureController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //1、添加一个scrollView
    UIScrollView *scrollV = [[UIScrollView alloc]init];
    scrollV.frame = self.view.bounds;
    scrollV.delegate = self;
    self.scrollV = scrollV;
    [self.view addSubview:scrollV];
    
    
    //2、往scrollView里面添加图片
    CGFloat scrollVW = scrollV.width;
    CGFloat scrollVH = scrollV.height;
    for (int i = 0; i < NFcount; i++) {
        //控制位置和尺寸
        UIImageView *img = [[UIImageView alloc]init];
        img.width = scrollVW;
        img.height = scrollVH;
        img.x = i * scrollVW;
        img.y = 0;
        //图片
        NSString *str = [NSString stringWithFormat:@"new_feature_%d",i + 1];
        img.image = [UIImage imageNamed:str];
        
        [scrollV addSubview:img];
    }
    
    //2.1设置scrollview的属性
    
    //设置弹簧的范围，不设置的话scrollview不知道可以拉伸的距离，拉动不会有效果的
    scrollV.contentSize = CGSizeMake(NFcount * scrollVW, 0);
    //设置分页的效果，设置之后拖动会有四舍五入般的控制view的图片的分页停留
    scrollV.pagingEnabled = YES;
    //去除边缘地方的弹簧效果
    scrollV.bounces = NO;
    //去除水平方向的滚动条的显示
    scrollV.showsHorizontalScrollIndicator= NO;
    
    //3、添加UIPageControl （小点点）
    UIPageControl *pageC = [[UIPageControl alloc]init];
    pageC.numberOfPages = NFcount;
    pageC.currentPageIndicatorTintColor = XBColor(253, 98, 42);
    pageC.pageIndicatorTintColor = XBColor(189, 189, 189);
    
    //3.1 设置UIPageControl的属性
    pageC.centerX = scrollVW * 0.5;
    pageC.centerY = scrollVH - 50;
    
    self.pageC = pageC;
    [self.view addSubview:pageC];
}

#pragma  mark -- scrollView的在协议方法
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //scrollView滚动的时候多次调用
    double page =scrollView.contentOffset.x / scrollView.width;
    self.pageC.currentPage = (int)(page + 0.5);
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
