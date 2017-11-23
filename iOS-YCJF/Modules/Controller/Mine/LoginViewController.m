//
//  LoginViewController.m
//  iOS-YCJF
//
//  Created by 姜宁桃 on 2017/8/16.
//  Copyright © 2017年 Yincheng. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "PasswordbackViewController.h"
#import "TabBarViewController.h"

@interface LoginViewController ()<UITextFieldDelegate>

/***返回 ***/
@property (nonatomic ,strong)UIButton *returnBtn;
/***银程logo ***/
@property (nonatomic ,strong)UIImageView *portraitimgV;
/***账号输入 ***/
@property (nonatomic ,strong)UITextField *accountTF;
/***账号图标 ***/
@property (nonatomic ,strong)UIImageView *accountImg;
/***密码输入 ***/
@property (nonatomic ,strong)UITextField *passwordTF;
/***密码图标 ***/
@property (nonatomic ,strong)UIImageView *passwordImg;
/***登入按钮 ***/
@property (nonatomic ,strong)UIButton *LogBtn;
/***注册账号 ***/
@property (nonatomic ,strong)UIButton *registeredBtn;
/***忘记密码 ***/
@property (nonatomic ,strong)UIButton *forgetBtn;
/***银程金服图片 ***/
@property (nonatomic ,strong)UIImageView *chimg;

@end

@implementation LoginViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.navView.hidden = YES;
    [MobClick beginLogPageView:@"登录"];
    [TalkingData trackPageBegin:@"登录"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configUI];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [MobClick endLogPageView:@"登录"];
    [TalkingData trackPageEnd:@"登录"];
}

- (void)configUI
{
    self.backImageView.image = IMAGE_NAMED(@"bg_login");
    [self.view addSubview:self.returnBtn];
    
    [self.view addSubview:self.portraitimgV];
    [self.portraitimgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.equalTo(self.returnBtn.mas_bottom).offset(20);
        make.width.and.height.offset(120*widthScale);
    }];
    
    [self.view addSubview:self.accountImg];
    [self.accountImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(18);
        make.width.offset(18);make.height.offset(24);
        make.top.offset(self.view.height/2);
    }];
    [self.view addSubview:self.accountTF];
    [self.accountTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.accountImg.mas_right).offset(12);
        make.height.offset(24);
        make.top.equalTo(self.accountImg.mas_top);
        make.right.offset(-26);
    }];
    
    [self.view addSubview:self.passwordImg];
    [self.passwordImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(18);
        make.width.offset(18);make.height.offset(24);
        make.top.equalTo(self.accountImg.mas_bottom).offset(50);
    }];
    [self.view addSubview:self.passwordTF];
    [self.passwordTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.passwordImg.mas_right).offset(12);
        make.height.offset(24);
        make.top.equalTo(self.passwordImg.mas_top);
        make.right.offset(-26);
    }];
    
    UIView *V1= [[UIView alloc]init];
    V1.backgroundColor = grcolor;
    [self.view addSubview:V1];
    [V1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(11);make.right.offset(-11);
        make.top.equalTo(self.accountImg.mas_bottom).offset(5);
        make.height.offset(2);
    }];
    
    
    UIView *V2= [[UIView alloc]init];
    V2.backgroundColor = grcolor;
    [self.view addSubview:V2];
    [V2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(11);make.right.offset(-11);
        make.top.equalTo(self.passwordImg.mas_bottom).offset(5);
        make.height.offset(2);
    }];
    
    [self.view addSubview:self.LogBtn];
    [self.LogBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(13); make.right.offset(-13);
        make.top.equalTo(V2.mas_bottom).offset(35);
        make.height.offset(45);
    }];
    
    UIView *V3= [[UIView alloc]init];
    V3.backgroundColor = lancolor;
    [self.view addSubview:V3];
    [V3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.LogBtn.mas_bottom).offset(32);
        make.centerX.offset(0);
        make.width.offset(2); make.height.offset(18);
    }];
    
    [self.view addSubview:self.registeredBtn];
    [self.registeredBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.top.equalTo(self.LogBtn.mas_bottom).offset(30);
        make.centerY.equalTo(V3.mas_centerY);
        make.right.equalTo(V3.mas_left).offset(-18);
    }];
    
    [self.view addSubview:self.forgetBtn];
    [self.forgetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(V3.mas_centerY);
        make.left.equalTo(V3.mas_right).offset(18);
    }];
    
    [self.view addSubview:self.chimg];
    [self.chimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.bottom.offset(-12);
        make.width.offset(110*widthScale);
        make.height.offset(30*heightScale);
    }];

}

