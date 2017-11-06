//
//  DoubleElevenViewController.m
//  iOS-YCJF
//
//  Created by 姜宁桃 on 2017/10/25.
//  Copyright © 2017年 Yincheng. All rights reserved.
//

#import "DoubleElevenViewController.h"
#import "DoubleElevenTableViewCell.h"
#import "ssyTenderModel.h"
#import "SsyGiftView.h"
#import "SsyRuleView.h"
#import "ShareManager.h"
#import "ssyInfoModel.h"

@interface DoubleElevenViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UIScrollView * _bgScrollView;
    UIImageView * _bgImgV;
    UITableView * _tableView;
    UIImageView * _giftImgV;
    UIImageView * _defaultImgV;
    
    UIImageView * _headImgV; // 头像
    UILabel * _userLab; // 用户帐号（*）
    UIButton * _activityRuleBtn;   // 活动规则
    UIButton * _loginBtn;
    
    UIImageView * _rankingImgV; // 排名背景图
    UILabel * _rankingLab;  // 排名
    UILabel * _rankingDescriptionLab;  // 排名描述
    
    UILabel * _prospEarningsLab;    // 预期收益
    UILabel * _prospTitleLab;   // 预期收益（标题）
    UILabel * _investmentLab;    // 年化投资额
    UILabel * _investmentTitleLab;   // 年化投资额（标题）
    
    ssyInfoModel * ssyModel; // 消息模型
}
@property (nonatomic, strong) NSMutableArray * dataSource;

@property (nonatomic, strong) UIButton * investNowBtn; // 立即投资按钮

@end

@implementation DoubleElevenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"双11争冠夺壕礼";
    [self configUI];
    
}

