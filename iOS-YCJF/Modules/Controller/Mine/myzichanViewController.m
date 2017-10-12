//
//  myzichanViewController.m
//  iOS-CHJF
//
//  Created by garday on 2017/3/28.
//  Copyright © 2017年 garday. All rights reserved.
//

#import "myzichanViewController.h"
#import "payTableViewCell.h"
#import "CashValueViewController.h"
#import "myBillsViewController.h"
#import "touziViewController.h"
#import "zhangdanViewController.h"
@interface myzichanViewController ()<UITableViewDataSource,UITableViewDelegate>{
    UILabel *label1 ;
  
}
/***tabbarview ***/
@property (nonatomic ,strong)UITableView *tab;
/***<#注释#> ***/
@property (nonatomic ,strong)UIView *HeaderView;
/***<#注释#> ***/
@property (nonatomic ,strong)NSArray *arra;
/***<#注释#> ***/
@property (nonatomic ,strong)NSMutableArray *Zcarr;


@end

@implementation myzichanViewController
-(NSArray *)arra{
    if (!_arra) {
        _arra = [NSArray array];
        _arra = @[@"可提金额",@"不可提金额",@"提现中金额",@"投资冻结金额",@"待收本金",@"待收收益"];
    }
    return _arra;
}
-(NSMutableArray *)Zcarr{
    if (!_Zcarr) {
        _Zcarr = [[NSMutableArray alloc]init];
    }return _Zcarr;
}
-(UIView *)HeaderView{
    if (!_HeaderView) {
        _HeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 174)];
        _HeaderView.backgroundColor =lancolor;
        UIImageView *img = [[UIImageView alloc]initWithFrame:self.HeaderView.frame];
        img.image = [UIImage imageNamed:@"bg_Graph_b"];

        [_HeaderView addSubview:img];
        
        UILabel *label = [[UILabel alloc] init];
        label.text = @"我的资产(元)";
        label.font = [UIFont fontWithName:@".PingFangSC-Regular" size:15];
        label.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1/1.0];
        [img addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.offset(0);
            make.top.offset(39);
        }];
        label1 = [[UILabel alloc] init];
        label1.text = @"";
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
        
        label1.text =info[@"data"][@"tot_money"];
       
        [self.Zcarr addObject:info[@"data"][@"ky_account"]];
        [self.Zcarr addObject:info[@"data"][@"bky_account"]];
        [self.Zcarr addObject:info[@"data"][@"ky_freeze"]];
        [self.Zcarr addObject:info[@"data"][@"freeze_touzi"]];
         [self.Zcarr addObject:info[@"data"][@"v_twait_benjin"]];
        [self.Zcarr addObject:info[@"data"][@"v_twait_lixi"]];
       
        NSLog(@"%@",self.Zcarr);
        [self.tab reloadData];
        [self.tab.mj_header endRefreshing];
    }];

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = @"我的资产";
    [MobClick beginLogPageView:self.title];
    [TalkingData trackPageBegin:self.title];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:self.title];
    [TalkingData trackPageEnd:self.title];
}
- (void)viewDidLoad {
    [super viewDidLoad];
        self.view.backgroundColor = grcolor;
    [self.view addSubview:self.tab];
    _tab.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopics)];
    _tab.mj_header.automaticallyChangeAlpha = YES;//自动改变透明度
    [self loadNewTopics];
//    [_tab.mj_header beginRefreshing];
 // Do any additional setup after loading the view.
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
    if (indexPath.row == 0 || indexPath.row ==1) {
        // 可提金额  不可提金额
        CashValueViewController * withVC = [[CashValueViewController alloc] init];
        [self.navigationController pushViewController:withVC animated:YES];
    }else if (indexPath.row == 2){
        // 提现中的金额
        CashValueViewController *vc = [[CashValueViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 3){
        // 投资记录
        touziViewController *cx = [[touziViewController alloc]init];
        [self.navigationController pushViewController:cx animated:YES];
    }else if (indexPath.row == 4 || indexPath.row == 5){
        // 我的账单
        zhangdanViewController *cx = [[zhangdanViewController alloc]init];
        [self.navigationController pushViewController:cx animated:YES];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    payTableViewCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"payTableViewCell" owner:nil options:nil]lastObject];
    cell.xslab.text = self.arra[indexPath.row];
    cell.xslab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    cell.xslab.textColor = [UIColor colorWithRed:73/255.0 green:73/255.0 blue:73/255.0 alpha:1/1.0];
    if (self.Zcarr.count>0) {
        cell.nrlab.text = self.Zcarr[indexPath.row];
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
