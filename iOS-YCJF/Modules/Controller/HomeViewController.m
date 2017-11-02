//
//  HomeViewController.m
//  iOS-YCJF
//
//  Created by 姜宁桃 on 2017/8/8.
//  Copyright © 2017年 Yincheng. All rights reserved.
//

#import "HomeViewController.h"
#import "bannerModel.h"
#import "newsModel.h"
#import "TopicModel.h"
#import "investlistModel.h"
#import "biaoModel.h"
#import "PushHandler.h"

#import <SDCycleScrollView.h>
#import "CouplesCollectionViewCell.h"
#import "HBtnCollectionViewCell.h"
#import "InvestmenCollectionViewCell.h"
#import "selecellTableViewCell.h"
#import "newsTableViewCell.h"

#import "HomeActivityView.h"
#import "SuspendView.h"
#import "CCPScrollView.h"
#import "UpdateTipView.h"
#import "BiaoDetailViewController.h"
#import "TabBarViewController.h"
#import "chenghuiViewController.h"
#import "YinChengNewsDetailViewController.h"
#import "yaoqinghyViewController.h"
#import "LoginViewController.h"
#import "WelfareView.h"
#import "myjiangzhuangViewController.h"

#import "DoubleElevenViewController.h"
#import "InviteFriendsViewController.h"

#define HeaderHeight 330

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;


@interface HomeViewController ()<UITableViewDelegate, UITableViewDataSource, SDCycleScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, visitDetailDelegate>
{
    WelfareView * _welfareView;
    UIView * bgView;
}
@property (nonatomic) CGRect origialFrame;
//@property (nonatomic, strong) HomeTwoBtnView * twoHomeBtnView;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) SDCycleScrollView * sdScrollView; // 轮播图控件
@property (nonatomic, strong) UIPageControl * pageControl;  // 新人专享的pageControl
@property (nonatomic ,strong)UIButton *nvbtn; //公告按钮
//@property (nonatomic, strong) UIView * nvbtn; // 公告栏
@property (nonatomic,strong)UICollectionView *FourBtnCollect; //四个按钮
@property (nonatomic,strong)UICollectionView *coupleCollect;    // 新人专享
@property (nonatomic,strong)UICollectionView *UserCollect; //用户collect

/***上一次的请求参数 ***/
@property (nonatomic ,strong)NSDictionary *params;

@property (nonatomic, strong) NSMutableArray * bannerArray; // 轮播图数组
@property (nonatomic, strong) NSMutableArray * gonggaoArray; // 公告中心数组
@property (nonatomic ,strong)NSArray *sjarr;    // 顶部四个按钮数组
@property (nonatomic ,strong)NSArray *arra; //标题
@property (nonatomic, strong) NSMutableArray * xslistArray; // 新人专享数组
@property (nonatomic, strong) NSMutableArray * jxlistArray; // 精选投资数组
@property (nonatomic, strong) NSMutableArray * investlistArray; // 昨日投资榜数组
@property (nonatomic, strong) NSMutableArray * newsArray;   // 新闻中心数组
@property (nonatomic ,strong)NSMutableArray *investImgArr;  // 昨日投资榜排行图片

@end

@implementation HomeViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navView.hidden = NO;
    self.navigationController.navigationBar.hidden = YES;
    self.title = @"首页";
    [MobClick beginLogPageView:self.title];
    [TalkingData trackPageBegin:self.title];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:self.title];
    [TalkingData trackPageEnd:self.title];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1.获取主队列
   dispatch_queue_t queue=dispatch_get_main_queue();
   //2.把任务添加到主队列中执行
   dispatch_async(queue, ^{
        NSLog(@"使用异步函数执行主队列中的任务1--%@",[NSThread currentThread]);
       if ([preUrl hasPrefix:@"https://www.yinchenglicai.com/"]) {
           // 正式服
           [self getAppVersion];   // 获取app版本信息
       }
    });
   dispatch_async(queue, ^{
           NSLog(@"使用异步函数执行主队列中的任务2--%@",[NSThread currentThread]);
       // 获取活动弹窗
       [self getActivityPopView];
       
    });
   dispatch_async(queue, ^{
        NSLog(@"使用异步函数执行主队列中的任务3--%@",[NSThread currentThread]);
       [self loadNewTopics];
    });
    
    
    [self configUI];
    
    [PushHandler shareInstance].baseController = self;
    
    [self showSuspendView];
}