#pragma mark - Help Hander
- (void)configUI
{
    [self NavBack];
    
    _bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, screen_width, screen_height-64)];
    _bgScrollView.mj_header.automaticallyChangeAlpha = YES;//自动改变透明度
    _bgScrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopics)];
    [self.view addSubview:_bgScrollView];
    
    _bgImgV = [[UIImageView alloc] initWithFrame:_bgScrollView.bounds];
    _bgImgV.image = IMAGE_NAMED(@"backR_img");
    [_bgScrollView addSubview:_bgImgV];
    
    _headImgV = [UIImageView new];
    _headImgV.radius = 12;
    _headImgV.image = IMAGE_NAMED(@"default_tx");
    [_bgScrollView addSubview:_headImgV];
    [_headImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.offset(15);
        make.width.height.offset(24);
    }];
    
    _userLab = [UILabel new];
    _userLab.textColor = KWhiteColor;
    _userLab.font = systemFont(14);
    _userLab.text = @"暂未登录";
    [_bgScrollView addSubview:_userLab];
    [_userLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headImgV.mas_right).offset(5);
        make.centerY.equalTo(_headImgV.mas_centerY).offset(0);
    }];
    
    _activityRuleBtn = [UIButton buttonWithFrame:CGRectMake(screen_width-85, 15, 75, 24) title:@"活动规则" image:@"" target:self action:@selector(ActivityRuleBtnEvent)];
    _activityRuleBtn.titleLabel.font = systemFont(12);
    [_activityRuleBtn setTitleColor:color(49,70,215, 1) forState:UIControlStateNormal];
    [_activityRuleBtn setBackgroundColor:KWhiteColor];
    _activityRuleBtn.radius = 12;
    [_bgScrollView addSubview:_activityRuleBtn];
    
    _giftImgV = [[UIImageView alloc] initWithImage:IMAGE_NAMED(@"icon_gift")];
    [_bgScrollView addSubview:_giftImgV];
    [_giftImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_activityRuleBtn.mas_bottom).offset(15);
        make.left.equalTo(_activityRuleBtn.mas_left).offset(20);
        make.width.offset(40);
        make.height.offset(44);
    }];
    [self addGiftAnimation];
    [_giftImgV tapGesture:^(UIGestureRecognizer *ges) {
        
        SsyGiftView * activityView = [[SsyGiftView alloc] initWithFrame:screen_bounds];
        [self.view.window addSubview:activityView];
    }];
    
    [_bgScrollView addSubview:[self configTableHeadView]];
    if ([UserDefaults objectForKey:@"uid"]) {
        _rankingImgV = [UIImageView new];
        _rankingImgV.image = IMAGE_NAMED(@"top_no");
        [_bgScrollView addSubview:_rankingImgV];
        [_rankingImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.offset(0);
            make.top.offset(54);
            make.width.offset(84.5);
            make.height.offset(84.5);
        }];
        
        _rankingLab = [UILabel new];
        _rankingLab.textColor = color(254, 67, 48, 1);
        _rankingLab.font = systemFont(24);
        [_rankingImgV addSubview:_rankingLab];
        [_rankingLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_rankingImgV).offset(0);
            make.top.offset(25);
        }];
        
        _rankingDescriptionLab = [UILabel new];
        _rankingDescriptionLab.textColor = KWhiteColor;
        _rankingDescriptionLab.font = systemFont(12);
        _rankingDescriptionLab.textAlignment = NSTextAlignmentCenter;
        [_bgScrollView addSubview:_rankingDescriptionLab];
        [_rankingDescriptionLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_rankingImgV.mas_bottom).offset(7);
            make.centerX.offset(0);
        }];
        
        _prospTitleLab = [UILabel new];
        _prospTitleLab.textColor = KWhiteColor;
        _prospTitleLab.font = systemFont(12);
        _prospTitleLab.text = @"预期收益(元)";
        _prospTitleLab.textAlignment = NSTextAlignmentCenter;
        [_bgScrollView addSubview:_prospTitleLab];
        [_prospTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_rankingDescriptionLab.mas_bottom).offset(56);
            make.left.offset(60);
        }];
        
        _prospEarningsLab = [UILabel new];
        _prospEarningsLab.textColor = KWhiteColor;
        _prospEarningsLab.font = boldSystemFont(18);//systemFont(18);
        _prospEarningsLab.textAlignment = NSTextAlignmentCenter;
        [_bgScrollView addSubview:_prospEarningsLab];
        [_prospEarningsLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_prospTitleLab.mas_top).offset(-8);
            make.centerX.equalTo(_prospTitleLab.mas_centerX).offset(0);
        }];
        
        _investmentTitleLab = [UILabel new];
        _investmentTitleLab.textColor = KWhiteColor;
        _investmentTitleLab.font = systemFont(12);
        _investmentTitleLab.text = @"年化投资额(元)";
        _investmentTitleLab.textAlignment = NSTextAlignmentCenter;
        [_bgScrollView addSubview:_investmentTitleLab];
        [_investmentTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_rankingDescriptionLab.mas_bottom).offset(56);
            make.right.equalTo(_activityRuleBtn.mas_right).offset(-44);
        }];
        
        _investmentLab = [UILabel new];
        _investmentLab.textColor = KWhiteColor;
        _investmentLab.font = boldSystemFont(18);//systemFont(18);
        _investmentLab.textAlignment = NSTextAlignmentCenter;
        [_bgScrollView addSubview:_investmentLab];
        [_investmentLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_investmentTitleLab.mas_top).offset(-8);
            make.centerX.equalTo(_investmentTitleLab.mas_centerX).offset(0);
        }];
        
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 253+40, _bgScrollView.width-20, _bgScrollView.height-343) style:UITableViewStyleGrouped];
    }else
    {
        
        _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loginBtn setTitle:@"立即登录" forState:UIControlStateNormal];
        _loginBtn.titleLabel.font = systemFont(14);
        _loginBtn.radius = 2;
        [_loginBtn setTitleColor:color(49,70,215, 1) forState:UIControlStateNormal];
        [_loginBtn setBackgroundColor:KWhiteColor];
        [_loginBtn addTarget:self action:@selector(loginBtnEvnet) forControlEvents:UIControlEventTouchUpInside];
        [_bgScrollView addSubview:_loginBtn];
        [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.offset(0);
            make.top.offset(60);
            make.width.offset(164);
            make.height.offset(30);
        }];
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 120+40, _bgScrollView.width-20, _bgScrollView.height-170-44) style:UITableViewStyleGrouped];
    }
    
    [self.view addSubview:self.investNowBtn];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.bounces = NO;
    _tableView.separatorColor = color(240, 240, 240, 1);
    _tableView.backgroundColor = KWhiteColor;
    [_tableView registerNib:[UINib nibWithNibName:@"DoubleElevenTableViewCell" bundle:nil] forCellReuseIdentifier:@"DoubleElevenTableViewCell"];
    [_bgScrollView addSubview:_tableView];
    
    _defaultImgV = [[UIImageView alloc] initWithImage:IMAGE_NAMED(@"data_no")];
    _defaultImgV.contentMode = UIViewContentModeScaleAspectFit;
    [_tableView addSubview:_defaultImgV];
    _defaultImgV.hidden = YES;
    [_defaultImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_tableView.mas_centerX).offset(0);
        make.top.equalTo(_tableView.mas_top).offset(50);
        if (_tableView.height-50>=320) {
            make.height.offset(320);
        }else
        {
            make.height.offset(_tableView.height-50);
        }
    }];
    
    [self loadNewTopics];  // 获取数据
}

