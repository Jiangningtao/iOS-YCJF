//
//  mingxi1ViewController.m
//  iOS-CHJF
//
//  Created by garday on 2017/4/11.
//  Copyright © 2017年 garday. All rights reserved.
//

#import "mingxi1ViewController.h"
#import "mingxiTableViewCell.h"
#import "mingxiModel.h"
@interface mingxi1ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic ,strong)UITableView *tab;
/***上一次的请求参数 ***/
@property (nonatomic ,strong)NSDictionary *params;
/***<#注释#> ***/
@property (nonatomic ,strong)NSMutableArray *Modelarr;
@end

@implementation mingxi1ViewController
-(NSMutableArray *)Modelarr{
    if (!_Modelarr) {
        _Modelarr = [NSMutableArray array];
    }
    return _Modelarr;
}

-(UITableView *)tab{
    if (!_tab) {
        _tab = [[UITableView alloc]initWithFrame:CGRectMake(0, 20+66, self.view.frame.size.width, self.view.frame.size.height-11-44) style:UITableViewStyleGrouped];
        _tab.backgroundColor = grcolor;
        _tab.delegate = self;
        _tab.dataSource = self;
        _tab.estimatedRowHeight = 0;
        _tab.estimatedSectionHeaderHeight = 0;
        _tab.estimatedSectionFooterHeight = 0;
    }
    return _tab;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self AFNetwork];
    [self.view addSubview:self.tab];
   
    if (@available(iOS 11.0, *)) {
        self.tab.contentInsetAdjustmentBehavior = UIApplicationBackgroundFetchIntervalNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = false;
    }
}
-(void)AFNetwork{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"uid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"uid"];
    params[@"sid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"sid"];
    params[@"at"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"at"];
    params[@"version"] = @"v1.0.3";
    params[@"os"] = @"ios";
    params[@"pageIndex"] = @"1";
   params[@"pageSize"] = @"10";
   
    self.params = params;
    [WWZShuju initlizedData:czjlurl paramsdata:params dicBlick:^(NSDictionary *info) {
        if (self.params != params)return ;
        NSLog(@"---充值-----%@",info);
        self.Modelarr = [mingxiModel mj_objectArrayWithKeyValuesArray:info[@"data"]];
        NSLog(@"----%@",info[@"data"]);
         NSLog(@"----%@",self.Modelarr);
        if (self.Modelarr.count == 0) {
            UIImageView *imv = [[UIImageView alloc]init];
            imv.image = [UIImage imageNamed:@"pic_zwsj"];
            [self.view addSubview:imv];
            [imv mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.offset(0);
                make.centerY.offset(0);
                make.width.offset(155);
                make.height.offset(194);
            }];
        }
        [self.tab reloadData];
    }];
    
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.Modelarr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    mingxiTableViewCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"mingxiTableViewCell" owner:nil options:nil]lastObject];
    cell.model = self.Modelarr[indexPath.row];
    NSLog(@"----de%@",cell.model);
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
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
