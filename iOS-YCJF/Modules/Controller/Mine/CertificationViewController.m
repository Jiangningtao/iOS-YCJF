//
//  CertificationViewController.m
//  iOS-YCJF
//
//  Created by 姜宁桃 on 2017/8/18.
//  Copyright © 2017年 Yincheng. All rights reserved.
//
/**
 *  账户认证
 */
#import "CertificationViewController.h"
#import "STPickerSingle.h"
#import "LLPayUtil.h"
#import <LLPaySDK/LLPaySdk.h>
#import "certificationTableViewCell.h"

@interface CertificationViewController ()<UITableViewDataSource,UITableViewDelegate, STPickerSingleDelegate, UITextFieldDelegate, LLPaySdkDelegate>{
    UITextField *textf;
    STPickerSingle * _bankPicker;
    NSMutableArray * _dataArr;
    NSString * urlStr;
}
/***tf的tag值 ***/
@property (nonatomic ,assign)NSInteger CellTfTag;
/***tabview ***/
@property (nonatomic ,strong)UITableView *tab;
/***组的头标题 ***/
@property (nonatomic ,strong)NSArray *arr;
/***名称 ***/
@property (nonatomic ,strong)NSArray *mcarr;
/***<#注释#> ***/
@property (nonatomic ,strong)NSArray *mcarr1;
/***<#注释#> ***/
@property (nonatomic ,strong)NSArray *mcarr2;

/***<#注释#> ***/
@property (nonatomic ,strong)NSArray *mcarr3;
/**
 *  银行数组
 */
@property (nonatomic, strong) NSMutableArray * bankArr;
/***身份验证 ***/
@property (nonatomic ,strong)UIButton *sfbtn;
@property (nonatomic, strong) NSMutableDictionary * dataDict; // 输入内容字典

@end

@implementation CertificationViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = @"账户认证";
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
    [self.view addSubview:self.tab];
    [self.view addSubview:self.sfbtn];
    [self.sfbtn  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(13);
        make.bottom.offset(-5);
        make.right.offset(-13);
        make.height.offset(45);
    }];
    
    [self NetWork];
}

