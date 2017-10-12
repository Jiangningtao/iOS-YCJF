//
//  keshiyongViewController.m
//  iOS-CHJF
//
//  Created by garday on 2017/3/22.
//  Copyright © 2017年 garday. All rights reserved.
//

#import "keshiyongViewController.h"
#import "jaingjuanCollectionViewCell.h"
#import "investingViewController.h"
#import "myjjModel.h"
@interface keshiyongViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic,strong)UICollectionView *FourBtnCollect;
@property (nonatomic ,strong)NSDictionary *params;
/***<#注释#> ***/
@property (nonatomic ,strong)NSMutableArray *Modelarr;
/***<#注释#> ***/
@property (nonatomic ,strong)NSMutableArray *Modelarr1;
/***当前页码 ***/
@property (nonatomic ,assign)NSInteger page;
@end

@implementation keshiyongViewController
-(NSMutableArray *)Modelarr{
    if (!_Modelarr) {
        _Modelarr = [NSMutableArray array];
    }
    return _Modelarr;
}
-(NSMutableArray *)Modelarr1{
    if (!_Modelarr1) {
        _Modelarr1 = [NSMutableArray array];
    }
    return _Modelarr1;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.titlestr) {
     self.tabBarController.tabBar.hidden = YES;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.titlestr) {
        self.title = self.titlestr;
        self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
        self.tabBarController.tabBar.hidden = NO;
        self.navigationController.navigationBar.tintColor =[UIColor whiteColor];
        UIButton *leftButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 10, 19)];
        [leftButton addTarget:self action:@selector(leftbtnclicked) forControlEvents:UIControlEventTouchUpInside];
        [leftButton setBackgroundImage:[UIImage imageNamed:@"icon_back_click"] forState:UIControlStateNormal];
        [leftButton setBackgroundImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateHighlighted];
        self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:leftButton];
        
        UIButton *rightbutton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 57, 20)];
        [rightbutton addTarget:self action:@selector(rightbtnclicked) forControlEvents:UIControlEventTouchUpInside];
        rightbutton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        [rightbutton setTitle:@"取消使用" forState:UIControlStateNormal];
        [rightbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightbutton];
    }
    self.view.backgroundColor = grcolor;
    [self layout];
    
    // Do any additional setup after loading the view.
}
-(void)leftbtnclicked{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightbtnclicked{
    if (self.titlestr) {
        
        
        investingViewController* oneVC =nil;
        
        for(UIViewController* VC in self.navigationController.viewControllers){
            
            if([VC isKindOfClass:[investingViewController class]]){
                
                oneVC =(investingViewController *) VC;
                oneVC.sqman =nil;
                oneVC.jssuan =nil;
                oneVC.jisuanbfb = @"0";
                oneVC.jsyhq = nil;
                oneVC.hbid = nil;
                oneVC.jxid = nil;
                [self.navigationController popToViewController:oneVC animated:YES];}
            
        }
    }
}
-(void)loadNewTopics{
//    [self.FourBtnCollect.mj_footer resetNoMoreData];
    //结束下拉刷新
    [self.FourBtnCollect.mj_footer endRefreshing];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"uid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"uid"];
    params[@"sid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"sid"];
    params[@"at"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"at"];
    params[@"version"] = @"v1.0.3";
    params[@"os"] = @"ios";
    params[@"pageSize"] = @"10";
    params[@"pageIndex"] = @"1";
    params[@"is_used"] = @"0";
    self.page = 1;
    
    self.params = params;
    
    if (self.titlestr) {
        [WWZShuju initlizedData:getTouziurl paramsdata:params dicBlick:^(NSDictionary *info) {
            if (self.params != params)return ;
            NSLog(@"---奖劵未使用-----%@",info);
            self.Modelarr = [myjjModel mj_objectArrayWithKeyValuesArray:info[@"data"]];
            if (self.Modelarr.count ==0) {
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
            [self.FourBtnCollect.mj_header endRefreshing];//结束刷新
            [self.FourBtnCollect reloadData];
        
        }];
    }else{
    [WWZShuju initlizedData:myjjurl paramsdata:params dicBlick:^(NSDictionary *info) {
        if (self.params != params)return ;
        NSLog(@"---奖劵未使用-----%@",info);
        self.Modelarr = [myjjModel mj_objectArrayWithKeyValuesArray:info[@"data"]];
        if (self.Modelarr.count ==0) {
            UIImageView *imv = [[UIImageView alloc]init];
            imv.image = [UIImage imageNamed:@"pic_zwsj"];
            [self.view addSubview:imv];
            [imv mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.offset(0);
                make.top.offset(100);
                make.width.offset(155);
                make.height.offset(194);
            }];
        }else{
            self.FourBtnCollect.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopics)];
        }
        
         [self.FourBtnCollect.mj_header endRefreshing];//结束刷新
        [self.FourBtnCollect reloadData];
      
    }];
    }
    
}

