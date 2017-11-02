//
//  myjiangliViewController.m
//  iOS-CHJF
//
//  Created by garday on 2017/3/29.
//  Copyright © 2017年 garday. All rights reserved.
//

#import "myjiangliViewController.h"
#import "touziTableViewCell.h"
#import "jiangliModel.h"
@interface myjiangliViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSString *str;
}
/***<#注释#> ***/
@property (nonatomic ,strong)UITableView *tab;
/***<#注释#> ***/
@property (nonatomic ,strong)NSArray  *arr;
/***上一次的请求参数 ***/
@property (nonatomic ,strong)NSDictionary *params;
/***<#注释#> ***/
@property (nonatomic ,strong)NSMutableArray *Modelarr;
/***当前页码 ***/
@property (nonatomic ,assign)NSInteger page;
@end

@implementation myjiangliViewController
-(NSMutableArray *)Modelarr{
    if (!_Modelarr) {
        _Modelarr = [NSMutableArray array];
    }
    return _Modelarr;
}
-(NSArray *)arr{
    if (!_arr) {
        _arr = [NSArray array];
        _arr = @[@"2.00%加息劵",@"100元现金劵",@"1000元现金劵",@"2.34资金奖励",@"2.00%加息劵"];
    }
    return _arr;
}

-(UITableView *)tab{
    if (!_tab) {
        self.tab = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
        self.tab.dataSource= self;
        self.tab.delegate = self;
        self.tab.backgroundColor =grcolor;
        _tab.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopics)];
        _tab.mj_header.automaticallyChangeAlpha = YES;//自动改变透明度
        [_tab.mj_header beginRefreshing];
         self.tab.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopics)];
    }
    return _tab;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self Nav];
    str = [NSString string];
    self.view.backgroundColor = grcolor;
    [self.view addSubview:self.tab];
    
//    UIImageView *imv = [[UIImageView alloc]init];
//    imv.image = [UIImage imageNamed:@"pic_zwsj"];
//    [self.view addSubview:imv];
//    [imv mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.offset(0);
//        make.centerY.offset(0);
//        make.width.offset(155);
//        make.height.offset(194);
//    }];
    
    // Do any additional setup after loading the view.
}
-(void)loadNewTopics
{
    [self.tab.mj_footer resetNoMoreData];
    //结束下拉刷新
    [self.tab.mj_footer endRefreshing];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"uid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"uid"];
    params[@"sid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"sid"];
    params[@"at"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"at"];
    params[@"version"] = @"v1.0.3";
    params[@"os"] = @"ios";
    params[@"pageSize"] = @"10";
    params[@"pageIndex"] = @"1";
    params[@"btj"] = @"1";
    self.activity?params[@"activity"] = @"1":nil;
    self.params = params;
    [WWZShuju initlizedData:wdjlurl paramsdata:params dicBlick:^(NSDictionary *info) {
        NSLog(@"%@",info);
        _Modelarr = [jiangliModel mj_objectArrayWithKeyValuesArray:info[@"data"]];
        
        if ([info[@"r"] integerValue] == 1 && [info[@"total"] integerValue] == 0) {
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
        [self.tab.mj_header endRefreshing];
        NSLog(@"--_Modelarr%@",_Modelarr);
        //清空页码
        self.page = 0;
    }];
    
    
}
-(void)loadMoreTopics{
    //消除尾部"没有更多数据"的状态
    [self.tab.mj_footer resetNoMoreData];
    //结束上拉刷新
    [self.tab.mj_header endRefreshing];
    
    self.page++;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"uid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"uid"];
    params[@"sid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"sid"];
    params[@"at"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"at"];
    params[@"version"] = @"v1.0.3";
    params[@"os"] = @"ios";
    NSInteger page = self.page + 1;
    params[@"pageIndex" ]=@(page);
    params[@"btj"] = @"1";
    
    self.params = params;
    [WWZShuju initlizedData:wdjlurl paramsdata:params dicBlick:^(NSDictionary *info) {
        NSLog(@"%@",info);
        [_Modelarr addObjectsFromArray:[jiangliModel mj_objectArrayWithKeyValuesArray:info[@"data"]]];
        
        [self.tab reloadData];
        [self.tab.mj_header endRefreshing];
        NSLog(@"--_Modelarr%@",_Modelarr);
        self.page = page;
    }];

}
-(void)Nav{
    self.navigationItem.title =@"我的奖励";
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *leftbutton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 10, 19)];
    
    [leftbutton setBackgroundImage:[UIImage imageNamed:@"icon_back1"] forState:UIControlStateNormal];
    [leftbutton setBackgroundImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateHighlighted];
    [leftbutton addTarget:self action:@selector(leftbtnclicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftbarbtn=[[UIBarButtonItem alloc]initWithCustomView:leftbutton];
    self.navigationItem.leftBarButtonItem=leftbarbtn;
}
-(void)leftbtnclicked{
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    self.tab.mj_footer.hidden = (self.Modelarr.count == 0);
    return self.Modelarr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    touziTableViewCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"touziTableViewCell" owner:nil options:nil]lastObject];
    cell.jianglimodel =self.Modelarr[indexPath.row];
    
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 9;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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
