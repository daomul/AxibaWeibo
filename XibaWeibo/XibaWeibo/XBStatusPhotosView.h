//
//  XBStatusPhotosView.h
//  XibaWeibo
//
//  Created by K3CLOUDBOS on 15/8/8.
//  Copyright (c) 2015年 axiba. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XBStatusPhotosView : UIView

@property(nonatomic,strong) NSArray *photos;

+(CGSize)sizeWithCount:(int)count;
@end
