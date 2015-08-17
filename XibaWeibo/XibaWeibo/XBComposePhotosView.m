//
//  XBComposePhotosView.m
//  XibaWeibo
//
//  Created by K3CLOUDBOS on 15/8/17.
//  Copyright (c) 2015年 axiba. All rights reserved.
//

#import "XBComposePhotosView.h"

@implementation XBComposePhotosView


#pragma mark -- life cycle 
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _photos = [NSMutableArray array];
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    NSUInteger count = self.subviews.count;
    int maxCol = 4;
    CGFloat imageWH = 70;
    CGFloat imageMargin = 10;
    
    for (int i = 0; i<count; i++) {
        UIImageView *photoView = self.subviews[i];
        
        int col = i % maxCol;
        photoView.x = col * (imageWH + imageMargin);
        
        int row = i / maxCol;
        photoView.y = row * (imageWH + imageMargin);
        photoView.width = imageWH;
        photoView.height = imageWH;
    }
}

#pragma mark - public methods

-(void)addPhoto:(UIImage *)photo
{
    UIImageView *img = [[UIImageView alloc]init];
    img.image = photo;
    
    //选完照片添加到当前，才会调用layoutSubviews
    [self addSubview:img];
    
    [self.photos addObject:photo];
}

@end
