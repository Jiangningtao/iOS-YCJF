//
//  xiangqingViewController.m
//  iOS-CHJF
//
//  Created by garday on 2017/3/21.
//  Copyright © 2017年 garday. All rights reserved.
//

#import "xiangqingViewController.h"
#import "SheetCell.h"
#import "BiaoDetailViewController.h"
@interface xiangqingViewController ()<UITableViewDataSource,UITableViewDelegate>{
    UIScrollView *contentView;
    UIButton *btn;
}
/***<#注释#> ***/
@property (nonatomic ,strong)UIView *view1;
/** 表格列表 */
@property (nonatomic,strong)UITableView *SheetTable;
/** 头视图 */
@property (nonatomic,strong)UIView *HeadView;
/** 头标题 */
@property (nonatomic, copy)NSArray *HeadTitleArr;
/** 数据 */
@property (nonatomic, copy)NSMutableArray *DataArr;
/***上一次的请求参数 ***/
@property (nonatomic ,strong)NSDictionary *params;
/***<#注释#> ***/
@property (nonatomic ,strong)NSMutableArray *Modelarr;
@end

@implementation xiangqingViewController
-(NSMutableArray *)Modelarr{
    if (!_Modelarr) {
        _Modelarr = [NSMutableArray array];
    }
    return _Modelarr;
}
-(UIView *)view1{
    if(!_view1){
        _view1 = [[UIView alloc] initWithFrame:CGRectMake(0,0, self.view.width, 125)];
        _view1.backgroundColor = [UIColor whiteColor];
        
        UILabel *label = [[UILabel alloc] init];
//        label.text = @"w1234系列宝马抵押标";
        label.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        label.textColor = [UIColor colorWithRed:73/255.0 green:73/255.0 blue:73/255.0 alpha:1/1.0];
        
        [_view1 addSubview:label];
        label.tag = 51;
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(17);
            make.top.offset(11);
        }];
        
        UILabel *label1 = [[UILabel alloc] init];
//        label1.text = @"(还款中)";
        label1.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
//        label1.textColor = [UIColor colorWithRed:253/255.0 green:128/255.0 blue:46/255.0 alpha:1/1.0];
        [_view1 addSubview:label1];
        label1.tag = 52;
        [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(label.mas_right).offset(2);
            make.top.offset(11);
        }];
        UIView *viewq = [[UIView alloc] init];
        viewq.backgroundColor = self.view.backgroundColor;
        [_view1 addSubview:viewq];
        [viewq mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.offset(0);
            make.height.offset(1);
            make.top.equalTo(label.mas_bottom).offset(8);
        }];
        NSArray *arr = [NSArray array];
        arr = @[@"待收总额",@"已收总计",@"已收利息管理费"];
        for (int i = 0; i<3; i++) {
            UILabel *labelq = [[UILabel alloc] init];
//            labelq.text =arr[i];
            labelq.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
            labelq.textColor = [UIColor colorWithRed:73/255.0 green:73/255.0 blue:73/255.0 alpha:1/1.0];
            [_view1 addSubview:labelq];
            labelq.tag =100+i;
            [labelq mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.offset(-self.view1.centerX *2/3 +i *(self.view1.centerX*2/3));
                make.top.equalTo(viewq.mas_bottom).offset(23);
            }];

  
            UILabel *labelw = [[UILabel alloc] init];
            labelw.text = arr[i];
            labelw.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
            labelw.textColor = [UIColor colorWithRed:73/255.0 green:73/255.0 blue:73/255.0 alpha:1/1.0];
            [_view1 addSubview:labelw];
            [labelw mas_makeConstraints:^(MASConstraintMaker *make) {
                 make.centerX.offset(-self.view1.centerX*2/3 +i *(self.view1.centerX*2/3));
                make.top.equalTo(labelq.mas_bottom).offset(7);
            }];

        }
        
        for (int i = 0; i<2; i++) {
            UIView *viewshu = [[UIView alloc] init];
            viewshu.backgroundColor = grcolor;
            [_view1 addSubview:viewshu];
            [viewshu mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(self.view1.width/3 +i *(self.view1.width/3));
                make.top.equalTo(viewq.mas_bottom).offset(20);
                make.width.offset(2);
                make.height.offset(50);
            }];
        }
        
    }
    return _view1;
}

