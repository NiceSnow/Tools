//
//  Tools.h
//  项目整理
//
//  Created by shengtian on 2017/6/22.
//  Copyright © 2017年 shengtian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface Tools : NSObject
/**
 生成指定大小的image
 
 @param size 大小
 @return image
 */

+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size;
@end
