//
//  InvestViewController.m
//  iOS-YCJF
//
//  Created by 姜宁桃 on 2017/8/9.
//  Copyright © 2017年 Yincheng. All rights reserved.
//

#import "InvestViewController.h"
#import "JXTZTableViewCell.h"
#import "biaoModel.h"
#import "BiaoDetailViewController.h"

@interface InvestViewController ()<UITableViewDataSource,UITableViewDelegate>
/***tabbarview ***/
@property (nonatomic ,strong)UITableView *tab;
/***上一次的请求参数 ***/
@property (nonatomic ,strong)NSDictionary *params;
/***当前页码 ***/
@property (nonatomic ,assign)NSInteger page;

/*** 模型***/
@property (nonatomic ,strong)NSMutableArray *model;
/***<#注释#> ***/
@property (nonatomic ,strong)NSMutableArray *modelq;

@end

@implementation InvestViewController

-(NSMutableArray *)model{
    if(!_model){
        _model = [[NSMutableArray alloc] init];
        
    }
    return _model;
}

-(NSMutableArray *)modelq{
    if(!_modelq){
        _modelq = [[NSMutableArray alloc] init];
        
    }
    return _modelq;
}

-(UITableView *)tab{
    if (!_tab) {
        _tab = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-70) style:UITableViewStyleGrouped];
        _tab.delegate = self;
        _tab.dataSource = self;
    }
    return _tab;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self.view addSubview:self.tab];
    
    _tab.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopics)];
    _tab.mj_header.automaticallyChangeAlpha = YES;//自动改变透明度
    [_tab.mj_header beginRefreshing];
    MJRefreshAutoNormalFooter * footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopics)];
    [footer setTitle:@"历史标的仅展现至当前页数" forState:MJRefreshStateNoMoreData];
    self.tab.mj_footer = footer;
    
    [self showSuspendView];
}

-(void)loadNewTopics
{
    [self.tab.mj_footer resetNoMoreData];
    //结束下拉刷新
    [self.tab.mj_footer endRefreshing];
    self.page++;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"app_id"] = @"3";
    params[@"os"] = @"ios";
    params[@"secret"] = @"aodsadhowiqhdwiqs";
    params[@"version"] = @"v1.0.3";
    params[@"cls"] = @"1";
    params[@"xinshou"] = @"2";
    params[@"pageSize"] = @"10";
    params[@"pageIndex"] = @"1";
    params[@"no_xinshou"] = @"1";
    params[@"uid"] = [UserDefaults objectForKey:@"uid"];
    self.params = params;
    
    NSLog(@"%@?%@", tzurl, params);
    [manager POST:tzurl parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@", responseObject[@"xslist"]);
        if (self.params != params)return ;
        //新手标
        self.model = [biaoModel mj_objectArrayWithKeyValuesArray:responseObject[@"xslist"]];
        self.modelq = [biaoModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
        [self.tab reloadData];
        [self.tab.mj_header endRefreshing];//结束刷新
        //清空页码
        self.page = 0;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        if (self.params != params)return ;
        [self.tab.mj_header endRefreshing];//结束刷新
    }];
    
}
/**加载更多数据**/
-(void)loadMoreTopics
{
    //消除尾部"没有更多数据"的状态
    [self.tab.mj_footer resetNoMoreData];
    //结束上拉刷新
    [self.tab.mj_header endRefreshing];
    self.page++;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"app_id"] = @"3";
    params[@"os"] = @"ios";
    params[@"secret"] = @"aodsadhowiqhdwiqs";
    params[@"version"] = @"v1.0.3";
    params[@"cls"] = @"1";
    params[@"xinshou"] = @"2";
    params[@"no_xinshou"] = @"1";
    params[@"uid"] = [UserDefaults objectForKey:@"uid"];
    NSInteger page = self.page + 1;
    params[@"pageIndex" ]=@(page);
    
    self.params = params;
    [manager POST:tzurl parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (self.params != params)return ;
        
        
        self.model  = [biaoModel mj_objectArrayWithKeyValuesArray:responseObject[@"xslist"]];
        [self.modelq addObjectsFromArray:[biaoModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]]];
        [self.tab reloadData];
        
        [self.tab.mj_footer endRefreshing];//结束刷新
        self.tab.mj_footer.state = MJRefreshStateNoMoreData;
        //设置页码
        self.page = page;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        if (self.params != params)return ;
        [self.tab.mj_footer endRefreshing];//结束刷新
        self.page--;
        
    }];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.tabBarController.tabBar.hidden = NO;
    self.title = @"投资";
    
    [MobClick beginLogPageView:self.title];
    [TalkingData trackPageBegin:self.title];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:self.title];
    [TalkingData trackPageEnd:self.title];
}


