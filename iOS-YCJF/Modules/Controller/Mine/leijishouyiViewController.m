//
//  leijishouyiViewController.m
//  iOS-CHJF
//
//  Created by garday on 2017/3/28.
//  Copyright © 2017年 garday. All rights reserved.
//

#import "leijishouyiViewController.h"
#import "payTableViewCell.h"
#import "myBillsViewController.h"
#import "zhangdanViewController.h"
#import "fundRecordViewController.h"
#import "myjiangliViewController.h"
@interface leijishouyiViewController ()<UITableViewDataSource,UITableViewDelegate>{
    UILabel *label1 ;
}
/***tabbarview ***/
@property (nonatomic ,strong)UITableView *tab;
/***<#注释#> ***/
@property (nonatomic ,strong)UIView *HeaderView;
@property (nonatomic ,strong)NSArray *arra;
/***<#注释#> ***/
@property (nonatomic ,strong)NSMutableArray *Zcarrq;

@end

@implementation leijishouyiViewController
-(NSArray *)arra{
    if (!_arra) {
        _arra = [NSArray array];
        _arra = @[@"投资利息收益",@"奖劵收益",@"利息管理费",@"提现手续费",@"推荐人奖励",@"活动奖励"];
    }
    return _arra;
}
-(NSMutableArray *)Zcarrq{
    if (!_Zcarrq) {
        _Zcarrq = [[NSMutableArray alloc]init];
    }return _Zcarrq;
}
-(UIView *)HeaderView{
    if (!_HeaderView) {
        _HeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 174)];
        _HeaderView.backgroundColor =lancolor;
        UIImageView *img = [[UIImageView alloc]initWithFrame:self.HeaderView.frame];
        img.image = [UIImage imageNamed:@"gb_Graph_o"];
        
        [_HeaderView addSubview:img];
        
        UILabel *label = [[UILabel alloc] init];
        label.text = @"累计收益(元)";
        label.font = [UIFont fontWithName:@".PingFangSC-Regular" size:15];
        label.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1/1.0];
        [img addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.offset(0);
            make.top.offset(39);
        }];
        label1 = [[UILabel alloc] init];
        label1.text = @"0.00";
        label1.font = [UIFont fontWithName:@".PingFangSC-Regular" size:44];
        label1.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1/1.0];
        [img addSubview:label1];
        [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.offset(0);
            make.top.equalTo(label.mas_bottom).offset(20);
        }];
        
        
    }
    return _HeaderView;
}
-(UITableView *)tab{
    if (!_tab) {
        _tab = [[UITableView alloc]initWithFrame:CGRectMake(0, 11, self.view.width, self.view.height-121-78) style:UITableViewStyleGrouped];
        _tab.backgroundColor =grcolor;
        _tab.delegate = self;
        _tab.dataSource = self;
        _tab.tableHeaderView = self.HeaderView;
        

    }
    return _tab;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tab];
    self.view.backgroundColor = grcolor;
    _tab.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopics)];
    _tab.mj_header.automaticallyChangeAlpha = YES;//自动改变透明度
//    [_tab.mj_header beginRefreshing];
    [self loadNewTopics];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = @"累计收益";
    [MobClick beginLogPageView:self.title];
    [TalkingData trackPageBegin:self.title];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:self.title];
    [TalkingData trackPageEnd:self.title];
}
-(void)loadNewTopics
{
    NSMutableDictionary *pass =[NSMutableDictionary dictionary];
    pass[@"uid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"uid"];
    pass[@"sid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"sid"];
    pass[@"at"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"at"];
    pass[@"version"] = @"v1.0.3";
    pass[@"os"] = @"ios";
    [WWZShuju initlizedData:zcmxurl paramsdata:pass dicBlick:^(NSDictionary *info) {
        NSLog(@"%@",info);
       
        label1.text =info[@"data"][@"tot_shouyi"];
        
        [self.Zcarrq addObject:info[@"data"][@"v_tcur_lixi"]];
        [self.Zcarrq addObject:info[@"data"][@"v_tcur_lixi"]];
        [self.Zcarrq addObject:info[@"data"][@"v_ttot_lixiguanlifei"]];
        [self.Zcarrq addObject:info[@"data"][@"v_tot_cashout_fee"]];
        [self.Zcarrq addObject:info[@"data"][@"tjrjiangli"]];
        [self.Zcarrq addObject:info[@"data"][@"v_huodongjiangli"]];
        
        NSLog(@"%@",self.Zcarrq);
        [self.tab reloadData];
        [self.tab.mj_header endRefreshing];
    }];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
//组中的元素
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arra.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 1;
}

//分组间距
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 0;//section头部高度
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        zhangdanViewController * vc = [[zhangdanViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 1) {
        myBillsViewController * vc = [[myBillsViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 4) {
        myjiangliViewController * vc = [[myjiangliViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 3) {
        myBillsViewController * vc = [[myBillsViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 5) {
        myBillsViewController * vc = [[myBillsViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 2) {
        myBillsViewController * vc = [[myBillsViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    payTableViewCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"payTableViewCell" owner:nil options:nil]lastObject];
    cell.xslab.text = _arra[indexPath.row];
    cell.xslab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    cell.xslab.textColor = [UIColor colorWithRed:73/255.0 green:73/255.0 blue:73/255.0 alpha:1/1.0];
    if (self.Zcarrq.count>1) {
        cell.nrlab.text =self.Zcarrq[indexPath.row]  ;
    }else{
        cell.nrlab.text = @"加载中";
    }
    
    cell.nrlab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    cell.nrlab.textColor = [UIColor colorWithRed:57/255.0 green:149/255.0 blue:223/255.0 alpha:1/1.0];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
    
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
