//
//  XBStatusPhotosView.m
//  XibaWeibo
//
//  Created by K3CLOUDBOS on 15/8/8.
//  Copyright (c) 2015年 axiba. All rights reserved.
//

#define XBStatusPhotoWH 70
#define XBStatusPhotoMargin 10

//最大列数
#define XBStatusPhotoMaxCol(count) ((count==4)?2:3)

#import "XBStatusPhotosView.h"
#import "XBPhotoModel.h"
#import "XBStatusPhotoView.h"

@implementation XBStatusPhotosView

#pragma mark -- life cycle
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    // 动态计算图片流里面布局的尺寸和位置
    int photosCount = self.photos.count;
    int maxCol = XBStatusPhotoMaxCol(photosCount);
    for (int i = 0; i < photosCount; i++)
    {
        XBStatusPhotoView *photoView = self.subviews[i];
        
        //动态计算当前图片的行号和列号 0开始的
        int col = i % maxCol;
        int row = i / maxCol;
        
        //动态计算当前图片的尺寸和位置
        photoView.x = col * (XBStatusPhotoMargin + XBStatusPhotoWH);
        photoView.y = row * (XBStatusPhotoMargin + XBStatusPhotoWH);
        photoView.width = XBStatusPhotoWH;
        photoView.height = XBStatusPhotoWH;
    }
}

#pragma mark -- public method 根据图片流的个数计算图片需要的区域大小

+(CGSize)sizeWithCount:(int)count
{
    // 计算最大的列数 2或者3
    int maxCol = XBStatusPhotoMaxCol(count);
    
    // 计算出当前有几列几行
    int col = (count > maxCol)?maxCol:count;
    int row = (count + maxCol - 1) / maxCol;
    
    // 根据列数和行数计算出总的需要的宽高
    CGFloat photoW = col * (XBStatusPhotoWH + XBStatusPhotoMargin);
    CGFloat photoH = row * (XBStatusPhotoWH + XBStatusPhotoMargin);
    
    return (CGSize){photoW,photoH};
}

#pragma mark -- getter and setter
-(void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    
    int photosCount = photos.count;
    
    // 1、创建足够多的图像，这里的判断是在于循环利用cell中，当实际需要的图片数目比缓存中已经创建的要多的时候，就需要再多创建不够的数目
    while (self.subviews.count < photosCount)
    {
        XBStatusPhotoView *photo = [[XBStatusPhotoView alloc]init];
        [self addSubview:photo];
    }
    
    // 2、然后就可以对所有的图片传值，控制可见性(比如缓存已经创建的是比较多个图像的，但是实际不需要那么多，那么循环利用的过程就需要讲它们隐藏)
    for (int i = 0; i < self.subviews.count; i++)
    {
        XBStatusPhotoView *photoView = self.subviews[i];
        if (i < photosCount)
        {
            photoView.photo = photos[i];
            photoView.hidden = NO;
        }
        else
        {
            photoView.hidden = YES;
        }
    }
}

@end
