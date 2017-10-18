//
//  huikuanxqViewController.m
//  iOS-CHJF
//
//  Created by garday on 2017/3/21.
//  Copyright © 2017年 garday. All rights reserved.
//

#import "huikuanxqViewController.h"
#import "BiaoDetailViewController.h"

@interface huikuanxqViewController ()<UITableViewDataSource,UITableViewDelegate>{
    UILabel *labeltm;
    

}
/***<#注释#> ***/
@property (nonatomic ,strong)UIView *viewa;
/***<#注释#> ***/
@property (nonatomic ,strong)UIView *viewb;
/***<#注释#> ***/
@property (nonatomic ,strong)UITableView *tab;
/***<#注释#> ***/
@property (nonatomic ,strong)NSMutableArray *arr;
/***<#注释#> ***/
@property (nonatomic ,strong)NSMutableArray *DataArr;
@end

@implementation huikuanxqViewController
-(NSMutableArray *)DataArr{
    if (!_DataArr) {
        _DataArr = [[NSMutableArray alloc] init];
    }
    return _DataArr;
}
-(NSMutableArray *)arr{
    if (!_arr) {
        _arr = [[NSMutableArray alloc] init];
//        if (self.typ == TTGStateOK) {
        [_arr addObject:@"交易时间"];
         [_arr addObject:@"预期收益率"];
         [_arr addObject:@"项目期限"];
         [_arr addObject:@"回款方式"];
         [_arr addObject:@"投资金额"];
         [_arr addObject:@"预期收益"];
         [_arr addObject:@"回款时间"];

//
//        _arr = @[@"交易时间",@"预期收益率",@"项目期限",@"还款方式",@"投资金额",@"预期收益"];

    }
    return _arr;
}
-(UITableView *)tab{
    if (!_tab) {
        self.tab = [[UITableView alloc]initWithFrame:CGRectMake(0, 11, self.view.frame.size.width, self.view.frame.size.height+33) style:UITableViewStyleGrouped];
        self.tab.dataSource= self;
        self.tab.delegate = self;
        self.tab.backgroundColor =grcolor;
        self.tab.tableHeaderView = self.viewa;
        self.tab.tableFooterView = self.viewb;
//        _tab.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopics)];
//        _tab.mj_header.automaticallyChangeAlpha = YES;//自动改变透明度
//        [_tab.mj_header beginRefreshing];

        
    }
    return _tab;
}


-(UIView *)viewa{
    if(!_viewa){
        _viewa = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 80)];
        _viewa.backgroundColor = [UIColor whiteColor];
        
        self.labelbt = [[UILabel alloc] init];
        self.labelbt.text = @"";
        self.labelbt.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        self.labelbt.textColor = [UIColor colorWithRed:73/255.0 green:73/255.0 blue:73/255.0 alpha:1/1.0];
        [_viewa addSubview:self.labelbt];
        [self.labelbt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.offset(0);
            make.left.offset(7);
        }];
        
       self.labelsh = [[UILabel alloc] init];
        self.labelsh.text = @"";
        self.labelsh.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        self.labelsh.textColor =  [UIColor colorWithRed:253/255.0 green:128/255.0 blue:46/255.0 alpha:1/1.0];
        [_viewa addSubview:self.labelsh];
        [self.labelsh mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.offset(0);
            make.right.offset(-20);
        }];
    
    }
    return _viewa;
}
-(UIView *)viewb{
    if(!_viewb){
        _viewb = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 70)];
        _viewb.backgroundColor = [UIColor whiteColor];
        UIButton *btn = [[UIButton alloc] init];
        [btn setTitle:@"查看投资项目" forState:UIControlStateNormal];
        [btn setTitleColor: [UIColor colorWithRed:57/255.0 green:149/255.0 blue:223/255.0 alpha:1/1.0] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        btn.backgroundColor = [UIColor whiteColor];
        [btn addTarget:self action:@selector(brnClicked) forControlEvents:UIControlEventTouchUpInside];
        [_viewb addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.offset(0);
            make.centerY.offset(0);
              }];
    }
    return _viewb;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self Nav];
    [self.view addSubview:self.tab];

    [self loadNewTopics];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tab reloadData];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    
}

