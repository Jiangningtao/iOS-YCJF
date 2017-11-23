//
//  NewAutoTenderViewController.m
//  iOS-YCJF
//
//  Created by 姜宁桃 on 2017/11/21.
//  Copyright © 2017年 Yincheng. All rights reserved.
//

#import "NewAutoTenderViewController.h"
#import "AutoTenderModel.h"
#import "AutoTenderTableView.h"
#import "MonthPickerView.h"
#import "AprPickerView.h"

@interface NewAutoTenderViewController ()<TableViewSelectedEvent, MonthPickeDelegate, AprPickeDelegate>
{
    AutoTenderModel * _tenderModel;
    BOOL _isEditing;
    
    UILabel * _rankLab; // 当前排名
    UISwitch * _swithView; // 开关
    UIButton * _bottomBtn; // 底部的修改、保存按钮
}
@property (nonatomic, strong) AutoTenderTableView * tableView;

@property (nonatomic, strong) MonthPickerView * monthPickerView; // 期限选择器
@property (nonatomic, strong) AprPickerView * aprPickerView; // 预期收益率选择器

@end

@implementation NewAutoTenderViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = @"自动投标";
    [MobClick beginLogPageView:self.title];
    [TalkingData trackPageBegin:self.title];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:self.title];
    [TalkingData trackPageEnd:self.title];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configUI];
    [self Network];
}

- (void)configUI
{
    [self NavBack];
    [self rightBarBtn:@"规则说明" act:@selector(ruleDescriptionEvent)];
    self.backImageView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = grcolor;
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:[self configFooterView]];
    
    kWeakSelf(self)
    self.tableView.textChangeBlock = ^(NSString *text) {
        NSLog(@"单标最高金额：%@", text);
        _tenderModel.money = text;
        [weakself setPickerDatas];
    };
}

- (UIView *)configTableHeaderView
{
    UIView * _tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 60)];
    UIView * _topLineV = [[UIView alloc] initWithFrame:CGRectMake(0, 10, screen_width, 0.5)];
    _topLineV.backgroundColor = grcolor;
    [_tableHeaderView addSubview:_topLineV];
    
    UIView * _bottomLineV = [[UIView alloc] initWithFrame:CGRectMake(0, 60, screen_width, 0.5)];
    _bottomLineV.backgroundColor = grcolor;
    [_tableHeaderView addSubview:_bottomLineV];
    
    UIView * _contentV = [[UIView alloc] init];
    _contentV.backgroundColor = KWhiteColor;
    [_tableHeaderView addSubview:_contentV];
    [_contentV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(_topLineV.mas_bottom).offset(0);
        make.bottom.equalTo(_bottomLineV.mas_top).offset(0);
    }];
    
    UILabel * _titleLab = [[UILabel alloc] init];
    _titleLab.text = @"自动投标";
    [_contentV addSubview:_titleLab];
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.centerY.equalTo(_contentV.mas_centerY);
    }];
    
    _rankLab = [[UILabel alloc] init];
    _rankLab.font = systemFont(14);
    _rankLab.textColor = [UIColor darkGrayColor];
    [_contentV addSubview:_rankLab];
    [_rankLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLab.mas_right).offset(5);
        make.centerY.equalTo(_contentV.mas_centerY);
    }];
    
    _swithView = [[UISwitch alloc] init];
    [_swithView addTarget:self action:@selector(SwitchClicked:) forControlEvents:UIControlEventValueChanged];
    [_contentV addSubview:_swithView];
    [_swithView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.centerY.equalTo(_contentV.mas_centerY);
    }];
    
    return _tableHeaderView;
}

- (UIView *)configFooterView
{
    UIView * _footerV = [[UIView alloc] initWithFrame:CGRectMake(0, screen_height-WTTab_Bar_Height, screen_width, WTTab_Bar_Height)];
    _footerV.backgroundColor = KWhiteColor;
    
    _bottomBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 5, screen_width-30, 40)];
    [_bottomBtn setTitle:@"修改参数设置" forState:UIControlStateNormal];
    _bottomBtn.radius = 5;
    [_bottomBtn addTarget:self action:@selector(updateParamsEvent:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomBtn setTitleColor:blue_color forState:UIControlStateNormal];
    [_bottomBtn setBackgroundColor:KWhiteColor];
    [_footerV addSubview:_bottomBtn];
    
    return _footerV;
}

