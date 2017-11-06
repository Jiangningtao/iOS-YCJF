//
//  BiaoDetailViewController.m
//  iOS-YCJF
//
//  Created by 姜宁桃 on 2017/8/11.
//  Copyright © 2017年 Yincheng. All rights reserved.
//

#import "BiaoDetailViewController.h"

//#import "xqModel.h"
#import "ItemModel.h"

#import "LoginViewController.h"
#import "investingViewController.h"

#import "QRG_MJRefreshAutoFooter.h"
#import "QRG_MJRefreshNormalHeader.h"

#import "DoubleLabBtn.h"
#import "TopTableViewCell.h"
#import "BiaoBottomTableViewCell.h"
#import "TenderViewTableViewCell.h"
#import "BorrowImgTableViewCell.h"

#define BottomH 50

@interface BiaoDetailViewController ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>
{
    DoubleLabBtn *btn;
    UIScrollView *TwoScrollView;
    UIView * _bgView;
    NSMutableDictionary * _myImageHeightDictionary;
    NSMutableDictionary * _responseObject;
    NSString * _shareAddressUrl;
    NSString * _shareTitle;
    NSString * _shareImg;
    NSString * _shareContent;
    xqModel * _xqModel;
}
@property (nonatomic, strong) UITableView *TopTable;
@property (nonatomic, strong) UITableView * tableView;
/** 投资记录列表 */
@property (nonatomic,strong)UITableView *RecoderTable;
@property (nonatomic, strong) UIWebView * WebView;
/** 标签栏底部的指示器 */
@property (nonatomic, weak) UIView *indicatorView;
/** 当前选择的按钮 */
@property (nonatomic, weak) UIButton *selectedButton;
/** 顶部的标题View */
@property (nonatomic, weak) UIView *titlesView;
/** 投资记录标题数组 */
@property (nonatomic, strong) NSArray *titlesArray;
/** 材料合同标题数组 */
@property (nonatomic, strong) NSArray *titleArr;
/** 头视图标题数据 */
@property (nonatomic, copy)NSArray *HeadTitleArr;
/** 头视图 */
@property (nonatomic,strong)UIView *HeadView;
@property (nonatomic ,strong)NSMutableArray *imgHetongArr;   // 合同
@property (nonatomic, strong) NSMutableArray * imgCailiaoArr;   // 材料
/** table数据 */
@property (nonatomic,strong)NSMutableArray *TableDataArr;
/** table数据 */
@property (nonatomic,strong)NSMutableArray *DataArr;
/***<#注释#> ***/
@property (nonatomic ,strong)NSString *Status;
/***<#注释#> ***/
@property (nonatomic ,strong)NSString *borrw;
/** 视图底部 */
@property (nonatomic,strong)UIView *BottomView;

@property (nonatomic, strong) MineItemModel * Model;
@property (nonatomic, strong) AccinfoModel * accModel;
/***当前页码 ***/
@property (nonatomic ,assign)NSInteger page;

@end

@implementation BiaoDetailViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = @"投资详情";
    [MobClick beginLogPageView:self.title];
    [TalkingData trackPageBegin:self.title];
    self.navigationController.navigationBar.hidden = NO;
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    // bg.png为自己ps出来的想要的背景颜色。
    [navigationBar setBackgroundImage:[UIImage imageWithColor:UIColorHex(3995DF)]
                       forBarPosition:UIBarPositionAny
                           barMetrics:UIBarMetricsDefault];
    [navigationBar setShadowImage:[UIImage new]];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    self.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName:[UIColor whiteColor]};
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:self.title];
    [TalkingData trackPageEnd:self.title];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    self.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName:[UIColor blackColor]};
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.Model = [MineInstance shareInstance].mineModel;
    self.accModel = [MineInstance shareInstance].accModel;
    [self NavBack];
    [self configUI];
    [self loadNewTopics];
    [self.view addSubview:self.BottomView];
}