- (void)getAppVersion
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
//    CFShow(infoDictionary);
    // app名称
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    // app build版本
    NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
    NSLog(@"app名称：%@, app版本：%@, app build版本：%@", app_Name, app_Version, app_build);
    
    NSArray * versionArr = [app_Version componentsSeparatedByString:@"."];
    NSString * version1 = versionArr[0];
    NSString * version2 = [NSString stringWithFormat:@"%@.%@", versionArr[1], versionArr[2]];
    NSLog(@"versionArr：%@, version1：%@, version2：%@", versionArr, version1, version2);
    
    NSMutableDictionary * paramsDict = [NSMutableDictionary dictionary];
    paramsDict[@"app_id"] = @"3";
    paramsDict[@"os"] = @"ios";
    NSLog(@"%@?%@", versionurl, paramsDict);
    [WWZShuju initlizedData:versionurl paramsdata:paramsDict dicBlick:^(NSDictionary *info) {
        NSLog(@"%@", info);
        if ([info[@"r"] integerValue] == 1) {
            // 获取更新信息成功   app_Version(1.2.0) = version (version1) + versionName (version2)
            if ([info[@"item"][@"version"] floatValue] > [version1 floatValue] || [info[@"item"][@"versionName"] floatValue] > [version2 floatValue]) {
                if ([info[@"item"][@"force"] floatValue] == 0) {
                    UpdateTipView * updateView = [[UpdateTipView alloc] initWithFrame:screen_bounds updateStr:info[@"item"][@"updateMsg"]];
                    [self.view.window addSubview:updateView];
                }else if ([info[@"item"][@"force"] floatValue] == 1)
                {
                    [self AlertWithTitle:@"发现新版本" message:info[@"item"][@"updateMsg"] andOthers:@[@"立即更新"] animated:YES action:^(NSInteger index) {
                        if (index == 0) {
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:AppStroreUrl]];
                        }
                    }];
                }
            }
            
        }
    }];
    
}

- (void)getActivityPopView
{
    [WWZShuju initlizedData:syhdurl paramsdata:nil dicBlick:^(NSDictionary *info) {
        
        if ([info[@"r"]   isEqual: @1]) {
            NSLog(@"%@", info);
            [UserDefaults setObject:info[@"xshbmoney"] forKey:KXshbmoney];
            [UserDefaults synchronize];
            if ( [[UserDefaults objectForKey:KNewRegister] isEqualToString:@"1"] && [[UserDefaults objectForKey:@"uid"] length] > 0 && [info[@"xshbifshow"] integerValue] == 1) {
                // 新手注册登录后进入，不必显示活动弹窗，下次在弹出
                NSLog(@"新手注册登录后进入，不必显示活动弹窗，下次在弹出");
                
                _welfareView = [[WelfareView alloc] initWithFrame:screen_bounds];
                _welfareView.visitDelegate = self;
                _welfareView.imgUrl = info[@"xshbpath"];
                _welfareView.txtStr = info[@"xshbtxt"];
                [self.view.window addSubview:_welfareView];
                [UserDefaults setObject:@"2" forKey:KNewRegister];
                [UserDefaults synchronize];
            }else
            {
                NSLog(@"push = %@", [UserDefaults objectForKey:KIs_push]);
                if ([[UserDefaults objectForKey:KIs_push] integerValue] == 0) {
                    if ([info[@"ifshow"] integerValue]  ==1) {
                        HomeActivityView * activityView = [[HomeActivityView alloc] initWithFrame:screen_bounds];
                        activityView.pageURLString = info[@"path"];
                        activityView.blockSelect = ^{
                            WebViewController * webVC = [[WebViewController alloc] init];
                            webVC.url = info[@"url"];
                            [self.navigationController pushViewController:webVC animated:YES];
                        };
                        [self.view.window addSubview:activityView];
                    }
                }
            }
        }
    }];
}

- (void)visitDetailOfWelfareEvent
{
    myjiangzhuangViewController *jiangQuan = [[myjiangzhuangViewController alloc] init];
    //隐藏tabbar
    jiangQuan.upVC = @"jiangQuan";
    UINavigationController * nav= [[UINavigationController alloc] initWithRootViewController:jiangQuan];
    [self presentViewController:nav animated:YES completion:nil];
}