#pragma mark - NetWork
// 获取设置的数据
- (void)Network
{
    NSMutableDictionary *pramas = [NSMutableDictionary dictionaryWithDictionary:self.paramsBase];
    pramas[@"uid"] = Get_uid_value;
    pramas[@"sid"] = Get_sid_value;
    
    NSLog(@"%@", [self JointUrlAddressWithUrl:tbxxrl parameter:pramas]);
    [WWZShuju initlizedData:tbxxrl paramsdata:pramas dicBlick:^(NSDictionary *info) {
        NSLog(@"%@", info);
        _tenderModel = [[AutoTenderModel alloc] initWithDictionary:info[@"item"] error:nil];
        // 设置开关
        if ([_tenderModel.isjihuo integerValue] == 0) {
            [_swithView setOn:NO animated:YES];
            _rankLab.text = @"未开启";
            _rankLab.textColor = [UIColor colorWithRed:253/255.0 green:128/255.0 blue:46/255.0 alpha:1/1.0];
        }else{
            [_swithView setOn:YES animated:YES];
            // 当前排名：curseq
            _rankLab.text = [NSString stringWithFormat:@"当前排名%@位", _tenderModel.curseq];
            NSMutableAttributedString *rankStr = [[NSMutableAttributedString alloc]initWithString:_rankLab.text];
            [rankStr addAttribute:NSForegroundColorAttributeName
                               value: [UIColor colorWithRed:253/255.0 green:128/255.0 blue:46/255.0 alpha:1/1.0]
                               range:NSMakeRange(4, _tenderModel.curseq.length)];
            _rankLab.attributedText = rankStr;
        }
        
        [self dealWithNetworkData];
        
    }];
}

- (void)dealWithNetworkData
{
    if (!_tenderModel.timelimit_month_first) {
        _tenderModel.timelimit_month_first = @"0";
    }
    if (!_tenderModel.timelimit_month_last){
        _tenderModel.timelimit_month_last = @"0";
    }
    if (!_tenderModel.apr_first){
        _tenderModel.apr_first = @"0";
    }
    if (!_tenderModel.apr_last){
        _tenderModel.apr_last = @"0";
    }
    if (!_tenderModel.money){
        _tenderModel.money = @"0";
    }
    if ([_tenderModel.timelimit_month_first isEqualToString:@"0"]) {
        _tenderModel.timelimit_month_first = @"不限";
    }else{
        _tenderModel.timelimit_month_first = [_tenderModel.timelimit_month_first stringByAppendingString:@"个月"];
    }
    if ([_tenderModel.timelimit_month_last isEqualToString:@"0"]) {
        _tenderModel.timelimit_month_last = @"不限";
    }else{
        _tenderModel.timelimit_month_last = [_tenderModel.timelimit_month_last stringByAppendingString:@"个月"];
    }
    if ([_tenderModel.apr_first isEqualToString:@"0"]) {
        _tenderModel.apr_first = @"不限";
    }else{
        _tenderModel.apr_first = [_tenderModel.apr_first stringByAppendingString:@"%"];
    }
    if ([_tenderModel.apr_last isEqualToString:@"0"]) {
        _tenderModel.apr_last = @"不限";
    }else{
        _tenderModel.apr_last = [_tenderModel.apr_last stringByAppendingString:@"%"];
    }
    
    [self setPickerDatas];
}