-(void)NavBack{
    UIButton *leftbutton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 10, 21)];
    
    [leftbutton setBackgroundImage:[UIImage imageNamed:@"icon_back1"] forState:UIControlStateNormal];
    [leftbutton setBackgroundImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateHighlighted];
    [leftbutton addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftbarbtn=[[UIBarButtonItem alloc]initWithCustomView:leftbutton];
    self.navigationItem.leftBarButtonItem=leftbarbtn;
    
    [self rightBarBtnImgN:@"icon_share" act:@selector(shareBtnEvent)];
}

- (UIView *)configTableHeadView
{
    UIView * tableHeadView = [[UIView alloc] initWithFrame:CGRectMake(10, [UserDefaults objectForKey:@"uid"]?253:120, screen_width-20, 44)];
    tableHeadView.radius=4;
    tableHeadView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UILabel * _pmLab = [UILabel new];
    _pmLab.text = @"排名";
    _pmLab.textColor = color(69, 52, 219, 1);
    _pmLab.font = systemFont(12);
    [tableHeadView addSubview:_pmLab];
    [_pmLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.centerY.offset(0);
    }];
    
    UILabel * _yhLab = [UILabel new];
    _yhLab.text = @"用户名称";
    _yhLab.textColor = color(69, 52, 219, 1);
    _yhLab.font = systemFont(12);
    [tableHeadView addSubview:_yhLab];
    [_yhLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_pmLab.mas_right).offset(40*widthScale);
        make.centerY.offset(0);
    }];
    
    UILabel * _jpLab = [UILabel new];
    _jpLab.text = @"奖品";
    _jpLab.textColor = color(69, 52, 219, 1);
    _jpLab.font = systemFont(12);
    [tableHeadView addSubview:_jpLab];
    [_jpLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_yhLab.mas_right).offset(48*widthScale);
        make.centerY.offset(0);
    }];
    
    UILabel * _nhLab = [UILabel new];
    _nhLab.text = @"年化投资额(元)";
    _nhLab.textColor = color(69, 52, 219, 1);
    _nhLab.font = systemFont(12);
    [tableHeadView addSubview:_nhLab];
    [_nhLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-10);
        make.centerY.offset(0);
    }];
    
    return tableHeadView;
}

#pragma mark - Event hander
- (void)backClick:(UIButton *)button {
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)shareBtnEvent
{
    [ShareManager shareWithTitle:ssyModel.share_title Content:ssyModel.share_content ImageName:@"share_ycjf" Url:ssyModel.share_url];
}

- (void)ActivityRuleBtnEvent
{
    SsyRuleView * ruleView = [[SsyRuleView alloc] initWithFrame:screen_bounds];
    ruleView.url = ssyModel.rule;
    [self.view.window addSubview:ruleView];
}

- (void)loginBtnEvnet
{
    LoginViewController * vc = [[LoginViewController alloc] init];
    vc.isTurnToTabVC= @"YES";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)investNowBtnEvnet
{
    [self.navigationController popViewControllerAnimated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        KPostNotification(KNotificationTabSelectInvest, nil);
    });
}