-(void)NavBack{
     
    UIButton *leftbutton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 10, 21)];
    [leftbutton setBackgroundImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    [leftbutton setBackgroundImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateHighlighted];
    [leftbutton addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftbarbtn=[[UIBarButtonItem alloc]initWithCustomView:leftbutton];
    self.navigationItem.leftBarButtonItem=leftbarbtn;
    
    UIButton *rightbutton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 22)];
    [rightbutton addTarget:self action:@selector(rightbtnclicked) forControlEvents:UIControlEventTouchUpInside];
    [rightbutton setBackgroundImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    [rightbutton setBackgroundImage:[UIImage imageNamed:@"share_click"] forState:UIControlStateHighlighted];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:rightbutton];
}

-(void)loadNewTopics
{
    [MBProgressHUD showActivityMessageInWindow:@"数据加载中"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"sid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"sid"];
    params[@"at"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"at"];
    params[@"version"] = @"v1.0.3";
    params[@"os"] = @"ios";
    params[@"isjihuo"] = @"1";
    params[@"pageSize"] = @"10";
    params[@"pageIndex"] = @"1";
    params[@"share"] = @"q";
    params[@"diyalist"] = @"1";
    params[@"attentionlist"] = @"1";
    params[@"tenderlist"] = @"1";
    params[@"bid"] = self.idstr;
    self.page = 1;
    
//    self.params = params;
    NSLog(@"%@?%@", xqurl, params);
    [manager POST:xqurl parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //        [self.xqmodel removeAllObjects];
        NSLog(@"---%@",responseObject);
        _responseObject = [[NSMutableDictionary alloc] initWithDictionary:responseObject];
        
        NSString * _borrow_contents_url = responseObject[@"item"][@"borrow_contents_url"];
        NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:_borrow_contents_url]];
        [_WebView loadRequest:request];
        
        [self.imgHetongArr removeAllObjects];
        [self.imgCailiaoArr removeAllObjects];
        
        if (responseObject[@"product_hetong"]) {
            NSArray *arr =  NULL_TO_NIL([responseObject objectForKey:@"product_hetong"]);
            if (arr) {
                for (NSDictionary *dicq in arr) {
                    //                [self.imgPhotoarr addObject:dicq[@"fidurl"]];
                    ItemModel *model = [ItemModel new];
                    model.imageUrl = dicq[@"fidurl"];
                    [self.imgHetongArr addObject:model];
                }
            }
        }
        
        if (responseObject[@"product_cailiao"]) {
            NSArray *arr1 = NULL_TO_NIL([responseObject objectForKey:@"product_cailiao"]);
            if (arr1) {
                for (NSDictionary * dict in arr1) {
                    //                [self.imgProjectArr addObject:dict[@"fidurl"]];
                    ItemModel *model = [ItemModel new];
                    model.imageUrl = dict[@"fidurl"];
                    [self.imgCailiaoArr addObject:model];
                }
            }
        }
        
        
        NSLog(@"cout1%@  cout2%@ count %ld, %ld", self.imgHetongArr, self.imgCailiaoArr, self.imgHetongArr.count, self.imgCailiaoArr.count);
        if ([_responseObject[@"item"][@"status"] integerValue] != 1) {
            _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, screen_height-BottomH-64-40)];
            _bgView.backgroundColor = [UIColor whiteColor];
            [_tableView addSubview:_bgView];
            
            UIImageView *imgView = [[UIImageView alloc] init];
            imgView.image = [UIImage imageNamed:@"clht_img"];
            [_bgView addSubview:imgView];
            [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.offset(-40*heightScale);
                make.centerX.offset(0);
            }];
            
            UILabel * lab = [[UILabel alloc] init];
            lab.text = @"为保证借款人身份信息安全，回款中的项目将不再显示借款材料合同！";
            lab.textColor = color(102, 102, 102, 1);
            lab.textAlignment = NSTextAlignmentCenter;
            lab.numberOfLines = 0;
            [_bgView addSubview:lab];
            [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(20);
                make.right.offset(-20);
                make.top.equalTo(imgView.mas_bottom).offset(25*heightScale);
            }];
        }else
        {
            [self.tableView reloadData];
        }
        
        NSLog(@"----投资记录------%@",responseObject[@"tender_list"]);
        NSArray *arr = responseObject[@"tender_list"];
        NSLog(@"%ld", arr.count);
        if ([arr count] > 0) {
            self.TableDataArr = [[NSMutableArray alloc] initWithArray:arr];
            [self.RecoderTable reloadData];
            if (arr.count == 10) {
                self.RecoderTable.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopics)];
            }
        }else{
            UIImageView *imv = [[UIImageView alloc]init];
            imv.image = [UIImage imageNamed:@"pic_zwsj"];
            [self.RecoderTable addSubview:imv];
            [imv mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.offset(0);
                make.centerY.offset(0);
                make.width.offset(155);
                make.height.offset(194);
            }];
            self.RecoderTable.tableFooterView.hidden = YES;
        }

        [self.DataArr removeAllObjects];
        _xqModel = [xqModel mj_objectWithKeyValues:responseObject[@"item"]];
        self.Status = _xqModel.status;
        self.borrw = _xqModel.borrow_account_scale;
        if (_xqModel != nil) {
            [self.DataArr addObject:_xqModel];
        }
        [self.TopTable reloadData];
        
        _shareAddressUrl = responseObject[@"item"][@"share_url"];
        _shareTitle = responseObject[@"item"][@"share_title"];
        _shareContent = responseObject[@"item"][@"share_body"];
        _shareImg = responseObject[@"item"][@"share_img"];

        if ([[NSUserDefaults standardUserDefaults]objectForKey:KAccount]) {
            if ([_xqModel.status intValue]==1&& [_xqModel.borrow_account_scale intValue]<100) {
                btn.text = @"投资购买";
                btn.detailText =[NSString stringWithFormat:@"剩余可投金额 %@元",_xqModel.borrow_account_wait] ;
                [btn addTarget:self action:@selector(selebtnClicked) forControlEvents:UIControlEventTouchUpInside];
                [btn setBackgroundColor:[UIColor redColor]];
                
            }else if ([_xqModel.status intValue]==1&& [_xqModel.borrow_account_scale intValue] >= 100) {
                [btn setTitle:@"已售完" forState:UIControlStateNormal];
                btn.userInteractionEnabled = NO;
                [btn setBackgroundColor:gracolor];
            }else if ([_xqModel.status intValue]==3) {
                [btn setTitle:@"回款中" forState:UIControlStateNormal];
                btn.userInteractionEnabled = NO;
                [btn setBackgroundColor:gracolor];
            }else if ([_xqModel.status intValue]==6) {
                [btn setTitle:@"已完成" forState:UIControlStateNormal];
                btn.userInteractionEnabled = NO;
                [btn setBackgroundColor:gracolor];
            }else  {
                [btn setTitle:@"已撤销" forState:UIControlStateNormal];
                btn.userInteractionEnabled = NO;
                [btn setBackgroundColor:gracolor];
            }
            
        }else{
            [btn setTitle:@"请登陆账号" forState:UIControlStateNormal];
            btn.backgroundColor =[UIColor redColor];
            [btn addTarget:self action:@selector(loginBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        }
        
        [MBProgressHUD hideHUD];
        [self.TopTable.mj_header endRefreshing];//结束刷新
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [self.TopTable.mj_header endRefreshing];//结束刷新
        [MBProgressHUD hideHUD];
    }];
    
}

