//
//  BaseNavigationController.m
//  31jinfu
//
//  Created by 刘厚宽 on 2017/5/5.
//  Copyright © 2017年 刘厚宽. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINavigationBar *navBar = [UINavigationBar appearance];
    UIBarButtonItem *barItem = [UIBarButtonItem appearance];
    
    //去掉UINavigationBar的阴影
    [navBar setShadowImage:[[UIImage alloc] init]];
    
    navBar.tintColor = [UIColor greenColor];
    [navBar setBarTintColor:[UIColor redColor]];
    
    [navBar setTitleTextAttributes:@{
                                     NSForegroundColorAttributeName : [UIColor greenColor],
                                     NSFontAttributeName : [UIFont systemFontOfSize:18]
                                     }];
    [barItem setTitleTextAttributes:@{
                                      NSForegroundColorAttributeName : [UIColor whiteColor],
                                      NSFontAttributeName : [UIFont systemFontOfSize:15]
                                      } forState:UIControlStateNormal];
    
    
}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    viewController.hidesBottomBarWhenPushed = YES;
    [super pushViewController:viewController animated:animated];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
