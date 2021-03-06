//
//  daishouzdViewController.m
//  iOS-CHJF
//
//  Created by garday on 2017/3/21.
//  Copyright © 2017年 garday. All rights reserved.
//

#import "daishouzdViewController.h"
#import "zhangdanTableViewCell.h"
#import "xiangqingViewController.h"
#import "DSZDMolde.h"
@interface daishouzdViewController ()<UITableViewDataSource,UITableViewDelegate>{
//    UILabel *label;
    UILabel *la;
    NSArray *s;
}
/***<#注释#> ***/
@property (nonatomic ,strong)UITableView *tab;
/***<#注释#> ***/
@property (nonatomic ,strong)UIView *lanView;
/***上一次的请求参数 ***/
@property (nonatomic ,strong)NSDictionary *params;
/***分页 页数 ***/
@property (nonatomic ,assign)NSUInteger page;
/***<#注释#> ***/
@property (nonatomic ,strong)NSMutableArray *Modelarr;
/***列表数居 ***/
@property (nonatomic ,copy)NSMutableArray *TableDataArr;
@end

@implementation daishouzdViewController

-(NSMutableArray *)TableDataArr{
    if (!_TableDataArr) {
        _TableDataArr = [[NSMutableArray alloc]init];
    }return _TableDataArr;
}

-(NSMutableArray *)Modelarr{
    if (!_Modelarr) {
        _Modelarr = [NSMutableArray array];
    }
    return _Modelarr;
}
-(UIView *)lanView{
    if(!_lanView){
        _lanView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 85)];
        _lanView.backgroundColor = lancolor;
        
        UIView *v = [[UIView alloc]init];
        v.backgroundColor = [UIColor whiteColor];
        [_lanView addSubview:v];
        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.offset(0);
            make.top.offset(20);
            make.width.offset(1);
            make.height.offset(50);
        }];
        NSArray *arr =[NSArray array];
        arr = @[@"待收本金(元)",@"待收利息(元)"];
        for (int i = 0; i<2; i++) {
           UILabel *label = [[UILabel alloc] init];
            label.text = @"0.00";
            label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
            label.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1/1.0];
            
            [_lanView addSubview:label];
            label.tag = 100+i;
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.offset(-self.lanView.centerX/2 +i *self.lanView.centerX);
                make.top.offset(23);
            }];
            
            UILabel *labela = [[UILabel alloc] init];
            labela.text = arr[i];
            labela.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
            labela.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1/1.0];
            //labela.tag = 101;

            [_lanView addSubview:labela];
            [labela mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.offset(-self.lanView.centerX/2 + i * self.lanView.centerX);
                make.top.equalTo(label.mas_bottom).offset(7);

            }];

        }
        
       
    }
    return _lanView;
}

