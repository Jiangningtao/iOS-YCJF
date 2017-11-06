//
//  yaoqingjiluViewController.m
//  iOS-CHJF
//
//  Created by garday on 2017/3/22.
//  Copyright © 2017年 garday. All rights reserved.
//

#import "yaoqingjiluViewController.h"
#import "inTableViewCell.h"
#import "yaoqingjiluData.h"
@interface yaoqingjiluViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UILabel *szlabel;
}
/***<#注释#> ***/
@property (nonatomic ,strong)UIView *sview;
/***<#注释#> ***/
@property (nonatomic ,strong)UITableView *tab;
/***<#注释#> ***/
@property (nonatomic ,strong)UIView *v;
/***当前页码 ***/
@property (nonatomic ,assign)NSInteger page;
/***<#注释#> ***/
@property (nonatomic ,strong)UIScrollView *contentView;
/***<#注释#> ***/
@property (nonatomic ,strong)NSArray *arr;
/***<#注释#> ***/
@property (nonatomic,strong)NSMutableArray *dataSource;
@end

@implementation yaoqingjiluViewController

-(void)Nav{
    self.navigationItem.title =@"我的邀请记录";
    self.view.backgroundColor = grcolor;
    UIButton *leftbutton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 10, 19)];
    
    [leftbutton setBackgroundImage:[UIImage imageNamed:@"icon_back1"] forState:UIControlStateNormal];
    [leftbutton setBackgroundImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateHighlighted];
    [leftbutton addTarget:self action:@selector(leftbtnclicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftbarbtn=[[UIBarButtonItem alloc]initWithCustomView:leftbutton];
    self.navigationItem.leftBarButtonItem=leftbarbtn;
}

-(UITableView *)tab{
    if (!_tab) {
        _tab = [[UITableView alloc]init];
        _tab.backgroundColor = [UIColor whiteColor];
        _tab.delegate = self;
        _tab.dataSource = self;
        _tab.mj_header =[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(AFN)];
        _tab.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(AFNMore)];
    }
    return _tab;
}



-(UIView *)sview{
    if(!_sview){
        _sview = [[UIView alloc] init];
        _sview.backgroundColor = [UIColor whiteColor];
        UILabel *yqlabel = [[UILabel alloc] init];
        yqlabel.text = @"我已成功邀请人数";
        yqlabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        yqlabel.textColor = [UIColor colorWithRed:73/255.0 green:73/255.0 blue:73/255.0 alpha:1/1.0];
        [self.sview addSubview:yqlabel];
        [yqlabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.offset(0);
            make.top.offset(20);
        }];
        
        szlabel = [[UILabel alloc] init];
        szlabel.text = @"-";
        szlabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:30];
        szlabel.textColor = [UIColor colorWithRed:239/255.0 green:90/255.0 blue:78/255.0 alpha:1/1.0];
        [self.sview addSubview:szlabel];
        [szlabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.offset(0);
            make.top.equalTo(yqlabel.mas_bottom).offset(13);
        }];

    }
    return _sview;
}
-(UIView *)v{
    if(!_v){
        _v = [[UIView alloc] init];
         _v.backgroundColor = [UIColor whiteColor];
        
        UILabel *labels = [[UILabel alloc] init];
        labels.text = @"邀请账号";
        labels.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        labels.textColor = [UIColor colorWithRed:73/255.0 green:73/255.0 blue:73/255.0 alpha:1/1.0];
        [self.v addSubview:labels];
        [labels mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(15);
            make.centerY.offset(0);
        }];
        
        UILabel *labelb = [[UILabel alloc] init];
        labelb.text = @"邀请时间";
        labelb.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        labelb.textColor = [UIColor colorWithRed:73/255.0 green:73/255.0 blue:73/255.0 alpha:1/1.0];
        [self.v addSubview:labelb];
        [labelb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.offset(0);
            make.centerY.offset(0);
        }];
        
        UILabel * labeljl = [[UILabel alloc] init];
        labeljl.text = @"获得奖励";
        labeljl.textAlignment = NSTextAlignmentRight;
        labeljl.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        labeljl.textColor = [UIColor colorWithRed:73/255.0 green:73/255.0 blue:73/255.0 alpha:1/1.0];
        [self.v addSubview:labeljl];
        [labeljl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-15);
            make.centerY.offset(0);
        }];

    }
    return _v;
}