#pragma mark - NetWork
+(void)load{
    NSMutableDictionary *params  = [NSMutableDictionary dictionary];
    params[@"app_id"] = @"3";
    params[@"secret"] = @"aodsadhowiqhdwiqs";
    [WWZShuju initlizedData:aturl paramsdata:params dicBlick:^(NSDictionary *info) {
        NSLog(@"--1--%@",info);
        [[NSUserDefaults standardUserDefaults]setObject:info[@"at"] forKey:@"at"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSLog(@"%@", [[NSUserDefaults standardUserDefaults]objectForKey:@"at"]);
    }];
}

-(void)loadNewTopics
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"app_id"] = @"3";
    params[@"at"] =[[NSUserDefaults standardUserDefaults]objectForKey:@"at"];
    params[@"banner"] = @"1";
    params[@"channel"] = @"feipao";
    params[@"first"] = @"1";
    params[@"flash_adv"] = @"1";
    params[@"secret"] = @"aodsadhowiqhdwiqs";
    params[@"version"] = @"v1.0.3";
    params[@"os"] = @"ios";
    params[@"cls"] = @"1";
    params[@"tjblist"] = @"2";
    params[@"investmentListYest"] = @"3";
    params[@"new_num"] = @"2";
    params[@"gg_num"] = @"1";
    params[@"first_cls"] = @"4,5";
    params[@"cls_each"] = @"1";
    params[@"xinshou"] = @"2";
    params[@"no_xinshou"] = @"1";
    params[@"banner_share"] = @"1";
    params[@"uid"] = [UserDefaults objectForKey:@"uid"];
    
//    [MBProgressHUD showActivityMessageInWindow:@"数据加载中"];
    self.params = params;
    
    NSLog(@"%@?%@", syurl, params);
    [manager POST:syurl parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (self.params != params)return ;
        NSLog(@"%@", responseObject);
        
        [self.bannerArray removeAllObjects];
        [self.gonggaoArray removeAllObjects];
        [self.newsArray removeAllObjects];
        [self.xslistArray removeAllObjects];
        [self.jxlistArray removeAllObjects];
        [self.investlistArray removeAllObjects];
        
        //处理轮播图
        NSMutableArray * bannerImgUrlArr = [NSMutableArray new];
        for (NSDictionary *imgDic in (NSArray *)responseObject[@"banner"]) {
            bannerModel *mode = [[bannerModel alloc] initWithDictionary:imgDic error:nil];
            [bannerImgUrlArr addObject:imgDic[@"img_url"]];
            [self.bannerArray addObject:mode];
        }
        self.sdScrollView.imageURLStringsGroup = bannerImgUrlArr;
        
        // 处理公告中心
        for (NSDictionary *gonggaoDic in (NSArray *)responseObject[@"gg_data"]) {
            [self.gonggaoArray addObject:gonggaoDic];
        }
        if (self.gonggaoArray.count > 0) {
            [self.nvbtn setTitle:self.gonggaoArray[0][@"title"] forState:UIControlStateNormal];
        }
        
        //  处理新人专享
        if (NULL_TO_NIL(responseObject[@"xslist"])) {
            for (NSDictionary *xsDic in (NSArray *)responseObject[@"xslist"]) {
                TopicModel * model = [[TopicModel alloc] initWithDictionary:xsDic error:nil];
                [self.xslistArray addObject:model];
            }
        }
        
        //  精选投资
        [responseObject[@"tjblist"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if (![obj[@"bid"] isKindOfClass:[NSNull class]]) {
                [self.jxlistArray addObject:[biaoModel mj_objectWithKeyValues:obj]];
            }
            if (self.jxlistArray.count>2) {
                *stop = YES;
            }
        }];
//        NSLog(@"%@", self.jxlistArray);
        
        //  昨日投资榜
        for (NSDictionary *zrDic in (NSArray *)responseObject[@"investmentListYest"]) {
            investlistModel * model = [[investlistModel alloc] initWithDictionary:zrDic error:nil];
            [self.investlistArray addObject:model];
        }
        
        // 处理新闻
        for (NSDictionary *newsDic in (NSArray *)responseObject[@"new_data"]) {
            newsModel *mode = [[newsModel alloc] initWithDictionary:newsDic error:nil];
            [self.newsArray addObject:mode];
        }
        
        NSMutableArray * twoBtnTitleArray = [[NSMutableArray alloc] init];
        [twoBtnTitleArray addObject:@"安全保障"];  // responseObject[@"home"][@"totsafe"]
        [twoBtnTitleArray addObject:@"数据披露"];  // responseObject[@"home"][@"totdata"]
        
        NSMutableArray * twoBtnSubTitleArray = [[NSMutableArray alloc] init];
        [twoBtnSubTitleArray addObject:@"银行存管即将上线"];    // responseObject[@"home"][@"safe"]
        [twoBtnSubTitleArray addObject:@"运营数据完全透明"];    // responseObject[@"home"][@"data"]
        /*
        self.twoHomeBtnView = [[HomeTwoBtnView alloc] initWithFrame:CGRectMake(0, self.nvbtn.bottom, screen_width, 90) titleArray:twoBtnTitleArray subTitleArray:twoBtnSubTitleArray];
        WS(weakself);
        self.twoHomeBtnView.blockOfSafeBtn = ^{
            // 安全保障
            NSLog(@"safe");
            WebViewController * webVC = [[WebViewController alloc] init];
            webVC.url = aqbzh5;
            webVC.WebTiltle = @"安全保障";
            [weakself.navigationController pushViewController:webVC animated:YES];
        };
        
        self.twoHomeBtnView.blockOfDataBtn = ^{
            // 数据披露
            NSLog(@"data");
            WebViewController * webVC = [[WebViewController alloc] init];
            webVC.url = yybgh5;
            webVC.WebTiltle = @"运营报告";
            [weakself.navigationController pushViewController:webVC animated:YES];
        };
        
        [bgView addSubview:self.twoHomeBtnView];
        */
        NSLog(@"%ld, %ld, %ld, %ld, %ld, %ld", self.bannerArray.count, self.gonggaoArray.count, self.xslistArray.count, self.jxlistArray.count, self.investlistArray.count, self.newsArray.count);
        [self.tableView.mj_header endRefreshing];//结束刷新
        [self.tableView reloadData];
        [_coupleCollect reloadData];
        [_UserCollect reloadData];
//        [MBProgressHUD hideHUD];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (self.params != params)return ;
        //结束刷新
        [self.tableView.mj_header endRefreshing];
//        [MBProgressHUD hideHUD];
        NSLog(@"%@",error);
    }];
    
}

