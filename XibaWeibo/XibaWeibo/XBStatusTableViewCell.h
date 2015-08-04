//
//  XBStatusTableViewCell.h
//  XibaWeibo
//
//  Created by K3CLOUDBOS on 15/8/2.
//  Copyright (c) 2015年 axiba. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XBStatusFrameModel;

@interface XBStatusTableViewCell : UITableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic,strong)XBStatusFrameModel *statusFrame;
@end