-(NSMutableArray *)DataArr{
    if (!_DataArr) {
        _DataArr = [NSMutableArray array];
    }
    return _DataArr;
}

-(NSArray *)HeadTitleArr{
    if (!_HeadTitleArr) {
        _HeadTitleArr = @[@"回款时间",@"本金(元)",@"收益(元)",@"状态"];
    }
    return _HeadTitleArr;
}

-(UIView *)HeadView{
    if (!_HeadView) {
        _HeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,ScreenWidth, 40)];
        _HeadView.backgroundColor = [UIColor whiteColor];
        CGFloat LeftMargin = 5;
        CGFloat LabWidth = (ScreenWidth-2*LeftMargin)/self.HeadTitleArr.count;
        for (NSInteger i = 0; i<self.HeadTitleArr.count; i++) {
            UILabel *lab = [self QuickSetLab];
            lab.frame = CGRectMake(LeftMargin+(i*LabWidth),5,LabWidth,25);
            if (i==0) {
                lab.textAlignment = NSTextAlignmentLeft;
            }else if (i==1||i==2){
                lab.textAlignment = NSTextAlignmentCenter;
            }else{
                lab.textAlignment = NSTextAlignmentRight;
            }
            lab.text = self.HeadTitleArr[i];
            [_HeadView addSubview:lab];
        }
    }
    return _HeadView;
}

-(UITableView *)SheetTable{
    if (!_SheetTable) {
        _SheetTable = [[UITableView alloc]initWithFrame:CGRectMake(0, self.view1.height+10, ScreenWidth,self.view.frame.size.height/2) style:UITableViewStylePlain];
        _SheetTable.dataSource = self;
        _SheetTable.backgroundColor = grcolor;
        _SheetTable.delegate = self;
//        _SheetTable.showsVerticalScrollIndicator = NO;
        _SheetTable.tableHeaderView = self.HeadView;
        _SheetTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopics)];
        _SheetTable.mj_header.automaticallyChangeAlpha = YES;//自动改变透明度
        [_SheetTable.mj_header beginRefreshing];
    }
    return _SheetTable;
}