#pragma mark - Event Hander
-(void)returnBtnClicked{
    KPostNotification(KNotificationRefreshMineDatas, nil);
    if ([self.isTurnToTabVC isEqualToString:@"YES"]) {
        AppDelegateInstance.window.rootViewController = [[TabBarViewController alloc] init];
    }else
    {
        if (self.presentingViewController) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)returnBtnEvent
{
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)registeredBtnClicked{
    RegisterViewController *vc = [[RegisterViewController alloc]init];
    vc.tel = self.accountTF.text;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)forgetBtnClicked{
    PasswordbackViewController *vc = [[PasswordbackViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)LogBtnClicked{
    
    if (self.accountTF.text.length ==0 ||self.passwordTF.text.length ==0 ) {
        [self showError:@"请输入手机号码或密码"];
    }else if ( [self.accountTF.text characterAtIndex:0] != '1'){
        [self showError:@"请输入正确的手机号码"];
    }else if(self.accountTF.text.length < 11 ||self.accountTF.text.length >11){
        [self showError:@"请输入正确的手机号码"];
    }else if(self.passwordTF.text.length < 6){
        [self showError:@"密码必须8位以上16位以下"];
    }
    
    else {
        
        NSMutableDictionary *paramss = [NSMutableDictionary dictionary];
        paramss[@"username"] =self.accountTF.text;
        paramss[@"at"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"at"];
        [MBProgressHUD showActivityMessageInWindow:@"正在获取加密信息"];
        [WWZShuju initlizedData:jmurl paramsdata:paramss dicBlick:^(NSDictionary *info) {
            NSLog(@"加密%@",info);
            [[NSUserDefaults standardUserDefaults]setObject:info[@"sid"] forKey:@"sid"];
            [[NSUserDefaults standardUserDefaults]setObject:info[@"salt"] forKey:@"salt"];
            [[NSUserDefaults standardUserDefaults]setObject:info[@"cd"] forKey:@"cd"];
            [UserDefaults synchronize];
            [self LogBtnNetWork];
            
        }];
        
    }
}

- (void)LogBtnNetWork{
    [MBProgressHUD showActivityMessageInWindow:@"正在登录，请稍候"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"at"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"at"];
    params[@"sid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"sid"];
    params[@"username"] =self.accountTF.text;
    // 数据MD5加密
    NSString * str = [self.passwordTF.text MD5];
    NSString *salt =  [NSString stringWithFormat:@"%@%@",str,[[NSUserDefaults standardUserDefaults]objectForKey:@"salt"]];
    NSString *str1 = [salt MD5];
    NSString *cd = [NSString stringWithFormat:@"%@%@",str1,[[NSUserDefaults standardUserDefaults]objectForKey:@"cd"]];
    NSString *str2 = [cd MD5];
    params[@"password"] = str2;
    NSLog(@"%@?%@",drurl, params);
    [WWZShuju initlizedData:drurl paramsdata:params dicBlick:^(NSDictionary *info) {
        NSLog(@"-----2---------%@",info[@"ifxs"]);
        [MBProgressHUD hideHUD];
        NSLog(@"%@------%@",str2,[[NSUserDefaults standardUserDefaults]objectForKey:@"cd"]);
        
        
        
        if ([info[@"r"] isEqualToNumber:@0]) {
            
            //加密
            NSString *temp = info[@"msg"];
            NSLog(@"%@", temp);
            if ([temp containsString:@"密码"]||[temp containsString:[@"密码" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]) {
                [self showError:info[@"msg"]];
                return ;
            }else if([temp hasPrefix:@"用户不存在"])
            {
                [self showError1:@"该号码尚未注册，请立即前往注册"];
            }else
            {
                [self showHUD:temp de:2.0];
            }
            
        }else{
            // 绑定信鸽帐号
            [XGPush registerDevice:[UserDefaults objectForKey:KDeviceToken] successCallback:^{
                // 绑定信鸽帐号
                [XGPush setAccount:self.accountTF.text successCallback:^{
                    // 成功
                    NSLog(@"绑定信鸽帐号成功");
                } errorCallback:^{
                    // 失败
                    NSLog(@"绑定信鸽帐号失败");
                }];
            } errorCallback:^{
                NSLog(@"注册页面--注册信鸽推送失败！");
            }];
            
            [UserDefaults setObject:self.accountTF.text forKey:KAccount];
            [UserDefaults setObject:self.passwordTF.text forKey:self.accountTF.text];
            [UserDefaults setObject:info[@"item"][@"uid"] forKey:@"uid"];
            [UserDefaults setObject:info[@"ifxs"] forKey:KIs_xs];
            [UserDefaults setObject:info[@"item"][@"is_defaultpaypass"] forKey:KIs_defaultpaypass];
            [UserDefaults setObject:@"1" forKey:KSecurytyshow];
            
            [UserDefaults synchronize];
            NSLog(@" uid =%@, tel=%@", [UserDefaults objectForKey:@"uid"], [UserDefaults objectForKey:KAccount]);
            if ([NSString judueIPhonePlatformSupportTouchID] && [[UserDefaults objectForKey:KGestureLock] isEqualToString:@"2"])
            {
                [self AlertWithTitle:@"提示" message:@"登录成功！是否立即打开指纹解锁？" andOthers:@[@"下次再说", @"立即开启"] animated:YES action:^(NSInteger index) {
                    if (index == 0) {
                        //
                        NSLog(@"您的设置硬件暂时不支持指纹识别");
                        [[NSUserDefaults standardUserDefaults]setObject:@"2" forKey:KTouchLock];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            
                            [self returnBtnClicked];
                        });
                    }else if (index ==1){
                        // 显示指纹验证提示框
                        [self startTouchIDWithPolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics];
                    }
                }];
            }
            else
            {
                NSLog(@"您的设置硬件暂时不支持指纹识别");
                [[NSUserDefaults standardUserDefaults]setObject:@"2" forKey:KTouchLock];
                [[NSUserDefaults standardUserDefaults] synchronize];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [self returnBtnClicked];
                });
            }
            
        }
        
        
    }];
    
}

- (void)startTouchIDWithPolicy:(LAPolicy )policy{
    
    LAContext *context = [[LAContext alloc]init];//使用 new 不会给一些属性初始化赋值
    
    context.localizedFallbackTitle = @"暂不开启";//@""可以不让 feedBack 按钮显示
    //LAPolicyDeviceOwnerAuthenticationWithBiometrics
    [context evaluatePolicy:policy localizedReason:@"请验证已有指纹来开启指纹解锁" reply:^(BOOL success, NSError * _Nullable error) {
        
        //SVProgressHUD dismiss 需要 0.15才会消失;所以dismiss 后进行下一步操作;但是0.3是适当延长时间;留点余量
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            if (success)
            {
                NSLog(@"指纹识别成功");
                // 指纹识别成功，回主线程更新UI
                dispatch_async(dispatch_get_main_queue(), ^{
                    //成功操作--马上调用纯指纹验证方法
                    
                    if (policy == LAPolicyDeviceOwnerAuthentication)
                    {
                        [self startTouchIDWithPolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics];
                    }
                    else
                    {
                        [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:KTouchLock];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        [self showHUD:@"开启指纹解锁成功" de:1.5];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self returnBtnClicked];
                        });
                    }
                });
            }
            
            if (error) {
                //指纹识别失败，回主线程更新UI
                NSLog(@"指纹识别成功");
                dispatch_async(dispatch_get_main_queue(), ^{
                    //失败操作
//                    [self handelWithError:error];
                    [[NSUserDefaults standardUserDefaults]setObject:@"2" forKey:KTouchLock];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    [self showError1:@"指纹验证失败！您可以稍后进入安全中心来开启指纹解锁。"];
                });
            }
        });
    }];
    
}



