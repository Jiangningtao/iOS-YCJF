//
//  Passwordback1ViewController.m
//  iOS-CHJF
//
//  Created by garday on 2017/3/27.
//  Copyright © 2017年 garday. All rights reserved.
//

#import "Passwordback1ViewController.h"
#import "zqtextfield.h"

@interface Passwordback1ViewController ()<UITextFieldDelegate>
/***密码输入框 ***/
@property (nonatomic ,strong)zqtextfield *passwordTF;
/***密码是否可见模式 ***/
@property (nonatomic ,strong)UIButton *ckBtn;
/***<#注释#> ***/
@property (nonatomic ,strong)UIView *view1;
@end

@implementation Passwordback1ViewController
-(NSString *)mobilestr{
    if (!_mobilestr) {
        _mobilestr = [NSString string];
    }
    return _mobilestr;
}
-(NSString *)verycodestr{
    if (!_verycodestr) {
        _verycodestr = [NSString string];
    }
    return _verycodestr;
}


-(UIView *)view1{
    if(!_view1){
        _view1 = [[UIView alloc] init];
        _view1.backgroundColor = [UIColor whiteColor];
        UILabel *label = [[UILabel alloc] init];
        label.text = @"新密码";
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        label.textColor = [UIColor colorWithRed:73/255.0 green:73/255.0 blue:73/255.0 alpha:1/1.0];
        [_view1 addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.offset(0);
            make.left.offset(21);
        }];
        
        [_view1 addSubview:self.passwordTF];
        [self.passwordTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.offset(0);
            make.left.equalTo(label.mas_right).offset(20);
            make.width.offset(self.view.width*2/3*widthScale);
        }];
        
        [_view1 addSubview:self.ckBtn];
        [self.ckBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.offset(0);
            make.right.offset(-16);
        }];

        
        
    }
    return _view1;
}
-(zqtextfield *)passwordTF{
    if(!_passwordTF){
        _passwordTF = [[zqtextfield alloc] init];
        _passwordTF.placeholder = @"6-12位数字、字母组合";
        _passwordTF.returnKeyType = UIReturnKeyDone ;
        _passwordTF.clearButtonMode = UITextFieldViewModeAlways;
        _passwordTF.secureTextEntry = YES;
        _passwordTF.delegate = self;
        _passwordTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _passwordTF.clearsOnBeginEditing = YES;
        [_passwordTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _passwordTF.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    }
    return _passwordTF;
}
-(UIButton *)ckBtn{
    if(!_ckBtn){
        _ckBtn = [[UIButton alloc] init];
        
        _ckBtn.backgroundColor = [UIColor whiteColor];
        [_ckBtn setImage:[UIImage imageNamed:@"icon_eyec"] forState:UIControlStateNormal];
        [_ckBtn setImage:[UIImage imageNamed:@"icon_eye"] forState:UIControlStateSelected];
        _ckBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        [_ckBtn addTarget:self action:@selector(ckbtnClickedq:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ckBtn;
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
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self Nav];
    [self.view  addSubview:self.view1];
    [self.view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.offset(76);
        make.height.offset(50);
    }];
    
    UIButton *PhonebBtn =[[UIButton alloc]init];
    [PhonebBtn setTitle:@"确定新密码" forState:UIControlStateNormal];
    [PhonebBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    PhonebBtn.backgroundColor = [UIColor redColor];
    PhonebBtn.layer.masksToBounds = YES;
    PhonebBtn.layer.cornerRadius = 4.0;
    PhonebBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    [PhonebBtn addTarget:self action:@selector(PhonebBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:PhonebBtn];
    [PhonebBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.equalTo(self.view1.mas_bottom).offset(111);
        make.right.offset(-12);
        make.left.offset(12);
        make.height.offset(45);
    }];

    
    // Do any additional setup after loading the view.
}

#pragma mark - UITextFieldDelegate
#pragma mark -对输入框的输入内容限制
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"/n"]) {
        return YES;
    }
    NSString *tobestr =[textField.text stringByReplacingCharactersInRange:range withString:string];
    if(textField == self.passwordTF){
        if ( [tobestr length]>16 ) {
            textField.text = [tobestr substringToIndex:16];
            [self showHUD:@"亲，密码最大只能16位数哦" de:1.0];
            return NO;
        }
        NSCharacterSet *cs;
        cs = [[NSCharacterSet characterSetWithCharactersInString:kAlphaNum] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""]; //按cs分离出数组,数组按@""分离出字符串
        BOOL canChange = [string isEqualToString:filtered];
        if (!canChange) {
            [self showHUD:@"密码只能设置字母和数字" de:1.0];
        }
        return  canChange;
        
    }
    return YES;
}

-(void)textFieldDidChange:(UITextField *)textField
{
    if (textField.text.length >=8&&textField.text.length <=16) {
        
    }
    
}
-(void)ckbtnClickedq:(UIButton *)sender{
    UIButton *button = sender;
    
    button.selected = !button.selected;
    if (button.selected) {
        self.passwordTF.secureTextEntry = NO;
    }else{
        self.passwordTF.secureTextEntry = YES;
    }
}
-(void)leftbtnclicked{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
-(void)PhonebBtnClicked{
    if (self.passwordTF.text.length > 0) {
        NSMutableDictionary *pramas = [NSMutableDictionary dictionary];
        pramas[@"mobile"] = self.mobilestr;
        pramas[@"verycode"] = self.verycodestr;
        pramas[@"newpwd"] = [self.passwordTF.text MD5];
        pramas[@"at"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"at"];
        [WWZShuju initlizedData:zhczmmurl paramsdata:pramas dicBlick:^(NSDictionary *info) {
            NSLog(@"--确定新密码--%@",info);
            
            if ([info[@"r"] isEqualToNumber:@1]) {
                NSLog(@"%@",info[@"msg"]);
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else{
                [self showError:info[@"msg"]];
            }
        }];
    }else
    {
        [self showError:@"密码不能为空"];
    }
    
   
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
