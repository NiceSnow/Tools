//
//  UIButton+extension.m
//  项目整理
//
//  Created by shengtian on 2017/6/23.
//  Copyright © 2017年 shengtian. All rights reserved.
//

#import "UIButton+extension.h"

@implementation UIButton (extension)
-(void)setSpacing:(CGFloat)spacing withText:(NSString*)text forState:(UIControlState)state numberOfLine:(NSInteger)line;{
    if (text.length<=0||!self ||!spacing) {
        return;
    }
    self.titleLabel.numberOfLines = line;
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:spacing];
    [paragraphStyle1 setLineBreakMode:NSLineBreakByTruncatingTail];
    [paragraphStyle1 setAlignment:NSTextAlignmentCenter];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [text length])];
    [self setAttributedTitle:attributedString1 forState:state];
}
@end