- (void)configUI
{
    [self layout];
    self.backImageView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, HeaderHeight)];
    _sdScrollView = [self setupADScrollView];
    [bgView addSubview:self.sdScrollView];
    [bgView addSubview:self.nvbtn];
    [bgView addSubview:self.FourBtnCollect];
    
    self.origialFrame = bgView.frame;
    [self.view addSubview:bgView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screen_width, screen_height) style:UITableViewStyleGrouped];
    [_tableView registerNib:[UINib nibWithNibName:@"selecellTableViewCell" bundle:nil] forCellReuseIdentifier:@"selecellTableViewCell"];
    _tableView.tableFooterView = [[CommonBottomView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 40)];
    _tableView.mj_header.automaticallyChangeAlpha = YES;//自动改变透明度
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopics)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.tableHeaderView = bgView;
    [self.view addSubview:self.tableView];
    
    self.titleView.image = IMAGE_NAMED(@"yc");
    self.navView.alpha = 0.f;
    [self.view addSubview:self.navView];
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        // 精选投资
        BiaoDetailViewController *ssc = [[BiaoDetailViewController alloc]init];
        biaoModel *mode = self.jxlistArray[indexPath.row];
        ssc.idstr = mode.bid;
        [self.navigationController pushViewController:ssc animated:YES];
    }else if (indexPath.section == 3){
        // 新闻详情
        YinChengNewsDetailViewController * ycNewsDetailVC = [[YinChengNewsDetailViewController alloc] init];
        newsModel * model = self.newsArray[indexPath.row];
        ycNewsDetailVC.news_id = model.news_id;
        [self.navigationController pushViewController:ycNewsDetailVC animated:YES];
    }
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.arra.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0 || section == 2) {
        return 1;
    }else if (section == 1 ){
        if (self.jxlistArray.count <= 2) {
            return self.jxlistArray.count;
        }else
        {
            return 2;
        }
    }else
    {
        if (self.newsArray.count <= 2) {
            return self.newsArray.count;
        }else
        {
            return 2;
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 260;
    }else if (indexPath.section == 1){
        return 178;
    }else{
        return 120;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *CellIdentifier1 = @"identifier3";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            [cell addSubview:self.coupleCollect];
            
            _pageControl = [[UIPageControl alloc] init];
            _pageControl.numberOfPages = 2;
            _pageControl.pageIndicatorTintColor = color(243, 243, 243, 1);
            _pageControl.currentPageIndicatorTintColor = color(187, 187, 187, 1);
            _pageControl.center = CGPointMake(cell.centerX, _coupleCollect.bottom);
            [cell addSubview:_pageControl];
        }
        return cell;
    }else if (indexPath.section == 1){
        selecellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"selecellTableViewCell"];
        if (self.jxlistArray.count > 0) {
            cell.model = self.jxlistArray[indexPath.row];
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }else if (indexPath.section == 3){
        newsTableViewCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"newsTableViewCell" owner:nil options:nil]lastObject];
        cell.model = self.newsArray[indexPath.row];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.section == 2){
        static NSString *CellIdentifier = @"identifier2";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            [cell addSubview:self.UserCollect];
            
        }
        return cell;
    }
