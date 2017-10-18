//
//  mynewsViewController.m
//  iOS-CHJF
//
//  Created by garday on 2017/3/27.
//  Copyright © 2017年 garday. All rights reserved.
//

#import "mynewsViewController.h"
#import "xiaoxiTableViewCell.h"
#import "MyNewsDetailViewController.h"
@interface mynewsViewController ()<UITableViewDataSource,UITableViewDelegate>
/***tabbarview ***/
@property (nonatomic ,strong)UITableView *tab;
/***上一次的请求参数 ***/
@property (nonatomic ,strong)NSDictionary *params;
/***当加载下一页数据时需要这个参数 ***/
@property (nonatomic ,copy)NSString *maxtime;
/***当前页码 ***/
@property (nonatomic ,assign)NSInteger page;
@property (nonatomic, strong) NSMutableArray * dataArray;

@end

@implementation mynewsViewController

-(NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tab.mj_header beginRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tab];
    
//    reloadMymessage
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadMymessage:) name:@"reloadMymessage" object:nil];
    
    _tab.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopics)];
    _tab.mj_header.automaticallyChangeAlpha = YES;//自动改变透明度
    [_tab.mj_header beginRefreshing];
    self.tab.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopics)];
    // Do any additional setup after loading the view.
}

- (void)reloadMymessage:(NSNotification *)noti
{
    [_tab.mj_header beginRefreshing];
}

-(void)loadNewTopics
{
    
    [self.tab.mj_footer resetNoMoreData];
    //结束下拉刷新
    [self.tab.mj_footer endRefreshing];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"uid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"uid"];
    params[@"sid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"sid"];
    params[@"at"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"at"];
    params[@"version"] = @"v1.0.3";
    params[@"os"] = @"ios";
    params[@"pageSize"] = @"10";
    params[@"pageIndex"] = @"1";
    self.params = params;
    
    NSLog(@"%@?%@", mymessage, params);
    [manager POST:mymessage parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@", responseObject);
        [self.dataArray removeAllObjects];
        if ([responseObject[@"data"] count] > 0) {
            for (NSDictionary * dict in responseObject[@"data"]) {
                [self.dataArray addObject:dict];
            }
        }else{
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
        [self.tab.mj_header endRefreshing];//结束刷新
        //清空页码
        self.page = 1;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
//        if (self.params != params)return ;
        [self.tab.mj_header endRefreshing];//结束刷新
    }];
    
}

-(void)loadMoreTopics{
    //消除尾部"没有更多数据"的状态
    [self.tab.mj_footer resetNoMoreData];
    //结束上拉刷新
    [self.tab.mj_header endRefreshing];
    self.page++;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"uid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"uid"];
    params[@"sid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"sid"];
    params[@"at"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"at"];
    params[@"version"] = @"v1.0.3";
    params[@"os"] = @"ios";
    NSInteger page = self.page;
    params[@"pageSize"] = @"10";
    params[@"pageIndex" ]=@(page);

    self.params = params;
    NSLog(@"%@?%@", mymessage, params);
    [manager POST:mymessage parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@", responseObject);
        if ([responseObject[@"data"] count] > 0) {
            for (NSDictionary * dict in responseObject[@"data"]) {
                [self.dataArray addObject:dict];
            }
        }else{
            self.tab.mj_footer.state = MJRefreshStateNoMoreData;
            //设置页码
            self.page = page;
        }
        
        [self.tab reloadData];
        [self.tab.mj_header endRefreshing];//结束刷新
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        //        if (self.params != params)return ;
        [self.tab.mj_header endRefreshing];//结束刷新
    }];
    
}


-(UITableView *)tab{
    if (!_tab) {
        _tab = [[UITableView alloc]initWithFrame:CGRectMake(0, 11, self.view.width, self.view.height-121) style:UITableViewStyleGrouped];
        [_tab registerNib:[UINib nibWithNibName:@"xiaoxiTableViewCell" bundle:nil] forCellReuseIdentifier:@"xiaoxiTableViewCell"];
        _tab.backgroundColor =grcolor;
        _tab.delegate = self;
        _tab.dataSource = self;
    }
    return _tab;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
//组中的元素
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
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
    if (section ==0) {
        return 11;
    }
    return 1;//section头部高度
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MyNewsDetailViewController * newsDetailVC = [[MyNewsDetailViewController alloc] init];
    NSDictionary * dict = self.dataArray[indexPath.row];
    newsDetailVC.dataDict = [NSDictionary dictionaryWithDictionary:dict];
    [self.navigationController pushViewController:newsDetailVC animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//  xiaoxiTableViewCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"xiaoxiTableViewCell" owner:nil options:nil]lastObject];
    xiaoxiTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"xiaoxiTableViewCell"];
    
    if (self.dataArray.count > 0) {
        NSDictionary * dict = self.dataArray[indexPath.row];
        if ([dict[@"sign"] isEqualToString:@"1"]) {
            // 已读
            cell.imgvjx.backgroundColor = color(204, 204, 204, 1);
            cell.titLab.textColor =color(204, 204, 204, 1);
            cell.timelab.textColor =color(204, 204, 204, 1);
            cell.xinxiLab.textColor =color(204, 204, 204, 1);
        }else
        {
            cell.imgvjx.backgroundColor = color(255, 0, 0, 1);
        }
        cell.titLab.text = dict[@"title"];
        cell.timelab.text = dict[@"time_h"];
        cell.xinxiLab.text = dict[@"note"];
    }
    
    return cell;
    
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"reloadMymessage" object:nil];
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