#pragma mark - NetWork
- (void)NetWork
{
    [self showHUD:@"数据加载中" isDim:YES];
    
    NSMutableDictionary *prama = [NSMutableDictionary dictionary];
    prama[@"uid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"uid"];
    prama[@"sid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"sid"];
    prama[@"at"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"at"];
    prama[@"version"] = @"v1.0.3";
    prama[@"os"] = @"ios";
    prama[@"paytype"] = @"3";
    prama[@"cardtype"] = @"3";
    prama[@"_sid"] = @"11";
    
    NSLog(@"%@?%@", smrzurl, prama);    // 获取银行列表
    [WWZShuju initlizedData:smrzurl paramsdata:prama dicBlick:^(NSDictionary *info) {
        NSLog(@"%@", info);
        self.bankArr = [[NSMutableArray alloc] initWithArray:info[@"bankList"]];
        _dataArr = [[NSMutableArray alloc] init];
        for (NSDictionary * item in self.bankArr) {
            [_dataArr addObject:item[@"name"]];
        }
        NSLog(@"%@", self.bankArr);
        [self hideHUD];
    }];
}

#pragma mark - Event Hander
-(void)sfBtnClicked{
    UITextField * tf3 = [self.view viewWithTag:3];
    
    if (tf3.text.length > 0 && [self.dataDict[@"person_name"] length] > 0 && [self.dataDict[@"person_id"] length] > 0 && [self.dataDict[@"card_no"] length] > 0) {
        NSMutableDictionary *prama = [NSMutableDictionary dictionaryWithDictionary:self.dataDict];
        prama[@"sid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"sid"];
        prama[@"at"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"at"];
        prama[@"uid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"uid"];
        prama[@"version"] = @"v1.0.3";
        prama[@"os"] = @"ios";
        prama[@"terminal_type"] = @"html5";
        prama[@"_sid"] = @"11";
        prama[@"style"] = @"sdk";
        prama[@"money"] = @"0.01";
        
        for (NSDictionary * dict in self.bankArr) {
            if ([dict[@"name"] isEqualToString:tf3.text]) {
                prama[@"card_code"] = dict[@"code"];
                NSLog(@"银行ID %@", prama[@"bank_code"]);
            }
        }
        
        [self showHUD:@"数据加载中" isDim:YES];
        NSLog(@"%@?%@", scsmrzurl, prama);
        [WWZShuju initlizedData:scsmrzurl paramsdata:prama dicBlick:^(NSDictionary *info) {
            
            [self hideHUD];
            NSLog(@"%@",info);
            NSDictionary * dict = info[@"data"];
            NSLog(@"%@", dict);
            if ([info[@"r"] integerValue] == 3 || [info[@"msg"] isEqualToString:@"使用data通过sdk继续进行支付"]) {
                LLPaySdk * paySdk = [LLPaySdk sharedSdk];
                paySdk.sdkDelegate = self;
                [paySdk presentLLPaySDKInViewController:self withPayType:LLPayTypeVerify andTraderInfo:dict];
            }else
            {
                [self showHUD:info[@"msg"] de:1.5];
            }
            
            
        }];
    }else
    {
        [self showHUD:@"请检查认证信息是否完整" de:2.0];
    }
    
}

#pragma - mark 支付结果 LLPaySdkDelegate
// 订单支付结果返回，主要是异常和成功的不同状态
// TODO: 开发人员需要根据实际业务调整逻辑
- (void)paymentEnd:(LLPayResult)resultCode withResultDic:(NSDictionary *)dic {
    
    NSString *msg = @"异常";
    switch (resultCode) {
        case kLLPayResultSuccess: {
            msg = @"成功";
        } break;
        case kLLPayResultFail: {
            msg = @"失败";
        } break;
        case kLLPayResultCancel: {
            msg = @"取消";
        } break;
        case kLLPayResultInitError: {
            msg = @"sdk初始化异常";
        } break;
        case kLLPayResultInitParamError: {
            msg = dic[@"ret_msg"];
        } break;
        default:
            break;
    }
    
    NSString *showMsg = msg;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"支付结果"
                                                                   message:showMsg
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确认"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * _Nonnull action) {
                                                KPostNotification(KNotificationRefreshMineDatas, nil);
                                                if ([msg hasPrefix:@"成功"] || [msg hasSuffix:@"成功" ]) {
                                                    [self.navigationController popToRootViewControllerAnimated:YES];
                                                }else
                                                {
                                                    [self reRealAction];
                                                }
                                            }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)reRealAction
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"uid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"uid"];
    params[@"sid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"sid"];
    params[@"at"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"at"];
    params[@"version"] = @"v1.0.3";
    params[@"os"] = @"ios";
    
    NSLog(@"%@?%@", qxscsmrzurl, params);
    [WWZShuju initlizedData:qxscsmrzurl paramsdata:params dicBlick:^(NSDictionary *info) {
        
        NSLog(@"%@", info);
        if ([info[@"r"] integerValue] == 1) {
            //[self showHUD:@"您已经成功重置认证信息" de:1.5];
            NSLog(@"您已经成功重置认证信息");
            KPostNotification(KNotificationRefreshMineDatas, nil);
        }else{
            KPostNotification(KNotificationRefreshMineDatas, nil);
            [self showHUD:@"您已经认证成功，即将跳转" de:1.5];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
        }
    }];
}



#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag == 3) {
        [self.view endEditing:YES];
        [textField resignFirstResponder];
        _bankPicker = [[STPickerSingle alloc] init];
        _bankPicker.delegate = self;
        _bankPicker.widthPickerComponent = 200;
        [_bankPicker setArrayData:_dataArr];
        [_bankPicker show];
        return NO;
    }
    
    return YES;
}

#pragma mark -对输入框的输入内容限制
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"/n"]) {
        return YES;
    }
    NSString *tobestr =[textField.text stringByReplacingCharactersInRange:range withString:string];
    if (textField.tag == 2 ) {
        if ( [tobestr length]>19 ) {
            textField.text = [tobestr substringToIndex:18];
            [self showError:@"亲，身份证号码只有18位数哦"];
            return NO;
        }
        NSCharacterSet *cs;
        cs = [[NSCharacterSet characterSetWithCharactersInString:kAlphaNum] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""]; //按cs分离出数组,数组按@""分离出字符串
        BOOL canChange = [string isEqualToString:filtered];
        if (!canChange) {
            [self showError:@"身份证号码只能是字母和数字"];
        }
        return  canChange;
        
    }else if (textField.tag == 4)
    {
        if ( [tobestr length]>30 ) {
            textField.text = [tobestr substringToIndex:20];
            [self showError:@"您的银行卡号长度不正确"];
            return NO;
        }
        NSCharacterSet *cs;
        cs = [[NSCharacterSet characterSetWithCharactersInString:Kshuzi] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""]; //按cs分离出数组,数组按@""分离出字符串
        BOOL canChange = [string isEqualToString:filtered];
        if (!canChange) {
            [self showError:@"银行卡号只能为数字"];
        }
        return  canChange;
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag == 1) {
        UITextField * tf = [self.tab viewWithTag:2];
        [tf becomeFirstResponder];
    }else
    {
        [textField resignFirstResponder];
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (textField.tag == 1) {
        self.dataDict[@"person_name"] = textField.text;
    }else if (textField.tag == 2){
        self.dataDict[@"person_id"] = textField.text;
    }else if (textField.tag == 4){
        self.dataDict[@"card_no"] = textField.text;
    }
    return YES;
}


