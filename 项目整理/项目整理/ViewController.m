//
//  ViewController.m
//  项目整理
//
//  Created by shengtian on 2017/6/22.
//  Copyright © 2017年 shengtian. All rights reserved.
//

#import "ViewController.h"
#import "UIButton+extension.h"
#import "UILabel+extension.h"
#import "NSString+extension.h"
#import "NSArray+extension.h"
#import "MacroDefinition.h"
#import "NSDictionary+extension.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 200, 80)];
    [btn addTarget:self action:@selector(presses) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = [UIColor redColor];
    [self.view addSubview:btn];
    [btn setSpacing:15 withText:@"哈里斯\n的叫法克aksjdhfakshdfajksdhfkjahsdf" forState:normal numberOfLine:2];
    
    UILabel* lable = [[UILabel alloc]initWithFrame:CGRectMake(100, 200, 200, 40)];
    [self.view addSubview:lable];
    [lable setSpacing:15 withText:@"哈里斯\n的叫法克aksjdhfakshdfajksdhfkjahsdf" numberOfLine:2];
    
    NSString* time = [NSString stringWithCurrentTime];
    
    NSString* str1 = [time timeToStringWithType:Y_M_D_h_m_s];
    
    NSArray* arr = @[@"123",@"414"];
    DebugLog(@"%@",[arr toJsonString]);
    NSMutableArray* muArray = [arr mutableCopy];
    NSString *json = [muArray toJsonString];
    
    NSArray* jsArray = [json jsonStringToObject];
    
    NSDictionary* dic = @{@"1":@"a",
                          @"2":@"b",
                          };
    
    NSString *dicJson = [dic toJsonString];
    NSDictionary* jsonDic = [dicJson jsonStringToObject];
    
    DebugLog(@"%@",[jsonDic objectForKey:@"1"]);
    
    DebugLog(@"%@",[arr toJsonString]);
    
    DebugLog(@"%@",[NSString getIPString]);
    
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