//    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return nil;
}

//分组间距
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 55;//section头部高度
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [self configTabTitleWithSection:section];
}


#pragma mark - collect
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView cellForItemAtIndexPath:indexPath];
    if ([collectionView isEqual:self.FourBtnCollect]) {
        WebViewController * webVC = [[WebViewController alloc] init];
        webVC.WebTiltle = self.sjarr[indexPath.item][@"title"];
        if (indexPath.row ==0){
            webVC.url = ptjsh5;
            [self.navigationController pushViewController:webVC animated:YES];
        }else if (indexPath.row ==1) {
            webVC.url = yybgh5;
            [self.navigationController pushViewController:webVC animated:YES];
        }else if (indexPath.row ==2) {
            webVC.url = aqbzh5;
            [self.navigationController pushViewController:webVC animated:YES];
        }else{
            if (![UserDefaults objectForKey:KAccount]) {
                [self AlertWithTitle:@"提示" message:@"您还没有登录，请先去登录" andOthers:@[@"取消", @"确定"] animated:YES action:^(NSInteger index) {
                    if (index == 0) {
                        // 点击取消按钮 不进行操作
                        NSLog(@"取消");
                    }else if(index == 1)
                    {
                        // 点击确定按钮，去登录
                        LoginViewController *sv = [[LoginViewController alloc]init];
                        sv.isTurnToTabVC = @"YES";
                        [self showViewController:sv sender:nil];
                    }
                }];
            }else
            {
                // 邀请好友
                //yaoqinghyViewController *xx = [[yaoqinghyViewController alloc]init];
                //[self.navigationController pushViewController:xx animated:YES];
                // 邀请好友活动
                InviteFriendsViewController *xx = [[InviteFriendsViewController alloc]init];
                [self.navigationController pushViewController:xx animated:YES];
            }
        }
        
    }else if ([collectionView isEqual:self.coupleCollect]){
        BiaoDetailViewController *ssc = [[BiaoDetailViewController alloc]init];
        biaoModel *mode = self.xslistArray[indexPath.row];
        ssc.idstr = mode.bid;
        [self.navigationController pushViewController:ssc animated:YES];
        
    }else{
        
    }
    // collectionView.clipsToBounds = NO;
}

- (NSInteger )collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if ([collectionView isEqual:_FourBtnCollect]) {
        return self.sjarr.count;
    }else if ([collectionView isEqual:_coupleCollect]) {
        return self.xslistArray.count;
    }else{
        return self.investlistArray.count;
    }
    return 0;
    //    return nil;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([collectionView isEqual:_FourBtnCollect]) {
        
        
        HBtnCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"custumecell" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
        cell.btimageV.image =  [UIImage imageNamed:self.sjarr[indexPath.item][@"img"]] ;
        cell.xslab.text = self.sjarr[indexPath.item][@"title"];
        return cell;
        
    }else if ([collectionView isEqual:_coupleCollect]){
        CouplesCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CouplesCollectionViewCell" forIndexPath:indexPath];
        if (self.xslistArray.count) {
            cell.pic = self.xslistArray[indexPath.item];
        }
        NSLog(@"cell -pic --%@",cell.pic);
        return cell;
    }
    else{
        InvestmenCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UserCollectCELLID" forIndexPath:indexPath];
        NSString * investImg = self.investImgArr[indexPath.item];
        cell.investImgV.image = [UIImage imageNamed:investImg];
        investlistModel * model = self.investlistArray[indexPath.item];
        if ([model.headpture integerValue] == 0) {
            cell.imgV.image = [UIImage imageNamed:@"defaultHead"];
            cell.imgV.layer.borderWidth = 0.5;
            cell.imgV.layer.borderColor = [UIColor lightGrayColor].CGColor;
        }else
        {
            [cell.imgV sd_setImageWithURL:[NSURL URLWithString:model.headpture_str] placeholderImage:[UIImage imageNamed:@"defaultHead"]];
        }
        cell.hmlab.text = model.mobile;
        return cell;
    }
    
    
}


