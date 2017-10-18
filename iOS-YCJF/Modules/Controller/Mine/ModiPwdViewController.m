//
//  ModiPwdViewController.m
//  iOS-YCJF
//
//  Created by 姜宁桃 on 2017/8/18.
//  Copyright © 2017年 Yincheng. All rights reserved.
//

#import "ModiPwdViewController.h"
#import "InputView.h"

@interface ModiPwdViewController ()
{
    NSString *localpassone; // 用来验证是否修改过交易密码的字符  1 ：未修改， 0 ： 修改过
    NSString *str;
    UIButton *btn;
}
@property (nonatomic, strong) InputView * oppInputView; // 旧密码输入框
@property (nonatomic, strong) InputView *fistInputView;
@property (nonatomic, strong) InputView *lastInputView;

@property (nonatomic, copy) NSString * oppInput; // 旧密码字符串
@property (nonatomic, copy) NSString *fistInput;
@property (nonatomic, copy) NSString *lastInput;

@end

@implementation ModiPwdViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = [[UserDefaults objectForKey:KIs_defaultpaypass] integerValue] ==1?@"绑定交易密码" : @"修改交易密码";
    [self AFN];
    [MobClick beginLogPageView:self.title];
    [TalkingData trackPageBegin:self.title];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:self.title];
    [TalkingData trackPageEnd:self.title];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.Model = [MineInstance shareInstance].mineModel;
    localpassone = [UserDefaults objectForKey:KIs_defaultpaypass];
    [self NavBack];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.oppInputView];
    [self.view addSubview:self.fistInputView];
    [self.view addSubview:self.lastInputView];
    
    [self.oppInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.view);
    }];
    
    [self.fistInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.lastInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    if ([localpassone integerValue] == 1) {
        // 初始化 888888
        self.oppInputView.hidden = YES;
        self.fistInputView.hidden = NO;
        [self.fistInputView becomeFirstResponder];
    }else
    {
        self.oppInputView.hidden = NO;
        self.fistInputView.hidden = YES;
        [self.oppInputView becomeFirstResponder];
    }
    self.lastInputView.hidden = YES;
}

-(void)btnclicked{
    
    [self showHUD:@"数据加载中" isDim:YES];
    NSMutableDictionary *pramas = [NSMutableDictionary dictionary];
    pramas[@"uid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"uid"];
    pramas[@"sid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"sid"];
    pramas[@"at"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"at"];
    pramas[@"version"] = @"v1.0.3";
    pramas[@"os"] = @"ios";
    
    NSString * oldpwd = [localpassone integerValue] == 1?@"888888":self.oppInput;
    NSLog(@"%@", oldpwd);
    NSString *ljm = [oldpwd MD5];
    NSString *ms = [NSString stringWithFormat:@"%@%@",ljm,str];
    NSLog(@"%@", ms);
    NSString *xmm = [ms MD5];
    
    pramas[@"oldpwd"] =xmm;
    pramas[@"newpay"] =[self.lastInput MD5];
    
    NSLog(@"%@?%@", xgjymmrl, pramas);
    [WWZShuju initlizedData:xgjymmrl paramsdata:pramas dicBlick:^(NSDictionary *info) {
        NSLog(@"--修改交易密码--%@",info);
        [self hideHUD];
        NSLog(@"--修改交易密码--%@",info[@"msg"]);
        if ([info[@"r"] integerValue] == 1) {
            KPostNotification(KNotificationRefreshMineDatas, nil);
            [UserDefaults setObject:@"0" forKey:KIs_defaultpaypass];
            [UserDefaults synchronize];
            [self showError:info[@"msg"]];
        }else
        {
            [self showError1:info[@"msg"]];
        }
        
    }];
}

-(void)leftbtnclicked{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)AFN{
    [self showHUD:@"数据加载中" isDim:YES];
    str = [NSString string]; //密匙
    NSMutableDictionary *prama = [NSMutableDictionary dictionary];
    prama[@"uid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"uid"];
    prama[@"sid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"sid"];
    prama[@"at"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"at"];
    prama[@"version"] = @"v1.0.3";
    prama[@"os"] = @"ios";
    
    [WWZShuju initlizedData:mmmsrl paramsdata:prama dicBlick:^(NSDictionary *info) {
        NSLog(@"%@", info);
        [self hideHUD];
        if ([info[@"r"] integerValue] == 1) {
            str =[NSString stringWithFormat:@"%@",info[@"sedpassed"]];
            NSLog(@"%@",str);
        }
    }];
}

#pragma mark -
- (void)check
{
    __weak typeof(self)weakself = self;
    if ([self.fistInput isEqualToString:self.lastInput]) {
        
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakself.view endEditing:YES];
            //            [weakself.navigationController popViewControllerAnimated:YES];
            [self btnclicked];  // 提交， 进行修改交易密码的网络请求
        }];
        
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"两次密码输入一致，确定提交？"] preferredStyle:UIAlertControllerStyleAlert];
        [alertVC addAction:action];
        [self presentViewController:alertVC animated:YES completion:nil];
        
        btn.hidden = NO;
        
    } else {
        
        UIAlertAction *actionRetry = [UIAlertAction actionWithTitle:@"重试" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakself switchToFirstInputMode];
        }];
        
        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakself.view endEditing:YES];
            [weakself.navigationController popViewControllerAnimated:YES];
        }];
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"两次新密码输入不一致，请重新输入" preferredStyle:UIAlertControllerStyleAlert];
        [alertVC addAction:actionCancel];
        [alertVC addAction:actionRetry];
        [self presentViewController:alertVC animated:YES completion:nil];
    }
}






