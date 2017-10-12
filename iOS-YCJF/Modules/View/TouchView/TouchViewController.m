//
//  TouchViewController.m
//  iOS-YCJF
//
//  Created by 姜宁桃 on 2017/8/24.
//  Copyright © 2017年 Yincheng. All rights reserved.
//

#import "TouchViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import <LocalAuthentication/LAError.h>
#import "LoginViewController.h"
#import "NSString+QDTouchID.h"
#import "TabBarViewController.h"

@interface TouchViewController ()
{
    UIImageView * _logoImgView;
    UILabel * _telLab;
    UIButton * _fingerImgBtn;
    UIButton * _fingerLoginBtn;
    UIButton * _otherLoginBtn;
    LoginViewController * loginVC;
}

@end

@implementation TouchViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //        [self showTouchView];
        if ([NSString judueIPhonePlatformSupportTouchID])
        {
            [self startTouchIDWithPolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics];
            
        }
        else
        {
            NSLog(@"您的设置硬件暂时不支持指纹识别");
        }
    });
}

- (void)startTouchIDWithPolicy:(LAPolicy )policy{
    
    LAContext *context = [[LAContext alloc]init];//使用 new 不会给一些属性初始化赋值
    
    context.localizedFallbackTitle = @"使用帐号密码登录";//@""可以不让 feedBack 按钮显示
    //LAPolicyDeviceOwnerAuthenticationWithBiometrics
    [context evaluatePolicy:policy localizedReason:@"请按home键指纹解锁" reply:^(BOOL success, NSError * _Nullable error) {
        
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
                        NSLog(@"验证成功 刷新主界面");
                        AppDelegateInstance.window.rootViewController = [[TabBarViewController alloc] init];
                    }
                    
                });
            }
            
            if (error) {
                //指纹识别失败，回主线程更新UI
                NSLog(@"指纹识别成功");
                dispatch_async(dispatch_get_main_queue(), ^{
                    //失败操作
                    [self handelWithError:error];
                    
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
            default:
            {
                //                [self fallBackEventWithTitle:context.localizedFallbackTitle];
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    NSLog(@"其他情况，切换主线程处理");
                    [self otherLoginBtnEvent];
                }];
                break;
            }
                
        }
    }
}

/**
 支付宝处理锁定
 */
- (void)handleLockOutTypeAliPay{
    
    //开启验证--调用非全指纹指纹验证
    [self startTouchIDWithPolicy:LAPolicyDeviceOwnerAuthentication];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self configUI];
}

