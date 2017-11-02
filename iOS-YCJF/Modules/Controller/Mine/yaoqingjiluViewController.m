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
/***<#注释#> ***/
//@property (nonatomic ,strong)UIView *xuview;
/***<#注释#> ***/
@property (nonatomic ,strong)UIScrollView *contentView;
/***<#注释#> ***/
@property (nonatomic ,strong)NSArray *arr;
/***<#注释#> ***/
@property (nonatomic ,strong)NSMutableArray *titarr;
/***<#注释#> ***/
@property (nonatomic ,strong)NSMutableArray *daarr;
@property (nonatomic, strong) NSMutableArray * moneyarr;
@property (nonatomic,strong)NSMutableArray *dataSource;
@end

@implementation yaoqingjiluViewController
-(NSMutableArray *)titarr{
    if (!_titarr) {
        _titarr = [NSMutableArray array];
    }
    return _titarr;
}
-(NSMutableArray *)daarr{
    if (!_daarr) {
        _daarr = [NSMutableArray array];
    }
    return _daarr;
}

-(NSMutableArray *)moneyarr
{
    if (!_moneyarr) {
        _moneyarr = [NSMutableArray array];
    }
    return _moneyarr;
}


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
         make.height.offset(self.view.height -self.v.height-self.sview.height -66);
     }];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = [NSMutableArray arrayWithCapacity:0];
    [self Nav];
    [self AFN];
    [self setUI];
    
    // Do any additional setup after loading the view.
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
    NSLog(@"%@?%@", yqjlurl, pramas);
    [WWZShuju initlizedData:yqjlurl paramsdata:pramas dicBlick:^(NSDictionary *info) {
        NSLog(@"%@",info);
//        只要解析data里面的吗en
        szlabel.text =[NSString stringWithFormat:@"%@",info[@"total"]] ;
//     打印出来看看
        [self.titarr removeAllObjects];
        [self.daarr removeAllObjects];
        [self.moneyarr removeAllObjects];
        self.dataSource = [[NSMutableArray alloc] initWithArray:[yaoqingjiluData transformFromDic:info[@"data"]]];
        for (NSDictionary *dic in (NSArray *)info[@"data"]) {
           [self.titarr addObject:dic[@"un"]];
            [self.daarr addObject:dic[@"time_zc"]];
            [self.moneyarr addObject:dic[@"money"]];
        }
        
        [self.tab reloadData];
        NSLog(@"%@%@%@",self.titarr,self.daarr, self.moneyarr);
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titarr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    inTableViewCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"inTableViewCell" owner:nil options:nil]lastObject];
    if (self.titarr.count >0) {
        cell.titlab.text = self.titarr[indexPath.row];
        cell.zhonglab.text = self.daarr[indexPath.row];
        cell.dalab.text = [NSString stringWithFormat:@"%@元", self.moneyarr[indexPath.row]];
        NSLog(@"%@", self.dataSource);
        if (self.dataSource.count != 0) {
            yaoqingjiluData *data = [self.dataSource objectAtIndex:indexPath.row];
            NSLog(@"%@", data);
            cell.titlab.text = data.un;
            cell.zhonglab.text = data.time_zc;
            cell.dalab.text = [NSString stringWithFormat:@"%@元", self.moneyarr[indexPath.row]];//data.money;
        }
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
