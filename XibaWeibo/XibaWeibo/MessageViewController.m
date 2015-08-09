//
//  MessageViewController.m
//  XibaWeibo
//
//  Created by bos on 15-6-10.
//  Copyright (c) 2015年 axiba. All rights reserved.
//

#import "MessageViewController.h"
#import "MessagereviewViewController.h"

@interface MessageViewController () <UITableViewDataSource>

@end

@implementation MessageViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"写私信" style:UIBarButtonItemStylePlain target:self action:@selector(privateMessage)];
    
    //注意：这里设置为不可点击时，时机很重要（如果是view 已经创建里的话，放在viewWillAppear才有效果，如果时viewDidLoad的话，则还没有加载到主题），对应的我们在XBNavigationController中设置不可见时的主题样式
    //self.navigationItem.rightBarButtonItem.enabled = NO;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - barItem点击事件
-(void)privateMessage
{
    NSLog(@"写私信");
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 20;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *IDentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IDentifier];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:IDentifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%d我是好人嘛？%d",indexPath.section,indexPath.row];
    return cell;
}

#pragma mark - Table view delegte
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessagereviewViewController *reviewVC = [[MessagereviewViewController alloc]init];
    reviewVC.title = @"消息回复";
    //reviewVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:reviewVC animated:YES];
}

@end
