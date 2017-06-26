//
//  UIImage+extension.h
//  项目整理
//
//  Created by shengtian on 2017/6/23.
//  Copyright © 2017年 shengtian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (extension)


/**
 图片拉伸

 @param edgeInsets 上左下右
 @return UIImage
 */
-(UIImage*)imageStretch:(UIEdgeInsets)edgeInsets;

/**
 图片缩放

 @param size 缩放大小
 @return 缩放后的image
 */
-(UIImage*)imageZoom:(CGSize)size;

/**
 图片压缩
 
 @return 缩放后的image
 */
-(UIImage*)imageZip;

/**
 *从图片中按指定的位置大小截取图片的一部分
 * UIImage image 原始的图片
 * CGRect rect 要截取的区域
 */
- (UIImage *)imageInRect:(CGRect)rect;



@end