- (void)loadMoreTopics
{
    self.page++;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"sid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"sid"];
    params[@"at"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"at"];
    params[@"version"] = @"v1.0.3";
    params[@"os"] = @"ios";
    params[@"isjihuo"] = @"1";
    params[@"pageSize"] = @"10";
    params[@"pageIndex" ]=@(self.page);
    params[@"share"] = @"q";
    params[@"diyalist"] = @"1";
    params[@"attentionlist"] = @"1";
    params[@"tenderlist"] = @"1";
    params[@"bid"] = self.idstr;
    
    [WWZShuju initlizedData:xqurl paramsdata:params dicBlick:^(NSDictionary *info) {
        
        NSLog(@"%@", info);
        NSArray *arr = info[@"tender_list"];
        NSLog(@"%ld", arr.count);
        if (arr.count == 0) {
            [self.RecoderTable.mj_footer endRefreshingWithNoMoreData];
        }else
        {
            [self.RecoderTable.mj_footer endRefreshing];
            [self.TableDataArr addObjectsFromArray:arr];
            [self.RecoderTable reloadData];
        }
    }];
}


- (void)configUI
{
    /** 底层view*/
    UIScrollView *mainScrollView = [[UIScrollView alloc] init];
    mainScrollView.scrollEnabled = NO;
    mainScrollView.frame = CGRectMake(0, 0, screen_width, screen_height);
    mainScrollView.contentSize = CGSizeMake(screen_width, screen_height * 2);
    mainScrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    mainScrollView.pagingEnabled = YES;
    mainScrollView.bounces = YES;
    [self.view addSubview:mainScrollView];
    
    [mainScrollView addSubview:self.TopTable];
    //设置UITableView 上拉加载
    _TopTable.mj_footer = [QRG_MJRefreshAutoFooter footerWithRefreshingBlock:^{
        //上拉，执行对应的操作---改变底层滚动视图的滚动到对应位置
        //设置动画效果
        [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
            //            self.scrollV.contentOffset = CGPointMake(0, IPHONE_H);
            [mainScrollView setContentOffset:CGPointMake(0, screen_height)];
            
        } completion:^(BOOL finished) {
            //结束加载
            [_TopTable.mj_footer endRefreshing];
        }];
    }];
    
    /** 第二页面 scrollView*/
    TwoScrollView = [[UIScrollView alloc] init];
    TwoScrollView.frame = CGRectMake(0, screen_height+44 , screen_width, screen_height - 64);
    TwoScrollView.contentSize = CGSizeMake(screen_width * 3, screen_height - 64);
    TwoScrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    TwoScrollView.pagingEnabled = YES;
    TwoScrollView.bounces = NO;
    TwoScrollView.delegate = self;
    
    [mainScrollView addSubview:TwoScrollView];
    
    // 标签栏整体
    UIView * navView = [[UIView alloc] initWithFrame:CGRectMake(0, screen_height-44, screen_width, 44)];
    [mainScrollView addSubview:navView];
    
    UIView *titlesView = [[UIView alloc] init];
    //    titlesView.backgroundColor = MYCOLOR(219, 255, 255);
    titlesView.backgroundColor  = [UIColor whiteColor];
    titlesView.frame = CGRectMake(0, navView.bottom, screen_width, 40);
    [mainScrollView addSubview:titlesView];
    self.titlesView = titlesView;
    
    // 底部的红色指示器
    UIView *indicatorView = [[UIView alloc] init];
    indicatorView.backgroundColor = lancolor;
    indicatorView.height = 2;
    indicatorView.y = titlesView.height - indicatorView.height;
    self.indicatorView = indicatorView;
    
    UIView *bgindicatorView = [[UIView alloc] initWithFrame:(CGRect){0,titlesView.height - indicatorView.height,screen_width,2}];
    bgindicatorView.backgroundColor = [UIColor whiteColor];
    [titlesView addSubview:bgindicatorView];
    
    CGFloat width = titlesView.width / self.titlesArray.count;
    CGFloat height = titlesView.height;
    for (int i = 0; i < self.titlesArray.count; i++) {
        UIButton *button = [[UIButton alloc] init];
        button.height = height;
        button.width = width;
        button.x = i * width;
        button.tag = i+1;
        [button setTitle:self.titlesArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
        [button setTitleColor:lancolor forState:UIControlStateDisabled];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        [titlesView addSubview:button];
        
        if (i == 0) {
            button.enabled = NO;
            self.selectedButton = button;
            
            // 让按钮内部的label根据文字内容来计算尺寸
            [button.titleLabel sizeToFit];
            self.indicatorView.width = button.titleLabel.width;
            self.indicatorView.centerX = button.centerX;
        }
    }
    [titlesView addSubview:indicatorView];
    /** 第二页面 table*/
    [TwoScrollView addSubview:self.WebView];
    [TwoScrollView addSubview:self.tableView];
    [TwoScrollView addSubview:self.RecoderTable];
    
    //设置TwoCollectionView 有下拉操作
    self.WebView.scrollView.mj_header = [QRG_MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //下拉执行对应的操作
        //        self.scrollV.contentOffset = CGPointMake(0,0);
        [UIView animateWithDuration:1 animations:^{
            [mainScrollView setContentOffset:CGPointMake(0, 0)];
            
        }];
        
        //结束加载
        [self.WebView.scrollView.mj_header endRefreshing];
    }];
    //设置TwoCollectionView 有下拉操作
    self.tableView.mj_header = [QRG_MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //下拉执行对应的操作
        //        self.scrollV.contentOffset = CGPointMake(0,0);
        [UIView animateWithDuration:1 animations:^{
            [mainScrollView setContentOffset:CGPointMake(0, 0)];
            
        }];
        
        //结束加载
        [self.tableView.mj_header endRefreshing];
    }];
    self.RecoderTable.mj_header = [QRG_MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //下拉执行对应的操作
        //        self.scrollV.contentOffset = CGPointMake(0,0);
        [UIView animateWithDuration:1 animations:^{
            [mainScrollView setContentOffset:CGPointMake(0, 0)];
            
        }];
        
        //结束加载
        [self.RecoderTable.mj_header endRefreshing];
    }];
    
}

