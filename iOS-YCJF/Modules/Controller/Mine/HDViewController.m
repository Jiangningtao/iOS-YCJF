//
//  HDViewController.m
//  iOS-CHJF
//
//  Created by garday on 2017/3/21.
//  Copyright © 2017年 garday. All rights reserved.
//

#import "HDViewController.h"
#import "SRTableViewCell.h"
#import "zdxqViewController.h"
#import "zdmodel.h"
@interface  HDViewController  ()<UITableViewDataSource,UITableViewDelegate>
/***<#注释#> ***/
@property (nonatomic ,strong)UITableView *tab;
/***上一次的请求参数 ***/
@property (nonatomic ,strong)NSDictionary *params;
/***<#注释#> ***/
@property (nonatomic ,strong)NSMutableArray *Modelarr;
@end

@implementation  HDViewController
-(NSMutableArray *)Modelarr{
    if (!_Modelarr) {
        _Modelarr = [[NSMutableArray alloc] init];
    }
    return _Modelarr;
}
-(UITableView *)tab{
    if (!_tab) {
        self.tab = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, ScreenHeight-180) style:UITableViewStyleGrouped];
        self.tab.dataSource= self;
        self.tab.delegate = self;
        self.tab.backgroundColor =grcolor;
    }
    return _tab;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.Modelarr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SRTableViewCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"SRTableViewCell" owner:nil options:nil]lastObject];
    zdmodel * model = self.Modelarr[indexPath.row];
    cell.titleLab.text = model.money;
    cell.chongzhiLab.text = model.actname;
    cell.timeLab.text = model.time_use;
    return cell;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *header = [[UIView alloc] init];
    UILabel *la = [[UILabel alloc]init];
    la.textColor =[UIColor blackColor];
//    la.text = @"10月账单";
    la.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
    la.width = 200;
    la.x = 19;
    la.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [header addSubview:la];
    return header;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    zdxqViewController *cx = [[zdxqViewController alloc]init];
    zdmodel *mode = self.Modelarr[indexPath.row];
    //金额人就是money，文字说明用actname,时间用time_use
    cx.arr = [[NSMutableArray alloc]initWithObjects:@"活动奖励",mode.time_use,mode.actname, nil];
    cx.mor = mode.money;
    [self.navigationController pushViewController:cx animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor = grcolor;
    [self.view addSubview:self.tab];
     [self AFNetwork];
   
    // Do any additional setup after loading the view.
}
-(void)AFNetwork{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"uid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"uid"];
    params[@"sid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"sid"];
    params[@"at"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"at"];
    params[@"version"] = @"v1.0.3";
    params[@"os"] = @"ios";
    params[@"pageSize"] = @"10";
    params[@"pageIndex"] = @"1";
    params[@"is_used"] = @"1";
    
    self.params = params;
    [WWZShuju initlizedData:getTouziurl paramsdata:params dicBlick:^(NSDictionary *info) {
        if (self.params != params)return ;
        NSLog(@"---奖励-----%@",info);
        self.Modelarr = [zdmodel mj_objectArrayWithKeyValuesArray:info[@"data"]];
              [self.tab reloadData];
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
    }];
    
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