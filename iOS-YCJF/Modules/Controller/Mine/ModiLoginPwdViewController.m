//
//  ModiLoginPwdViewController.m
//  iOS-YCJF
//
//  Created by 姜宁桃 on 2017/8/18.
//  Copyright © 2017年 Yincheng. All rights reserved.
//

#import "ModiLoginPwdViewController.h"
#import "zqtextfield.h"
#import "LoginViewController.h"
#import "TabBarViewController.h"

@interface ModiLoginPwdViewController ()<UITextFieldDelegate>
/***<#注释#> ***/
@property (nonatomic ,strong)UIView *view1;
/***<#注释#> ***/
@property (nonatomic ,strong)UIView *view2;

/***<#注释#> ***/
@property (nonatomic ,strong)UILabel *lab1;
@property (nonatomic ,strong)UILabel *lab2;

@property (nonatomic ,strong)zqtextfield *originaltf;
@property (nonatomic ,strong)zqtextfield *newltf;

/***<#注释#> ***/
@property (nonatomic ,strong)UIButton *ToviewBtn;
@property (nonatomic ,strong)UIButton *determineBtn;

@end

@implementation ModiLoginPwdViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = @"修改登录密码";
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
    
    self.backImageView.backgroundColor = grcolor;
    
    [self configUI];
}

- (void)configUI
{
    UIButton *rightbutton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 22, 20)];
    [rightbutton addTarget:self action:@selector(rightbtnclicked) forControlEvents:UIControlEventTouchUpInside];
    [rightbutton setBackgroundImage:[UIImage imageNamed:@"icon_tel"] forState:UIControlStateNormal];
    [rightbutton setBackgroundImage:[UIImage imageNamed:@"Page 1"] forState:UIControlStateHighlighted];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:rightbutton];
    
    [self.view addSubview:self.view1];
    [self.view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);make.right.offset(0);
        make.top.offset(66+11);
        make.height.offset(50);
    }];
    [self.view addSubview:self.view2];
    [self.view2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);make.right.offset(0);
        make.top.equalTo(self.view1.mas_bottom).offset(11);
        make.height.offset(50);
    }];
    
    [self.view addSubview:self.determineBtn];
    [self.determineBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(12);make.right.offset(-12);
        make.top.equalTo(self.view2.mas_bottom).offset(41);
        make.height.offset(45);
    }];

}

#pragma mark -对输入框的输入内容限制
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"/n"]) {
        return YES;
    }
    NSString *tobestr =[textField.text stringByReplacingCharactersInRange:range withString:string];
    if (self.newltf == textField || self.originaltf) {
        
        if ( [tobestr length] >16) {
            textField.text = [tobestr substringToIndex:16];
            [self showTipView:@"亲，密码位数不对哦"];
            return NO;
        }
        NSCharacterSet *cs;
        cs = [[NSCharacterSet characterSetWithCharactersInString:kAlphaNum] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""]; //按cs分离出数组,数组按@""分离出字符串
        BOOL canChange = [string isEqualToString:filtered];
        if (!canChange) {
            [self showTipView:@"密码只能设置字母和数字"];
        }
        
        return  canChange;
        
    }
    return YES;
}

-(void)rightbtnclicked{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"400-005-6677"];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}
- (void)textFieldDidChange:(UITextField *)textField
{
    NSLog(@"%@", textField.text);
    
}
-(void)ckbtnClicked:(UIButton *)sender{
    UIButton *button = sender;
    
    button.selected = !button.selected;
    if (button.selected) {
        self.newltf.secureTextEntry = NO;
    }else{
        self.newltf.secureTextEntry = YES;
    }
}
-(void)btnclicked{
    
    NSMutableDictionary *pramas = [NSMutableDictionary dictionary];
    pramas[@"uid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"uid"];
    pramas[@"sid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"sid"];
    pramas[@"at"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"at"];
    pramas[@"version"] = @"v1.0.3";
    pramas[@"os"] = @"ios";
    if (self.originaltf.text.length > 0 && self.newltf.text.length > 0) {
        if (self.newltf.text.length >= 6) {
            pramas[@"oldpassword"] =self.originaltf.text;
            pramas[@"newpassword"] =self.newltf.text;
            
            [WWZShuju initlizedData:xgdrurl paramsdata:pramas dicBlick:^(NSDictionary *info) {
                NSLog(@"--修改登录--%@",info);
                if ([[info[@"r"] stringValue] isEqualToString:@"1"]) {
                    [self showError:@"修改成功"];
                }else{
                    [self showError1:info[@"msg"]];
                }
                
                
            }];
        }else
        {
            [self showError1:@"亲，密码位数不对哦"];
        }
        
    }else
    {
        [self showError1:@"原密码或新密码不能为空"];
    }
    
    
}

-(void)showError:(NSString *)error
{
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:error preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *av = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self showHUD:@"即将推出，请重新登录" de:1.5];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSUserDefaults *eUser = [NSUserDefaults standardUserDefaults];
            [eUser removeObjectForKey:[UserDefaults objectForKey:KAccount]];
            [eUser removeObjectForKey:KAccount];    // 帐户帐号
            [eUser setObject:@"2" forKey:KGestureLock];// 手势状态
            [eUser setObject:@"2" forKey:KTouchLock];
            [eUser removeObjectForKey:@"uid"];
            [eUser removeObjectForKey:@"sid"];
            [eUser removeObjectForKey:@"at"];
            [eUser synchronize];
            
            TabBarViewController *vc = [[TabBarViewController alloc]init];
            [self.view.window setRootViewController:vc];
        });
        
    }];
    [ac addAction:av];
    [self presentViewController:ac animated:YES completion:nil];
    
}
-(void)showError1:(NSString *)error
{
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:error preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *av = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [ac addAction:av];
    [self presentViewController:ac animated:YES completion:nil];
    
}

