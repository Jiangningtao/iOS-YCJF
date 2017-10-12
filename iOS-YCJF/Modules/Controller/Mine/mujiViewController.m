//
//  mujiViewController.m
//  iOS-CHJF
//
//  Created by garday on 2017/3/21.
//  Copyright © 2017年 garday. All rights reserved.
//

#import "mujiViewController.h"
#import "touziTableViewCell.h"
#import "huikuanxqViewController.h"
#import "touziModel.h"

@interface mujiViewController ()<UITableViewDataSource,UITableViewDelegate>
/***<#注释#> ***/
@property (nonatomic ,strong)UITableView *tab;
/***当前页码 ***/
@property (nonatomic ,assign)NSInteger page;
/***<#注释#> ***/
@property (nonatomic ,strong)NSMutableArray *Model;
@end

@implementation mujiViewController

-(NSMutableArray *)Model{
    if (!_Model) {
        _Model = [NSMutableArray array];
    }
    return _Model;
}
-(UITableView *)tab{
    if (!_tab) {
        self.tab = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-66-44) style:UITableViewStyleGrouped];
        self.tab.dataSource= self;
        self.tab.delegate = self;
        self.tab.backgroundColor =grcolor;
        _tab.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopics)];
        _tab.mj_header.automaticallyChangeAlpha = YES;//自动改变透明度
        [_tab.mj_header beginRefreshing];
    }
    return _tab;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = grcolor;
    [self.view addSubview:self.tab];
    
    
    // Do any additional setup after loading the view.
}
-(void)loadNewTopics{
    [self.tab.mj_footer resetNoMoreData];
    //结束下拉刷新
    [self.tab.mj_footer endRefreshing];
    NSMutableDictionary *pass = [NSMutableDictionary dictionary];
    
    pass[@"version"] = @"v1.0.3";
    pass[@"os"] = @"ios";
    pass[@"uid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"uid"];
    pass[@"sid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"sid"];
    pass[@"at"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"at"];
    pass[@"bstatus"] = @"1";
    pass[@"pageIndex"] = @"1";
    pass[@"pageSize"] = @"10";
    
    [WWZShuju initlizedData:blburl paramsdata:pass dicBlick:^(NSDictionary *info) {
        NSLog(@"%@",info);
        self.Model = [touziModel mj_objectArrayWithKeyValuesArray:info[@"data"]];
        
        [self.tab reloadData];
        [self.tab.mj_header endRefreshing];
        //清空页码
        self.page = 1;
        if (self.Model.count == 0) {
            UIImageView *imv = [[UIImageView alloc]init];
            imv.image = [UIImage imageNamed:@"pic_zwsj"];
            [self.view addSubview:imv];
            [imv mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.offset(0);
                make.centerY.offset(0);
                make.width.offset(155);
                make.height.offset(194);
            }];
        }else{
            self.tab.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopics)];
        }
    }];
}
-(void)loadMoreTopics{
    //消除尾部"没有更多数据"的状态
    [self.tab.mj_footer resetNoMoreData];
    //结束上拉刷新
    [self.tab.mj_header endRefreshing];
    self.page++;
    NSMutableDictionary *pass = [NSMutableDictionary dictionary];
    
    pass[@"version"] = @"v1.0.3";
    pass[@"os"] = @"ios";
    pass[@"uid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"uid"];
    pass[@"sid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"sid"];
    pass[@"at"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"at"];
    pass[@"bstatus"] = @"1";
   
    NSInteger page = self.page;
    pass[@"pageIndex" ]=@(page);
    [WWZShuju initlizedData:blburl paramsdata:pass dicBlick:^(NSDictionary *info) {
        NSLog(@"%@",info);
        [self.Model addObjectsFromArray:[touziModel mj_objectArrayWithKeyValuesArray:info[@"data"]]];
        [self.tab reloadData];
        [self.tab.mj_header endRefreshing];
        if ([info[@"data"] count] == 0) {
            self.tab.mj_footer.state = MJRefreshStateNoMoreData;
            //设置页码
            self.page = page;
        }
    }];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.Model.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    touziTableViewCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"touziTableViewCell" owner:nil options:nil]lastObject];
    cell.model = self.Model[indexPath.row];
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 9;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
        huikuanxqViewController *cx = [[huikuanxqViewController alloc]init];
        touziModel *mode = self.Model[indexPath.row];
    NSLog(@"%@", mode);
        cx.idstr1 = mode.bid;
    cx.mode = mode;
        cx.typ =TTGStateError;
        [self.navigationController pushViewController:cx animated:YES];
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
