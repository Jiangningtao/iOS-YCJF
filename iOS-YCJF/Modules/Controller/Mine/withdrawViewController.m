//
//  withdrawViewController.m
//  iOS-YCJF
//
//  Created by 姜宁桃 on 2017/8/21.
//  Copyright © 2017年 Yincheng. All rights reserved.
//

#import "withdrawViewController.h"

#import "MyAreaPicker.h"
#import "paymentView.h"
#import "CancarryViewController.h"
#import "zfbczjgViewController.h"
#import "FindBackPayPwdViewController.h"
#import <IQKeyboardManager.h>

@interface withdrawViewController ()<UITextFieldDelegate, PickerAreaDelegate>
{
    MyAreaPicker * _areaPicker;
    NSDictionary * bankDict;
    NSString * str;
    NSString * _cityid;
    NSString * _provinceID;
}
/***金额Imgview ***/
@property (nonatomic ,strong)UIImageView *jeImv;
/***银行Imgview ***/
@property (nonatomic ,strong)UIImageView *yhImv;
@property (nonatomic ,strong)UIImageView *zxImv;
@property (nonatomic ,strong)UIImageView *fhImv;
@property (nonatomic ,strong)UIImageView *xhImv;

/***<#注释#> ***/
@property (nonatomic ,strong)UILabel *jeLab;
@property (nonatomic ,strong)UILabel *moneyxsLab;
@property (nonatomic ,strong)UILabel *yhkLab;
@property (nonatomic ,strong)UILabel *sxfLab;
@property (nonatomic ,strong)UILabel *tsLab;
@property (nonatomic, strong) UILabel * khhLab;
/***<#注释#> ***/
@property (nonatomic ,strong)UILabel *buketiLab;
/***<#注释#> ***/
@property (nonatomic ,strong)UIView *Vsx;

/***<#注释#> ***/
@property (nonatomic ,strong)UILabel *gzrLab;

/***提现 ***/
@property (nonatomic ,strong)UIButton *tixianBtn;
@property (nonatomic ,strong)UIButton *quantiBtn;
@property (nonatomic ,strong)UIButton *kezhuanBtn;

/***输入框 ***/
@property (nonatomic ,strong)UITextField *SrkTF;
@property (nonatomic ,strong)UITextField *BrhTF;
@property (nonatomic, strong) UITextField *KhhTF;

@property (nonatomic, strong) paymentView * payView;
@property (nonatomic, copy) NSString *payPwd;

@property (nonatomic, strong) MineItemModel * Model;
@property (nonatomic, strong) AccinfoModel * accModel;

@end

@implementation withdrawViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self AFN];
    self.title = @"提现";
    [MobClick beginLogPageView:self.title];
    [TalkingData trackPageBegin:self.title];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    [MobClick endLogPageView:self.title];
    [TalkingData trackPageEnd:self.title];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    self.Model = [MineInstance shareInstance].mineModel;
    self.accModel = [MineInstance shareInstance].accModel;
    NSLog(@"%@", self.Model);
    [self NavBack];
    self.backImageView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = [UIColor whiteColor];
    
    bankDict = self.infoDict[@"bankList"][0];
    [self UIlayout];
    
    UIButton *rightbutton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 57, 20)];
    [rightbutton addTarget:self action:@selector(rightbtnclicked) forControlEvents:UIControlEventTouchUpInside];
    rightbutton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    [rightbutton setTitle:@"提现说明" forState:UIControlStateNormal];
    [rightbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:rightbutton];
}