-(void)loadNewTopics{
    NSMutableDictionary *pass = [NSMutableDictionary dictionary];
    pass[@"version"] = @"v1.0.3";
    pass[@"os"] = @"ios";
    pass[@"uid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"uid"];
    pass[@"sid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"sid"];
    pass[@"at"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"at"];
    pass[@"id"] = self.mode.id;
    if (self.typ == TTGStateOK) {
        pass[@"bid"] = self.idstr;
    }else if (self.typ == TTGStateError){
        pass[@"bid"] = self.idstr1;
    }else{
        pass[@"bid"] = self.idstr2;
    }
   
    NSLog(@"%@?%@", tzlburl, pass);
    [WWZShuju initlizedData:tzlburl paramsdata:pass dicBlick:^(NSDictionary *info) {
        NSLog(@"------%@",info);
        
        self.labelbt.text =info[@"name"];
        
        if ([info[@"status"] isEqualToString:@"0"]) {
            self.labelsh.text =@"待初审";
            self.labelsh.textColor = [UIColor lightGrayColor];
        }else if ([info[@"status"] isEqualToString:@"1"]){
            self.labelsh.text =@"募集中";
            self.labelsh.textColor = lancolor;
        }else if ([info[@"status"]isEqualToString:@"2"]){
            self.labelsh.text =@"初审失败";
            self.labelsh.textColor = [UIColor lightGrayColor];
        }else if ([info[@"status"] isEqualToString:@"3"]){
            self.labelsh.text =@"回款中";
            self.labelsh.textColor = [UIColor orangeColor];
        }else if ([info[@"status"] isEqualToString:@"4"]){
            self.labelsh.text =@"复审失败";
            self.labelsh.textColor = [UIColor lightGrayColor];
        }else if ([info[@"status"] isEqualToString:@"5"]){
            self.labelsh.text =@"用户自行撤销";
            self.labelsh.textColor = [UIColor lightGrayColor];
        }else if ([info[@"status"] isEqualToString:@"6"]){
            self.labelsh.text =@"回款成功";
            self.labelsh.textColor = [UIColor lightGrayColor];
        }else if ([info[@"status"] isEqualToString:@"7"]){
            self.labelsh.text =@"自动投标中";
            self.labelsh.textColor = [UIColor lightGrayColor];
        }else if ([info[@"status"] isEqualToString:@"8"]){
            self.labelsh.text =@"复审中";
            self.labelsh.textColor = [UIColor lightGrayColor];
        }
//        NSLog(@"--c--c--c %@",self.idstr);
        NSArray *keyArr = [info allKeys];
        if ([keyArr containsObject:@"time_h"]) {
            [_DataArr addObject:info[@"time_h"]];
        }else{
            [_DataArr addObject:@""];
        }
        
        //换成这样的试试 你继续
        if ([keyArr containsObject:@"borrow_apr"]) {
            [_DataArr addObject:info[@"borrow_apr"]];
        }else{
            [_DataArr addObject:@""];
        }
        
        if ([keyArr containsObject:@"days"]) {
            if ([info[@"days"] integerValue]>0) {
                [_DataArr addObject:[NSString stringWithFormat:@"%@天",info[@"borrow_period"]]];
            }else {
                [_DataArr addObject:[NSString stringWithFormat:@"%@月",info[@"borrow_period"]]];
            }

        }else{
            [_DataArr addObject:@""];
        }
        
        if ([keyArr containsObject:@"borrow_stylename"]) {
            [_DataArr addObject:info[@"borrow_stylename"]];
        }else{
            [_DataArr addObject:@""];
        }
        if ([keyArr containsObject:@"account"]) {
            [_DataArr addObject:info[@"account"]];
        }else{
            [_DataArr addObject:@""];
        }
        
        if ([keyArr containsObject:@"yushouyi"]) {
            [_DataArr addObject:info[@"yushouyi"]];
        }else{
            [_DataArr addObject:@""];
        }
        
        if ([keyArr containsObject:@"repay_each_time"]) {
            [_DataArr addObject:info[@"repay_each_time"]];
        }else
        {
            [_DataArr addObject:@""];
        }
        
        
//        //人呢?????照着判断 自己写
//            [_DataArr addObject:info[@"borrow_apr"]];
//            if (info[@"days"]>0) {
//                [_DataArr addObject:[NSString stringWithFormat:@"%@天",info[@"borrow_period"]]];
//            }else if(info[@"days"]== 0){
//                [_DataArr addObject:[NSString stringWithFormat:@"%@月",info[@"borrow_period"]]];
//            }
//            //[_DataArr addObject:info[@"days"]];
//            [_DataArr addObject:info[@"borrow_stylename"]];
//            [_DataArr addObject:info[@"account"]];
//            [_DataArr addObject:info[@"yushouyi"]];

        
        
        NSLog(@"%@",_DataArr);
        [self.tab reloadData];
        [self.tab.mj_header endRefreshing];
    }];
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //arr是指左侧标题  是本地的？  en  dataarr是网络的？en dataar有可能空掉？有可能没数据
    return self.DataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    static NSString *CellIdentifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
   cell.textLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
//    if (self.DataArr.count>0) {
    if (self.arr[indexPath.row] != nil) {
        cell.textLabel.text = self.arr[indexPath.row];
    }
    if (self.DataArr[indexPath.row] != nil) {
        cell.detailTextLabel.text = self.DataArr[indexPath.row];
        if ([self.labelsh.text isEqualToString:@"募集中"] && [cell.textLabel.text isEqualToString:@"回款时间"]) {
            cell.detailTextLabel.text = @"正在火热募集中";
        }
    }
    
         //这里
        NSLog(@"%@9999",self.DataArr);
    
        cell.detailTextLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}
-(void)brnClicked{
    BiaoDetailViewController * vc = [[BiaoDetailViewController alloc] init];
    if (self.typ == TTGStateOK) {
        vc.idstr= self.idstr;
    }else if (self.typ == TTGStateError){
        vc.idstr = self.idstr1;
    }else{
        vc.idstr = self.idstr2;
    }
    [self.navigationController pushViewController:vc animated:YES];
}


-(void)Nav{
    self.navigationItem.title =@"投资详情";
    self.view.backgroundColor = grcolor;
    UIButton *leftbutton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 10, 19)];
    
    [leftbutton setBackgroundImage:[UIImage imageNamed:@"icon_back1"] forState:UIControlStateNormal];
    [leftbutton setBackgroundImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateHighlighted];
    [leftbutton addTarget:self action:@selector(leftbtnclicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftbarbtn=[[UIBarButtonItem alloc]initWithCustomView:leftbutton];
    self.navigationItem.leftBarButtonItem=leftbarbtn;
    
    
    UIButton *rightbutton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 57, 20)];
    [rightbutton addTarget:self action:@selector(rightbtnclicked) forControlEvents:UIControlEventTouchUpInside];
    rightbutton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    [rightbutton setTitle:@"投资合同" forState:UIControlStateNormal];
    [rightbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:rightbutton];
}

-(void)leftbtnclicked{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rightbtnclicked{
    
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