// 保存自动投标设置的网络请求
- (void)NetworkOfSaveAutoTenderSetting
{
    NSMutableDictionary *pramas = [NSMutableDictionary dictionaryWithDictionary:self.paramsBase];
    pramas[@"uid"] = Get_uid_value;
    pramas[@"sid"] = Get_sid_value;
    pramas[@"isjihuo"] = @"1";
    pramas[@"tender_type"]= @"2";
    pramas[@"timelimit_status"] = @"1";
    
    // 处理预期期限结果
    NSMutableString * monthStart = [NSMutableString stringWithString:_tenderModel.timelimit_month_first];
    NSMutableString * monthEnd = [NSMutableString stringWithString: _tenderModel.timelimit_month_last];
     // 处理：不限-不限  这种情况
    if ([monthStart isEqualToString:@"不限"] && [monthEnd isEqualToString:@"不限"] ) {
        pramas[@"timelimit_status"] = @"0";
    }else
    {
        pramas[@"timelimit_status"] = @"1";
    }
    if ([monthStart isEqualToString:@"不限"]) {
        monthStart = (NSMutableString *)@"0";
    }else
    {
        monthStart = (NSMutableString *)[monthStart stringByReplacingOccurrencesOfString:@"个月" withString:@""];
    }
    if ([monthEnd isEqualToString:@"不限"]) {
        monthEnd = (NSMutableString *)@"0";
    }else
    {
        monthEnd = (NSMutableString *)[monthEnd stringByReplacingOccurrencesOfString:@"个月" withString:@""];
    }
    // 处理预期收益率结果
    NSMutableString * aprStart = [NSMutableString stringWithString:_tenderModel.apr_first];
    NSMutableString * aprEnd = [NSMutableString stringWithString: _tenderModel.apr_last];
    if ([aprStart isEqualToString:@"不限"] && [aprEnd isEqualToString:@"不限"] ) {
        pramas[@"apr_status"] = @"0";
    }else
    {
        pramas[@"apr_status"] = @"1";
    }
    if ([aprStart isEqualToString:@"不限"]) {
        aprStart = (NSMutableString *)@"0";
    }else
    {
        aprStart = (NSMutableString *)[aprStart stringByReplacingOccurrencesOfString:@"%" withString:@""];
    }
    if ([aprEnd isEqualToString:@"不限"]) {
        aprEnd = (NSMutableString *)@"0";
    }else
    {
        aprEnd = (NSMutableString *)[aprEnd stringByReplacingOccurrencesOfString:@"%" withString:@""];
    }
    
    pramas[@"timelimit_month_first"] = monthStart;
    pramas[@"timelimit_month_last"] = monthEnd;
    
    pramas[@"apr_first"] = aprStart;
    pramas[@"apr_last"] = aprEnd;

    pramas[@"min_money"] =@"0";
    if ([_tenderModel.money integerValue] == 0 || !_tenderModel.money) {
        [self showTipView:@"单标最高金额有误，请重新输入"];
        [_swithView setOn:NO animated:YES];
        return;
    }
    pramas[@"money"] = _tenderModel.money;
    
    NSLog(@"%@", [self JointUrlAddressWithUrl:tbszrl parameter:pramas]);
    [WWZShuju initlizedData:tbszrl paramsdata:pramas dicBlick:^(NSDictionary *info) {
        NSLog(@"--自动投标设置--%@",info);
        NSLog(@"%@",info[@"msg"]);
        [self showTipView:info[@"msg"]];
        if ([info[@"item"][@"isjihuo"] integerValue] == 0) {
            [_swithView setOn:NO animated:YES];
            _rankLab.text = @"未开启";
            _rankLab.textColor = [UIColor colorWithRed:253/255.0 green:128/255.0 blue:46/255.0 alpha:1/1.0];
        }else{
            [_swithView setOn:YES animated:YES];
            // 当前排名：curseq
            _rankLab.textColor = [UIColor darkGrayColor];
            _rankLab.text = [NSString stringWithFormat:@"当前排名%@位", info[@"item"][@"curseq"]];
            NSMutableAttributedString *rankStr = [[NSMutableAttributedString alloc]initWithString:_rankLab.text];
            [rankStr addAttribute:NSForegroundColorAttributeName
                            value: [UIColor colorWithRed:253/255.0 green:128/255.0 blue:46/255.0 alpha:1/1.0]
                            range:NSMakeRange(4, [info[@"item"][@"curseq"] length])];
            _rankLab.attributedText = rankStr;
        }
        _bottomBtn.selected = NO;
        [_bottomBtn setTitle:@"修改参数设置" forState:UIControlStateNormal];
        [_bottomBtn setTitleColor:blue_color forState:UIControlStateNormal];
        [_bottomBtn setBackgroundColor:KWhiteColor];
        _isEditing = NO;
        self.tableView.isEditing = _isEditing;
        [self.tableView reloadData];
        KPostNotification(KNotificationRefreshMineDatas, nil);
    }];
}