#pragma mark 滑动隐藏导航栏
#if 1
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //往上滑动offset增加，往下滑动，yoffset减小
    CGFloat yoffset = scrollView.contentOffset.y;
    
    // 获取当前的偏移量，计算当前第几页
    int number = scrollView.contentOffset.x/scrollView.bounds.size.width+0.5;
    self.pageControl.currentPage = number;

    
    if (yoffset<HeaderHeight) {//滑动到导航栏地底部之前
        CGFloat colorAlpha = yoffset/HeaderHeight;
        self.navView.alpha = colorAlpha;
    }else {//超过导航栏底部
        self.navView.alpha = 1;
    }
    //处理放大效果和往上移动的效果
    if (yoffset>0) {//往上滑动
       
        bgView.frame = ({
            CGRect frame = self.origialFrame;
            frame.origin.y = self.origialFrame.origin.y - yoffset;
            frame;
        });
        
    }else {//往下滑动，放大处理
        bgView.frame = ({
            CGRect frame = self.origialFrame;
//            frame.size.height = self.origialFrame.size.height - yoffset;
//            frame.size.width = frame.size.height/1.2;
 //           frame.origin.x = _origialFrame.origin.x - (frame.size.width-_origialFrame.size.width)/2;
            frame;
        });
        
    }
    
}
#endif


#pragma mark -  SDCycleScrollViewDelegate
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    bannerModel *mode = self.bannerArray[index];
    NSLog(@"%@", mode.url);
    if ([mode.url hasSuffix:@"h5/app/act.html"]) {
        WebViewController * webVC = [[WebViewController alloc] init];
        webVC.url = mode.url;
        webVC.WebTiltle = @"新手福利";
        webVC.bannerModel = mode;
        [self.navigationController pushViewController:webVC animated:YES];
    }else if(![mode.url isEqualToString:@"#"])
    {
        WebViewController * webVC = [[WebViewController alloc] init];
        webVC.url = mode.url;
        webVC.bannerModel = mode;
        [self.navigationController pushViewController:webVC animated:YES];
    }else if ([mode.url isEqualToString:@"#"])
    {
        DoubleElevenViewController * vc = [[DoubleElevenViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - Event Hander
-(void)novbtnclicked{
    NSLog(@"公告");
    WebViewController * webVC = [[WebViewController alloc] init];
    webVC.url = ggzxh5;
    [self.navigationController pushViewController:webVC animated:YES];
}

#pragma mark - Help Method
- (UIView *)configTabHeadView
{
    UIView * _tabHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 345)];
    _sdScrollView = [self setupADScrollView];
    [_tabHeadView addSubview:self.sdScrollView];
    [_tabHeadView addSubview:self.nvbtn];
    [_tabHeadView addSubview:self.FourBtnCollect];
    return _tabHeadView;
}

/**
 *  3D滚动广告轮播
 */
-(SDCycleScrollView*)setupADScrollView{
    
    // 添加上方轮播图 --- 创建不带标题的图片轮播器
    SDCycleScrollView* _headerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, screen_width, 200) delegate:self placeholderImage:[UIImage imageNamed:@"banner_default"]];
    _headerView.pageControlDotSize = CGSizeMake(8*widthScale, 8*widthScale);
    _headerView.currentPageDotColor = [UIColor whiteColor];
    _headerView.pageDotColor = color(217, 217, 217, 1);
    _headerView.backgroundColor = [UIColor whiteColor];
    [_headerView adjustWhenControllerViewWillAppera];
    _headerView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
    return _headerView;
}
/**
 *  公告中心
 */
