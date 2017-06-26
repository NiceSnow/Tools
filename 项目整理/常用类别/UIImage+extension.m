//
//  UIImage+extension.m
//  项目整理
//
//  Created by shengtian on 2017/6/23.
//  Copyright © 2017年 shengtian. All rights reserved.
//

#import "UIImage+extension.h"

@implementation UIImage (extension)
-(UIImage*)imageStretch:(UIEdgeInsets)edgeInsets;{
    return [self resizableImageWithCapInsets:edgeInsets resizingMode:UIImageResizingModeStretch];
}

-(UIImage*)imageZoom:(CGSize)size;{
    UIImage *newimage;
    if (nil == self) {
        newimage = nil;
    }else{
        UIGraphicsBeginImageContext(size);
        [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newimage;
}

-(UIImage*)imageZip{
    if (!self)
    {
        return nil;
    }
    NSData *data =UIImagePNGRepresentation(self);
    CGFloat dataSize = data.length/1024;
    CGFloat width  = self.size.width;
    CGFloat height = self.size.height;
    CGSize size;
    
    if (dataSize<=50)//小于50k
    {
        return self;
    }
    else if (dataSize<=100)//小于100k
    {
        size = CGSizeMake(width/1.f, height/1.f);
    }
    else if (dataSize<=200)//小于200k
    {
        size = CGSizeMake(width/2.f, height/2.f);
    }
    else if (dataSize<=500)//小于500k
    {
        size = CGSizeMake(width/2.f, height/2.f);
    }
    else if (dataSize<=1000)//小于1M
    {
        size = CGSizeMake(width/2.f, height/2.f);
    }
    else if (dataSize<=2000)//小于2M
    {
        size = CGSizeMake(width/2.f, height/2.f);
    }
    else//大于2M
    {
        size = CGSizeMake(width/2.f, height/2.f);
    }
    NSLog(@"%f,%f",size.width,size.height);
    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(0,0, size.width, size.height)];
    UIImage *newImage =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    if (!newImage)
    {
        return self;
    }
    return newImage;
}

- (UIImage *)imageInRect:(CGRect)rect;{
    CGImageRef sourceImageRef = [self CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    return newImage;
}

@end
