//
//  yhkczViewController.m
//  iOS-CHJF
//
//  Created by garday on 2017/3/23.
//  Copyright © 2017年 garday. All rights reserved.
//

#import "yhkczViewController.h"
//#import "czView.h"
//#import "ChargeResultController.h"
#import <LLPaySdk.h>
@interface yhkczViewController ()<LLPaySdkDelegate>
{
    NSDictionary * _infoDict;
    NSString * urlStr;
}
/***金额Imgview ***/
@property (nonatomic ,strong)UIImageView *jeImv;
/***银行Imgview ***/
@property (nonatomic ,strong)UIImageView *yhImv;
@property (nonatomic ,strong)UIImageView *zxImv;
@property (nonatomic ,strong)UIImageView *fhImv;

/***<#注释#> ***/
@property (nonatomic ,strong)UILabel *jeLab;
@property (nonatomic ,strong)UILabel *moneyxsLab;
@property (nonatomic ,strong)UILabel *yhkLab;
@property (nonatomic ,strong)UILabel *sxfLab;
/***<#注释#> ***/
@property (nonatomic ,strong)UILabel *czxeLab;
/***<#注释#> ***/
@property (nonatomic ,strong)UIView *Vsx;

/***<#注释#> ***/
@property (nonatomic ,strong)UILabel *gzrLab;



/***充值 ***/


@property (nonatomic ,strong)UIButton *chongzhiBtn;




/***输入框 ***/
@property (nonatomic ,strong)UITextField *SrkTF;
@end



@implementation yhkczViewController

