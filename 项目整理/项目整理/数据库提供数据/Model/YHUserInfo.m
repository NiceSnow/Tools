//
//  YHUserInfo.m
//  PikeWay
//
//  Created by kun on 16/4/25.
//  Copyright © 2016年 YHSoft. All rights reserved.
//

#import "YHUserInfo.h"
#import <UIKit/UIKit.h>

@implementation YHUserInfo


#pragma mark - YHFMDB
+ (NSString *)DB_PrimaryKey{
    return @"uid";
}

+ (NSDictionary *)DB_ReplacedKeyFromPropertyName{
    return @{@"uid":DB_PrimaryKey};
}

+ (NSDictionary *)DB_PropertyIsInstanceOfArray{
    return @{
             @"jobTags":[NSString class],
             @"workExperiences":[YHWorkExperienceModel class],
             @"eductaionExperiences":[YHEducationExperienceModel class]
             };
}

+ (NSDictionary *)DB_ReplacedKeyFromDictionaryWhenPropertyIsObject{
    return @{@"userSetting":[NSString stringWithFormat:@"userSetting%@",DB_AppendingID],
             
             };
}

#pragma mark - Life

- (void)dealloc {
}

@end