/**
 处理错误数据
 
 @param error 错误信息
 */
- (void)handelWithError:(NSError *)error{
    
    if (error) {
        
        NSLog(@"%@",error.domain);
        NSLog(@"%zd",error.code);
        NSLog(@"%@",error.userInfo[@"NSLocalizedDescription"]);
        
        LAError errorCode = error.code;
        switch (errorCode) {
                
            case LAErrorTouchIDLockout: {
                //touchID 被锁定--ios9才可以
                
                [self handleLockOutTypeAliPay];
                
                
                break;
            }
            case LAErrorPasscodeNotSet:
            {
                NSLog(@"系统未设置密码");
                [self returnBtnClicked];
                break;
            }
            case LAErrorTouchIDNotAvailable:
            {
                NSLog(@"设备Touch ID不可用，例如未打开");
                [self returnBtnClicked];
                break;
            }
            case LAErrorTouchIDNotEnrolled:
            {
                NSLog(@"设备Touch ID不可用，用户未录入");
                [self returnBtnClicked];
                break;
            }
                
            default:
                [[NSUserDefaults standardUserDefaults]setObject:@"2" forKey:KTouchLock];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [self showError1:@"指纹验证失败！您可以稍后进入安全中心来开启指纹解锁。"];
                break;
        }
    }
}