- (void)closeAutoTenderNetwork
{
    NSMutableDictionary *pramas = [NSMutableDictionary dictionaryWithDictionary:self.paramsBase];
    pramas[@"uid"] = Get_uid_value;
    pramas[@"sid"] = Get_sid_value;
    pramas[@"isjihuo"] = @"0";
    pramas[@"tender_type"]= @"2";
    pramas[@"timelimit_status"] = @"1";
    
    // 处理预期期限结果
    NSMutableString * monthStart = [NSMutableString stringWithString:_tenderModel.timelimit_month_first];
    NSMutableString * monthEnd = [NSMutableString stringWithString: _tenderModel.timelimit_month_last];
    // 处理：不限-不限  这种情况
    if ([monthStart isEqualToString:@"不限"] && [monthEnd isEqualToString:@"不限"] ) {
        pramas[@"timelimit_status"] = @"0";
    }else
    {
        pramas[@"timelimit_status"] = @"1";
    }
    if ([monthStart isEqualToString:@"不限"]) {
        monthStart = (NSMutableString *)@"0";
    }else
    {
        monthStart = (NSMutableString *)[monthStart stringByReplacingOccurrencesOfString:@"个月" withString:@""];
    }
    if ([monthEnd isEqualToString:@"不限"]) {
        monthEnd = (NSMutableString *)@"0";
    }else
    {
        monthEnd = (NSMutableString *)[monthEnd stringByReplacingOccurrencesOfString:@"个月" withString:@""];
    }
    // 处理预期收益率结果
    NSMutableString * aprStart = [NSMutableString stringWithString:_tenderModel.apr_first];
    NSMutableString * aprEnd = [NSMutableString stringWithString: _tenderModel.apr_last];
    if ([aprStart isEqualToString:@"不限"] && [aprEnd isEqualToString:@"不限"] ) {
        pramas[@"apr_status"] = @"0";
    }else
    {
        pramas[@"apr_status"] = @"1";
    }
    if ([aprStart isEqualToString:@"不限"]) {
        aprStart = (NSMutableString *)@"0";
    }else
    {
        aprStart = (NSMutableString *)[aprStart stringByReplacingOccurrencesOfString:@"%" withString:@""];
    }
    if ([aprEnd isEqualToString:@"不限"]) {
        aprEnd = (NSMutableString *)@"0";
    }else
    {
        aprEnd = (NSMutableString *)[aprEnd stringByReplacingOccurrencesOfString:@"%" withString:@""];
    }
    
    pramas[@"timelimit_month_first"] = monthStart;
    pramas[@"timelimit_month_last"] = monthEnd;
    
    pramas[@"apr_first"] = aprStart;
    pramas[@"apr_last"] = aprEnd;
    
    pramas[@"min_money"] =@"0";
    pramas[@"money"] = _tenderModel.money;
    
    NSLog(@"%@", [self JointUrlAddressWithUrl:tbszrl parameter:pramas]);
    [WWZShuju initlizedData:tbszrl paramsdata:pramas dicBlick:^(NSDictionary *info) {
        NSLog(@"--自动投标设置--%@",info);
        NSLog(@"%@",info[@"msg"]);
        [self showTipView:info[@"msg"]];
        if ([info[@"item"][@"isjihuo"] integerValue] == 0) {
            [_swithView setOn:NO animated:YES];
            _rankLab.text = @"未开启";
            _rankLab.textColor = [UIColor colorWithRed:253/255.0 green:128/255.0 blue:46/255.0 alpha:1/1.0];
        }else{
            [_swithView setOn:YES animated:YES];
            // 当前排名：curseq
            _rankLab.text = [NSString stringWithFormat:@"当前排名%@位", info[@"item"][@"curseq"]];
            NSMutableAttributedString *rankStr = [[NSMutableAttributedString alloc]initWithString:_rankLab.text];
            [rankStr addAttribute:NSForegroundColorAttributeName
                            value: [UIColor colorWithRed:253/255.0 green:128/255.0 blue:46/255.0 alpha:1/1.0]
                            range:NSMakeRange(4, [info[@"item"][@"curseq"] length])];
            _rankLab.attributedText = rankStr;
        }
        _bottomBtn.selected = NO;
        [_bottomBtn setTitle:@"修改参数设置" forState:UIControlStateNormal];
        [_bottomBtn setTitleColor:blue_color forState:UIControlStateNormal];
        [_bottomBtn setBackgroundColor:KWhiteColor];
        _isEditing = NO;
        self.tableView.isEditing = _isEditing;
        [self.tableView reloadData];
        KPostNotification(KNotificationRefreshMineDatas, nil);
    }];
}

#pragma mark - MonthPickeDelegate
-(void)pickerMonth:(MonthPickerView *)pickerSingle selectedStartMonth:(NSString *)startMonthStr selectedEndMonth:(NSString *)endMonthStr
{
    _tenderModel.timelimit_month_first = startMonthStr;
    _tenderModel.timelimit_month_last = endMonthStr;
    [self setPickerDatas];
}

#pragma mark - AprPickeDelegate
-(void)pickerApr:(AprPickerView *)picker selectedStartApr:(NSString *)startAprStr selectedEndApr:(NSString *)endAprStr
{
    _tenderModel.apr_first = startAprStr;
    _tenderModel.apr_last = endAprStr;
    [self setPickerDatas];
}