-(void)setUI{
   
    [self.view addSubview:self.sview];
    [self.sview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(76);
        make.left.right.offset(0);
        make.height.offset(120);
    }];
    
    
    [self.view addSubview:self.v ];
    [self.v mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(self.sview.mas_bottom).offset(10);
        make.height.offset(40);
    }];
    
    [self.view addSubview:self.tab];
     [self.tab mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.right.offset(0);
         make.top.equalTo(self.v.mas_bottom).offset(0);
         make.bottom.offset(0);
     }];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = [NSMutableArray arrayWithCapacity:0];
    [self Nav];
    [self AFN];
    [self setUI];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
-(void)AFN{
    NSMutableDictionary *pramas = [NSMutableDictionary dictionary];
    pramas[@"uid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"uid"];
    pramas[@"sid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"sid"];
    pramas[@"at"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"at"];
    pramas[@"app_id"] = @"3";
    pramas[@"secret"] = @"aodsadhowiqhdwiqs";
    pramas[@"version"] = @"v1.0.3";
    pramas[@"btj"] = @"1";
    self.activity?pramas[@"activity"] = @"1":nil;
    pramas[@"pageIndex"] = @"1";
    pramas[@"pageSize"] = @"10";
    pramas[@"type"] = @"2";
    self.page = 1;
    NSLog(@"%@?%@", yqjlurl, pramas);
    [WWZShuju initlizedData:yqjlurl paramsdata:pramas dicBlick:^(NSDictionary *info) {
        NSLog(@"%@",info);
        [self.tab.mj_header endRefreshing];
        szlabel.text =[NSString stringWithFormat:@"%@",info[@"total"]] ;
        self.dataSource = [[NSMutableArray alloc] initWithArray:[yaoqingjiluData transformFromDic:info[@"data"]]];
        
        [self.tab reloadData];
    }];
}

-(void)AFNMore{
    self.page++;
    NSMutableDictionary *pramas = [NSMutableDictionary dictionary];
    pramas[@"uid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"uid"];
    pramas[@"sid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"sid"];
    pramas[@"at"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"at"];
    pramas[@"app_id"] = @"3";
    pramas[@"secret"] = @"aodsadhowiqhdwiqs";
    pramas[@"version"] = @"v1.0.3";
    pramas[@"btj"] = @"1";
    self.activity?pramas[@"activity"] = @"1":nil;
    NSInteger page = self.page;
    pramas[@"pageSize"] = @"10";
    pramas[@"pageIndex" ]=@(page);
    pramas[@"type"] = @"2";
    NSLog(@"%@?%@", yqjlurl, pramas);
    [WWZShuju initlizedData:yqjlurl paramsdata:pramas dicBlick:^(NSDictionary *info) {
        NSLog(@"%@",info);
        [self.tab.mj_footer endRefreshing];
        [self.dataSource addObjectsFromArray:[yaoqingjiluData transformFromDic:info[@"data"]]];
        if ([info[@"data"] count] == 0) {
            self.tab.mj_footer.state = MJRefreshStateNoMoreData;
        }
        [self.tab reloadData];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    inTableViewCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"inTableViewCell" owner:nil options:nil]lastObject];
    if (self.dataSource.count != 0) {
        yaoqingjiluData *data = [self.dataSource objectAtIndex:indexPath.row];
        NSLog(@"%@", data);
        cell.titlab.text = data.un;
        cell.zhonglab.text = data.time_zc;
        cell.dalab.text = [NSString stringWithFormat:@"%@元", data.money];//data.money;
    }

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
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
