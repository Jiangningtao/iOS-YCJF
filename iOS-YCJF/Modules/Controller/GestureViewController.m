//
//  GestureViewController.m
//  iOS-YCJF
//
//  Created by 姜宁桃 on 2017/8/25.
//  Copyright © 2017年 Yincheng. All rights reserved.
//

#import "GestureViewController.h"
#import "YLSwipeLockView.h"
#import "TabBarViewController.h"
#import "LoginViewController.h"

@interface GestureViewController ()<YLSwipeLockViewDelegate>
{
    UILabel *titleLabel2;
    UIButton *leftButton;
    
    NSString *currentUser;
    NSInteger inputIndex;
    NSInteger timerIndex;
    NSTimer *timer;
}

/***<#注释#> ***/
@property (nonatomic ,strong)YLSwipeLockView *lockView;

@end

@implementation GestureViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    titleLabel2.text = @"请输入手势密码";
    titleLabel2.textColor = color(51, 51, 51, 1);
    self.navigationController.navigationBar.hidden = YES;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //试验密码次数
    inputIndex = 5;
    
    //倒计时秒数
    timerIndex = 30;
    
    self.view.backgroundColor = grcolor;
    [self configUI];
    
}

- (void)configUI{
    
    UIImageView *imgV = [[UIImageView alloc]init];
    imgV.image = [UIImage imageNamed:@"ic_finger_logo"];
    imgV.layer.masksToBounds = YES;
    imgV.layer.cornerRadius = 31;
    [self.view addSubview:imgV];
    [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.offset(100);
        make.width.height.offset(62);
    }];
    
    titleLabel2  = [[UILabel alloc]init];
    titleLabel2.backgroundColor = [UIColor clearColor];
    titleLabel2.font = [UIFont systemFontOfSize:14];
    titleLabel2.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel2];
    [titleLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.equalTo(imgV.mas_bottom).offset(30);
    }];
    
    [self.view addSubview:self.lockView];
    [self.lockView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(50);
        make.centerX.offset(0);
        make.width.height.offset(250);
        
    }];
    
    UIButton *btn = [[UIButton alloc]init];
    [btn setTitle:@"更换登录方式" forState:UIControlStateNormal];
    [btn setTitleColor:lancolor forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(otherLoginBtnEvent) forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.bottom.offset(-20);
    }];
    
}

#pragma mark - Event Hander
- (YLSwipeLockViewState)swipeView:(YLSwipeLockView *)swipeView didEndSwipeWithPassword:(NSString *)password {
    
    NSLog(@"手势密码结果为:%@",password);
    
    //判断密码是否正确
    if ([password isEqualToString:[UserDefaults objectForKey:KGestureLock]])
    {
        //#warning test
        titleLabel2.text = @"请输入手势密码";
        self.lockView.userInteractionEnabled = YES;
        
        inputIndex = 5; //密码正确，重置计数
        titleLabel2.text = @"解锁密码成功"; //提示用户正在登陆
        
        AppDelegateInstance.window.rootViewController = [[TabBarViewController alloc] init];
        
        return YLSwipeLockViewStateNormal;
    } else {
        
        inputIndex --;
        NSString *title = [NSString stringWithFormat:@"密码错误，剩余次数%ld",(long)inputIndex];
        
        titleLabel2.text = title;
        titleLabel2.textColor = [UIColor redColor];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                titleLabel2.text = @"请重新输入手势密码";
                titleLabel2.textColor = color(51, 51, 51, 1);
            });
        });
        
        
        if (inputIndex == 0)
        {
            
            titleLabel2.text = [NSString stringWithFormat:@"%ld秒后重试",(long)timerIndex];
            titleLabel2.textColor = [UIColor purpleColor];
            timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerStart:) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];
            self.lockView.userInteractionEnabled = NO;
            
        }
        
        return YLSwipeLockViewStateWarning;
        
    }
    
}

-(void)reset
{
    titleLabel2.text = @"请输入手势密码";
}

- (void)timerStart:(NSTimer *)myTimer {
    
    timerIndex--;
    titleLabel2.text = [NSString stringWithFormat:@"%ld秒后重试",(long)timerIndex];
    
    if (timerIndex == 0) {
        
        inputIndex = 5;
        timerIndex = 120; //第二次重试错误时倒计时120秒！！
        self.lockView.userInteractionEnabled = YES;
        titleLabel2.text = @"请重试";
        titleLabel2.textColor = color(51, 51, 51, 1);
        [myTimer invalidate];
        
    }
    
}

- (void)openLockView {
    inputIndex = 5;
    self.lockView.userInteractionEnabled = YES;
}

- (void)otherLoginBtnEvent
{
    LoginViewController *sv = [[LoginViewController alloc]init];
    sv.isTurnToTabVC = @"YES";
    [self showViewController:sv sender:nil];
#if 0
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
#endif
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


#pragma mark - Getter
-(YLSwipeLockView *)lockView{
    if(!_lockView){
        _lockView = [[YLSwipeLockView alloc] init];
        _lockView.delegate = self;
    }
    return _lockView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