- (void)setPickerDatas
{
    NSString * _timeStr = [NSString stringWithFormat:@"%@-%@", _tenderModel.timelimit_month_first, _tenderModel.timelimit_month_last];
    NSString * _aprStr = [NSString stringWithFormat:@"%@-%@", _tenderModel.apr_first, _tenderModel.apr_last];
    NSString * _moneyStr = _tenderModel.money;
    self.tableView.tabViewDataSource = [NSMutableArray arrayWithArray:@[_timeStr, _aprStr, _moneyStr]];
    [self.tableView reloadData];
}

#pragma mark - Event Hander
- (void)ruleDescriptionEvent
{
    WebViewController * webVC = [[WebViewController alloc] init];
    webVC.url = gzsmh5;
    [self.navigationController pushViewController:webVC animated:YES];
}

-(void)SwitchClicked:(UISwitch *)sender{
    if (sender.on==YES) {
        [self AlertWithTitle:@"提示" message:@"您确定要保存并开启自动投标吗？" andOthers:@[@"取消", @"开启"] animated:YES action:^(NSInteger index) {
            // 保存并开启自动投标
            if (index == 1) {
                [self NetworkOfSaveAutoTenderSetting];
            }else{
                sender.on = NO;
            }
        }];
    }else{
        [self AlertWithTitle:@"提示" message:@"您确定要关闭自动投标吗？" andOthers:@[@"取消", @"关闭"] animated:YES action:^(NSInteger index) {
            // 关闭自动投标的网络请求
            if (index == 1) {
                [self closeAutoTenderNetwork];
            }else{
                sender.on = YES;
            }
        }];
    }
}

- (void)updateParamsEvent:(UIButton *)sender
{
    UIButton *button = sender;
    button.selected = !button.selected;
    if (button.selected) {
        _isEditing = YES;
        [_bottomBtn setTitle:@"保存设置" forState:UIControlStateNormal];
        [_bottomBtn setTitleColor:KWhiteColor forState:UIControlStateNormal];
        [_bottomBtn setBackgroundColor:color(65, 148, 221, 1)];
    }else{
        [self AlertWithTitle:@"提示" message:@"您确定要保存并开启自动投标吗？" andOthers:@[@"取消", @"开启"] animated:YES action:^(NSInteger index) {
            // 保存并开启自动投标
            if (index == 1) {
                [self NetworkOfSaveAutoTenderSetting];
            }else{
                button.selected = !button.selected;
                _isEditing = YES;
                [_bottomBtn setTitle:@"保存设置" forState:UIControlStateNormal];
                [_bottomBtn setTitleColor:KWhiteColor forState:UIControlStateNormal];
                [_bottomBtn setBackgroundColor:color(65, 148, 221, 1)];
            }
        }];
    }
    
    self.tableView.isEditing = _isEditing;
    [self.tableView reloadData];
}

-(void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld, %ld, %id", indexPath.section, indexPath.row, self.editing);
    if (_isEditing) {
        // 编辑状态
        NSLog(@"可编辑");
        [self.view endEditing:YES];
        if (indexPath.section == 0 && indexPath.row == 0) {
            [self.view addSubview:self.monthPickerView];
            [self.monthPickerView show];
        }else if (indexPath.section == 0 && indexPath.row == 1){
            [self.view addSubview:self.aprPickerView];
            [self.aprPickerView show];
        }
    }else
    {
        NSLog(@"不可编辑");
    }
}

#pragma mark - Getter
-(AutoTenderTableView *)tableView
{
    if (!_tableView) {
        _tableView = [[AutoTenderTableView alloc] initWithFrame:CGRectMake(0, WTStatus_And_Navigation_Height, screen_width, screen_height-WTStatus_And_Navigation_Height) style:UITableViewStylePlain cellHeight:50];
        _tableView.tableViewEventDelegate = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        [_tableView.mj_footer removeFromSuperview];
        [_tableView.mj_header removeFromSuperview];
        _tableView.tableHeaderView = [self configTableHeaderView];
    }
    return _tableView;
}

-(MonthPickerView *)monthPickerView
{
    if (!_monthPickerView) {
        _monthPickerView = [[MonthPickerView alloc] init];
        _monthPickerView.title = @"选择投资期限";
        _monthPickerView.delegate = self;
    }
    return _monthPickerView;
}

-(AprPickerView *)aprPickerView
{
    if (!_aprPickerView) {
        _aprPickerView = [[AprPickerView alloc] init];
        _monthPickerView.title = @"请选择预期收益率";
        _aprPickerView.delegate = self;
    }
    return _aprPickerView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
