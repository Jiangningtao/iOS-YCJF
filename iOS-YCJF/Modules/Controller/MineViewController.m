//
//  MineViewController.m
//  Working
//
//  Created by 姜宁桃 on 16/7/8.
//  Copyright © 2016年 小浩. All rights reserved.
//

#import "MineViewController.h"

#import "recordCollectionViewCell.h"
#import "rankingTableViewCell.h"
#import "menuCollectionViewCell.h"
#import "AutomaticTableViewCell.h"

#import "MineInstance.h"

#import "SettingViewController.h"
#import "LoginViewController.h"
#import "NEWSViewController.h"

#import "touziViewController.h"
#import "zhangdanViewController.h"
#import "yaoqinghyViewController.h"
#import "myjiangzhuangViewController.h"
#import "gychenghuiViewController.h"
#import "SafeSettingViewController.h"
#import "myBillsViewController.h"
#import "CashValueViewController.h"
#import "assetDetailViewController.h"
//#import "AutoTenderController.h"
#import "NewAutoTenderViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface MineViewController ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout, CLLocationManagerDelegate>
{
    UIView * _markView;  // 信息标记
    UIImageView * _leftImageV;
    
    AccinfoModel * accInfoModel; // 账户信息模型
    MineItemModel * mineItemModel; // 个人信息模型
}
/***tabview ***/
@property (nonatomic ,strong)UITableView *tab;
/** 第二组tableview的collect */
@property (nonatomic,strong)UICollectionView *Collect;
/***第五组tableview的collect ***/
@property (nonatomic ,strong)UICollectionView *sixBtnCollact;

/***图片array ***/
@property (nonatomic ,strong)NSArray *sjarr;
/***主题lab的数据 ***/
@property (nonatomic ,strong)NSArray *ztarr;
/***详情lab的数据 ***/
@property (nonatomic ,strong)NSArray *xqarr;
/***中间三个按钮的图文 ***/
@property (nonatomic ,strong)NSArray *btarr;

/***上一次的请求参数 ***/
@property (nonatomic ,strong)NSDictionary *params;
@property (nonatomic, strong) CLLocationManager * locManager;
/*地理编码*/
@property (nonatomic, strong) CLGeocoder * geocoder;

@end

@implementation MineViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"我的"];
    [TalkingData trackPageBegin:@"我的"];
    
    self.navigationController.navigationBar.hidden = YES;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    [self loadSuspendData];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"我的"];
    [TalkingData trackPageEnd:@"我的"];
    self.navigationController.navigationBar.hidden = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.locManager startUpdatingLocation];
    [self myAddrBtnEvent];
    // 添加通知的观察者，刷新数据
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadNewTopics) name:KNotificationRefreshMineDatas object:nil];
    
    
    [self.view addSubview:self.tab];
    [self layout];
    
    [self loadNewTopics];
    
    [self showSuspendView];
    
    [self configNavView];
    
    if (@available(iOS 11.0, *)) {
        self.tab.contentInsetAdjustmentBehavior = UIApplicationBackgroundFetchIntervalNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = false;
    }
}