-(void)pickerSingle:(STPickerSingle *)pickerSingle selectedTitle:(NSString *)selectedTitle
{
    UITextField * tf = [self.tab viewWithTag:3];
    tf.text = selectedTitle;
    
}

#pragma mark - 提示框
-(void)showError:(NSString *)error
{
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:error preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *av = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [ac addAction:av];
    [self presentViewController:ac animated:YES completion:nil];
    
}



#pragma mark - UITableViewDelegate & UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 2) {
        return 1;
    }
    return 2;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *header = [[UIView alloc] init];
    UILabel *la = [[UILabel alloc]init];
    if (section == 2) {
        la.textColor = lancolor;
    }else
    {
        la.textColor =[UIColor blackColor];
    }
    la.text = self.arr[section];
    la.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
    la.width = 200;
    la.x = 19;
    la.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [header addSubview:la];
    return header;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 3) {
        return 10;
    }
    return 40;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    certificationTableViewCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"certificationTableViewCell" owner:nil options:nil]lastObject];
    cell.tf.clearButtonMode = UITextFieldViewModeAlways;
    cell.tf.delegate = self;
    cell.tf.inputAccessoryView = [[UIView alloc] init];
    if (indexPath.section == 0) {
        cell.namelab.text = self.mcarr[indexPath.row][@"sec"];
        cell.tf.placeholder =self.mcarr[indexPath.row][@"text"];
        if (indexPath.row == 0) {
            cell.tf.text = self.dataDict[@"name"];
        }else
        {
            cell.tf.text = self.dataDict[@"personid"];
        }
        
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else{
            
        }
        cell.namelab.text = self.mcarr1[indexPath.row][@"sec"];
        cell.tf.placeholder =self.mcarr1[indexPath.row][@"text"];
        cell.tf.returnKeyType = UIReturnKeyDone;
    }  else if (indexPath.section == 2){
        cell.namelab.text = self.mcarr2[indexPath.row][@"sec"];
        cell.tf.placeholder =self.mcarr2[indexPath.row][@"text"];
        cell.namelab.textColor = [UIColor lightGrayColor];
        cell.tf.clearButtonMode = UITextFieldViewModeNever;
        cell.tf.userInteractionEnabled = NO;
    }
    
    self.CellTfTag += 1;
    cell.tf.tag = self.CellTfTag;
    NSLog(@"tag = %ld",(long)cell.tf.tag);
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Getter
-(NSArray *)arr{
    if (!_arr) {
        _arr = [NSArray array];
        _arr = @[@"个人信息(与持卡人信息保持一致)",@"银行卡信息",@"首次充值最低1分起并进行身份验证",@""];
    }
    return _arr;
}

-(NSArray *)mcarr{
    if (!_mcarr) {
        _mcarr = [NSArray array];
        _mcarr = @[@{@"sec":@"姓名",@"text":@"请输入真实姓名"},
                   @{@"sec":@"身份证",@"text":@"输入18位身份证号码"}
                   ];
    }
    return _mcarr;
}

-(NSArray *)mcarr1{
    if (!_mcarr1) {
        _mcarr1 = [NSArray array];
        _mcarr1 = @[@{@"sec":@"银行",@"text":@"请选择银行名称"},
                    @{ @"sec":@"卡号",@"text":@"请输入银行卡号"}
                    ];
    }
    return _mcarr1;
}

-(NSArray *)mcarr2{
    if (!_mcarr2) {
        _mcarr2 = [NSArray array];
        _mcarr2 = @[@{@"sec":@"充值金额",@"text":@"本次默认充值0.01元"}
                    ];
    }
    return _mcarr2;
}

-(NSMutableDictionary *)dataDict
{
    if (!_dataDict) {
        _dataDict = [[NSMutableDictionary alloc] init];
    }
    return _dataDict;
}

-(UITableView *)tab{
    if (!_tab) {
        self.tab = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height -55) style:UITableViewStyleGrouped];
        self.tab.dataSource= self;
        self.tab.delegate = self;
        self.tab.backgroundColor =grcolor;
        
    }
    return _tab;
}

-(UIButton *)sfbtn{
    if (!_sfbtn) {
        _sfbtn = [[UIButton alloc]init];
        _sfbtn.backgroundColor = lancolor;
        [_sfbtn setTitle:@"身份验证" forState:UIControlStateNormal];
        [_sfbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sfbtn addTarget:self action:@selector(sfBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        _sfbtn.layer.masksToBounds = YES;
        _sfbtn.layer.cornerRadius = 3.0;
    }
    return _sfbtn;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