#pragma mark - Help Method
-(void)UIlayout{
    UIView *xuxian1 = [[UIView alloc]init];
    xuxian1.backgroundColor = grcolor;
    [self.view addSubview:xuxian1];
    [xuxian1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.height.offset(2);
        make.top.offset(0);
    }];
    //可提金额
    [self.view addSubview:self.jeImv];
    [self.jeImv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(47);
        make.top.offset(100);
        make.width.height.offset(50);
    }];
    [self.view addSubview:self.jeLab];
    [self.jeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.jeImv.mas_centerX);
        make.top.equalTo(self.jeImv.mas_bottom).offset(7);
    }];
    
    //银行
    [self.view addSubview:self.yhImv];
    [self.yhImv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-47);
        make.top.offset(100);
        make.width.offset(50);
        make.height.offset(50);
    }];
    [self.view addSubview:self.yhkLab];
    [self.yhkLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.yhImv.mas_centerX);
        make.top.equalTo(self.yhImv.mas_bottom).offset(7);
    }];
    
    //支付显示
    [self.view addSubview:self.moneyxsLab];
    [self.moneyxsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.jeImv.mas_centerY);
        make.centerX.offset(0);
    }];
    [self.view addSubview:self.zxImv];
    [self.zxImv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.equalTo(self.moneyxsLab).offset(10);
        make.width.offset(100);
        make.height.offset(10);
    }];
    
    //本缺剩余免费提现次数
    [self.view addSubview:self.Vsx];
    [self.Vsx mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.height.offset(20);
        make.top.equalTo(_jeLab.mas_bottom).offset(16);
    }];
    [self.view addSubview:self.buketiLab];
    [self.buketiLab mas_makeConstraints:^(MASConstraintMaker *make) {
        // make.left.equalTo(self.fhImv.mas_left);
        make.left.offset(20);
        make.top.equalTo(self.Vsx.mas_bottom).offset(10);
    }];
    
    [self.view addSubview:self.kezhuanBtn];
    [self.kezhuanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.buketiLab.mas_centerY);
        make.right.offset(-20);
    }];
    
    UIView *xuxian = [[UIView alloc]init];
    xuxian.backgroundColor = grcolor;
    [self.view addSubview:xuxian];
    [xuxian mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.right.offset(-10);
        make.height.offset(1);
        make.top.equalTo(self.kezhuanBtn.mas_bottom).offset(8);
    }];
    
    [self.view addSubview:self.fhImv];
    [self.fhImv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.top.equalTo(xuxian.mas_bottom).offset(15);
        make.width.height.offset(18);
    }];
    [self.view addSubview:self.quantiBtn];
    [self.quantiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-10);
        make.width.offset(60);
        make.centerY.equalTo(self.fhImv.mas_centerY);
    }];
    UIView *xu =[[UIView alloc]init];
    xu.backgroundColor =[UIColor lightGrayColor];
    [self.view addSubview:xu];
    [xu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(1);
        make.height.offset(20);
        make.centerY.equalTo(self.fhImv.mas_centerY);
        make.right.equalTo(self.quantiBtn.mas_left).offset(-8);
    }];
    [self.view addSubview:self.SrkTF];
    [self.SrkTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.fhImv.mas_centerY);
        make.left.equalTo(_fhImv.mas_right).offset(10);
        make.right.equalTo(self.quantiBtn.mas_left).offset(-10*widthScale);
    }];
    
    if ([bankDict[@"branch"] length] == 0) {
        UIView *xuxian1 = [[UIView alloc]init];
        xuxian1.backgroundColor = grcolor;
        [self.view addSubview:xuxian1];
        [xuxian1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(10);
            make.right.offset(-10);
            make.height.offset(1);
            make.top.equalTo(self.SrkTF.mas_bottom).offset(8);
        }];
        
        [self.view addSubview:self.khhLab];
        [self.khhLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(10);
            make.top.equalTo(xuxian1.mas_bottom).offset(15);
        }];
        
        [self.view addSubview:self.KhhTF];
        [self.KhhTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.khhLab.mas_centerY);
            make.left.equalTo(self.khhLab.mas_right).offset(10);
            make.right.offset(-10);
        }];
        
        
        UIView *xuxian2 = [[UIView alloc]init];
        xuxian2.backgroundColor = grcolor;
        [self.view addSubview:xuxian2];
        [xuxian2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(10);
            make.right.offset(-10);
            make.height.offset(1);
            make.top.equalTo(self.KhhTF.mas_bottom).offset(8);
        }];
        
        [self.view addSubview:self.xhImv];
        [self.xhImv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(10);
            make.top.equalTo(xuxian2.mas_bottom).offset(15);
            make.width.height.offset(11);
        }];
        [self.view addSubview:self.tsLab];
        [self.tsLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_xhImv.mas_centerY);
            make.left.equalTo(_xhImv.mas_right).offset(3);
        }];
        [self.view addSubview:self.BrhTF];
        [self.BrhTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.xhImv.mas_centerY);
            make.left.equalTo(self.tsLab.mas_right).offset(10);
            make.right.offset(-10);
        }];
    }
    
    
    UIImageView *imgxx = [[UIImageView alloc]init];
    imgxx.image = [UIImage imageNamed:@"xuxian"];
    [self.view addSubview:imgxx];
    [imgxx mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.right.offset(-10);
        make.height.offset(1);
        if ([bankDict[@"branch"] length] == 0) {
            make.top.equalTo(self.BrhTF.mas_bottom).offset(10);
        }else
        {
            make.top.equalTo(self.SrkTF.mas_bottom).offset(10);
        }
    }];
    
    [self.view addSubview:self.tixianBtn];
    [self.tixianBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.equalTo(imgxx.mas_bottom).offset(38);
        make.left.offset(10);make.right.offset(-10);
        make.height.offset(45);
        
    }];
    
    [self.view addSubview:self.gzrLab];
    [self.gzrLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.equalTo(self.tixianBtn.mas_bottom).offset(10);
    }];
    
}