-(void)loginBtnClicked{
    LoginViewController *sv = [[LoginViewController alloc]init];
    sv.isTurnToTabVC = @"YES";
    [self showViewController:sv sender:nil];
}

-(void)selebtnClicked{

    if ([[UserDefaults objectForKey:KAccount] isEqualToString:@"15267065901"] || [[UserDefaults objectForKey:KAccount] isEqualToString:@"13516779834"] || [[UserDefaults objectForKey:KAccount] isEqualToString:@"18857810390"] || [[UserDefaults objectForKey:KAccount] isEqualToString:@"18365208214"] || [[UserDefaults objectForKey:KAccount] isEqualToString:@"18903856251"]) {
        // 购买
        investingViewController *ssc = [[investingViewController alloc]init];
        ssc.shareAddress = _shareAddressUrl;
        ssc.bid = self.idstr;
        ssc.model = _xqModel;
        ssc.borrow_account_wait = _xqModel.borrow_account_wait;
        ssc.borrow_apr = _xqModel.borrow_apr;
        ssc.borrow_period = _xqModel.v_borrow_period;
        [self.navigationController pushViewController:ssc animated:YES];
    }else
    {
        NSLog(@"%@---%@", _xqModel.isxs, self.Model.ifxs);
        if ([_xqModel.isxs integerValue] == 1 && [[UserDefaults objectForKey:KIs_xs] integerValue] == 0) {
            [self showTipView:@"您是老用户了，无法购买此标！"];
        }else
        {
            // 购买
            investingViewController *ssc = [[investingViewController alloc]init];
            ssc.shareAddress = _shareAddressUrl;
            ssc.bid = self.idstr;
            ssc.model = _xqModel;
            ssc.borrow_account_wait = _xqModel.borrow_account_wait;
            ssc.borrow_apr = _xqModel.borrow_apr;
            ssc.borrow_period = _xqModel.v_borrow_period;
            [self.navigationController pushViewController:ssc animated:YES];
        }
    }
    
}