- (void)handleLockOutTypeAliPay{
    //开启验证--调用非全指纹指纹验证
    [self startTouchIDWithPolicy:LAPolicyDeviceOwnerAuthentication];
}

#pragma mark - UITextFieldDelegate
#pragma mark -对输入框的输入内容限制
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"/n"]) {
        return YES;
    }
    NSString *tobestr =[textField.text stringByReplacingCharactersInRange:range withString:string];
    if (self.accountTF == textField) {
        if ( [tobestr length]>=11 ) {
            textField.text = [tobestr substringToIndex:11];
            [self.passwordTF becomeFirstResponder];
            //        [self showHUD:@"亲，手机号码只有11位数哦" de:1];
            //        [self showError:@"亲，手机号码只有11位数哦"];
            return NO;
        }
        NSCharacterSet *cs;
        cs = [[NSCharacterSet characterSetWithCharactersInString:Kshuzi] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""]; //按cs分离出数组,数组按@""分离出字符串
        BOOL canChange = [string isEqualToString:filtered];
        if (!canChange) {
            [self showError:@"手机号只能是数字噢"];
        }
        return  canChange;
        
    }else{
        if ( [tobestr length]>16 ) {
            textField.text = [tobestr substringToIndex:16];
            [self showError:@"亲，密码最大只能16位数哦"];
            return NO;
        }
        NSCharacterSet *cs;
        cs = [[NSCharacterSet characterSetWithCharactersInString:kAlphaNum] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""]; //按cs分离出数组,数组按@""分离出字符串
        BOOL canChange = [string isEqualToString:filtered];
        if (!canChange) {
            [self showError:@"密码只能设置字母和数字"];
        }
        return  canChange;
        
    }
    return YES;
}

#pragma mark -对于键盘设置输入框之间的跳转
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    BOOL retValue = NO;
    if (textField == self.accountTF)//当是 “手机号码”输入框时
    {
        if ([textField.text length]  == 11)//输入的号码完整时
        {
            [self.passwordTF becomeFirstResponder];// “密码”输入框 作为 键盘的第一 响应者，光标 进入此输入框中
            retValue = NO;
        }
    }
    else
    {
        [self.passwordTF resignFirstResponder];//如果 现在 是 第二个输入框，那么 键盘 隐藏
        [self.LogBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
    return retValue;
    
    
}

#pragma mark - 提示框
-(void)showError:(NSString *)error
{
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:error preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *av = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        self.passwordTF.text =@"";
    }];
    [ac addAction:av];
    [self presentViewController:ac animated:YES completion:nil];
    
}

-(void)showError1:(NSString *)error
{
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:error preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *av = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if ([error isEqualToString:@"你的指纹信息发生变更，请直接使用帐号密码登录"]) {
            
        }else if ([error isEqualToString:@"该号码尚未注册，请立即前往注册"]){
            [self registeredBtnClicked];
        }else{
            
            [self returnBtnClicked];
        }
    }];
    [ac addAction:av];
    [self presentViewController:ac animated:YES completion:nil];
    
}