-(void)tixianBtnClicked{
    
    NSLog(@"%@", self.SrkTF.text);
    if ([self.SrkTF.text floatValue] > 0) {
        if ([self.SrkTF.text floatValue] >= [self.infoDict[@"tixian"][@"min"] floatValue]) {
            if ([self.SrkTF.text floatValue] > [self.infoDict[@"keti"][@"balance"] floatValue]) {
                [self showError:[NSString stringWithFormat:@"可提金额不足%@元", self.SrkTF.text]];
            }else
            {
                if ([bankDict[@"branch"] length] == 0 &&( self.BrhTF.text.length ==0 || !_cityid || !_provinceID)) {
                    [self showError:@"为了保障您的提现资金正确打入您的银行卡，请填写银行卡对应的正确的支行名称和开户地址"];
                }else
                {
                    [self.view addSubview:self.payView];
                    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                        _payView.frame = CGRectMake(0, screen_height-420, screen_width, 420);
                    } completion:^(BOOL finished) {
                        [_payView becomeFirstResponder];
                    }];
                    self.payView.foundBlock = ^{
                        NSLog(@"忘记交易密码，找回密码");
                        FindBackPayPwdViewController * vc = [[FindBackPayPwdViewController alloc] init];
                        [self.navigationController pushViewController:vc animated:YES];
                    };
                }
            }
        }else
        {
            [self showError:[NSString stringWithFormat:@"提现金额不能小于最低限额 %@元", self.infoDict[@"tixian"][@"min"]]];
        }
        
    }else
    {
        [self showError:@"提现金额不正确或不能为空"];
    }
}