-(void)loadNewTopics{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"uid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"uid"];
    params[@"sid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"sid"];
    params[@"at"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"at"];
    params[@"version"] = @"v1.0.3";
    params[@"os"] = @"ios";
    params[@"pageSize"] = @"10";
    params[@"pageIndex"] = @"1";
    params[@"bid"] = self.idstr;
    self.params = params;
    [WWZShuju initlizedData:zdxqurl paramsdata:params dicBlick:^(NSDictionary *info) {
        if (self.params != params)return ;
        NSLog(@"---详情-----%@",info);
        
        NSDictionary *dic =info[@"item"];
        UILabel *laqqq = [self.view1 viewWithTag:51];
        laqqq.text =dic[@"name"];
        
        
        
        UILabel *la1 = [self.view1 viewWithTag:52];
        if ([dic[@"status"] isEqualToString:@"0"]) {
            la1.text =@"待初审";
            la1.textColor = [UIColor lightGrayColor];
        }else if ([dic[@"status"]  isEqualToString:@"1"]){
            la1.text =@"募集中";
            la1.textColor = lancolor;
        }else if ([dic[@"status"]  isEqualToString:@"2"]){
            la1.text =@"初审失败";
            la1.textColor = [UIColor lightGrayColor];
        }else if ([dic[@"status"]  isEqualToString:@"3"]){
            la1.text =@"回款中";
            la1.textColor = [UIColor orangeColor];
        }else if ([dic[@"status"]  isEqualToString:@"4"]){
            la1.text =@"复审失败";
            la1.textColor = [UIColor lightGrayColor];
        }else if ([dic[@"status"]  isEqualToString:@"5"]){
           la1.text =@"用户自行撤销";
            la1.textColor = [UIColor lightGrayColor];
        }else if ([dic[@"status"]  isEqualToString:@"6"]){
            la1.text =@"回款成功";
            la1.textColor = [UIColor lightGrayColor];
        }else if ([dic[@"status"]  isEqualToString:@"7"]){
            la1.text =@"自动投标中";
            la1.textColor = [UIColor lightGrayColor];
        }else if ([dic[@"status"]  isEqualToString:@"8"]){
            la1.text =@"复审中";
            la1.textColor = [UIColor lightGrayColor];
        }
        

        
        UILabel *one = [self.view1 viewWithTag:100];
        one.text = info[@"item"][@"totshouru"];
        
        UILabel *two = [self.view1 viewWithTag:101];
        two.text = info[@"item"][@"totrecover_account_yes"];

        UILabel *three = [self.view1 viewWithTag:102];
        three.text = info[@"item"][@"totsxf"];
       
        
        
        NSArray *arr = info[@"data"];
        for (NSDictionary *Datadic in arr) {
            NSString *strd = [NSString string];
            if ([Datadic[@"recover_status"] isEqualToString:@"1"]) {
                strd = @"已回款";
                la1.textColor = [UIColor orangeColor];
            }else{
                strd = @"待回款";
            }
        [self.DataArr addObject:[NSString stringWithFormat:@"%@,%@,%@,%@",Datadic[@"recover_time"],Datadic[@"recover_capital"],Datadic[@"recover_interest"],strd]];
        }


        
        [self.SheetTable reloadData];
        [self.SheetTable.mj_header endRefreshing];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self Nav];
    contentView = [[UIScrollView alloc]initWithFrame:self.view.frame];
    contentView.backgroundColor =grcolor;
//    contentView.showsVerticalScrollIndicator = YES;
    contentView.bounces = NO;
    contentView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:contentView];
    [contentView addSubview:self.view1];
    
     [contentView addSubview:self.SheetTable];
    
    
    btn = [[UIButton alloc]init];
    btn.backgroundColor = grcolor;
    btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
    [btn setTitle:@"查看投资项目" forState:UIControlStateNormal];
    [btn setTitleColor:lancolor forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClicked) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.equalTo(self.SheetTable.mas_bottom).offset(31);
    }];
    
    // Do any additional setup after loading the view.
}
-(void)viewDidLayoutSubviews{
    contentView.contentSize = CGSizeMake(self.view.width, btn.centerY+20+123);
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.DataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 48;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"identifier";
    SheetCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[SheetCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.DataStr = self.DataArr[indexPath.row];
    return cell;
}


-(UILabel *)QuickSetLab{
    UILabel *lab = [[UILabel alloc]init];
    lab.backgroundColor = [UIColor clearColor];
    lab.textColor = [UIColor blackColor];
    lab.font = [UIFont systemFontOfSize:16];
    lab.numberOfLines = 0;
    return lab;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.tabBarController.tabBar.hidden = YES;
}

-(void)Nav{
    self.view.backgroundColor = grcolor;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationItem.title =@"我的账单";
    UIButton *leftbutton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 10, 21)];
    
    [leftbutton setBackgroundImage:[UIImage imageNamed:@"icon_back1"] forState:UIControlStateNormal];
    [leftbutton setBackgroundImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateHighlighted];
    [leftbutton addTarget:self action:@selector(leftbtnclicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftbarbtn=[[UIBarButtonItem alloc]initWithCustomView:leftbutton];
    self.navigationItem.leftBarButtonItem=leftbarbtn;
    
    
    
    
}
-(void)btnClicked{
    BiaoDetailViewController * detailVC = [[BiaoDetailViewController alloc] init];
    detailVC.idstr = self.idstr;
    [self.navigationController pushViewController:detailVC animated:YES];
}

-(void)leftbtnclicked{
    [self.navigationController popViewControllerAnimated:YES];
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
