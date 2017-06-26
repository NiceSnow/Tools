//
//  UILabel+extension.h
//  项目整理
//
//  Created by shengtian on 2017/6/23.
//  Copyright © 2017年 shengtian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (extension)
/**
 文字间距
 
 @param spacing 间距大小
 @param text 显示文字
 @param line 行数
 */
-(void)setSpacing:(CGFloat)spacing withText:(NSString*)text numberOfLine:(NSInteger)line;
@end