-(void)AFN{
    str = [NSString string]; //密匙
    
    NSMutableDictionary *prama = [NSMutableDictionary dictionary];
    prama[@"uid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"uid"];
    prama[@"sid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"sid"];
    prama[@"at"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"at"];
    prama[@"version"] = @"v1.0.3";
    prama[@"os"] = @"ios";
    
    [WWZShuju initlizedData:mmmsrl paramsdata:prama dicBlick:^(NSDictionary *info) {
        NSLog(@"%@", info);
        if ([info[@"r"] integerValue] == 1) {
            str =[NSString stringWithFormat:@"%@",info[@"sedpassed"]];
            NSLog(@"%@",str);
        }
    }];
}

-(void)kezhuanBtnClicked{
    CancarryViewController *vc =[[CancarryViewController alloc]init];
    vc.money = self.infoDict[@"buketi"][@"balance"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)quantiBtnClicked
{
    self.SrkTF.text = self.infoDict[@"keti"][@"balance"];
}

#pragma mark - 提示框
-(void)showError:(NSString *)error
{
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:error preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *av = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if ([error isEqualToString:@"为了保障您的提现资金正确打入您的银行卡，请填写银行卡对应的正确的支行名称和开户地址"]) {
            [self.BrhTF becomeFirstResponder];
        }else if ([error isEqualToString:@"提现金额不正确或不能为空"] || [error hasPrefix:@"提现金额不能小于最低限额"])
        {
            [self.SrkTF becomeFirstResponder];
        }
    }];
    [ac addAction:av];
    [self presentViewController:ac animated:YES completion:nil];
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


#pragma mark - Event Hander
-(void)rightbtnclicked{
    WebViewController * webVC = [[WebViewController alloc] init];
    webVC.url = txsmh5;
    webVC.WebTiltle = @"提现说明";
    [self.navigationController pushViewController:webVC animated:YES];
}

#pragma mark - Getter
-(UILabel *)gzrLab{
    if(!_gzrLab){
        _gzrLab = [[UILabel alloc] init];
        _gzrLab.text = @"当天申请、次日到账";
        _gzrLab.textColor = [UIColor lightGrayColor];
        _gzrLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];
    }
    return _gzrLab;
}

-(UIImageView *)jeImv{
    if(!_jeImv){
        _jeImv = [[UIImageView alloc] init];
        _jeImv.image = [UIImage imageNamed:@"pic_keti"];
    }
    return _jeImv;
}

-(UIImageView *)yhImv{
    if(!_yhImv){
        _yhImv = [[UIImageView alloc] init];
        _yhImv.image = [UIImage imageNamed:[NSString stringWithFormat:@"a_%@", bankDict[@"bank"]]];
    }
    return _yhImv;
}
-(UIImageView *)zxImv{
    if(!_zxImv){
        _zxImv = [[UIImageView alloc] init];
        _zxImv.image = [UIImage imageNamed:@"pic_arrow"];
    }
    return _zxImv;
}
-(UIImageView *)fhImv{
    if(!_fhImv){
        _fhImv = [[UIImageView alloc] init];
        _fhImv.image = [UIImage imageNamed:@"pic_jinbi"];
    }
    return _fhImv;
}

-(UIImageView *)xhImv{
    if(!_xhImv){
        _xhImv = [[UIImageView alloc] init];
        _xhImv.image = [UIImage imageNamed:@"pic_xinghao"];
    }
    return _xhImv;
}

-(UILabel *)jeLab{
    if(!_jeLab){
        _jeLab = [[UILabel alloc] init];
        NSString *s =@"";
        _jeLab.text =[NSString stringWithFormat:@"可提金额\n%@元%@",self.infoDict[@"keti"][@"balance"],s] ;
        _jeLab.numberOfLines = 0;
        _jeLab.textColor =[UIColor blackColor];
        _jeLab.textAlignment = NSTextAlignmentCenter;
        _jeLab.font = [UIFont systemFontOfSize:14];
        
    }
    return _jeLab;
}
-(UILabel *)moneyxsLab{
    if(!_moneyxsLab){
        _moneyxsLab = [[UILabel alloc] init];
        _moneyxsLab.text =@"支付" ;
        _moneyxsLab.textColor =[UIColor orangeColor];
        _moneyxsLab.font = [UIFont systemFontOfSize:12];
        
    }
    return _moneyxsLab;
}
-(UILabel *)tsLab{
    if(!_tsLab){
        _tsLab = [[UILabel alloc] init];
        _tsLab.text =@"支行：" ;
        _tsLab.textColor =[UIColor blackColor];
        _tsLab.font = [UIFont systemFontOfSize:16*widthScale];
        
    }
    return _tsLab;
}
-(UILabel *)khhLab
{
    if (!_khhLab) {
        _khhLab = [[UILabel alloc] init];
        _khhLab.text = @"开户行：";
        _khhLab.textColor = [UIColor blackColor];
        _khhLab.font = [UIFont systemFontOfSize:16*widthScale];
    }
    return _khhLab;
}

-(UILabel *)yhkLab{
    if(!_yhkLab){
        _yhkLab = [[UILabel alloc] init];
        NSString *s =@"";
        _yhkLab.text =[NSString stringWithFormat:@"%@\n储蓄卡(%@)%@",bankDict[@"card_name"],[bankDict[@"account"] substringFromIndex:[bankDict[@"account"] length] - 4],s] ;
        _yhkLab.textColor =[UIColor blackColor];
        _yhkLab.numberOfLines = 0;
        _yhkLab.textAlignment = NSTextAlignmentCenter;
        _yhkLab.font = [UIFont systemFontOfSize:14];
        
    }
    return _yhkLab;
}
-(UILabel *)buketiLab{
    if(!_buketiLab){
        _buketiLab = [[UILabel alloc] init];
        _buketiLab.text =[NSString stringWithFormat:@"不可提金额： %.2f元", [self.infoDict[@"buketi"][@"balance"] floatValue]];
        _buketiLab.textColor =[UIColor blackColor];
        _buketiLab.font = [UIFont systemFontOfSize:12];
    }
    return _buketiLab;
}
-(UIView *)Vsx{
    if(!_Vsx){
        _Vsx = [[UIView alloc] init];
        _Vsx.backgroundColor =[UIColor colorWithRed:255/255.0 green:240/255.0 blue:177/255.0 alpha:1/1.0];
        [self.Vsx addSubview:self.sxfLab];
        [self.sxfLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.offset(0);
            make.left.offset(20);
        }];
        
    }
    return _Vsx;
}