-(UIButton *)nvbtn{
    if (!_nvbtn) {
        _nvbtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, 30)];
        _nvbtn.backgroundColor = [UIColor colorWithRed:234/255.0 green:242/255.0 blue:255/255.0 alpha:1/1.0];
        [_nvbtn setImage:[UIImage imageNamed:@"icon-tz"] forState:UIControlStateNormal];
        _nvbtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _nvbtn.titleLabel.font = [UIFont systemFontOfSize:12*heightScale];
        [_nvbtn setTitleColor: [UIColor colorWithRed:57/255.0 green:149/255.0 blue:223/255.0 alpha:1/1.0] forState:UIControlStateNormal];
        [_nvbtn addTarget:self action:@selector(novbtnclicked) forControlEvents:UIControlEventTouchUpInside];
        _nvbtn.imageEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
        _nvbtn.titleEdgeInsets = UIEdgeInsetsMake(0, 25, 0, 0);
    }
    return _nvbtn;
}
/*
- (UIView *)nvbtn
{
    if (!_nvbtn) {
        _nvbtn = [[UIView alloc] initWithFrame:CGRectMake(0, 200, screen_width, 30*heightScale)];
        _nvbtn.backgroundColor = [UIColor colorWithRed:234/255.0 green:242/255.0 blue:255/255.0 alpha:1/1.0];
        UIImageView * nvImgV = [[UIImageView alloc] initWithImage:IMAGE_NAMED(@"icon-tz")];
        nvImgV.frame = CGRectMake(10, 9*widthScale, 12, 12);
        CCPScrollView * cpScrollView = [[CCPScrollView alloc] initWithFrame:CGRectMake(nvImgV.right+5, 5*widthScale, screen_width-30, 20*heightScale)];
        cpScrollView.titleArray = [NSArray arrayWithObjects:@"iPhone6s上线32G内存手机你怎么看？",@"亲爱的朋友们2016年还有100天就要过去了,2017年您准备好了吗?",@"今年双11您预算了几个月的工资？",@"高德与百度互掐，你更看好哪方？", nil];
        
        cpScrollView.titleFont = 12;
        
        cpScrollView.titleColor = [UIColor colorWithRed:57/255.0 green:149/255.0 blue:223/255.0 alpha:1/1.0];
        
        cpScrollView.BGColor = [UIColor clearColor];
        cpScrollView.clickLabelBlock = ^(NSInteger index, NSString *titleString) {
            NSLog(@"%ld-----%@",index,titleString);
            
        };
        [_nvbtn addSubview:cpScrollView];
        [_nvbtn addSubview:nvImgV];
    }
    return _nvbtn;
}
*/
- (UIView *)configTabTitleWithSection:(NSInteger)section
{
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screen_width, 55)];
    v.backgroundColor = [UIColor whiteColor];
    
    UILabel * titleLab = [[UILabel alloc] init];
    titleLab.text = self.arra[section];
    [v addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(0);
        make.left.offset(19);
    }];
    
    UILabel * subTitleLab = [[UILabel alloc] init];
    subTitleLab.font = systemFont(13.0f);
    [v addSubview:subTitleLab];
    if (section == 0) {
        subTitleLab.text = @"收益所见即所得 本息100%回款";
        subTitleLab.textColor = [UIColor colorWithRed:253/255.0 green:128/255.0 blue:46/255.0 alpha:1/1.0];
        [subTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.offset(0);
            make.right.offset(-8);
        }];
    }else if (section == 2){
        subTitleLab.text = @"每日零点统计";
        subTitleLab.textColor = color(100, 100, 100, 1);
        [subTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.offset(0);
            make.right.offset(-8);
        }];
    }else if (section == 1 || section == 3){
        UIImageView * moreImgV = [[UIImageView alloc] init];
        moreImgV.image = IMAGE_NAMED(@"icon_more");
        [v addSubview:moreImgV];
        [moreImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.offset(0);
            make.right.offset(-8);
            make.width.height.offset(15);
        }];
        subTitleLab.text = @"查看更多";
        subTitleLab.textColor = color(100, 100, 100, 1);
        [subTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.offset(0);
            make.right.offset(-25);
        }];
        if (section == 1) {
            [v tapGesture:^(UIGestureRecognizer *ges) {
                NSLog(@"精选投资 查看更多事件");
                KPostNotification(KNotificationTabSelectInvest, nil);
            }];
        }else
        {
            [v tapGesture:^(UIGestureRecognizer *ges) {
                NSLog(@"新闻中心 查看更多事件");
                chenghuiViewController *ssc = [[chenghuiViewController alloc]init];
                ssc.titlestr = @"新闻中心";
                [self.navigationController pushViewController:ssc animated:YES];
            }];
        }
    }
    return v;
}