-(UITableView *)tab{
    if (!_tab) {
        self.tab = [[UITableView alloc]initWithFrame:CGRectMake(0,self.lanView.height, self.view.width, self.view.frame.size.height-self.lanView.height-100) style:UITableViewStyleGrouped];
        self.tab.dataSource= self;
        self.tab.delegate = self;
        self.tab.backgroundColor =grcolor;
        _tab.estimatedRowHeight = 0;
        _tab.estimatedSectionHeaderHeight = 0;
        _tab.estimatedSectionFooterHeight = 0;
        _tab.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopics)];
        _tab.mj_header.automaticallyChangeAlpha = YES;//自动改变透明度
        [_tab.mj_header beginRefreshing];
        
    }
    return _tab;
}
-(void)loadNewTopics{
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
  
    self.params = params;
    [WWZShuju initlizedData:dszdurl paramsdata:params dicBlick:^(NSDictionary *info) {
        if (self.params != params)return ;
        NSLog(@"---待收-----%@",info);

        UILabel *one = [self.lanView viewWithTag:100];
            one.text = info[@"tj"][@"v_twait_benjin"];
        NSLog(@"%@   ----- %@",  info[@"tj"], info[@"tj"][@"v_tcur_lixi"]);
         UILabel *two = [self.lanView viewWithTag:101];
            two.text = info[@"tj"][@"v_twait_lixi"];
        [self. TableDataArr removeAllObjects];
        NSArray *dataArr = info[@"data"];
        NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:0];
        for (int i =0; i<dataArr.count; i++) {
            NSDictionary *dic = dataArr[i];
            DSZDMolde *mode = [DSZDMolde mj_objectWithKeyValues:dic];
            if (tempArr.count == 0) {
                [tempArr addObject:mode];
            }else{
                DSZDMolde *tempMode = [tempArr lastObject];
                if ([tempMode.name isEqualToString:mode.name]) {//如果相等则为同一天
                    [tempArr addObject:mode];
                }else{
                    [self.TableDataArr addObject:tempArr];
                    tempArr = [NSMutableArray arrayWithCapacity:0];
                    [tempArr addObject:mode];
                }
            }
            if (i == dataArr.count -1) {
                [self.TableDataArr addObject:tempArr];
            }
           
        }

        NSLog(@"%@",self.TableDataArr);
        [self.tab reloadData];
        [self.tab.mj_header endRefreshing];
        self.page = 1;
        if (self.TableDataArr.count == 0) {
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
    NSLog(@"%@?%@", dszdurl, params);
    [WWZShuju initlizedData:dszdurl paramsdata:params dicBlick:^(NSDictionary *info) {
        if (self.params != params)return ;
        NSLog(@"---待收-----%@",info);
        
        NSArray *dataArr = info[@"data"];
        NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:0];
        for (int i =0; i<dataArr.count; i++) {
            NSDictionary *dic = dataArr[i];
            DSZDMolde *mode = [DSZDMolde mj_objectWithKeyValues:dic];
            if (tempArr.count == 0) {
                [tempArr addObject:mode];
            }else{
                DSZDMolde *tempMode = [tempArr lastObject];
                if ([tempMode.name isEqualToString:mode.name]) {//如果相等则为同一天
                    [tempArr addObject:mode];
                }else{
                    [self.TableDataArr addObject:tempArr];
                    tempArr = [NSMutableArray arrayWithCapacity:0];
                    [tempArr addObject:mode];
                }
            }
            if (i == dataArr.count -1) {
                [self.TableDataArr addObject:tempArr];
            }
        }
        
        [self.tab reloadData];
        [self.tab.mj_header endRefreshing];
        if ([info[@"data"] count] == 0) {
            self.tab.mj_footer.state = MJRefreshStateNoMoreData;
            //设置页码
            self.page = page;
        }
        
    }];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tab];
    [self.view addSubview:self.lanView];
    // Do any additional setup after loading the view.
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *header = [[UIView alloc] init];
    la = [[UILabel alloc]init];
    la.textColor =lancolor;
  DSZDMolde *mode = [self.TableDataArr[section] firstObject];
    la.text = mode.recover_time;
    la.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
    la.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [header addSubview:la];
    [la mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(16);
        make.top.offset(7);
    }];
    
    return header;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.TableDataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.TableDataArr[section]count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    NSDictionary *dic = self.TableDataArr[section];
    DSZDMolde *mode = [[self.TableDataArr objectAtIndex:section] firstObject];
    return mode.recover_time;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    zhangdanTableViewCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"zhangdanTableViewCell" owner:nil options:nil]lastObject];
    
    //NSDictionary *dic = self.TableDataArr[indexPath.section];
    //NSArray *arr = dic[[dic allKeys][0]];
    cell.model = self.TableDataArr[indexPath.section][indexPath.row];
    //自己那字典放数据
    //日了
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    xiangqingViewController *vc = [[xiangqingViewController alloc]init];
    DSZDMolde *mode = self.TableDataArr[indexPath.section][indexPath.row];
    vc.idstr = mode.bid;
    
    [self.navigationController pushViewController:vc animated:YES];
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