//cell的组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
//组中的元素
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section  == 0) {
        return self.model.count;
    }else{
        return self.modelq.count;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 11;
    }
    return 0.1;
}

//分组间距
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 55;//section头部高度
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        UIView *v = [[UIView alloc]initWithFrame:self.view.frame];
        v.backgroundColor = [UIColor whiteColor];
        UIButton *xsbbtn = [[UIButton alloc]init];
        [xsbbtn setImage:[UIImage imageNamed:@"liwu"] forState:UIControlStateNormal];
        [xsbbtn setTitle:@" 新手标" forState:UIControlStateNormal];
        [xsbbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        xsbbtn.backgroundColor = [UIColor whiteColor];
        [v addSubview:xsbbtn];
        [xsbbtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.offset(0);
            make.left.offset(19);
        }];
        UIView *lanView =[[UIView alloc]init];
        lanView.backgroundColor = blue_color;
        [v addSubview:lanView];
        [lanView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(xsbbtn.mas_centerY);
            make.width.offset(1);
            make.height.offset(12);
            make.left.equalTo(xsbbtn.mas_right).offset(15);
        }];
        UILabel *Labtext = [[UILabel alloc]init];
        Labtext.text = @"仅对平台首次投资用户开放";
        Labtext.textColor = [UIColor lightGrayColor];
        Labtext.font =[UIFont systemFontOfSize:14];
        [v addSubview:Labtext];
        [Labtext mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(xsbbtn.mas_centerY);
            make.left.equalTo(lanView.mas_right).offset(15);
        }];
        UIView *vq = [[UIView alloc]initWithFrame:CGRectMake(0, 55, v.frame.size.width, 1)];
        vq.backgroundColor = grcolor;
        [v addSubview:vq];
        
        
        return v;
    }else  if (section == 1) {
        UIView *v1 = [[UIView alloc ]init];
        v1.backgroundColor = [UIColor whiteColor];
        
        UIButton *tzbtn = [[UIButton alloc]init];
        [tzbtn setImage:[UIImage imageNamed:@"iconJX"] forState:UIControlStateNormal];
        [tzbtn setTitle:@" 精选投资" forState:UIControlStateNormal];
        [tzbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        tzbtn.backgroundColor = [UIColor whiteColor];
        [v1 addSubview:tzbtn];
        [tzbtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.offset(0);
            make.left.offset(19);
        }];
        UIView *vw = [[UIView alloc]initWithFrame:CGRectMake(0, 55, v1.frame.size.width, 1)];
        vw.backgroundColor = grcolor;
        [v1 addSubview:vw];
        return v1;
    }
    return nil;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JXTZTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"topic"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"JXTZTableViewCell" owner:nil options:nil]lastObject];
    }
    
    if (indexPath.section == 0) {
        if (self.model.count>0) {
            cell.rst = self.model[indexPath.row];
        }
        
    }else if(indexPath.section ==1){
        if (self.modelq.count>0) {
            cell.rst = self.modelq[indexPath.row];
        }
        
    }
    
    
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 135;
}

//处理cell点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BiaoDetailViewController *ssc = [[BiaoDetailViewController alloc]init];
    if (indexPath.section ==0) {
        biaoModel *mode = self.model[indexPath.row];
        ssc.idstr = mode.bid;
    }else{
        biaoModel *mode = self.modelq[indexPath.row];
        ssc.idstr = mode.bid;
    }
    [self.navigationController pushViewController:ssc animated:YES];
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