-(UILabel *)sxfLab{
    if(!_sxfLab){
        _sxfLab = [[UILabel alloc] init];
        NSString * sxf ;    // 剩余免费提现次数 和 手续费 的显示文本
        if (self.infoDict[@"tixian"][@"ftimescur"] >= self.infoDict[@"tixian"][@"ftimesall"] ) {
            sxf = [NSString stringWithFormat:@"提现手续费：%@元", self.infoDict[@"tixian"][@"fee_f1"] ];
        }else
        {
            sxf = [NSString stringWithFormat:@"每月前%@次申请免手续费，本月剩余免费提现次数:%ld次", self.infoDict[@"tixian"][@"ftimesall"],[self.infoDict[@"tixian"][@"ftimesall"] integerValue] - [self.infoDict[@"tixian"][@"ftimescur"] integerValue]];
        }
        _sxfLab.text = sxf;
        _sxfLab.textColor =[UIColor brownColor];
        _sxfLab.font = [UIFont systemFontOfSize:11];
        
        
    }
    return _sxfLab;
}

-(UIButton *)kezhuanBtn{
    
    if(!_kezhuanBtn){
        _kezhuanBtn = [[UIButton alloc] init];
        [_kezhuanBtn setTitle:@"转可提现" forState:UIControlStateNormal];
        [_kezhuanBtn setTitleColor:lancolor forState:UIControlStateNormal];
        _kezhuanBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];
        [_kezhuanBtn addTarget:self action:@selector(kezhuanBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _kezhuanBtn;
    
}
-(UIButton *)quantiBtn{
    if(!_quantiBtn){
        _quantiBtn = [[UIButton alloc] init];
        [_quantiBtn setTitle:@"全部提现" forState:UIControlStateNormal];
        [_quantiBtn setTitleColor:lancolor forState:UIControlStateNormal];
        _quantiBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];
        [_quantiBtn addTarget:self action:@selector(quantiBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _quantiBtn;
}
-(UIButton *)tixianBtn{
    if(!_tixianBtn){
        _tixianBtn = [[UIButton alloc] init];
        [_tixianBtn setTitle:@"确定提现" forState:UIControlStateNormal];
        [_tixianBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _tixianBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        _tixianBtn.titleLabel.layer.masksToBounds = YES;
        _tixianBtn.layer.cornerRadius =5.0;
        _tixianBtn.backgroundColor = [UIColor redColor];
        [_tixianBtn addTarget:self action:@selector(tixianBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tixianBtn;
}
-(UITextField *)SrkTF{
    if(!_SrkTF){
        _SrkTF = [[UITextField alloc] init];
        _SrkTF.delegate = self;
        _SrkTF.placeholder =[NSString stringWithFormat:@"提现最低限额%@元", self.infoDict[@"tixian"][@"min"]];
        _SrkTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _SrkTF.keyboardType = UIKeyboardTypeDecimalPad;
        _SrkTF.keyboardAppearance=UIKeyboardAppearanceAlert;
        _SrkTF.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16*widthScale];
    }
    return _SrkTF;
}
-(UITextField *)BrhTF{
    if(!_BrhTF){
        _BrhTF = [[UITextField alloc] init];
        _BrhTF.delegate = self;
        _BrhTF.placeholder =[NSString stringWithFormat:@"请务必输入正确的支行名称"];
        _BrhTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _BrhTF.keyboardType = UIKeyboardTypeDefault;
        _BrhTF.returnKeyType = UIReturnKeyDone;
        _BrhTF.keyboardAppearance=UIKeyboardAppearanceAlert;
        _BrhTF.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16*widthScale];
    }
    return _BrhTF;
}
-(UITextField *)KhhTF{
    if(!_KhhTF){
        _KhhTF = [[UITextField alloc] init];
        _KhhTF.placeholder =[NSString stringWithFormat:@"请选择开户行省、市信息 >"];
        [_KhhTF setValue:lancolor forKeyPath:@"_placeholderLabel.textColor"];
        _KhhTF.delegate = self;
        _KhhTF.textAlignment = NSTextAlignmentRight;
        _KhhTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _KhhTF.keyboardType = UIKeyboardTypeDefault;
        _KhhTF.keyboardAppearance=UIKeyboardAppearanceAlert;
        _KhhTF.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16*widthScale];
    }
    return _KhhTF;
}
-(paymentView *)payView
{
    if (!_payView) {
        _payView = [[paymentView alloc] initWithFrame:CGRectMake(0, screen_height-420, screen_width, 420)];
        _payView.tip = @"请输入交易密码";
        __weak typeof(self) weakself = self;
        _payView.textChangeBlock = ^(NSString *text){
            weakself.payPwd = text;
        };
        _payView.frame = CGRectMake(0, screen_height, screen_width, 420);
    }
    return _payView;
}

- (void)setPayPwd:(NSString *)payPwd
{
    _payPwd = payPwd;
    if (payPwd.length == 6) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 提现网络请求
            NSLog(@"%@", payPwd);
            [self.payView endEditing:YES];
//            [MBProgressHUD showHUDAddedTo:self.payView animated:YES];
            [self NetWorkOfWithdraw];
        });
    }
    
}

- (void)NetWorkOfWithdraw
{
    NSMutableDictionary *pass =[NSMutableDictionary dictionary];
    pass[@"uid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"uid"];
    pass[@"sid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"sid"];
    pass[@"at"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"at"];
    pass[@"version"] = @"v1.0.3";
    pass[@"secret"] = @"aodsadhowiqhdwiqs";
    pass[@"app_id"] = @"3";
    pass[@"os"] = @"ios";
    pass[@"branch"] = self.BrhTF.text;
    pass[@"money"] = self.SrkTF.text;
    pass[@"pid"] = _provinceID;
    pass[@"cid"] = _cityid;
    NSString *ljm = [self.payPwd MD5];
    NSString *ms = [NSString stringWithFormat:@"%@%@",ljm,str];
    NSLog(@"%@", ms);
    NSString *xmm = [ms MD5];
    pass[@"paypass"] = xmm;
    pass[@"txtype"] = @"yh";
    NSLog(@"%@?%@", txyhksj, pass);
    [WWZShuju initlizedData:txyhksj paramsdata:pass dicBlick:^(NSDictionary *info) {
        NSLog(@"%@",info);
        if ([info[@"r"] integerValue] == 1) {
//            [TalkingDataAppCpa onPay:[[NSUserDefaults standardUserDefaults]objectForKey:@"uid"] withOrderId:[NSString stringWithFormat:@"yh%@", self.zhmc] withAmount:[self.money intValue] withCurrencyType:@"提现到银行卡" withPayType:@"提现到银行卡"];
//            [MobClick event:@"提现" attributes:@{@"txtype":@"yh", @"money":self.money}];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [MBProgressHUD hideHUDForView:self.payView animated:YES];
                [MBProgressHUD showSuccessMessage:info[@"msg"]];
                [self.payView clear];
                [self.payView closeBtnEvnet];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    zfbczjgViewController *vc = [[zfbczjgViewController alloc]init];
                    vc.classtype = classTwo;
                    vc.infoDict = self.infoDict;
                    vc.zfb = self.Model.zfb;
                    vc.tixianMoney = self.SrkTF.text;
                    [self.navigationController pushViewController:vc animated:YES];
                });
            });
        }else
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD showErrorMessage:info[@"msg"]];
                if ([info[@"msg"] hasPrefix:@"交易密码"]) {
//                    [MBProgressHUD hideHUDForView:self.payView animated:YES];
                    [self.payView clear];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.payView becomeFirstResponder];
                    });
                }else
                {
//                    [MBProgressHUD hideHUDForView:self.payView animated:YES];
                    [self.payView clear];
                    [self.payView closeBtnEvnet];
                }
            });
        }
    }];
}