#pragma mark - Getter
-(UIButton *)returnBtn{
    if (!_returnBtn) {
        _returnBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 30, 29.7, 29.7)];
        [_returnBtn setImage:[UIImage imageNamed:@"icon_close"] forState:UIControlStateNormal];
        [_returnBtn addTarget:self action:@selector(returnBtnEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _returnBtn;
}

-(UIImageView *)portraitimgV{
    if (!_portraitimgV) {
        _portraitimgV = [[UIImageView alloc]init];
        _portraitimgV.image = [UIImage imageNamed:@"pic"];
        _portraitimgV.layer.masksToBounds = YES;
        _portraitimgV.layer.cornerRadius =60.0*widthScale;
    }
    return _portraitimgV;
}

-(UIImageView *)accountImg{
    if (!_accountImg) {
        _accountImg = [[UIImageView alloc]init];
        _accountImg.image = [UIImage imageNamed:@"pic_sjhm"];
    }
    return _accountImg;
}

-(UITextField *)accountTF{
    if (!_accountTF) {
        _accountTF = [[UITextField alloc]init];
        _accountTF.returnKeyType = UIReturnKeyNext;
        _accountTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _accountTF.placeholder = @"请输入注册时的手机号码";
        _accountTF.text = [UserDefaults objectForKey:KAccount];
        _accountTF.keyboardType = UIKeyboardTypeNumberPad;
        _accountTF.clearButtonMode = UITextFieldViewModeAlways;
        //_accountTF.keyboardAppearance=UIKeyboardAppearanceAlert;//键盘样式
        _accountTF.delegate = self;
        //        _accountTF.keyboardType = UIKeyboardTypeNumberPad;//纯数字键盘
        _accountTF.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        
    }
    return _accountTF;
}

-(UIImageView *)passwordImg{
    if (!_passwordImg) {
        _passwordImg = [[UIImageView alloc]init];
        _passwordImg.image = [UIImage imageNamed:@"pic_mima"];
        
    }
    return _passwordImg;
}

-(UITextField *)passwordTF{
    if (!_passwordTF) {
        _passwordTF = [[UITextField alloc]init];
        _passwordTF.placeholder = @"请输入用户密码";
//        _passwordTF.text = [UserDefaults objectForKey:KAccount]?[UserDefaults objectForKey:[UserDefaults objectForKey:KAccount]]:nil;
        _passwordTF.returnKeyType = UIReturnKeyDone ;
        _passwordTF.clearButtonMode = UITextFieldViewModeAlways;
        _passwordTF.delegate = self;
        _passwordTF.secureTextEntry = YES;
        _passwordTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
        //        _passwordTF.keyboardAppearance=UIKeyboardAppearanceAlert;//键盘样式
        //        _passwordTF.keyboardType = UIKeyboardTypeNumberPad;//纯数字键盘
        _passwordTF.keyboardType = UIKeyboardTypeDefault;
        _passwordTF.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        
    }
    return _passwordTF;
}

-(UIButton *)LogBtn{
    if(!_LogBtn){
        _LogBtn = [[UIButton alloc] init];
        [_LogBtn setTitle:@"登录" forState:UIControlStateNormal];
        [_LogBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _LogBtn.backgroundColor = lancolor;
        _LogBtn.layer.masksToBounds = YES;
        _LogBtn.layer.cornerRadius = 4.0;
        _LogBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        [_LogBtn addTarget:self action:@selector(LogBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _LogBtn;
}
-(UIButton *)registeredBtn{
    if(!_registeredBtn){
        _registeredBtn = [[UIButton alloc] init];
        [_registeredBtn setTitle:@"注册账号" forState:UIControlStateNormal];
        [_registeredBtn setTitleColor:lancolor forState:UIControlStateNormal];
        _registeredBtn.backgroundColor = [UIColor whiteColor];
        _registeredBtn.titleLabel.font =  [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        [_registeredBtn addTarget:self action:@selector(registeredBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registeredBtn;
}
-(UIButton *)forgetBtn{
    if(!_forgetBtn){
        _forgetBtn = [[UIButton alloc] init];
        [_forgetBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
        [_forgetBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _forgetBtn.backgroundColor = [UIColor whiteColor];
        _forgetBtn.titleLabel.font =  [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        [_forgetBtn addTarget:self action:@selector(forgetBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _forgetBtn;
}
-(UIImageView *)chimg{
    if(!_chimg){
        _chimg = [[UIImageView alloc] init];
        _chimg.image = [UIImage imageNamed:@"logo"];
        
    }
    return _chimg;
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
