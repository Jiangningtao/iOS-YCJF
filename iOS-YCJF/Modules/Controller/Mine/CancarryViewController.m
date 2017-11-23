//
//  CancarryViewController.m
//  iOS-CHJF
//
//  Created by garday on 2017/4/14.
//  Copyright © 2017年 garday. All rights reserved.
//

#import "CancarryViewController.h"
#import "paymentView.h"
#import "ModiPwdViewController.h"
#import "FindBackPayPwdViewController.h"

@interface CancarryViewController ()<UITextFieldDelegate>
{
    NSString * str;
    CGFloat rate;
    CGFloat shouxufei;
}

/***不可提余额 ***/
@property (nonatomic ,strong)UILabel *jinelab;
/***<#注释#> ***/
@property (nonatomic ,strong)UIButton *ketiBtn;
/***转可提余额 ***/
@property (nonatomic ,strong)UILabel *zhuanlab;
/***<#注释#> ***/
@property (nonatomic ,strong)UIButton *quanketiBtn;
/***<#注释#> ***/
//@property (nonatomic ,strong)UILabel *shouxuLab;
/***<#注释#> ***/
@property (nonatomic ,strong)UITextField *jinetextTF;

@property (nonatomic, strong) paymentView * payView;
@property (nonatomic, copy) NSString *payPwd;

@end

@implementation CancarryViewController
//-(UILabel *)shouxuLab{
//    if(!_shouxuLab){
//        _shouxuLab = [[UILabel alloc] init];
//        _shouxuLab.text = [NSString stringWithFormat:@"转可提手续费：%@元", shouxufei];
//        _shouxuLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];
//        _shouxuLab.textColor = [UIColor colorWithRed:178/255.0 green:178/255.0 blue:178/255.0 alpha:1/1.0];
//        
//    }
//    return _shouxuLab;
//}
-(UIButton *)ketiBtn{
    if(!_ketiBtn){
        _ketiBtn = [[UIButton alloc] init];
        [_ketiBtn setTitle:@"确定转可提" forState:UIControlStateNormal];
        [_ketiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _ketiBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        _ketiBtn.titleLabel.layer.masksToBounds = YES;
        _ketiBtn.layer.cornerRadius =5.0;
        _ketiBtn.backgroundColor = [UIColor redColor];
        [_ketiBtn addTarget:self action:@selector(tixianBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _ketiBtn;
}
-(UILabel *)jinelab{
    if(!_jinelab){
        _jinelab = [[UILabel alloc] init];
        _jinelab.text =[NSString stringWithFormat:@"%.2f", [self.money floatValue]];
        _jinelab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        
    }
    return _jinelab;
}
-(UIButton *)quanketiBtn{
    if(!_quanketiBtn){
        _quanketiBtn = [[UIButton alloc] init];
        [_quanketiBtn setTitle:@"全部转可提" forState:UIControlStateNormal];
        [_quanketiBtn setTitleColor:lancolor forState:UIControlStateNormal];
        _quanketiBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];
        [_quanketiBtn addTarget:self action:@selector(kezhuanBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _quanketiBtn;
}
-(UITextField *)jinetextTF{
    if(!_jinetextTF){
        _jinetextTF = [[UITextField alloc] init];
        _jinetextTF = [[UITextField alloc] init];
        _jinetextTF.placeholder =@"请输入金额";
        _jinetextTF.delegate = self;
        _jinetextTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _jinetextTF.keyboardType = UIKeyboardTypeDecimalPad;
        _jinetextTF.keyboardAppearance=UIKeyboardAppearanceAlert;
        _jinetextTF.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        
    }
    return _jinetextTF;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    shouxufei = 0.00;
    [self AFN];
    self.title =@"不可提转可提";
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
    [self Nav];
    [self layout];
    // Do any additional setup after loading the view.
}
-(void)layout{
    UILabel *yeLab = [[UILabel alloc]init];
    yeLab.text = @"不可提余额";
    yeLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    [self.view addSubview:yeLab];
    [yeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(21);
        make.top.offset(17+66);
    }];
    
    [self.view addSubview:self.jinelab];
    [self.jinelab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(yeLab.mas_centerY);
        make.right.offset(-17);
    }];
    
    UIView *xuxian = [[UIView alloc]init];
    xuxian.backgroundColor = grcolor;
    [self.view addSubview:xuxian];
    [xuxian mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(yeLab.mas_bottom).offset(17);
        make.height.offset(2);
    }];
    
    
    UILabel *kjLab = [[UILabel alloc]init];
    kjLab.text = @"转可提金额";
    kjLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    [self.view addSubview:kjLab];
    [kjLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(21);
        make.top.equalTo(xuxian.mas_bottom).offset(17);
        
    }];
    
    [self.view addSubview:self.jinetextTF];
    [self.jinetextTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(kjLab.mas_left);
        make.top.equalTo(kjLab.mas_bottom).offset(20);
        make.height.offset(25);
        make.width.offset(self.view.width*2/3);
    }];
    
    [self.view addSubview:self.quanketiBtn];
    [self.quanketiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-20);
        make.centerY.equalTo(_jinetextTF.mas_centerY);
    }];
    UIView *xu =[[UIView alloc]init];
    xu.backgroundColor =[UIColor lightGrayColor];
    [self.view addSubview:xu];
    [xu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(2);
        make.height.offset(20);
        make.centerY.equalTo(_jinetextTF.mas_centerY);
        make.right.equalTo(self.quanketiBtn.mas_left).offset(-8);
    }];
    UIImageView *img =[[ UIImageView alloc]init];
    img.image = [UIImage imageNamed:@"line"];
    [self.view addSubview:img];
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(self.quanketiBtn.mas_bottom).offset(15);
        make.height.offset(4);
        
        
    }];
    
