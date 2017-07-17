//
//  LucencyViewController.m
//  项目整理
//
//  Created by shengtian on 2017/7/17.
//  Copyright © 2017年 shengtian. All rights reserved.
//

#import "LucencyViewController.h"
#import "LucencyViewController2.h"
#import "BaseNavigationController.h"

@interface LucencyViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSArray * itemsArr;
@property(nonatomic,strong) UITableView* tableView;

@end

@implementation LucencyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"透明导航栏";
    [self.view addSubview:self.tableView];
    _itemsArr = @[@"折线图-第一象限",@"折线图-第一二象限",@"折线图第一四象限",@"折线图-全象限",@"饼图",@"环状图",@"柱状图",@"表格",@"雷达图",@"散点图"];
    // Do any additional setup after loading the view.
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat minAlphaOffset = - 64;
    CGFloat maxAlphaOffset = 200;
    CGFloat offset = scrollView.contentOffset.y;
    CGFloat alpha = (offset - minAlphaOffset) / (maxAlphaOffset - minAlphaOffset);
    NSLog(@"%@",@(alpha));
    self.barImageView.alpha = alpha;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _itemsArr.count;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LucencyViewController2 *show = [LucencyViewController2 new];
    
    show.index = indexPath.row;
    
    [self.navigationController pushViewController:show animated:YES];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = _itemsArr[indexPath.row];
    return cell;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:screenBounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tableView.delegate = self;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tableView.delegate = nil;
    self.barImageView.alpha = 1;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
