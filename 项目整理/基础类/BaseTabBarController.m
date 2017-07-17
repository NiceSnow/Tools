//
//  BaseTabBarController.m
//  31jinfu
//
//  Created by 刘厚宽 on 2017/5/5.
//  Copyright © 2017年 刘厚宽. All rights reserved.
//

#import "BaseTabBarController.h"

@interface BaseTabBarController ()<UITabBarControllerDelegate>

@end

@implementation BaseTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tabBar setTranslucent:NO];
    [self.tabBar setBackgroundImage:[UIImage new]];
    [self.tabBar setTintColor:[UIColor purpleColor]];
    self.delegate = self;
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
//    UINavigationController * nav = (UINavigationController *)viewController;
//    if ([nav.topViewController isKindOfClass:[MainRootViewController class]]) {
//        return [UserHelper isLogin:self];
//    }
    return YES;
}


@end