//    [self.view addSubview:self.shouxuLab];
//    [self.shouxuLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.offset(21);
//        make.top.equalTo(img.mas_bottom).offset(12);
//        
//    }];
    
    [self.view addSubview:self.ketiBtn];
    [self.ketiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.right.offset(-10);
        make.centerX.offset(0);
        make.height.offset(45);
        make.centerY.offset(0);
    }];
    
    
    UIButton *alertbtn = [[UIButton alloc]init];
    [alertbtn setImage:[UIImage imageNamed:@"Group 6"] forState:UIControlStateNormal];
    [alertbtn setTitleColor:[UIColor colorWithRed:195/255.0 green:195/255.0 blue:195/255.0 alpha:1/1.0] forState:UIControlStateNormal];
    [alertbtn setTitle:@"投资有风险 理财需谨慎" forState:UIControlStateNormal];
    alertbtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:alertbtn];
    [alertbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.bottom.offset(-20);
    }];

    
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

-(void)tixianBtnClicked{
    
    NSLog(@"%@  %@", self.jinetextTF.text, self.money);
    if ([self.jinetextTF.text floatValue] > 0) {
        if ([self.jinetextTF.text floatValue] <= shouxufei) {
            // 转可提余额 小于 2块  不可进行转可提操作
            [self showError:[NSString stringWithFormat:@"转可提金额必须大于手续费(%.2f元), 详情请查看提现说明", shouxufei]];
        }else{
            if ([self.jinetextTF.text floatValue] >  [self.money floatValue]) {
                [self showError:[NSString stringWithFormat:@"转可提金额不能大于不可提余额"]];
            }else
            {
                [self.view addSubview:self.payView];
                [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    _payView.frame = CGRectMake(0, screen_height-CHPasswordViewH, screen_width, CHPasswordViewH);
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
        [self showError:@"转可提金额不正确或不能为空"];
    }

}

-(paymentView *)payView
{
    if (!_payView) {
        _payView = [[paymentView alloc] initWithFrame:CGRectMake(0, screen_height-CHPasswordViewH, screen_width, CHPasswordViewH)];
        _payView.tip = @"请输入交易密码";
        __weak typeof(self) weakself = self;
        _payView.textChangeBlock = ^(NSString *text){
            weakself.payPwd = text;
        };
        _payView.frame = CGRectMake(0, screen_height, screen_width, CHPasswordViewH);
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
    pass[@"os"] = @"ios";
    pass[@"money"] = self.jinetextTF.text;
    NSString *ljm = [self.payPwd MD5];
    NSString *ms = [NSString stringWithFormat:@"%@%@",ljm,str];
    NSLog(@"%@", ms);
    NSString *xmm = [ms MD5];
    pass[@"paypass"] = xmm;
    pass[@"txtype"] = @"yh";
    NSLog(@"%@?%@", bktzkt, pass);
    [WWZShuju initlizedData:bktzkt paramsdata:pass dicBlick:^(NSDictionary *info) {
        NSLog(@"%@",info);
        if ([info[@"r"] integerValue] == 1) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD showSuccessMessage:info[@"msg"]];
                [self.payView clear];
                [self.payView closeBtnEvnet];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    KPostNotification(KNotificationRefreshMineDatas, nil);
                    [self.navigationController popToRootViewControllerAnimated:YES];
                });
            });
        }else
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD showErrorMessage:info[@"msg"]];
                if ([info[@"msg"] hasPrefix:@"交易密码"]) {
                    [self.payView clear];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.payView becomeFirstResponder];
                    });
                }else
                {
                    [self.payView clear];
                    [self.payView closeBtnEvnet];
                }
            });
        }
    }];
}

-(void)Nav{
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *leftbutton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 10, 19)];
    
    [leftbutton setBackgroundImage:[UIImage imageNamed:@"icon_back1"] forState:UIControlStateNormal];
    [leftbutton setBackgroundImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateHighlighted];
    [leftbutton addTarget:self action:@selector(leftbtnclicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftbarbtn=[[UIBarButtonItem alloc]initWithCustomView:leftbutton];
    self.navigationItem.leftBarButtonItem=leftbarbtn;
}

-(void)leftbtnclicked{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rightbtnclicked{
    
}

-(void)kezhuanBtnClicked{
    self.jinetextTF.text = self.money;
}

#pragma mark - 提示框
-(void)showError:(NSString *)error
{
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:error preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *av = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [ac addAction:av];
    [self presentViewController:ac animated:YES completion:nil];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSLog(@"tf %@  s %@", textField.text, string);
    
    return YES;
}

//- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
//{
//    shouxufei = rate*[textField.text floatValue];
//    self.shouxuLab.text = [NSString stringWithFormat:@"转可提手续费：%.2f元", rate*[textField.text floatValue]];
//    return YES;
//}

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
