//
//  quanbuViewController.m
//  iOS-CHJF
//
//  Created by garday on 2017/3/21.
//  Copyright © 2017年 garday. All rights reserved.
//

#import "quanbuViewController.h"
#import "touziTableViewCell.h"
#import "mujixqViewController.h"
#import "huikuanxqViewController.h"
#import "touziModel.h"
@interface quanbuViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSString *str;
}
/***<#注释#> ***/
@property (nonatomic ,strong)UITableView *tab;
/***<#注释#> ***/
@property (nonatomic ,strong)NSArray  *arr;
/***<#注释#> ***/
@property (nonatomic ,strong)NSMutableArray *model;
/***当前页码 ***/
@property (nonatomic ,assign)NSInteger page;
@end

@implementation quanbuViewController
-(NSMutableArray *)model{
    if (!_model) {
        _model = [NSMutableArray array];
    }
    return _model;
}
-(NSArray *)arr{
    if (!_arr) {
        _arr = [NSArray array];
        _arr = @[@"募集中",@"回款中",@"募集中",@"回款成功"];
    }
    return _arr;
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
   
    str = [NSString string];
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
    pass[@"bstatus"] = @"";
    pass[@"pageIndex"] = @"1";
    pass[@"pageSize"] = @"10";
    NSLog(@"%@?%@", blburl, pass);
    [WWZShuju initlizedData:blburl paramsdata:pass dicBlick:^(NSDictionary *info) {
        NSLog(@"%@",info);
        self.model = [touziModel mj_objectArrayWithKeyValuesArray:info[@"data"]];
        
        [self.tab reloadData];
        [self.tab.mj_header endRefreshing];//结束刷新
        //清空页码
        self.page = 1;
        if (self.model.count == 0) {
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
    pass[@"bstatus"] = @"";
   
    NSInteger page = self.page;
    pass[@"pageIndex" ]=@(self.page);
    NSLog(@"%@?%@", blburl, pass);
    [WWZShuju initlizedData:blburl paramsdata:pass dicBlick:^(NSDictionary *info) {
        NSLog(@"%@",info);
         [self.model addObjectsFromArray:[touziModel mj_objectArrayWithKeyValuesArray:info[@"data"]]];
        [self.tab reloadData];
        [self.tab.mj_footer endRefreshing];//结束刷新
        if ([info[@"data"] count] == 0) {
            self.tab.mj_footer.state = MJRefreshStateNoMoreData;
            //设置页码
            self.page = page;
        }
        
    }];
    

    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.model.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    touziTableViewCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"touziTableViewCell" owner:nil options:nil]lastObject];
    cell.model = self.model[indexPath.row];
    
    
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
//    touziTableViewCell *cell =[tableView cellForRowAtIndexPath:indexPath];
// 知道cell 得到他的下标    NSIndexPath *indexPath = [self.tableview indexPathForCell:cell];
//    if ([cell.ztlab.text  isEqualToString:@"回款中"]) {
      
        huikuanxqViewController *cx = [[huikuanxqViewController alloc]init];
        touziModel *mode = self.model[indexPath.row];
        cx.idstr = mode.bid;
        cx.typ = TTGStateOK;
    cx.mode = mode;
        [self.navigationController pushViewController:cx animated:YES];
//    }
//    else{
//        mujixqViewController *cx = [[mujixqViewController alloc]init];
//        touziModel *mode = self.model[indexPath.row];
//        cx.idstr = mode.bid;
//    
//        [self.navigationController pushViewController:cx animated:YES];

//}
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