- (void)loadMoreTopics
{
    //消除尾部"没有更多数据"的状态
    [self.FourBtnCollect.mj_footer resetNoMoreData];
    //结束上拉刷新
    [self.FourBtnCollect.mj_header endRefreshing];
    self.page++;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"uid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"uid"];
    params[@"sid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"sid"];
    params[@"at"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"at"];
    params[@"version"] = @"v1.0.3";
    params[@"os"] = @"ios";
    params[@"is_used"] = @"0";
    NSInteger page = self.page;
    params[@"pageSize"] = @"10";
    params[@"pageIndex" ]=@(page);
    
    self.params = params;
    [WWZShuju initlizedData:myjjurl paramsdata:params dicBlick:^(NSDictionary *info) {
        if (self.params != params)return ;
        NSLog(@"---奖劵已过期-----%@",info);
        [self.Modelarr addObjectsFromArray:[myjjModel mj_objectArrayWithKeyValuesArray:info[@"data"]]];
        
        if ([info[@"data"] count] == 0) {
            self.FourBtnCollect.mj_footer.state = MJRefreshStateNoMoreData;
            //设置页码
            self.page = page;
        }
        
        [self.FourBtnCollect reloadData];
        
    }];
    
}


-(void)layout{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = CGSizeMake(ScreenWidth-20,105);
    // 设置列的最小间距
    flowLayout.minimumInteritemSpacing = 12;
    // 设置最小行间距
    flowLayout.minimumLineSpacing = 12;
    // 设置布局的内边距
    flowLayout.sectionInset = UIEdgeInsetsMake(0,0,0,0);
    // 滚动方向
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _FourBtnCollect = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 16, ScreenWidth,self.titlestr == nil ?  ScreenHeight-120:ScreenHeight) collectionViewLayout:flowLayout];
    _FourBtnCollect.backgroundColor = grcolor;
    _FourBtnCollect.dataSource = self;
    _FourBtnCollect.delegate = self;
    _FourBtnCollect.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopics)];
    _FourBtnCollect.mj_header.automaticallyChangeAlpha = YES;//自动改变透明度
    [_FourBtnCollect.mj_header beginRefreshing];
//    self.FourBtnCollect.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopics)];
    
    [_FourBtnCollect registerNib:[UINib nibWithNibName:@"jaingjuanCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"custumecell"];
    [self.view addSubview:self.FourBtnCollect];
}

#pragma mrk -collect
- (NSInteger )collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.Modelarr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    jaingjuanCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"custumecell" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
    cell.xuxianView.alpha = 0;
    cell.model = self.Modelarr[indexPath.item];
    if (self.inputMoney && [self.inputMoney integerValue] < [cell.model.use_v integerValue]) {
        cell.imgView.image = [UIImage imageNamed:@"huise"];
    }
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (self.titlestr) {
        myjjModel *mode = self.Modelarr[indexPath.item];
        NSLog(@"%@, %@, %@", mode.money, mode.hbid, mode.type_name);
        if (self.inputMoney && [self.inputMoney integerValue] < [mode.use_v integerValue]) {
            [MBProgressHUD showInfoMessage:[@"投资金额需达到" stringByAppendingString:mode.use_v]];
        }else
        {
            investingViewController* oneVC =nil;
            
            for(UIViewController* VC in self.navigationController.viewControllers){
                
                if([VC isKindOfClass:[investingViewController class]]){
                    
                    oneVC =(investingViewController *) VC;
                    NSString *s = @"%";
                    if ([mode.money_ty isEqualToString:@"5"]) {
                        // 加息券
                        oneVC.sqman =[NSString stringWithFormat:@"%@%@ %@",mode.money,s,mode.type_name];
                        oneVC.jisuanbfb = mode.money;
                        oneVC.jxid = mode.hbid;
                        oneVC.jsyhq = mode.type_name;
                        oneVC.hbid = nil;
                    }else{
                        // 抵扣券
                        oneVC.sqman =[NSString stringWithFormat:@"%@元 %@",mode.money,mode.type_name];
                        oneVC.jssuan =mode.money;
                        oneVC.jsyhq = mode.type_name;
                        oneVC.hbid = mode.hbid;
                        oneVC.jxid = nil;
                        oneVC.jisuanbfb = 0;
                    }
                    
                    [self.navigationController popToViewController:oneVC animated:YES];}
                
            }
        }
       
 }

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
