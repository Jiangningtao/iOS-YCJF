//
//  SetPayPwdViewController.m
//  iOS-YCJF
//
//  Created by 姜宁桃 on 2017/8/18.
//  Copyright © 2017年 Yincheng. All rights reserved.
//

#import "SetPayPwdViewController.h"
#import "InputView.h"

@interface SetPayPwdViewController ()
{
    NSString *str;
    UIButton *btn;
}
@property (nonatomic, strong) InputView *fistInputView;
@property (nonatomic, strong) InputView *lastInputView;

@property (nonatomic, copy) NSString *fistInput;
@property (nonatomic, copy) NSString *lastInput;

@end

@implementation SetPayPwdViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = @"设置新交易密码";
    [self AFN];
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
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.fistInputView];
    [self.view addSubview:self.lastInputView];
    
    
    [self.fistInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.lastInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.fistInputView.hidden = NO;
    [self.fistInputView becomeFirstResponder];
    self.lastInputView.hidden = YES;
}

-(void)btnclicked{
    
    NSMutableDictionary *pramas = [NSMutableDictionary dictionary];
    pramas[@"uid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"uid"];
    pramas[@"sid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"sid"];
    pramas[@"at"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"at"];
    pramas[@"version"] = @"v1.0.3";
    pramas[@"os"] = @"ios";
    pramas[@"mobile"] = [UserDefaults objectForKey:KAccount];
    pramas[@"verycode"] = self.verycodestr;
    pramas[@"newpwd"] = self.lastInput;
    NSLog(@"%@?%@", zhczurl, pramas);
    [WWZShuju initlizedData:zhczurl paramsdata:pramas dicBlick:^(NSDictionary *info) {
        NSLog(@"%@",info);
        NSLog(@"%@",info[@"msg"]);
        if ([info[@"r"] isEqualToNumber:@1]) {
            [self showError:info[@"msg"]];
        }else
        {
            [self showHUD:info[@"msg"] de:1.5];
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
- (void)switchToFirstInputMode
{
    //clean
    [self.fistInputView clear];
    [self.lastInputView clear];
    
    self.lastInputView.hidden = YES;
    self.fistInputView.hidden = NO;
    [self.fistInputView becomeFirstResponder];
}

- (void)switchToLastInputMode
{
    self.fistInputView.hidden = YES;
    self.lastInputView.hidden = NO;
    [self.lastInputView becomeFirstResponder];
}

#pragma mark -  Getter
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
        KPostNotification(KNotificationRefreshMineDatas, nil);
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
    [ac addAction:av];
    [self presentViewController:ac animated:YES completion:nil];
    
}

-(void)showError1:(NSString *)error
{
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:error preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *av = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self switchToFirstInputMode];
    }];
    [ac addAction:av];
    [self presentViewController:ac animated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
