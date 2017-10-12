//
//  PasswordbackViewController.m
//  iOS-CHJF
//
//  Created by garday on 2017/3/27.
//  Copyright © 2017年 garday. All rights reserved.
//

#import "PasswordbackViewController.h"
#import "Passwordback1ViewController.h"
#import "yzBtn.h"
@interface PasswordbackViewController ()<UITextFieldDelegate>
/***<#注释#> ***/
@property (nonatomic ,strong)UIView *Mview;
/***注册的账号 ***/
@property (nonatomic ,strong)UITextField *accountTf;
/***验证码 ***/
@property (nonatomic ,strong)UITextField *VerificationTF;
/***验证码发送 ***/
@property (nonatomic ,strong)yzBtn *VerBtn;
/***<#注释#> ***/
@property (nonatomic ,strong)NSMutableString *str;
@end

@implementation PasswordbackViewController
-(NSMutableString *)str{
    if (!_str) {
        _str = [NSMutableString string];
    }
    return _str;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
    [MobClick beginLogPageView:@"找回密码"];
    [TalkingData trackPageBegin:@"找回密码"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"找回密码"];
    [TalkingData trackPageEnd:@"找回密码"];
}

-(UIView *)Mview{
    if(!_Mview){
        _Mview = [[UIView alloc] init];
        _Mview.backgroundColor = [UIColor whiteColor];
        [_Mview addSubview:self.accountTf];
        [self.accountTf mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(20);make.top.offset(15);
            make.right.offset(-20);
        }];
        UIView *v = [[UIView alloc]init];
        v.backgroundColor =grcolor;
        [_Mview addSubview:v];
        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.offset(0);
            make.height.offset(1);
            make.top.equalTo(self.accountTf.mas_bottom).offset(15);
        }];
        [_Mview addSubview:self.VerificationTF];
        [self.VerificationTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(20);make.top.equalTo(v.mas_bottom).offset(15);
            make.width.offset((self.view.width/2+30)*widthScale);
        }];
        
        [_Mview addSubview:self.VerBtn];
        [self.VerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.VerificationTF.mas_centerY);
            make.right.offset(-19);
        }];
        UIView *v1 = [[UIView alloc]init];
        v1.backgroundColor =lancolor;
        [_Mview addSubview:v1];
        [v1 mas_makeConstraints:^(MASConstraintMaker *make) {
             make.centerY.equalTo(self.VerBtn.mas_centerY);
            make.right.equalTo(self.VerBtn.mas_left).offset(-16);
            make.width.offset(1);
            make.height.offset(19);
        }];

    }
    return _Mview;
}
-(UITextField *)accountTf{
    if(!_accountTf){
        _accountTf = [[UITextField alloc] init];
        _accountTf.backgroundColor = [UIColor whiteColor];
        _accountTf.placeholder = @"输入注册时的手机号码";
        _accountTf.delegate = self;
        _accountTf.keyboardType = UIKeyboardTypeNumberPad;
         [_accountTf addTarget:self action:@selector(TextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _accountTf.clearButtonMode =UITextFieldViewModeAlways;//输入框中是否有个叉号
        //再次编辑就清空
//        _accountTf.clearsOnBeginEditing = YES;
        //首字母是否大写
        _accountTf.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _accountTf.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    }
    return _accountTf;
}

-(UITextField *)VerificationTF{
    if(!_VerificationTF){
        _VerificationTF = [[UITextField alloc] init];
        _VerificationTF.keyboardType = UIKeyboardTypeNumberPad;
        _VerificationTF.backgroundColor = [UIColor whiteColor];
        _VerificationTF.placeholder = @"输入短信验证码";
        _VerificationTF.delegate = self;
//        [_VerificationTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _VerificationTF.clearButtonMode =UITextFieldViewModeAlways;//输入框中是否有个叉号
        //再次编辑就清空
        //        _accountTf.clearsOnBeginEditing = YES;
        //首字母是否大写
        _VerificationTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _VerificationTF.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        
    }
    return _VerificationTF;
}

-(yzBtn *)VerBtn{
    if(!_VerBtn){
        _VerBtn = [[yzBtn alloc] init];
        _VerBtn.backgroundColor = [UIColor whiteColor];
        [_VerBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
        [_VerBtn setTitleColor:lancolor forState:UIControlStateNormal];
        _VerBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        [_VerBtn addTarget:self action:@selector(VerBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _VerBtn;
}
-(void)TextFieldDidChange:(UITextField *)textField
{
    if (textField.text.length ==11) {
        NSMutableDictionary *pramas =[NSMutableDictionary dictionary];
        pramas[@"at"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"at"];
        pramas[@"mobile"] = textField.text;
        [WWZShuju initlizedData:yzsjsfzcurl paramsdata:pramas dicBlick:^(NSDictionary *info) {
            NSLog(@"--------%@",info[@"r"]);
            if ([info[@"r"] isEqualToString:@"1"]) {
                [self showError:@"此号码未注册"];
            }else{
                
            }
            
        }];
        
    }

    
}
-(void)textFieldDidChange:(UITextField *)textField
{
    
    
}

#pragma mark - UITextFieldDelegate
#pragma mark -对输入框的输入内容限制
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"/n"]) {
        return YES;
    }
    NSString *tobestr =[textField.text stringByReplacingCharactersInRange:range withString:string];
    if (self.accountTf == textField) {
        if ( [tobestr length]>=11 ) {
            textField.text = [tobestr substringToIndex:11];
            [self.VerificationTF becomeFirstResponder];
            return NO;
        }
        NSCharacterSet *cs;
        cs = [[NSCharacterSet characterSetWithCharactersInString:Kshuzi] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""]; //按cs分离出数组,数组按@""分离出字符串
        BOOL canChange = [string isEqualToString:filtered];
        if (!canChange) {
            [self showHUD:@"手机号只能是数字噢" de:1.0];
        }
        return  canChange;
        
    }else if(self.VerificationTF == textField){
        if ( [tobestr length]>6 ) {
            textField.text = [tobestr substringToIndex:6];
            [self showHUD:@"验证码最多只有6位数哦" de:1.0];
            //[self showTipView:@"验证码最多只有6位数哦"];
            return NO;
        }
    }
    return YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self Nav];
    [self.view addSubview:self.Mview];
    [self.Mview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.offset(76);
        make.height.offset(100);
    }];
    
    UIButton *PhonebBtn =[[UIButton alloc]init];
    [PhonebBtn setTitle:@"手机验证" forState:UIControlStateNormal];
    [PhonebBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    PhonebBtn.backgroundColor = [UIColor redColor];
    PhonebBtn.layer.masksToBounds = YES;
    PhonebBtn.layer.cornerRadius = 4.0;
    PhonebBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    [PhonebBtn addTarget:self action:@selector(PhonebBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:PhonebBtn];
    [PhonebBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.equalTo(self.Mview.mas_bottom).offset(60);
        make.right.offset(-12);
        make.left.offset(12);
        make.height.offset(45);
    }];

    
    // Do any additional setup after loading the view.
}


-(void)Nav{
    self.view.backgroundColor =grcolor;
    self.navigationItem.title =@"密码找回";
    UIButton *leftbutton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 10, 21)];
    
    [leftbutton setBackgroundImage:[UIImage imageNamed:@"icon_back1"] forState:UIControlStateNormal];
    [leftbutton setBackgroundImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateHighlighted];
    [leftbutton addTarget:self action:@selector(leftbtnclicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftbarbtn=[[UIBarButtonItem alloc]initWithCustomView:leftbutton];
    self.navigationItem.leftBarButtonItem=leftbarbtn;
    
    
    UIButton *rightbutton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 21)];
    
    [rightbutton setBackgroundImage:[UIImage imageNamed:@"icon_tel"] forState:UIControlStateNormal];
    [rightbutton setBackgroundImage:[UIImage imageNamed:@"Page 1"] forState:UIControlStateHighlighted];
    [rightbutton addTarget:self action:@selector(rightbtnclicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightbarbtn=[[UIBarButtonItem alloc]initWithCustomView:rightbutton];
    self.navigationItem.rightBarButtonItem=rightbarbtn;
}

-(void)leftbtnclicked{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rightbtnclicked{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"400-005-6677"];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];

}
-(void)VerBtnClicked{
    if (_accountTf.text.length == 0 || _accountTf.text.length != 11) {
        [self showHUD:@"手机号码不能为空或不正确" de:1.0];
    }else
    {
        [self.VerBtn time]; 
        NSMutableDictionary *pramas = [NSMutableDictionary dictionary];
        pramas[@"mobile"] = self.accountTf.text;
        pramas[@"at"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"at"];
        [WWZShuju initlizedData:zhyzmurl paramsdata:pramas dicBlick:^(NSDictionary *info) {
            if ([info[@"r"] isEqualToString:@"1"]) {
                
            }else{
                [self showError:info[@"msg"]];
            }
            NSLog(@"找回密码获取验证码%@",info);
            
        }];
    }
    
    
}
-(void)PhonebBtnClicked{
    if (_accountTf.text.length == 0 || _accountTf.text.length != 11) {
        [self showHUD:@"手机号码不能为空或不正确" de:1.0];
        return;
    }else if (self.VerificationTF.text.length == 0)
    {
        [self showHUD:@"短信验证码不能为空" de:1.0];
        return;
    }
    NSMutableDictionary *pramas = [NSMutableDictionary dictionary];
    pramas[@"mobile"] = self.accountTf.text;
    pramas[@"verycode"] = self.VerificationTF.text;
    pramas[@"at"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"at"];
    [WWZShuju initlizedData:yzsjyzmurl paramsdata:pramas dicBlick:^(NSDictionary *info) {
        NSLog(@"%@",info);
         NSLog(@"%@",info[@"msg"]);
        if ([info[@"r"] isEqualToString:@"1"]) {
            Passwordback1ViewController *sv = [[Passwordback1ViewController alloc]init];
            sv.mobilestr =self.accountTf.text;
            sv.verycodestr = self.VerificationTF.text;
            [self.navigationController pushViewController:sv animated:YES];

        }else{
            [self showError:info[@"msg"]];
        }
        
    }];
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
