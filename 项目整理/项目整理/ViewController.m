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
#import "Tools.h"
#import "SqliteManager.h"
#import "TestData.h"
#import "LucencyViewController.h"
@interface ViewController (){
    NSString *_uid;//用户ID;
    int _dynTag;//动态标签类型
}
@property (nonatomic,strong) NSMutableArray *maDynList;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"首页";
    self.maDynList = [[TestData generateDynData] mutableCopy];
    _uid = @"10001";
    _dynTag = 1;
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
    
    DebugLog(@"%@",[[NSString getIPString] md5]);
    
    DebugLog(@"%@",[[NSString getIPString] encodeBase64]);
    
    DebugLog(@"%@",[[[NSString getIPString] encodeBase64] decodeBase64]);
    
    NSString *pubPath = [[NSBundle mainBundle] pathForResource:@"rsacert.der" ofType:nil];
    
    
    NSString *originalString = @"这是一段将要使用'.der'文件加密的字符串!";
    
    
    NSString *public_key_path = [[NSBundle mainBundle] pathForResource:@"public_key.der" ofType:nil];
    NSString *private_key_path = [[NSBundle mainBundle] pathForResource:@"private_key.p12" ofType:nil];
    
    NSString *encryptStr = [Tools encryptString:originalString publicKeyWithContentsOfFile:public_key_path];
    NSLog(@"加密前:%@", originalString);
    NSLog(@"加密后:%@", encryptStr);
    NSLog(@"解密后:%@", [Tools decryptString:encryptStr privateKeyWithContentsOfFile:private_key_path password:@"Mdd123123"]);
    
    
    [[SqliteManager sharedInstance] updateDynWithTag:_dynTag userID:_uid dynList:self.maDynList complete:^(BOOL success, id obj) {
        if (success) {
            NSLog(@"更新动态列表成功");
//            [self _showResultWithTitle:@"更新动态列表" obj:@"更新动态列表成功"];
        }else{
            NSLog(@"更新动态列表失败");
//            [self _showResultWithTitle:@"更新动态列表" obj:@"更新动态列表失败"];
        }
    }];
    
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)presses{
    [self.navigationController pushViewController:[[LucencyViewController alloc]init] animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
