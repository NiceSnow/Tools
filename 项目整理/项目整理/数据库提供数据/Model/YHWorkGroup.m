//
//  YHWorkGroup.m
//  PikeWay
//
//  Created by YHIOS002 on 16/5/5.
//  Copyright © 2016年 YHSoft. All rights reserved.
//

#import "YHWorkGroup.h"
#import <UIKit/UIKit.h>


extern const CGFloat contentLabelFontSize;
extern CGFloat maxContentLabelHeight;
extern CGFloat maxContentRepostLabelHeight;
extern const CGFloat kMarginContentLeft;
extern const CGFloat kMarginContentRight;

@implementation YHWorkGroup
{
    CGFloat _lastContentWidth;
}


//YHSERIALIZE_DESCRIPTION();

@synthesize msgContent = _msgContent;

- (void)setMsgContent:(NSString *)msgContent
{
    _msgContent = msgContent;
}



- (void)setIsOpening:(BOOL)isOpening
{
    if (!_shouldShowMoreButton) {
        _isOpening = NO;
    } else {
        _isOpening = isOpening;
    }
}

#pragma mark - YHFMDB
+ (NSString *)DB_PrimaryKey{
    return @"dynamicId";
}

+ (NSDictionary *)DB_ReplacedKeyFromPropertyName{
    return @{@"dynamicId":DB_PrimaryKey};
}


+ (NSDictionary *)DB_ReplacedKeyFromDictionaryWhenPropertyIsObject{
    return @{@"userInfo":[NSString stringWithFormat:@"userInfo%@",DB_AppendingID],
             @"forwardModel":[NSString stringWithFormat:@"forwardModel%@",DB_AppendingID]};
}

+ (NSDictionary *)DB_GetClassForKeyIsObject{
    return @{@"userInfo":[YHUserInfo class],
             @"forwardModel":[YHWorkGroup class]};
}

+ (NSArray *)DB_PropertyDonotSave{
    return @[@"contentW",@"lastContentWidth",@"isOpening",@"shouldShowMoreButton",@"showDeleteButton",@"hiddenBotLine"];
}

@end