#pragma mark - Getter
-(UIView *)view1{
    if(!_view1){
        _view1 = [[UIView alloc] init];
        _view1.backgroundColor = [UIColor whiteColor];
        
        [_view1 addSubview:self.lab1];
        [self.lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.offset(0);
            make.left.offset(21);
        }];
        
        [_view1 addSubview:self.originaltf];
        [self.originaltf mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.offset(0);
            make.right.offset(-20);
            make.left.equalTo(_lab1.mas_right).offset(15);
        }];
    }
    return _view1;
}

-(UILabel *)lab1{
    if(!_lab1){
        _lab1 = [[UILabel alloc] init];
        _lab1.text = @"原登录密码";
        _lab1.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    }
    return _lab1;
}
-(zqtextfield *)originaltf{
    if(!_originaltf){
        _originaltf.clearButtonMode = UITextFieldViewModeAlways;
        _originaltf = [[zqtextfield alloc] init];
        _originaltf.placeholder = @"请输入原登录密码";
        _originaltf.secureTextEntry = YES;
        _originaltf.delegate = self;
        _originaltf.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        //        [_originaltf addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _originaltf;
}
-(UILabel *)lab2{
    if(!_lab2){
        _lab2 = [[UILabel alloc] init];
        _lab2.text = @"新登录密码";
        _lab2.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    }
    return _lab2;
}
-(zqtextfield *)newltf{
    if(!_newltf){
        _newltf = [[zqtextfield alloc] init];
        _newltf.placeholder = @"6-12位数字、字母组合";
        _newltf.secureTextEntry = YES;
        _newltf.delegate = self;
        _newltf.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    }
    return _newltf;
}
-(UIButton *)ToviewBtn{
    if(!_ToviewBtn){
        _ToviewBtn = [[UIButton alloc]init];
        _ToviewBtn.backgroundColor = [UIColor whiteColor];
        [_ToviewBtn setImage:[UIImage imageNamed:@"icon_eyec"] forState:UIControlStateNormal];
        [_ToviewBtn setImage:[UIImage imageNamed:@"icon_eye"] forState:UIControlStateSelected];
        
        
        _ToviewBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        [_ToviewBtn addTarget:self action:@selector(ckbtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _ToviewBtn;
}

-(UIView *)view2{
    if(!_view2){
        _view2 = [[UIView alloc] init];
        _view2.backgroundColor = [UIColor whiteColor];
        
        [_view2 addSubview:self.lab2];
        [self.lab2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.offset(0);
            make.left.offset(21);
        }];
        
        [_view2 addSubview:self.ToviewBtn];
        [self.ToviewBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.offset(0);
            make.right.offset(-21);
            make.width.offset(21);
        }];
        
        [_view2 addSubview:self.newltf];
        [self.newltf mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.offset(0);
            make.left.equalTo(self.lab2.mas_right).offset(15);
            make.width.offset(self.view.width/2);
        }];
        
    }
    return _view2;
}

-(UIButton *)determineBtn{
    if(!_determineBtn){
        _determineBtn = [[UIButton alloc] init];
        [_determineBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_determineBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _determineBtn.backgroundColor = [UIColor redColor];
        _determineBtn.layer.masksToBounds =YES;
        _determineBtn.layer.cornerRadius = 4.0;
        
        _determineBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        [_determineBtn addTarget:self action:@selector(btnclicked) forControlEvents:UIControlEventTouchUpInside];
        //        [self.view addSubview:_ToviewBtn];
    }
    return _determineBtn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