-(UILabel *)gzrLab{
    if(!_gzrLab){
        _gzrLab = [[UILabel alloc] init];
        _gzrLab.text = @"银行充值十分钟内到账";
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
        _yhImv.image = [UIImage imageNamed:self.bankImgName];
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

-(UILabel *)jeLab{
    if(!_jeLab){
        _jeLab = [[UILabel alloc] init];
        NSString *s =@"";
        _jeLab.text =[NSString stringWithFormat:@"我的账户\n(%@)%@",self.accModel.ky_account,s] ;
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
-(UILabel *)yhkLab{
    if(!_yhkLab){
        _yhkLab = [[UILabel alloc] init];
        NSString *s =@"";
        NSString * n = [self.bankNumber substringFromIndex:[self.bankNumber length] - 4];
        _yhkLab.text =[NSString stringWithFormat:@"%@\n储蓄卡(%@)%@",self.bankName,n,s] ;
        _yhkLab.textColor =[UIColor blackColor];
        _yhkLab.numberOfLines = 0;
        _yhkLab.textAlignment = NSTextAlignmentCenter;
        _yhkLab.font = [UIFont systemFontOfSize:14];
        
    }
    return _yhkLab;
}
-(UILabel *)czxeLab{
    if(!_czxeLab){
        _czxeLab = [[UILabel alloc] init];
        NSDictionary * bankDict = _infoDict[@"bankList"][0];
        NSLog(@"%@", bankDict[@"limit"]);
        _czxeLab.text =[@"充值限额：" stringByAppendingString:bankDict[@"limit"]];
        //_czxeLab.text =@"充值限额：每日上限，具体以所属银行为准";
        _czxeLab.textColor =[UIColor blackColor];
        _czxeLab.textColor = [UIColor colorWithRed:178/255.0 green:178/255.0 blue:178/255.0 alpha:1/1.0];
        _czxeLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13*widthScale];
    }
    return _czxeLab;
}
-(UIView *)Vsx{
    if(!_Vsx){
        _Vsx = [[UIView alloc] init];
        _Vsx.backgroundColor =grcolor;
       
        
    }
    return _Vsx;
}

-(UIButton *)chongzhiBtn{
    if(!_chongzhiBtn){
        _chongzhiBtn = [[UIButton alloc] init];
        [_chongzhiBtn setTitle:@"充值" forState:UIControlStateNormal];
        [_chongzhiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _chongzhiBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        _chongzhiBtn.titleLabel.layer.masksToBounds = YES;
        _chongzhiBtn.layer.cornerRadius =5.0;
        _chongzhiBtn.backgroundColor = [UIColor redColor];
        [_chongzhiBtn addTarget:self action:@selector(chongzhiBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _chongzhiBtn;
}
-(UITextField *)SrkTF{
    if(!_SrkTF){
        _SrkTF = [[UITextField alloc] init];
        _SrkTF.placeholder =@"建议充值金额100元以上";
        _SrkTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _SrkTF.keyboardType = UIKeyboardTypeDecimalPad;
        _SrkTF.keyboardAppearance=UIKeyboardAppearanceAlert;
        _SrkTF.font = [UIFont fontWithName:@"PingFangSC-Regular" size:22];
    }
    return _SrkTF;
}
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
    [self.view addSubview:self.yhImv];
    [self.yhImv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(47);
        make.top.offset(17);
        make.width.height.offset(50);
    }];
    [self.view addSubview:self.yhkLab];
    [self.yhkLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.yhImv.mas_centerX);
        make.top.equalTo(self.yhImv.mas_bottom).offset(7);
    }];
    
    //银行
    [self.view addSubview:self.jeImv];
    [self.jeImv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-47);
        make.top.offset(17);
        make.width.offset(50);
        make.height.offset(50);
    }];
    [self.view addSubview:self.jeLab];
    [self.jeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.jeImv.mas_centerX);
        make.top.equalTo(self.jeImv.mas_bottom).offset(7);
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
    
    
    
    [self.view addSubview:self.Vsx];
    [self.Vsx mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.height.offset(1);
        make.top.equalTo(self.yhkLab.mas_bottom).offset(16);
    }];
    
    
    [self.view addSubview:self.fhImv];
    [self.fhImv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.top.equalTo(self.Vsx.mas_bottom).offset(22);
        make.width.height.offset(18);
    }];
    [self.view addSubview:self.SrkTF];
    [self.SrkTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.fhImv.mas_centerY);
        make.left.equalTo(_fhImv.mas_right).offset(10);
        make.right.offset(-20);
    }];
    UIImageView *imgxx = [[UIImageView alloc]init];
    imgxx.image = [UIImage imageNamed:@"line"];
    [self.view addSubview:imgxx];
    [imgxx mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.height.offset(4);
        make.top.equalTo(_fhImv.mas_bottom).offset(10);
    }];
    
    
    [self.view addSubview:self.czxeLab];
    [self.czxeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.fhImv.mas_left);
        make.top.equalTo(imgxx.mas_bottom).offset(7);
    }];
    
    
    
    [self.view addSubview:self.chongzhiBtn];
    [self.chongzhiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.equalTo(self.czxeLab.mas_bottom).offset(38);
        make.left.offset(10);make.right.offset(-10);
        make.height.offset(45);
        
    }];
    
    [self.view addSubview:self.gzrLab];
    [self.gzrLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.equalTo(self.chongzhiBtn.mas_bottom).offset(10);
    }];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];
    
    [self UIlayout];
  
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)chongzhiBtnClicked{
    
    NSLog(@"%@", self.SrkTF.text);
    if ([preUrl hasPrefix:@"http://120.27.211.129"]) {
        // 测试服
        [self showError:@"测试服充值直接找后台修改金额，不走连连"];
    }else
    {
        // 正式服
        if ([self.SrkTF.text floatValue] > 0) {
            NSMutableDictionary *prama = [[NSMutableDictionary alloc] init];
            prama[@"uid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"uid"];
            prama[@"sid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"sid"];
            prama[@"at"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"at"];
            prama[@"version"] = @"v1.0.3";
            prama[@"os"] = @"ios";
            prama[@"terminal_type"] = @"html5";
            prama[@"_sid"] = @"11";
            prama[@"money"] = @"0.01";
            prama[@"card_code"] = self.card_code;
            prama[@"card_no"] = self.bankNumber;
            prama[@"money"] = self.SrkTF.text;
            prama[@"style"] = @"sdk";
            
            NSLog(@"%@?%@", scsmrzurl, prama);
            [WWZShuju initlizedData:scsmrzurl paramsdata:prama dicBlick:^(NSDictionary *info) {
                
                NSLog(@"%@",info);
                NSDictionary * dict = info[@"data"];
                NSLog(@"%@", dict);
                LLPaySdk * paySdk = [LLPaySdk sharedSdk];
                paySdk.sdkDelegate = self;
                [paySdk presentLLPaySDKInViewController:self withPayType:LLPayTypeVerify andTraderInfo:dict];
            }];
        }else
        {
            [self showError:@"充值金额不正确或不能为空"];
        }
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
                                                if ([showMsg isEqualToString:@"支付成功"] || [showMsg isEqualToString:@"成功"]) {
                                                    KPostNotification(KNotificationRefreshMineDatas, nil);
                                                    [self.navigationController popToRootViewControllerAnimated:YES];
                                                }
                                            }]];
    [self presentViewController:alert animated:YES completion:nil];
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
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
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