- (void)configUI
{
    _logoImgView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth/2-31, 91*heightScale, 62, 62)];
    _logoImgView.image = [UIImage imageNamed:@"ic_finger_logo"];
    [self.view addSubview:_logoImgView];
    
    _telLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2- 100, _logoImgView.bottom+40*heightScale, 200, 20)];
    NSString *userId =  [[NSUserDefaults standardUserDefaults]objectForKey:KAccount];
    NSString * tel = [NSString stringWithFormat:@"%@****%@", [userId substringToIndex:3], [userId substringFromIndex:7]];
    _telLab.text = tel;
    _telLab.textAlignment = NSTextAlignmentCenter;
    _telLab.font =  [UIFont fontWithName:@"PingFangSC-Medium" size:24];
    _telLab.textColor = color(48, 48, 48, 1);
    [self.view addSubview:_telLab];
    
    _fingerImgBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth/2 - 50, _telLab.bottom+ 95*heightScale, 100, 107)];
    [_fingerImgBtn setImage:[UIImage imageNamed:@"ic_finger_blue"] forState:UIControlStateNormal];
    [_fingerImgBtn addTarget:self action:@selector(showTouchView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_fingerImgBtn];
    
    _fingerLoginBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth/2 - 120, _fingerImgBtn.bottom+ 10*heightScale, 240, 20)];
    [_fingerLoginBtn setTitleColor:lancolor forState:UIControlStateNormal];
    [_fingerLoginBtn setTitle:@"点击指纹进行指纹登录" forState:UIControlStateNormal];
    _fingerLoginBtn.titleLabel.font =  [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    [_fingerLoginBtn addTarget:self action:@selector(showTouchView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_fingerLoginBtn];
    
    _otherLoginBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth/2 - 90, ScreenHeight - 40, 180, 20)];
    [_otherLoginBtn setTitleColor:color(73, 73, 73, 1) forState:UIControlStateNormal];
    [_otherLoginBtn setTitle:@"更换登录方式" forState:UIControlStateNormal];
    _otherLoginBtn.titleLabel.font =  [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    [_otherLoginBtn addTarget:self action:@selector(otherLoginBtnEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_otherLoginBtn];
}

- (void)showTouchView
{
    [self startTouchIDWithPolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics];
}

- (void)otherLoginBtnEvent
{
    [self AlertWithTitle:@"帐号密码登录" message:@"请输入正确的帐号密码" buttons:@[@"取消",@"确定"] textFieldNumber:2 configuration:^(UITextField *field, NSInteger index) {
        if (index == 0) {
            field.text = [UserDefaults objectForKey:KAccount];
            field.enabled = NO;
        }else if (index == 1){
            field.secureTextEntry = YES;
            field.placeholder = @"请输入用户密码";
            [field becomeFirstResponder];
        }
        
    } animated:YES action:^(NSArray<UITextField *> *fields, NSInteger index) {
        if (index == 0) {
            NSLog(@"0000");
        }else if (index == 1){
            NSLog(@"11111");
            NSLog(@"000:%@, 111:%@", fields[0].text, fields[1].text);
            NSMutableDictionary *paramss = [NSMutableDictionary dictionary];
            paramss[@"username"] =fields[0].text;
            paramss[@"at"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"at"];
            
            [WWZShuju initlizedData:jmurl paramsdata:paramss dicBlick:^(NSDictionary *info) {
                NSLog(@"加密%@",info);
                [[NSUserDefaults standardUserDefaults]setObject:info[@"sid"] forKey:@"sid"];
                [[NSUserDefaults standardUserDefaults]setObject:info[@"salt"] forKey:@"salt"];
                [[NSUserDefaults standardUserDefaults]setObject:info[@"cd"] forKey:@"cd"];
                [UserDefaults synchronize];
                [self LogBtnNetWorkWithUname:fields[0].text Password:fields[1].text];
                
            }];
        }
    }];
//    if (!loginVC) {
//        loginVC = [[LoginViewController alloc] init];
//    }
//    [self presentViewController:loginVC animated:YES completion:nil];
}

- (void)LogBtnNetWorkWithUname:(NSString *)uname Password:(NSString *)pwd{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"at"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"at"];
    params[@"sid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"sid"];
    params[@"username"] =uname;
    // 数据MD5加密
    NSString * str = [pwd MD5];
    NSString *salt =  [NSString stringWithFormat:@"%@%@",str,[[NSUserDefaults standardUserDefaults]objectForKey:@"salt"]];
    NSString *str1 = [salt MD5];
    NSString *cd = [NSString stringWithFormat:@"%@%@",str1,[[NSUserDefaults standardUserDefaults]objectForKey:@"cd"]];
    NSString *str2 = [cd MD5];
    params[@"password"] = str2;
    NSLog(@"%@?%@",drurl, params);
    [WWZShuju initlizedData:drurl paramsdata:params dicBlick:^(NSDictionary *info) {
        NSLog(@"-----2---------%@",info);
        
        NSLog(@"%@------%@",str2,[[NSUserDefaults standardUserDefaults]objectForKey:@"cd"]);
        if ([info[@"r"] isEqualToNumber:@0]) {
            //加密
            NSString *temp = info[@"msg"];
            NSLog(@"%@", temp);
            if ([temp containsString:@"密码"]||[temp containsString:[@"密码" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]) {
                [MBProgressHUD showErrorMessage:info[@"msg"]];
                return ;
            }
            
        }else{
            
            [UserDefaults setObject:info[@"item"][@"uid"] forKey:@"uid"];
            [UserDefaults setObject:info[@"item"][@"is_defaultpaypass"] forKey:KIs_defaultpaypass];
            [UserDefaults setObject:@"1" forKey:KSecurytyshow];
            
            [UserDefaults synchronize];
            NSLog(@" uid =%@, tel=%@", [UserDefaults objectForKey:@"uid"], [UserDefaults objectForKey:KAccount]);
            AppDelegateInstance.window.rootViewController = [[TabBarViewController alloc] init];
        }
        
    }];
    
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