- (void)addGiftAnimation
{
    CGPoint originalPoint = _giftImgV.center;
    [UIView animateKeyframesWithDuration:0.5 delay:0.2 options:UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse | UIViewAnimationOptionAllowUserInteraction animations:^{
        CGPoint lastPoint = CGPointMake(originalPoint.x, originalPoint.y + 5);
        _giftImgV.transform = CGAffineTransformMakeScale(1.2, 1);
        _giftImgV.center = lastPoint;
    } completion:nil];
}

#pragma mark - Network
- (void)loadNewTopics
{
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    params[@"uid"] = [UserDefaults objectForKey:@"uid"]?[UserDefaults objectForKey:@"uid"]:@"";
    NSLog(@"%@?uid=%@", ssyactivityurl, params[@"uid"]);
    [WWZShuju initlizedData:ssyactivityurl paramsdata:params dicBlick:^(NSDictionary *info) {
        NSLog(@"%@", info);
        [_bgScrollView.mj_header endRefreshing];
        [self.dataSource removeAllObjects];
        
        ssyModel = [[ssyInfoModel alloc] initWithDictionary:info error:nil];
        NSLog(@"%@", ssyModel);
        
        for (NSDictionary * dict in info[@"list"]) {
            ssyTenderModel * model = [[ssyTenderModel alloc] initWithDictionary:dict error:nil];
            [self.dataSource addObject:model];
        }
        
        if (![UserDefaults objectForKey:@"uid"]) {
            _userLab.text = @"暂未登录";
            _headImgV.image = IMAGE_NAMED(@"default_tx");
        }else
        {
            _userLab.text = info[@"mobile"];
            [_headImgV sd_setImageWithURL:[NSURL URLWithString:ssyModel.headpture] placeholderImage:IMAGE_NAMED(@"default_tx")];
        }
        if ([ssyModel.ranking isEqualToString:@"未上榜"]) {
            _rankingImgV.image = IMAGE_NAMED(@"top_no");
            _rankingDescriptionLab.text = ssyModel.gap;
            _prospEarningsLab.text = ssyModel.yqsy;
            _investmentLab.text = ssyModel.tender_money;
        }else{
            _rankingImgV.image = IMAGE_NAMED(@"top_yes");
            _rankingLab.text = ssyModel.ranking;
            _rankingDescriptionLab.text = ssyModel.gap;
            _prospEarningsLab.text = ssyModel.yqsy;
            _investmentLab.text = ssyModel.tender_money;
        }
    
        if (self.dataSource.count == 0) {
            _defaultImgV.hidden = NO;
        }else
        {
            _defaultImgV.hidden = YES;
        }
        [_tableView reloadData];
    }];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DoubleElevenTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DoubleElevenTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ssyTenderModel * model = self.dataSource[indexPath.section];
    
    NSArray * topImgArr = @[@"icon_top01", @"icon_top02", @"icon_top03"];
    if (indexPath.section < 3) {
        cell.rankingBgImgV.image = IMAGE_NAMED(topImgArr[indexPath.section]);
        cell.rankingLab.hidden = YES;
    }else
    {
        cell.rankingLab.hidden = NO;
        cell.rankingBgImgV.image = IMAGE_NAMED(@"icon_top05");
        cell.rankingLab.text = [model.nmb integerValue]>=10?model.nmb:[NSString stringWithFormat:@" %@", model.nmb];
    }
    cell.telNumLab.text = model.mobile;
    cell.prizeLab.text = model.name;
    cell.investmentLab.text = model.tender_sum;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //return 50;
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.000001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.00001;
}

#pragma mark - Getter
-(UIButton *)investNowBtn
{
    if (!_investNowBtn) {
        _investNowBtn = [UIButton new];
        [_investNowBtn setBackgroundImage:IMAGE_NAMED(@"btn_touzi") forState:UIControlStateNormal];
        [_investNowBtn setBackgroundImage:IMAGE_NAMED(@"btn_touzi02") forState:UIControlStateSelected];
        _investNowBtn.frame = CGRectMake(0, screen_height-50, screen_width, 50);
        [_investNowBtn setTitle:@"立即投资" forState:UIControlStateNormal];
        [_investNowBtn addTarget:self action:@selector(investNowBtnEvnet) forControlEvents:UIControlEventTouchUpInside];
        _investNowBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:18];
        [_investNowBtn setTitleColor:KWhiteColor forState:UIControlStateNormal];
    }
    return _investNowBtn;
}

-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