#pragma mark - PickerAreaDelegate
- (void)pickerArea:(MyAreaPicker *)pickerArea province:(NSString *)province city:(NSString *)city
{
    NSLog(@"%@-%@", province, city);
//    _provinceID = provinceID;
//    _cityid = cityid;
    self.KhhTF.text = [NSString stringWithFormat:@"%@-%@", province, city];
    NSString *path = [[NSBundle mainBundle]pathForResource:@"cityPlist" ofType:@"plist"];
    NSMutableArray * rootArray = [[NSMutableArray alloc] initWithContentsOfFile:path];
//    NSLog(@"%@", rootArray);
    NSMutableArray * cityArray = [[NSMutableArray alloc] init];
    for (NSDictionary * dict in rootArray) {
        if ([dict[@"name"] isEqualToString:province]) {
            cityArray = dict[@"city"];
//            NSLog(@"%@", cityArray);
            for (NSDictionary * subDict in cityArray) {
                if ([subDict[@"name"] isEqualToString:city]) {
                    _provinceID = subDict[@"province"];
                    _cityid = subDict[@"city"];
                }
            }
        }
    }
    NSLog(@"%@-%@", _provinceID, _cityid);
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.KhhTF) {
        [self.view endEditing:YES];
        // 弹出选择框
        _areaPicker = [[MyAreaPicker alloc] init];
        _areaPicker.delegate = self;
        [_areaPicker show];
        return NO;
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.KhhTF) {
        [self.view endEditing:YES];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.BrhTF) {
        [self.view endEditing:YES];
    }
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