/**
 *  按钮点击
 */
- (void)titleClick:(UIButton *)button {
    // 修改按钮状态
    self.selectedButton.enabled = YES;
    button.enabled = NO;
    self.selectedButton = button;
    
    NSUInteger index = [self.titlesArray indexOfObject:button.titleLabel.text];
    // 让底部的内容scrollView滚动到对应位置
    [TwoScrollView setContentOffset:CGPointMake(index * screen_width, TwoScrollView.contentOffset.y) animated:YES];
    [UIView animateWithDuration:0.25 animations:^{
        self.indicatorView.width = button.titleLabel.width;
        self.indicatorView.centerX = button.centerX;
    }];
}

-(void)rightbtnclicked{
    _shareContent = [_shareContent stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    _shareContent = [_shareContent stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    [ShareManager shareWithTitle:_shareTitle Content:_shareContent ImageName:@"share_ycjf" Url:_shareAddressUrl];
}


#pragma mark---scrollview代理方法
/**
 * 手指松开scrollView后，scrollView停止减速完毕就会调用这个
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    CGFloat offsetX = TwoScrollView.contentOffset.x;
    //    EJLLog(@"%f",offsetX);
    // 当前位置需要显示的控制器的索引
    NSInteger index = offsetX / screen_width;
    
    // 选中滚动结束的按钮
    UIButton *btn1 = [self.titlesView viewWithTag:1];
    UIButton *btn2 = [self.titlesView viewWithTag:2];
    UIButton *btn3 = [self.titlesView viewWithTag:3];
    NSArray *btnArr = @[btn1,btn2,btn3];
    UIButton *titleButton = btnArr[index];
    if (titleButton == self.selectedButton) {
        return;
    }
    [self titleClick:titleButton];
}

#pragma mark - UITableViewDelegate
#pragma mark---------tableDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.TopTable) {
        if (indexPath.section == 0) {
            return 360*heightScale;
        }else if (indexPath.section ==1){
            return 160;
        }
    }else if (tableView == self.RecoderTable)
    {
        return 46;
    }else if (tableView == self.tableView)
    {
        ItemModel * model;
        if (indexPath.section == 0) {
            model = self.imgCailiaoArr[indexPath.row];
        }else
        {
            model = self.imgHetongArr[indexPath.row];
        }
        
        NSLog(@"xxxxxx   %f", [_myImageHeightDictionary[model.imageUrl] floatValue]);
        return [_myImageHeightDictionary[model.imageUrl] floatValue]?[_myImageHeightDictionary[model.imageUrl] floatValue]:570*heightScale;
    }
    
    return 30;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        if (section == 0) {
            return self.imgCailiaoArr.count;
        }else if (section == 1){
            return self.imgHetongArr.count;
        }
    }
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.TopTable || tableView == self.tableView) {
        return 2;
    }else if (tableView == self.RecoderTable)
    {
        return self.TableDataArr.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.TopTable) {
        if (indexPath.section == 0) {
            TopTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TopTableViewCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (self.DataArr.count > 0) {
                cell.model = self.DataArr[0];
            }
            return  cell;
        }else if (indexPath.section ==1){
            BiaoBottomTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"BiaoBottomTableViewCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (self.DataArr.count > 0) {
                cell.model = self.DataArr[0];
            }
            return  cell;
        }
    }else if (tableView == self.RecoderTable)
    {
        TenderViewTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TenderViewTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.Tender_CountLab.text = self.TableDataArr[indexPath.section][@"account"];
        cell.Tender_UserLab.text = self.TableDataArr[indexPath.section][@"mobile_h"];
        cell.Tender_DateLab.text = self.TableDataArr[indexPath.section][@"time_h"];
        return cell;
    }else if (tableView == self.tableView)
    {
        BorrowImgTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"BorrowImgTableViewCell"];
        ItemModel * model;
        if (indexPath.section == 0) {
            model = self.imgCailiaoArr[indexPath.row];
        }else
        {
            model = self.imgHetongArr[indexPath.row];
        }
        NSString *imgUrlString = model.imageUrl;
        
        cell.myImgView.contentMode = UIViewContentModeScaleToFill;
            [cell.myImgView sd_setImageWithURL:[NSURL URLWithString:imgUrlString]];  
        [cell.myImgView sd_setImageWithURL:[NSURL URLWithString:imgUrlString] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            CGFloat itemH = image.size.height / image.size.width * screen_width-20;
            [_myImageHeightDictionary setObject:[NSString stringWithFormat:@"%f",itemH] forKey:imgUrlString];
        }];
        
        return cell;
    }
   
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        return 40;
    }
    return 0.0000000001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0000000001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        UIView *v = [[UIView alloc]initWithFrame:self.view.frame];
        v.backgroundColor = [UIColor whiteColor];
        UIButton *xsbbtn = [[UIButton alloc]init];
        [xsbbtn setTitle:self.titleArr[section] forState:UIControlStateNormal];
        [xsbbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        xsbbtn.backgroundColor = [UIColor whiteColor];
        [v addSubview:xsbbtn];
        [xsbbtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.offset(0);
            make.left.offset(19);
        }];
        UIView *vq = [[UIView alloc]initWithFrame:CGRectMake(0, 39, v.frame.size.width, 1)];
        vq.backgroundColor = grcolor;
        [v addSubview:vq];
        return v;
    }
    return nil;
}


#pragma mark - Getter
-(UITableView *)TopTable
{
    if (!_TopTable) {
        _TopTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screen_width, screen_height-BottomH) style:UITableViewStyleGrouped];
        [_TopTable registerNib:[UINib nibWithNibName:@"TopTableViewCell" bundle:nil] forCellReuseIdentifier:@"TopTableViewCell"];
        [_TopTable registerNib:[UINib nibWithNibName:@"BiaoBottomTableViewCell" bundle:nil] forCellReuseIdentifier:@"BiaoBottomTableViewCell"];
        _TopTable.separatorColor = color(57, 148, 222, 1);
        _TopTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _TopTable.delegate = self;
        _TopTable.dataSource = self;
        _TopTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopics)];
        _TopTable.mj_header.automaticallyChangeAlpha = YES;//自动改变透明度
    }
    return _TopTable;
}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(screen_width, 0, screen_width, screen_height-BottomH-104) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:@"BorrowImgTableViewCell" bundle:nil] forCellReuseIdentifier:@"BorrowImgTableViewCell"];
        _tableView.tableFooterView = [self configFootView];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (UIView *)configFootView
{
    UIView * footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 120)];
    UIImageView * imgV = [UIImageView imageViewWithFrame:CGRectMake(0, 0, screen_width, 80) image:@"footer"];
    [footView addSubview:imgV];
    UILabel * lab = [UILabel new];
    lab.text = @" 投资有风险 理财需谨慎";
    lab.textAlignment = NSTextAlignmentCenter;
    lab.textColor = [UIColor colorWithRed:195/255.0 green:195/255.0 blue:195/255.0 alpha:1/1.0];
    lab.font = [UIFont systemFontOfSize:12];
    [footView addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgV.mas_bottom).offset(10);
        make.centerX.offset(0);
    }];
    UIImageView * gV = [[UIImageView alloc] initWithImage:IMAGE_NAMED(@"Group 6")];
    [footView addSubview:gV];
    [gV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(lab.mas_left).offset(-2);
        make.centerY.equalTo(lab.mas_centerY).offset(0);
        make.width.height.offset(12);
    }];
    return footView;
}

-(UITableView *)RecoderTable{
    if (!_RecoderTable) {
        _RecoderTable = [[UITableView alloc]initWithFrame:CGRectMake(screen_width*2, 0,screen_width, screen_height-BottomH-104) style:UITableViewStyleGrouped];
        _RecoderTable.dataSource = self;
        _RecoderTable.delegate = self;
        [_RecoderTable registerNib:[UINib nibWithNibName:@"TenderViewTableViewCell" bundle:nil] forCellReuseIdentifier:@"TenderViewTableViewCell"];
        _RecoderTable.showsVerticalScrollIndicator = NO;
        _RecoderTable.backgroundColor = self.view.backgroundColor;
        _RecoderTable.tableHeaderView = self.HeadView;
        _RecoderTable.tableFooterView = [[CommonBottomView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 40)];
    }
    return _RecoderTable;
}

-(NSArray *)HeadTitleArr{
    if (!_HeadTitleArr) {
        _HeadTitleArr = @[@"投资金额",@"投资人",@"投资时间"];
    }
    return _HeadTitleArr;
}

-(UIView *)HeadView{
    if (!_HeadView) {
        _HeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screen_width, 40)];
        _HeadView.backgroundColor = self.view.backgroundColor;
        
        UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screen_width, 40)];
        whiteView.backgroundColor = [UIColor whiteColor];
        [_HeadView addSubview:whiteView];
        
        CGFloat labMargin = 8;
        CGFloat SingleLabMargin = 5;
        CGFloat SingleLabWidth = (screen_width-(2*labMargin)-(2*SingleLabMargin))/3;
        for (NSInteger i = 0; i<3; i++) {
            UILabel *lab = [[UILabel alloc]init];
            lab.backgroundColor = [UIColor clearColor];
            lab.textColor = [UIColor darkTextColor];
            if (i==0) {
                lab.textAlignment = NSTextAlignmentLeft;
            }else if (i==1){
                lab.textAlignment = NSTextAlignmentCenter;
            }else if (i==2){
                lab.textAlignment = NSTextAlignmentRight;
            }
            lab.font = [UIFont systemFontOfSize:15];
            lab.numberOfLines = 0;
            lab.text = self.HeadTitleArr[i];
            [whiteView addSubview:lab];
            [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(whiteView.mas_centerY);
                make.height.offset(30);
                make.left.equalTo(whiteView.mas_left).offset(labMargin+(i*(SingleLabMargin+SingleLabWidth)));
                make.width.offset(SingleLabWidth);
            }];
        }
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(whiteView.frame)-.6, screen_width, .6)];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [_HeadView addSubview:lineView];
        
    }
    return _HeadView;
}


-(UIWebView *)WebView
{
    if (!_WebView) {
        _WebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, screen_width, screen_height-BottomH-64)];
        _WebView.scrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        // 添加额外的滚动附近区域的内容
        _WebView.scrollView.contentInset = UIEdgeInsetsMake(160, 0, 40, 0);
        // 在webView上添加一个imgView 在 imgView上添加一个label
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jieshao_img"]];
        imgView.frame = CGRectMake(0, -160, _WebView.frame.size.width, 160);
        [_WebView.scrollView addSubview:imgView];
    }
    return _WebView;
}

/**
 *  标题数组
 */
- (NSArray *)titlesArray {
    if (!_titlesArray) {
        self.titlesArray = @[@"项目详情", @"材料合同", @"投资记录"];
    }
    return _titlesArray;
}
- (NSArray *)titleArr {
    if (!_titleArr) {
        _titleArr = @[@"项目材料", @"项目合同"];
    }
    return _titleArr;
}

-(NSMutableArray *)imgHetongArr{
    if (!_imgHetongArr) {
        _imgHetongArr =[[NSMutableArray alloc] init];
    }
    return _imgHetongArr;
}

-(NSMutableArray *)imgCailiaoArr
{
    if (!_imgCailiaoArr) {
        _imgCailiaoArr =[[NSMutableArray alloc] init];
    }
    return _imgCailiaoArr;
}

-(NSMutableArray *)DataArr
{
    if (!_DataArr) {
        _DataArr = [[NSMutableArray alloc] init];
    }
    return _DataArr;
}

-(UIView *)BottomView{
    if (!_BottomView) {
        _BottomView = [[UIView alloc]initWithFrame:CGRectMake(0, screen_height-BottomH-64, screen_width, BottomH)];
        _BottomView.backgroundColor = [UIColor whiteColor];
        btn = [[DoubleLabBtn alloc]initWithFrame:CGRectMake(15, 5, screen_width-30, BottomH-10)];
        [btn setTitleColor:[UIColor whiteColor] forState:0];
        btn.backgroundColor = color(217, 217, 217, 1);
        btn.layer.cornerRadius = 5.0;
        
        
        [_BottomView addSubview:btn];
    }
    return _BottomView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
