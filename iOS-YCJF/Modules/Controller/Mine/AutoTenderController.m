//
//  AutoTenderController.m
//  iOS-YCJF
//
//  Created by 姜宁桃 on 2017/8/23.
//  Copyright © 2017年 Yincheng. All rights reserved.
//

#import "AutoTenderController.h"
#import "AutoTenderFirstRowCell.h"
#import "BidChooseDatePopview.h"
#import "AutoTenderSettingCell.h"

@interface AutoTenderController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,ChooseDatePickDelegate>{
    BOOL _canEditing;
    BOOL _isone;
    UITextField *_MaxJETf;
    UISwitch *swith;
    
}


/** 数据源 */
@property (nonatomic, copy)NSMutableArray *SourceDataArr;
/** 详情数据 */
@property (nonatomic, copy)NSMutableArray *DetlDataArr;
/** 列表 */
@property (nonatomic,strong)UITableView *AutoBidTable;
/** 底部视图 */
@property (nonatomic,strong)UIButton *BottomView;
/** 选择时间 */
@property (nonatomic,strong)BidChooseDatePopview *PopView;
/***<#注释#> ***/
@property (nonatomic ,strong)NSString *str;
@property (nonatomic ,strong)NSString *str1;
/***s ***/
@property (nonatomic ,strong)NSString *shouyilv;
/***<#注释#> ***/
@property (nonatomic ,strong)NSString *paimingstr;

/** 百分比下拉数据 */
@property (nonatomic, copy)NSArray *BFBChooseData;

/***投标信息数据 ***/
@property (nonatomic ,copy)NSDictionary *BidInfoDic;

@end

@implementation AutoTenderController
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
    
    [self NavBack];
    [self AFN];
    self.backImageView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = grcolor;
    
    UIButton *rightbutton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 57, 20)];
    [rightbutton addTarget:self action:@selector(rightbtnclicked) forControlEvents:UIControlEventTouchUpInside];
    rightbutton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    [rightbutton setTitle:@"规则说明" forState:UIControlStateNormal];
    [rightbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:rightbutton];
    
    [self.view addSubview:self.AutoBidTable];
    [self.view addSubview:self.BottomView];
    _canEditing = NO;
}