- (void)configNavView
{
    self.navView.hidden = NO;
    self.navView.backgroundColor = UIColorHex(3994DE);
    self.sepView.backgroundColor = UIColorHex(3994DE);
    [self showRightBtn:CGRectMake(screen_width-45, 24, 40, 36) withImage:@"icon_message" withImageWidth:20];
    _markView = [[UIView alloc] initWithFrame:CGRectMake(self.rightButton.width-18, 5, 10, 10)];
    _markView.backgroundColor = KRedColor;
    _markView.radius = 5;
    _markView.hidden = YES;
    [self.rightButton addSubview:_markView];
    
    UIView * _leftView = [[UIView alloc] initWithFrame:CGRectMake(10, WTStatus_And_Navigation_Height-36, 60, 24)];
    [_leftView tapGesture:^(UIGestureRecognizer *ges) {
        SettingViewController * vc = [[SettingViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [self.navView addSubview:_leftView];
    
    UIImageView * _leftImgV = [[UIImageView alloc] initWithImage:IMAGE_NAMED(@"circle3")];
    [_leftView addSubview:_leftImgV];
    [_leftImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(0);
        make.left.offset(5);
    }];
    
    _leftImageV = [[UIImageView alloc] initWithImage:IMAGE_NAMED(@"defaultHead")];
    _leftImageV.radius = 11;
    [_leftView addSubview:_leftImageV];
    [_leftImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(0);
        make.left.equalTo(_leftImgV.mas_right).offset(8);
        make.width.height.offset(22);
    }];
}

#pragma mark - NetWork
+(void)load{
    NSMutableDictionary *params1  = [NSMutableDictionary dictionary];
    params1[@"uid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"uid"];
    params1[@"sid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"sid"];
    params1[@"at"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"at"];
    NSLog(@"%@", [[NSUserDefaults standardUserDefaults]objectForKey:@"sid"]);
    [WWZShuju initlizedData:sidurl paramsdata:params1 dicBlick:^(NSDictionary *info) {
        NSLog(@"--2--%@",info);
        if ([info[@"r"] integerValue] == 1) {
            [[NSUserDefaults standardUserDefaults] setObject:info[@"sid"] forKey:@"sid"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            NSLog(@"%@", [[NSUserDefaults standardUserDefaults]objectForKey:@"sid"]);
        }
    }];
}

-(void)loadNewTopics{
    
//    [MBProgressHUD showActivityMessageInWindow:@"努力加载中"];
    NSMutableDictionary *pramas = [NSMutableDictionary dictionary];
    pramas[@"uid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"uid"];
    pramas[@"sid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"sid"];
    pramas[@"accinfo"] = @"1";
    pramas[@"at"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"at"];
    NSLog(@"%@?%@", Myurl, pramas);
    self.params = pramas;
    [WWZShuju initlizedData:Myurl paramsdata:pramas dicBlick:^(NSDictionary *info) {
        NSLog(@"%@", info[@"msg"]);
        NSLog(@"--我的--%@",info);
//        [MBProgressHUD hideHUD];
        if ([info[@"r"] integerValue] == 1) {
            accInfoModel = [[AccinfoModel alloc] initWithDictionary:info[@"accinfo"] error:nil];
            mineItemModel = [[MineItemModel alloc] initWithDictionary:info[@"item"] error:nil];
            // 给单例赋值
            [MineInstance shareInstance].mineModel = mineItemModel;
            [MineInstance shareInstance].accModel = accInfoModel;
            if ([mineItemModel.unread_message integerValue] != 0) {
                _markView.hidden = NO;
            }else
            {
                _markView.hidden = YES;
            }
            if ([mineItemModel.headpture integerValue] != 0) {
                [_leftImageV setImageWithURL:[NSURL URLWithString:mineItemModel.avatar_url] placeholder:IMAGE_NAMED(@"defaultHead")];
            }
            [UserDefaults setObject:info[@"accinfo"][@"cur_seq"] forKey:KCurseq];
            [UserDefaults setObject:info[@"item"][@"real_status"] forKey:KReal_status];
            [UserDefaults setObject:info[@"item"][@"is_defaultpaypass"] forKey:KIs_defaultpaypass];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
        
        UILabel * rlab = [UILabel labelWithFrame:CGRectMake(12, 0, 10, 10) text:@"" font:8 textColor:KWhiteColor];
        rlab.textAlignment = NSTextAlignmentCenter;
        rlab.radius = 5;
        rlab.backgroundColor = KRedColor;
        UIButton * rBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 18, 20)];
        [rBtn setBackgroundImage:IMAGE_NAMED(@"icon_message") forState:UIControlStateNormal];
        [rBtn setBackgroundImage:IMAGE_NAMED(@"icon_message") forState:UIControlStateSelected];
        [rBtn addSubview:rlab];
        [rBtn addTarget:self action:@selector(rightBarBtnEvent) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem * ritem = [[UIBarButtonItem alloc] initWithCustomView:rBtn];
        self.navigationItem.rightBarButtonItem = ritem;
        if ([[MineInstance shareInstance].mineModel.unread_message integerValue] != 0) {
            rlab.hidden = NO;
        }else
        {
            rlab.hidden = YES;
        }
        
        if ([info[@"msg"] hasSuffix:@"请重新登录后访问！"]) {
            if ([UserDefaults objectForKey:KAccount] && [UserDefaults objectForKey:[UserDefaults objectForKey:KAccount]]) {
                [self reloginEvent];
            }else
            {
                [self AlertWithTitle:@"提示" message:info[@"msg"] andOthers:@[@"确定"] animated:YES action:^(NSInteger index) {
                    
                    //  跳到登录页面
                    LoginViewController *loginVC = [[LoginViewController  alloc] init];
                    //隐藏tabbar
                    UINavigationController * naVC = [[UINavigationController alloc] initWithRootViewController:loginVC];
                    [self presentViewController:naVC animated:YES completion:nil];
                }];
            }
        }
        
        if (self.params != pramas)return ;
        [self.tab reloadData];
        [self.sixBtnCollact reloadData];
        [_tab.mj_header endRefreshing];
    }];
}

- (void)reloginEvent
{
    NSMutableDictionary *paramss = [NSMutableDictionary dictionary];
    paramss[@"username"] =[UserDefaults objectForKey:KAccount];
    paramss[@"at"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"at"];
    [MBProgressHUD showActivityMessageInWindow:@"正在获取加密信息"];
    [WWZShuju initlizedData:jmurl paramsdata:paramss dicBlick:^(NSDictionary *info) {
        NSLog(@"加密%@",info);
        [[NSUserDefaults standardUserDefaults]setObject:info[@"sid"] forKey:@"sid"];
        [[NSUserDefaults standardUserDefaults]setObject:info[@"salt"] forKey:@"salt"];
        [[NSUserDefaults standardUserDefaults]setObject:info[@"cd"] forKey:@"cd"];
        [UserDefaults synchronize];
        [self LogBtnNetWork];
        
    }];
}

- (void)LogBtnNetWork{
    [MBProgressHUD showActivityMessageInWindow:@"正在登录，请稍候"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"at"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"at"];
    params[@"sid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"sid"];
    params[@"username"] =[UserDefaults objectForKey:KAccount];
    // 数据MD5加密
    NSString * str = [[UserDefaults objectForKey:[UserDefaults objectForKey:KAccount]] MD5];
    NSString *salt =  [NSString stringWithFormat:@"%@%@",str,[[NSUserDefaults standardUserDefaults]objectForKey:@"salt"]];
    NSString *str1 = [salt MD5];
    NSString *cd = [NSString stringWithFormat:@"%@%@",str1,[[NSUserDefaults standardUserDefaults]objectForKey:@"cd"]];
    NSString *str2 = [cd MD5];
    params[@"password"] = str2;
    NSLog(@"%@?%@",drurl, params);
    [WWZShuju initlizedData:drurl paramsdata:params dicBlick:^(NSDictionary *info) {
        NSLog(@"-----2---------%@",info);
        [MBProgressHUD hideHUD];
        NSLog(@"%@------%@",str2,[[NSUserDefaults standardUserDefaults]objectForKey:@"cd"]);
        
        if ([info[@"r"] isEqualToNumber:@0]) {
            
            //加密
            NSString *temp = info[@"msg"];
            NSLog(@"%@", temp);
            
        }else{
            [self loadNewTopics];
        }
        
    }];
    
}

#pragma mark - 定位
//当位置发生改变的时候调用(上面我们设置的是10米,也就是当位置发生>10米的时候该代理方法就会调用)
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    //取出第一个位置
    CLLocation *location=[locations firstObject];
    NSLog(@"%@",location.timestamp);
    //位置坐标
    CLLocationCoordinate2D coordinate=location.coordinate;
    NSLog(@"经度：%f,纬度：%f,海拔：%f,航向：%f,速度：%f",coordinate.longitude,coordinate.latitude,location.altitude,location.course,location.speed);
    
    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark *pl = [placemarks firstObject];
        
        if(error == nil)
        {
            NSLog(@"%@, %@, %@, %@", pl.administrativeArea,pl.locality,pl.subLocality, pl.name);
            NSString * address = [NSString stringWithFormat:@"%@%@%@%@", pl.administrativeArea,pl.locality,pl.subLocality,pl.name];
            [self NetworkOfUploadLocation:address];
        }
    }];
    //如果不需要实时定位，使用完即使关闭定位服务
    [_locManager stopUpdatingLocation];
}

- (void)NetworkOfUploadLocation:(NSString *)address
{
    NSMutableDictionary *paramss = [NSMutableDictionary dictionary];
    paramss[@"uid"] =[UserDefaults objectForKey:@"uid"];
    paramss[@"at"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"at"];
    paramss[@"sid"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"sid"];
    paramss[@"location"] = address;
    paramss[@"source"] =@"2";
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    paramss[@"version"] = app_Version; // 版本
    NSLog(@"%@?%@", scyhdzurl, paramss);
    [WWZShuju initlizedData:scyhdzurl paramsdata:paramss dicBlick:^(NSDictionary *info) {
        NSLog(@"加密%@",info);
        
    }];
}

#pragma mark - Event Hander
- (void)leftBarBtnEvent
{
    NSLog(@"personal center");
    SettingViewController * vc = [[SettingViewController alloc] init];
//    vc.Model = _mineItemModel;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)navRightBtnClick:(UIButton *)button
{
    NSLog(@"icon_message");
    NEWSViewController * vc = [[NEWSViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Help hander
#pragma mark - 四个按钮的摆布
-(void)layout{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    //    layout.itemSize = CGSizeMake(ScreenWidth,100);
    // 设置列的最小间距
    layout.minimumInteritemSpacing = 0;
    // 设置最小行间距
    layout.minimumLineSpacing = 0;
    // 设置布局的内边距
    layout.sectionInset = UIEdgeInsetsMake(0,0,0,0);
    // 滚动方向
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _Collect = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, screen_width, 100) collectionViewLayout:layout];
    _Collect.backgroundColor = [UIColor whiteColor];
    
    _Collect.dataSource = self;
    _Collect.delegate = self;
    [_Collect registerNib:[UINib nibWithNibName:@"menuCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"UserCollectCELLID"];
    
    UICollectionViewFlowLayout *layoutc = [[UICollectionViewFlowLayout alloc]init];
    //  layoutc.itemSize   = CGSizeMake(ScreenWidth,80);
    // 设置列的最小间距
    layoutc.minimumInteritemSpacing = 0.5;
    // 设置最小行间距
    layoutc.minimumLineSpacing = 1;
    
    // 设置布局的内边距
    layoutc.sectionInset = UIEdgeInsetsMake(0,0,0,0);
    
    // 滚动方向
    //    layoutc.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    
    _sixBtnCollact = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0,  screen_width, 240) collectionViewLayout:layoutc];
    _sixBtnCollact.backgroundColor = grcolor;
    _sixBtnCollact.scrollEnabled = NO;
    _sixBtnCollact.dataSource = self;
    _sixBtnCollact.delegate = self;
    [_sixBtnCollact registerNib:[UINib nibWithNibName:@"recordCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"sixBtnCollactCELLID"];
    
}


#pragma mark - UITableViewDelegate & UITableViewDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        rankingTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"rankingTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = [MineInstance shareInstance].accModel;
        return cell;
    }else if (indexPath.section == 1){
        static NSString *CellIdentifier = @"identifier2";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            [cell addSubview:self.Collect];
        }
        return cell;
    }else if (indexPath.section == 2){
        AutomaticTableViewCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"AutomaticTableViewCell" owner:nil options:nil]lastObject];
        return cell;
        
    }else {
        static NSString *CellIdentifier = @"identifier3";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            [cell addSubview:self.sixBtnCollact];
        }
        return cell;
    }

    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 264;
    }else if(indexPath.section == 1){
        return 100;
    }else if (indexPath.section == 2){
        return 50;
    }
    else{
        return  240;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.00001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section ==0 ) {
        assetDetailViewController * vc = [[assetDetailViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.section == 2){
        NewAutoTenderViewController * vc = [[NewAutoTenderViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

#pragma mrk -collect
- (NSInteger )collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if ([collectionView isEqual:_sixBtnCollact]) {
        return self.xqarr.count;
    }
    return self.btarr.count;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView cellForItemAtIndexPath:indexPath];
    if ([collectionView isEqual:_sixBtnCollact]) {
        
        if (indexPath.item == 0) {
            touziViewController *cx = [[touziViewController alloc]init];
            [self.navigationController pushViewController:cx animated:YES];
        }else if (indexPath.item == 1){
            zhangdanViewController *xx = [[zhangdanViewController alloc]init];
            [self.navigationController pushViewController:xx animated:YES];
        }else if (indexPath.item == 2){
            yaoqinghyViewController *xx = [[yaoqinghyViewController alloc]init];
            [self.navigationController pushViewController:xx animated:YES];
        }else if (indexPath.item == 3){
            myjiangzhuangViewController *xx = [[myjiangzhuangViewController alloc]init];
            [self.navigationController pushViewController:xx animated:YES];
        }else if (indexPath.item == 4){
            SafeSettingViewController *vc = [[SafeSettingViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }else {
            gychenghuiViewController * vc = [[gychenghuiViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        
        
    }else{
        if (indexPath.item == 0) {
            
            CashValueViewController *sv = [[CashValueViewController alloc]init];
            [self.navigationController pushViewController:sv animated:YES];
            
        }else if (indexPath.item == 1){
            myBillsViewController *sc = [[myBillsViewController alloc]init];
            [self.navigationController pushViewController:sc animated:YES];
            
        }else{
            NSLog(@"333");
        }
        
    }
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([collectionView isEqual:_sixBtnCollact]) {
        return CGSizeMake((_sixBtnCollact.frame.size.width/2)-0.5, 80);
    }
    return CGSizeMake(_Collect.frame.size.width/3,100);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([collectionView isEqual:_sixBtnCollact]) {
        
        
        recordCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"sixBtnCollactCELLID" forIndexPath:indexPath];
        cell.imgtx.image = [UIImage imageNamed:self.sjarr[indexPath.item]];
        cell.tzlab.text = self.ztarr[indexPath.item];
        cell.xqlab.text = self.xqarr[indexPath.item];
        cell.backgroundColor = [UIColor whiteColor];
        
        if (indexPath.item ==2) {
            cell.slimv.image = [UIImage imageNamed:@"icon_songli"];
            cell.xqlab.textColor =[UIColor lightGrayColor];
        }
        
        if (indexPath.item == 3) {
            
            cell.xqlab.text = [[MineInstance shareInstance].accModel.hb_num stringByAppendingString:@"张"];
            cell.slimv.image = [UIImage imageNamed:@""];
            NSLog(@"--------%@",cell.xqlab.text);
            cell.xqlab.textColor = [UIColor redColor];
            
            
            
            
        }
        return cell;
    }
    else{
        menuCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UserCollectCELLID" forIndexPath:indexPath];
        cell.btimgV.image = [UIImage imageNamed:self.btarr[indexPath.item][@"img"]];
        cell.btlab.text = self.btarr[indexPath.item][@"title"];
        if (indexPath.item == 2) {
            cell.btlab.textColor = [UIColor lightGrayColor];
        }
        return cell;
    }
    //return nil;
    
}
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


#pragma mark - Getter
-(NSArray *)btarr{
    if (!_btarr) {
        _btarr = [NSArray array];
        _btarr = @[
                   @{@"title":@"充值提现",@"img":@"icon_chongzhi"},@{@"title":@"我的账单",@"img":@"icon_zhangdan"},@{@"title":@"(敬请期待)",@"img":@"icon_vip"}
                   ];
    }
    return _btarr;
}
-(NSArray *)sjarr{
    if (!_sjarr) {
        _sjarr = [NSArray array];
        _sjarr = @[@"icon_tzjl",@"icon_daishou",@"icon_yaoqing",@"icon_jiangquan",@"icon_safe",@"icon_about"];
    }
    return _sjarr;
}
-(NSArray *)ztarr{
    if (!_ztarr) {
        _ztarr = [NSArray array];
        _ztarr = @[@"投资记录",@"待收账单",@"邀请好友",@"我的奖劵",@"安全中心",@"关于银程"];
    }
    return _ztarr;
}
-(NSArray *)xqarr{
    if (!_xqarr) {
        _xqarr = [NSArray array];
        _xqarr = @[@"投资详情 一目了然",@"代收款项 清晰把控",@"邀请注册有好礼",@"5 张",@"理财更放心",@"客服 400-005-6677"];
    }
    return _xqarr;
}

-(UITableView *)tab
{
    if (!_tab) {
        _tab = [[UITableView alloc]initWithFrame:CGRectMake(0, WTStatus_And_Navigation_Height, screen_width, screen_height-WTStatus_And_Navigation_Height-WTTab_Bar_Height) style:UITableViewStyleGrouped];
        [_tab registerNib:[UINib nibWithNibName:@"rankingTableViewCell" bundle:nil] forCellReuseIdentifier:@"rankingTableViewCell"];
        _tab.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tab.dataSource= self;
        _tab.delegate = self;
        /// 自动关闭估算高度，不想估算那个，就设置那个即可
        _tab.estimatedRowHeight = 0;
        _tab.estimatedSectionHeaderHeight = 0;
        _tab.estimatedSectionFooterHeight = 0;
        _tab.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopics)];
        _tab.mj_header.automaticallyChangeAlpha = YES;//自动改变透明度
    }
    return _tab;
}

#if 1
#pragma mark - myAddrBtnEvent
- (void)myAddrBtnEvent
{
    [self.locManager requestWhenInUseAuthorization];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
        if (status == kCLAuthorizationStatusNotDetermined) {
            [self showAlertView];
        }
        else if (status == kCLAuthorizationStatusAuthorizedAlways ||
                 status == kCLAuthorizationStatusAuthorizedWhenInUse) {
            
            [self.locManager startUpdatingLocation];
        }
        else {
            [self showAlertView];
        }
    });
}

- (void)showAlertView
{
    [self AlertWithTitle:@"温馨提示" message:@"需要您开启定位服务,请到设置->隐私,打开定位服务" andOthers:@[@"取消", @"确定"] animated:YES action:^(NSInteger index) {
        if (index == 0) {
            NSLog(@"0");
        }else if (index == 1){
            NSLog(@"1");
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }
    }];
}

/**
 *  授权状态发生改变时调用
 */
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusAuthorizedAlways ||
        status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        
        [self.locManager startUpdatingLocation];
    }
}
#endif

#pragma mark - Getter
- (CLGeocoder *)geocoder
{
    if (_geocoder == nil) {
        _geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}

- (CLLocationManager *)locManager
{
    if (_locManager == nil) {
        _locManager = [[CLLocationManager alloc] init];
        self.locManager.distanceFilter = 10.0f;
        self.locManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locManager.delegate = self;
    }
    return _locManager;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
