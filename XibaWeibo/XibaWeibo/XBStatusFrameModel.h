//
//  XBStatusFrameModel.h
//  XibaWeibo
//
//  Created by K3CLOUDBOS on 15/8/2.
//  Copyright (c) 2015年 axiba. All rights reserved.
//

#import <Foundation/Foundation.h>
@class XBStatusModel;

@interface XBStatusFrameModel : NSObject

/** 微博模型数据 */
@property (nonatomic,strong) XBStatusModel *status;
/** 原创微博整体 */
@property (nonatomic, assign) CGRect originalViewF;
/** 头像 */
@property (nonatomic, assign) CGRect headIconViewF;


/** cell的高度 */
@property (nonatomic, assign) CGFloat cellHeight;


@end