-(void)AFN{
    
    NSMutableDictionary *pramas = [NSMutableDictionary dictionary];
    pramas[@"uid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"uid"];
    pramas[@"sid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"sid"];
    pramas[@"at"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"at"];
    pramas[@"version"] = @"v1.0.3";
    pramas[@"os"] = @"ios";
    
    [WWZShuju initlizedData:tbxxrl paramsdata:pramas dicBlick:^(NSDictionary *info) {
        NSLog(@"--自动投标查询--%@",info);
        
        if ([info[@"item"][@"timelimit_month_first"] isEqualToString:info[@"item"][@"timelimit_month_last"] ]) {
            if ([info[@"item"][@"timelimit_month_first"] isEqualToString:@"0"]||[info[@"item"][@"timelimit_month_last"] isEqualToString:@"0"]) {
                self.str = @"不限";
            }else{
                self.str =[NSString stringWithFormat:@"%@个月",info[@"item"][@"timelimit_month_first"]];
            }
        }else{
            self.str =[NSString stringWithFormat:@"%@个月到%@个月",info[@"item"][@"timelimit_month_first"],info[@"item"][@"timelimit_month_last"]];
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:info[@"item"][@"timelimit_status"] forKey:@"timelimit_status"];
        [UserDefaults synchronize];
        NSString *s =@"%";
        
        if ([info[@"item"][@"apr_first"] isEqualToString:info[@"item"][@"apr_last"] ]) {
            if ([info[@"item"][@"apr_first"] isEqualToString:@"0"]) {
                self.shouyilv = @"不限";
            }else
            {
                self.shouyilv =[NSString stringWithFormat:@"%@%@",info[@"item"][@"apr_first"],s];
            }
        }else{
            
            self.shouyilv =[NSString stringWithFormat:@"%@%@到%@%@",info[@"item"][@"apr_first"],s,info[@"item"][@"apr_last"],s];
        }
        
        if ([info[@"item"][@"min_money"]isEqualToString:@"0"]) {
            self.str1 =[NSString stringWithFormat:@"%@",info[@"item"][@"money"]];
        }else{
            self.str1 =[NSString stringWithFormat:@"%@",info[@"item"][@"money"]];
        }
        
        
        
        if ([info[@"item"][@"isjihuo"]isEqualToString:@"0"]) {
            [swith setOn:NO animated:YES];
            self.SourceDataArr = @[@[@""]].mutableCopy;
            self.DetlDataArr = @[@[@""]].mutableCopy;
            _BottomView.hidden = YES;
            self.SourceDataArr = @[@[@""]].mutableCopy;
        }else{
            [swith setOn:YES animated:YES];
            self.SourceDataArr = @[@[@""],@[@"投资期限",@"预期收益率",@"单标最高金额"]].mutableCopy;
            NSMutableArray *arr0 = [[NSMutableArray alloc]initWithObjects:self.str, nil];
            NSMutableArray *arr1 = [[NSMutableArray alloc]initWithObjects:self.str,self.shouyilv,[NSString stringWithFormat:@"%@元",self.str1], nil];
            NSMutableArray *arr2 = [[NSMutableArray alloc]initWithObjects:@"", nil];
            self.DetlDataArr = [[NSMutableArray alloc]initWithObjects:arr0,arr1,arr2, nil];
            
            _BottomView.hidden = NO;
        }
        
        
        
        [self.AutoBidTable reloadData];
        
    }];
    
    
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.SourceDataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.SourceDataArr[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return (indexPath.section==0||indexPath.section==self.SourceDataArr.count-1) ? 60 : 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        static NSString *CellID = @"CellIdentifier";
        AutoTenderFirstRowCell *Mycell = [tableView dequeueReusableCellWithIdentifier:CellID];
        if (!Mycell) {
            Mycell = [[AutoTenderFirstRowCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellID];
            Mycell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        Mycell.RankDetlLab.text = self.paimingstr;
        
        [Mycell.AutoBidSwitch addTarget:self action:@selector(SwitchClicked:) forControlEvents:UIControlEventValueChanged];
        swith= Mycell.AutoBidSwitch ;
        return Mycell;
        
    }else{
        if (indexPath.section==1&&indexPath.row== 2) {
            
            static NSString *CellIdentifier = @"identifier";
            AutoTenderSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (!cell) {
                cell = [[AutoTenderSettingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                
                cell.InputTf.delegate = self;
                cell.InputTf.keyboardType = UIKeyboardTypeNumberPad;
            }
            
            cell.textLabel.text = self.SourceDataArr[indexPath.section][indexPath.row];
            
            cell.textLabel.font = [UIFont systemFontOfSize:16];
            
            cell.InputTf.text = self.DetlDataArr[indexPath.section][indexPath.row];
            
            if (_canEditing==YES) {
                cell.InputTf.textColor = [UIColor blackColor];
                cell.InputTf.text = @"";
                cell.Ylab.hidden = NO;
                /*
                 NSMutableArray *arrqaq = self.DetlDataArr[1];
                 
                 [arrqaq replaceObjectAtIndex:0 withObject:@""];
                 [arrqaq replaceObjectAtIndex:1 withObject:@""];
                 */
            }else{
                cell.InputTf.textColor = [UIColor lightGrayColor];
                cell.Ylab.hidden = YES;
            }
            if (_isone == NO ) {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }else{
                if (indexPath.section ==1 &&indexPath.row == 2) {
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }else{
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }
            }
            _MaxJETf = cell.InputTf;
            return cell;
            
        }else{
            static NSString *CellIdentifier = @"identifier";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            cell.textLabel.text = self.SourceDataArr[indexPath.section][indexPath.row];
            
            cell.textLabel.font = [UIFont systemFontOfSize:16];
            //            if (self.DetlDataArr.count>1) {
            cell.detailTextLabel.text = self.DetlDataArr[indexPath.section][indexPath.row];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
            cell.detailTextLabel.textColor = [UIColor lightGrayColor];
            //            }
            
            if (_isone == NO ) {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }else{
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                if (indexPath.section ==1 &&indexPath.row == 2) {
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
            }
            return cell;
            
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.view endEditing:YES];
    if (_canEditing==YES) {
        if ((indexPath.section==1&&indexPath.row==0) || (indexPath.section==1&&indexPath.row==1)) {
            self.PopView = [[BidChooseDatePopview alloc]initWithFrame:[UIScreen mainScreen].bounds];
            self.PopView.tag = 100+1+indexPath.row;
            self.PopView.delegate = self;
            [self.view addSubview:self.PopView];
            if (indexPath.row==1) {
                self.PopView.ChooseData = self.BFBChooseData;
            }
            __weak AutoTenderController *weakSelf = self;
            [self.PopView setBlock:^{
                [weakSelf.PopView removeFromSuperview];
            }];
        }
    }
}

#pragma mark -编辑事件处理
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (_canEditing) {
        return YES;
    }
    return NO;
}


-(void)SwitchClicked:(UISwitch *)sender{
    BOOL isON = sender.isOn;
    if (isON==YES) {
        self.SourceDataArr = @[@[@""],@[@"投资期限",@"预期收益率",@"单标最高金额"]].mutableCopy;
        NSMutableArray *arr0 = [[NSMutableArray alloc]initWithObjects:@"", nil];
        NSMutableArray *arr1 = [[NSMutableArray alloc]initWithObjects:@"2个月到3个月",@"10%到12%",@"1000.00元", nil];
        NSMutableArray *arr2 = [[NSMutableArray alloc]initWithObjects:@"", nil];
        self.DetlDataArr = [[NSMutableArray alloc]initWithObjects:arr0,arr1,arr2, nil];
        //        self.DetlDataArr = @[@[@""],@[@"2个月到3个月",@"10%-12%",@"1000.00元"],@[@"0.00元"]].mutableCopy;
        _BottomView.hidden = NO;
    }else{
        [self closeAutoTenderAFN];  // 关闭自动投标
    }
    [self.AutoBidTable reloadData];
}

/**
 *  关闭自动投标
 */
- (void)closeAutoTenderAFN
{
    NSMutableDictionary *pramas = [NSMutableDictionary dictionary];
    pramas[@"uid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"uid"];
    pramas[@"sid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"sid"];
    pramas[@"at"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"at"];
    pramas[@"version"] = @"v1.0.3";
    pramas[@"os"] = @"ios";
    pramas[@"isjihuo"] = @"0";
    pramas[@"tender_type"]= @"2";
    NSString *a = @"0";
    pramas[@"min_money"] =a;
    pramas[@"money"] = self.str1;
    pramas[@"apr_status"] = @"1";
    
    
    NSString *monthStr = self.DetlDataArr[1][0];
    NSLog(@"%@", monthStr);
    NSArray *monthArr = [monthStr componentsSeparatedByString:@"到"];
    NSLog(@"%@", monthArr);
    if (monthArr != nil) {
        if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"timelimit_status"]isEqualToString:@"1"] && ![monthStr isEqualToString:@"不限"]) {
            if (monthArr.count == 2) {
                NSString *timeStr = monthArr[0];
                pramas[@"timelimit_status"] = @"1";
                pramas[@"timelimit_month_first"] = [timeStr substringToIndex:timeStr.length-2];
                NSString *timeStr1 = monthArr[1];
                pramas[@"timelimit_month_last"] = [timeStr1 substringToIndex:timeStr1.length-2];
            }else if(monthArr.count == 1){
                NSString *timeStr = monthArr[0];
                pramas[@"timelimit_status"] = @"1";
                pramas[@"timelimit_month_first"] = [timeStr substringToIndex:timeStr.length-2];
                pramas[@"timelimit_month_last"] = [timeStr substringToIndex:timeStr.length-2];
            }
            
            NSLog(@"%@-%@", pramas[@"timelimit_month_first"], pramas[@"timelimit_month_last"]);
        }else{
            //            NSString *timeStr = monthArr[0];
            pramas[@"timelimit_month_first"] =@"0";
            //            NSString *timeStr1 = monthArr[1];
            pramas[@"timelimit_month_last"] = @"0";
            pramas[@"timelimit_status"] = @"0";
        }
        
    }
    
    
    NSString *bfbStr = self.DetlDataArr[1][1];
    NSArray *bfbArrqqq = [bfbStr componentsSeparatedByString:@"到"];
    NSLog(@"%@ %ld", bfbStr, bfbArrqqq.count);
    if(bfbArrqqq !=nil){
        if (bfbArrqqq.count == 2) {
            NSString *bfStr = bfbArrqqq[0];
            pramas[@"apr_first"] = [bfStr substringToIndex:bfStr.length-1];
            NSString *bfStr1 = bfbArrqqq[1];
            pramas[@"apr_last"] = [bfStr1 substringToIndex:bfStr1.length-1];
        }else if(bfbArrqqq.count == 1)
        {
            NSString *bfStr = bfbArrqqq[0];
            pramas[@"apr_first"] = [bfStr substringToIndex:bfStr.length-1];
            pramas[@"apr_last"] = [bfStr substringToIndex:bfStr.length-1];
        }
    }
    
    NSLog(@"%@?%@", tbszrl, pramas);
    [WWZShuju initlizedData:tbszrl paramsdata:pramas dicBlick:^(NSDictionary *info) {
        NSLog(@"--自动投标设置--%@",info);
        NSLog(@"%@",info[@"msg"]);
        [self showHUD:info[@"msg"] de:1.5];
        _BottomView.hidden = YES;
        self.SourceDataArr = @[@[@""]].mutableCopy;
        self.DetlDataArr = @[@[@""],@[@"0.00元"]].mutableCopy;
        [self.AutoBidTable reloadData];
        KPostNotification(KNotificationRefreshMineDatas, nil);
    }];
}

-(void)ModifyBidSettingClicked{
    if ([self.BottomView.titleLabel.text isEqualToString:@"修改参数设置"]) {
        _canEditing = YES;
        [self.AutoBidTable reloadData];
        [_BottomView setTitle:@"保存设置" forState:0];
        [_BottomView setBackgroundColor:color(65, 148, 221, 1)];
        [_BottomView setTitleColor:[UIColor whiteColor] forState:0];
    }else{
        
        if ((_MaxJETf.text.length == 0)) {
            NSLog(@"qqqqq");
            [self showHUD:@"请输入单标最高金额" de:1.5];
            return;
        }else{
            NSMutableDictionary *pramas = [NSMutableDictionary dictionary];
            pramas[@"uid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"uid"];
            pramas[@"sid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"sid"];
            pramas[@"at"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"at"];
            pramas[@"version"] = @"v1.0.3";
            pramas[@"os"] = @"ios";
            pramas[@"isjihuo"] = @"1";
            pramas[@"tender_type"]= @"2";
            
            NSString *monthStr = self.DetlDataArr[1][0];
            NSLog(@"%@", monthStr);
            NSArray *monthArr = [monthStr componentsSeparatedByString:@"到"];
            NSLog(@"%@", monthArr);
            if (monthArr != nil) {
                if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"timelimit_status"]isEqualToString:@"1"] && ![monthStr isEqualToString:@"不限"]) {
                    if (monthArr.count == 2) {
                        NSString *timeStr = monthArr[0];
                        pramas[@"timelimit_status"] = @"1";
                        pramas[@"timelimit_month_first"] = [timeStr substringToIndex:timeStr.length-2];
                        NSString *timeStr1 = monthArr[1];
                        pramas[@"timelimit_month_last"] = [timeStr1 substringToIndex:timeStr1.length-2];
                    }else if(monthArr.count == 1){
                        NSString *timeStr = monthArr[0];
                        pramas[@"timelimit_status"] = @"1";
                        pramas[@"timelimit_month_first"] = [timeStr substringToIndex:timeStr.length-2];
                        pramas[@"timelimit_month_last"] = [timeStr substringToIndex:timeStr.length-2];
                    }
                    NSLog(@"%@-%@", pramas[@"timelimit_month_first"], pramas[@"timelimit_month_last"]);
                }else{
                    //            NSString *timeStr = monthArr[0];
                    pramas[@"timelimit_month_first"] =@"0";
                    //            NSString *timeStr1 = monthArr[1];
                    pramas[@"timelimit_month_last"] = @"0";
                    pramas[@"timelimit_status"] = @"0";
                }
                
            }
            
            
            NSString *bfbStr = self.DetlDataArr[1][1];
            
            NSArray *bfbArrqqq = [bfbStr componentsSeparatedByString:@"到"];
            if(bfbArrqqq !=nil){
                if (bfbArrqqq.count == 2) {
                    NSString *bfStr = bfbArrqqq[0];
                    pramas[@"apr_first"] = [bfStr substringToIndex:bfStr.length-1];
                    NSString *bfStr1 = bfbArrqqq[1];
                    pramas[@"apr_last"] = [bfStr1 substringToIndex:bfStr1.length-1];
                }else if(bfbArrqqq.count == 1)
                {
                    NSString *bfStr = bfbArrqqq[0];
                    NSLog(@"%@", bfStr);
                    if ([bfStr isEqualToString:@"不限"]) {
                        pramas[@"apr_first"] = @"0";
                        pramas[@"apr_last"] = @"0";
                    }else
                    {
                        pramas[@"apr_first"] = [bfStr substringToIndex:bfStr.length-1];
                        pramas[@"apr_last"] = [bfStr substringToIndex:bfStr.length-1];
                    }
                }
            }
            
            if (_MaxJETf.text.length>0) {
                NSString *a = @"0";
                pramas[@"min_money"] =a;
                pramas[@"money"] = _MaxJETf.text;
            }
            
            NSLog(@"%@?%@", tbszrl, pramas);
            [WWZShuju initlizedData:tbszrl paramsdata:pramas dicBlick:^(NSDictionary *info) {
                NSLog(@"--自动投标设置--%@",info);
                NSLog(@"%@",info[@"msg"]);
                [self showHUD:info[@"msg"] de:1.5];
                [self.AutoBidTable reloadData];
                KPostNotification(KNotificationRefreshMineDatas, nil);
            }];
        }
        
        
        NSMutableArray *arr = self.DetlDataArr[1];
        [arr replaceObjectAtIndex:2 withObject:[NSString stringWithFormat:@"%@元",_MaxJETf.text]];
        [_BottomView setTitle:@"修改参数设置" forState:0];
        [_BottomView setBackgroundColor:[UIColor whiteColor]];
        [_BottomView setTitleColor:color(65, 148, 221, 1) forState:0];
        _canEditing = NO;
        [self.AutoBidTable reloadData];
    }
}

-(void)chooseDatewithDateStr:(NSString *)dateStr andView:(BidChooseDatePopview *)view{
    //    if (view.tag-100==1) {
    NSMutableArray *arr = self.DetlDataArr[1];
    [arr replaceObjectAtIndex:view.tag-100-1 withObject:[dateStr isEqualToString:@"不限到不限"]?@"不限":dateStr];
    [dateStr isEqualToString:@"不限到不限"]?[[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"timelimit_status"]:[[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"timelimit_status"];
    [UserDefaults synchronize];
    //    }else if (view.tag-100==2) {
    //    
    //    }
    [self.AutoBidTable reloadData];
}

-(void)rightbtnclicked{
    WebViewController * webVC = [[WebViewController alloc] init];
    webVC.url = gzsmh5;
    webVC.WebTiltle = @"规则说明";
    [self.navigationController pushViewController:webVC animated:YES];
}

#pragma mark - Getter
-(NSArray *)BFBChooseData{
    if (!_BFBChooseData) {
        _BFBChooseData = [[NSArray alloc]init];
        NSMutableArray *arr = [[NSMutableArray alloc]init];
        for (NSInteger i = 10; i<20; i++) {
            [arr addObject:[NSString stringWithFormat:@"%ld%@",i,@"%"]];
        }
        _BFBChooseData = arr;
    }return _BFBChooseData;
}


-(NSMutableArray *)SourceDataArr{
    if (!_SourceDataArr) {
        _SourceDataArr = @[@[@""]].mutableCopy;
    }return _SourceDataArr;
}

-(NSMutableArray *)DetlDataArr{
    if (!_DetlDataArr) {
        _DetlDataArr = @[@[@""],@[@"0.00元"]].mutableCopy;
    }return _DetlDataArr;
}

-(UIButton *)BottomView{
    if (!_BottomView) {
        _BottomView = [[UIButton alloc]initWithFrame:CGRectMake(0, ScreenHeight-50, ScreenWidth, 50)];
        [_BottomView setBackgroundColor:[UIColor whiteColor]];
        [_BottomView setTitleColor:color(65, 148, 221, 1) forState:0];
        _BottomView.titleLabel.font = [UIFont systemFontOfSize:16];
        [_BottomView setTitle:@"修改参数设置" forState:0];
        [_BottomView addTarget:self action:@selector(ModifyBidSettingClicked) forControlEvents:UIControlEventTouchUpInside];
        _BottomView.hidden = YES;
        
    }return _BottomView;
}

-(UITableView *)AutoBidTable{
    if (!_AutoBidTable) {
        _AutoBidTable = [[UITableView alloc]initWithFrame:CGRectMake(0, WTStatus_And_Navigation_Height, ScreenWidth, ScreenHeight-WTStatus_And_Navigation_Height) style:UITableViewStyleGrouped];
        _AutoBidTable.dataSource = self;
        _AutoBidTable.delegate = self;
        _AutoBidTable.sectionHeaderHeight = 10;
        _AutoBidTable.sectionFooterHeight = .1;
        _AutoBidTable.showsHorizontalScrollIndicator = NO;
        _AutoBidTable.backgroundColor = self.view.backgroundColor;
    }return _AutoBidTable;
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