#pragma mark -
- (void)switchToOppInputMode
{
    [self.oppInputView clear];
    [self.fistInputView clear];
    [self.lastInputView clear];
    
    self.oppInputView.hidden = NO;
    self.fistInputView.hidden = YES;
    self.lastInputView.hidden = YES;
    [self.oppInputView becomeFirstResponder];
}

- (void)switchToFirstInputMode
{
    //clean
    [self.fistInputView clear];
    [self.lastInputView clear];
    
    self.oppInputView.hidden = YES;
    self.lastInputView.hidden = YES;
    self.fistInputView.hidden = NO;
    [self.fistInputView becomeFirstResponder];
}

- (void)switchToLastInputMode
{
    self.oppInputView.hidden = YES;
    self.fistInputView.hidden = YES;
    self.lastInputView.hidden = NO;
    [self.lastInputView becomeFirstResponder];
}

#pragma mark -  Getter
-(InputView *)oppInputView
{
    if (!_oppInputView) {
        _oppInputView = [[InputView alloc] init];
        _oppInputView.tip = @"请输入原交易密码";
        __weak typeof(self) weakself = self;
        _oppInputView.textChangeBlock = ^(NSString *text) {
            weakself.oppInput = text;
        };
    }
    return _oppInputView;
}
- (InputView *)fistInputView
{
    if (!_fistInputView) {
        _fistInputView = [[InputView alloc] init];
        _fistInputView.tip = @"请输入新交易密码";
        __weak typeof(self) weakself = self;
        _fistInputView.textChangeBlock = ^(NSString *text){
            weakself.fistInput = text;
        };
    }
    return _fistInputView;
    
}

- (InputView *)lastInputView
{
    if (!_lastInputView) {
        _lastInputView = [[InputView alloc] init];
        _lastInputView.tip = @"请再次输入新交易密码";
        
        __weak typeof(self) weakself = self;
        _lastInputView.textChangeBlock = ^(NSString *text){
            weakself.lastInput = text;
        };
    }
    return _lastInputView;
}

-(void)setOppInput:(NSString *)oppInput
{
    _oppInput = oppInput;
    if (oppInput.length == 6) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 判断旧支付密码是否正确
            [self checkPayPwd];
        });
    }
}

- (void)checkPayPwd
{
    [MBProgressHUD showActivityMessageInWindow:@"正在验证旧密码"];
    NSMutableDictionary *pramas = [NSMutableDictionary dictionary];
    pramas[@"uid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"uid"];
    pramas[@"sid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"sid"];
    pramas[@"at"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"at"];
    pramas[@"version"] = @"v1.0.3";
    pramas[@"os"] = @"ios";
    NSString * oldpwd = self.oppInput;
    NSLog(@"%@", oldpwd);
    NSString *ljm = [oldpwd MD5];
    NSString *ms = [NSString stringWithFormat:@"%@%@",ljm,str];
    NSLog(@"%@", ms);
    NSString *xmm = [ms MD5];
    pramas[@"oldpwd"] =xmm;
    
    NSLog(@"%@?%@", pdzfmmurl, pramas);
    [WWZShuju initlizedData:pdzfmmurl paramsdata:pramas dicBlick:^(NSDictionary *info) {
        [MBProgressHUD hideHUD];
        NSLog(@"--判断交易密码--%@",info[@"msg"]);
        if ([info[@"r"] integerValue] == 1) {
            // 支付密码正确，输入新密码
            [self switchToFirstInputMode];
        }else
        {
            [self.view endEditing:YES];
            // 支付密码不正确，重新输入旧密码
            [self  showTipView:@"原交易密码不正确，请重新输入"];
            [self switchToOppInputMode];
        }
        
    }];
}

- (void)setFistInput:(NSString *)fistInput
{
    _fistInput = fistInput;
    if (fistInput.length == 6) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self switchToLastInputMode];
        });
    }
    
}

- (void)setLastInput:(NSString *)lastInput
{
    _lastInput = lastInput;
    if (lastInput.length == 6) {
        [self check];
    }
}

#pragma mark - 提示框
-(void)showError:(NSString *)error
{
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:error preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *av = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [ac addAction:av];
    [self presentViewController:ac animated:YES completion:nil];
    
}

-(void)showError1:(NSString *)error
{
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:error preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *av = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if ([localpassone integerValue] == 1) {
            [self switchToFirstInputMode];
        }else
        {
            [self switchToOppInputMode];
        }
    }];
    [ac addAction:av];
    [self presentViewController:ac animated:YES completion:nil];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
