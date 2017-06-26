//
//  UILabel+extension.m
//  项目整理
//
//  Created by shengtian on 2017/6/23.
//  Copyright © 2017年 shengtian. All rights reserved.
//

#import "UILabel+extension.h"

@implementation UILabel (extension)
-(void)setSpacing:(CGFloat)spacing withText:(NSString*)text numberOfLine:(NSInteger)line;{
    if (text.length<=0||!self||!spacing) {
        return;
    }
    self.numberOfLines = line;
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:spacing];
    [paragraphStyle1 setLineBreakMode:NSLineBreakByTruncatingTail];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [text length])];
    [self setAttributedText:attributedString1];
    [self sizeToFit];
}
@end