#pragma mark - 四个按钮的摆布
-(void)layout{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = CGSizeMake(screen_width/4,91);
    // 设置列的最小间距
    flowLayout.minimumInteritemSpacing = 0;
    // 设置最小行间距
    flowLayout.minimumLineSpacing = 0;
    // 设置布局的内边距
    flowLayout.sectionInset = UIEdgeInsetsMake(0,0,0,0);
    // 滚动方向
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _FourBtnCollect = [[UICollectionView alloc]initWithFrame:CGRectMake(0, self.nvbtn.bottom, screen_width,91) collectionViewLayout:flowLayout];
    _FourBtnCollect.backgroundColor = [UIColor whiteColor];
    _FourBtnCollect.dataSource = self;
    _FourBtnCollect.delegate = self;
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 99.5, screen_width, 0.5)];
    lineView.backgroundColor = color(199, 199, 203, 1);
    [_FourBtnCollect addSubview:lineView];
    [_FourBtnCollect registerNib:[UINib nibWithNibName:@"HBtnCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"custumecell"];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(screen_width/3,120);
    // 设置列的最小间距
    layout.minimumInteritemSpacing = 0;
    // 设置最小行间距
    layout.minimumLineSpacing = 0;
    // 设置布局的内边距
    layout.sectionInset = UIEdgeInsetsMake(0,0,0,0);
    // 滚动方向
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _UserCollect = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, screen_width, 120) collectionViewLayout:layout];
    _UserCollect.backgroundColor = [UIColor whiteColor];
    _UserCollect.dataSource = self;
    _UserCollect.delegate = self;
    [_UserCollect registerNib:[UINib nibWithNibName:@"InvestmenCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"UserCollectCELLID"];
    
    UICollectionViewFlowLayout *couplelayout = [[UICollectionViewFlowLayout alloc]init];
    couplelayout.itemSize = CGSizeMake(screen_width-10,235);
    // 设置列的最小间距
    couplelayout.minimumInteritemSpacing = 0;
    // 设置最小行间距
    couplelayout.minimumLineSpacing = 0;
    // 设置布局的内边距
    couplelayout.sectionInset = UIEdgeInsetsMake(5,6,15,5);
    // 滚动方向
    couplelayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _coupleCollect = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, screen_width, 245) collectionViewLayout:couplelayout];
    _coupleCollect.backgroundColor = [UIColor whiteColor];
    _coupleCollect.dataSource = self;
    _coupleCollect.delegate = self;
    _coupleCollect.bounces = NO;
    _coupleCollect.pagingEnabled = YES;
    _coupleCollect.showsHorizontalScrollIndicator = NO;
    [_coupleCollect registerNib:[UINib nibWithNibName:@"CouplesCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CouplesCollectionViewCell"];
}


#pragma mark - Getter
-(NSMutableArray *)bannerArray
{
    if (!_bannerArray) {
        _bannerArray = [NSMutableArray new];
    }
    return _bannerArray;
}

- (NSMutableArray *)gonggaoArray
{
    if (!_gonggaoArray) {
        _gonggaoArray = [NSMutableArray new];
    }
    return _gonggaoArray;
}

-(NSMutableArray *)xslistArray
{
    if (!_xslistArray) {
        _xslistArray = [NSMutableArray new];
    }
    return _xslistArray;
}

-(NSMutableArray *)jxlistArray
{
    if (!_jxlistArray) {
        _jxlistArray = [NSMutableArray new];
    }
    return _jxlistArray;
}

-(NSMutableArray *)newsArray
{
    if (!_newsArray) {
        _newsArray = [NSMutableArray new];
    }
    return _newsArray;
}

-(NSMutableArray *)investlistArray
{
    if (!_investlistArray) {
        _investlistArray = [NSMutableArray new];
    }
    return _investlistArray;
}

-(NSArray *)sjarr{
    if (!_sjarr) {
        _sjarr = [NSArray array];
        _sjarr = @[
                   @{@"title":@"平台介绍",@"img":@"icon01"},
                   @{@"title":@"运营报告",@"img":@"icon02"},
                   @{@"title":@"风控管理",@"img":@"icon03"},
                   @{@"title":@"邀请好友",@"img":@"icon04"}
                   ];
    }
    return _sjarr;
}

-(NSMutableArray *)investImgArr
{
    if (!_investImgArr) {
        _investImgArr = [[NSMutableArray alloc] initWithArray:@[@"nomber_fir", @"nomber_sec", @"nomber_sth"]];
    }
    return _investImgArr;
}

-(NSArray *)arra{
    if (!_arra) {
        _arra = [NSArray array];
        _arra = @[@"新人专享",
                  @"精选投资",
                  @"昨日投资榜"];
    }
    return _arra;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
