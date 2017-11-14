//
//  RegisterViewController.m
//  iOS-YCJF
//
//  Created by 姜宁桃 on 2017/8/17.
//  Copyright © 2017年 Yincheng. All rights reserved.
//

#import "RegisterViewController.h"
#import "noteView.h"
#import "zqtextfield.h"
#import "yzBtn.h"
#import "TabBarViewController.h"

@interface RegisterViewController ()<UITextFieldDelegate>{
    UILabel *sjlab;
    zqtextfield *tf;
}

/***<#注释#> ***/
@property (nonatomic ,strong)UIView *view1;
/***帐号输入框 ***/
@property (nonatomic ,strong)UITextField *textTF;
/***发送验证码 ***/
@property (nonatomic ,strong)yzBtn  *sfbtn;
/***密码输入框 ***/
@property (nonatomic ,strong)zqtextfield *passwordTF;
/***密码是否可见模式 ***/
@property (nonatomic ,strong)UIButton *ckBtn;
/***输入推荐码 ***/
@property (nonatomic ,strong)UIButton *tjmBtn;
/***<#注释#> ***/
@property (nonatomic ,strong)UILabel *lab;

/***<#注释#> ***/
@property (nonatomic ,strong)noteView *view2;
/***<#注释#> ***/
@property (nonatomic ,strong)UIView *forView;

/***<#注释#> ***/
@property (nonatomic ,strong)NSMutableArray *dotArray;

@end

@implementation RegisterViewController

-(UIView *)view1{
    if(!_view1){
        _view1 = [[UIView alloc] init];
        _view1.backgroundColor = [UIColor whiteColor];
        [_view1 addSubview:self.textTF];
        
        UILabel *lab = [[UILabel alloc]init];
        lab.text = @"手机号码";
        lab.backgroundColor = _view1.backgroundColor;
        lab.numberOfLines = 0;
        lab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        [_view1 addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(21);
            make.top.offset(17);
        }];
        
        
        tf = [[zqtextfield alloc]init];
        tf.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        tf.placeholder = @"请输入手机号";
        tf.text = self.tel;
        tf.keyboardType = UIKeyboardTypeNumberPad;
        tf.delegate =self;
        tf.autocapitalizationType = UITextAutocapitalizationTypeNone;
        [tf addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [_view1 addSubview:tf];
        [tf mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(17 );
            make.left.equalTo(lab.mas_right).offset(13 );
            //                make.right.offset(-21);
            make.width.offset(self.view.width -120 );
            make.bottom.equalTo(lab.mas_bottom);
        }];
        UIView *xx = [[UIView alloc] init];
        xx.backgroundColor = grcolor;
        [_view1 addSubview:xx];
        [xx mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(tf.mas_bottom).offset(10);
            make.width.offset(self.view.width);
            make.height.offset(1);
        }];
        
        
        [self.textTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(20);
            make.top.equalTo(tf.mas_bottom).offset(20);
            make.width.offset(self.view.width*2/3-30);
        }];
        
        UIView *xxv = [[UIView alloc] init];
        xxv.backgroundColor = lancolor;
        [_view1 addSubview:xxv];
        [xxv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.textTF.mas_right).offset(5);
            make.centerY.equalTo(self.textTF.mas_centerY);
            make.width.offset(1);
            make.height.offset(19);
        }];
        
        [_view1 addSubview:self.sfbtn];
        [self.sfbtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(xxv.mas_right).offset(5);
            make.right.offset(-12);
            make.centerY.equalTo(xxv.mas_centerY);
            make.height.equalTo(self.textTF.mas_height);
        }];
        
        UIView *hv =[[UIView alloc]init];
        hv.backgroundColor = grcolor;
        [_view1 addSubview:hv];
        [hv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.offset(0);
            make.height.offset(1);
            make.top.equalTo(self.textTF.mas_bottom).offset(6);
        }];
        
        UILabel *accLab = [[UILabel alloc]init];
        accLab.text = @"登录密码";
        accLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        accLab.textColor = [UIColor colorWithRed:73/255.0 green:73/255.0 blue:73/255.0 alpha:1/1.0];
        [_view1 addSubview:accLab];
        [accLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(21);
            make.top.equalTo(hv.mas_bottom).offset(17);
        }];
        [_view1 addSubview:self.passwordTF];
        [self.passwordTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(accLab.mas_centerY);
            make.left.equalTo(accLab.mas_right).offset(20);
            make.width.offset(self.view.width/2);
        }];
        [_view1 addSubview:self.ckBtn];
        [self.ckBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-16);
            make.centerY.equalTo(accLab.mas_centerY);
        }];
        
    }
    return _view1;
}

-(UITextField *)textTF{
    if(!_textTF){
        _textTF = [[UITextField alloc] init];
        _textTF.placeholder = @"输入短信验证码";
        //首字母是否大写
        _textTF.delegate = self;
        _textTF.keyboardType = UIKeyboardTypeNumberPad;
        _textTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _textTF.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
//        [_textTF addTarget:self action:@selector(FieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        
    }
    return _textTF;
}
-(yzBtn *)sfbtn{
    if(!_sfbtn){
        _sfbtn = [[yzBtn alloc] init];
        _sfbtn.backgroundColor = [UIColor whiteColor];
        [_sfbtn setTitle:@"发送验证码" forState:UIControlStateNormal];
        [_sfbtn setTitleColor:lancolor forState:UIControlStateNormal];
        _sfbtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        [_sfbtn addTarget:self action:@selector(sfbtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sfbtn;
}

-(zqtextfield *)passwordTF{
    if(!_passwordTF){
        _passwordTF = [[zqtextfield alloc] init];
        _passwordTF.placeholder = @"6-12位数字、字母组合";
        _passwordTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
//        [_passwordTF addTarget:self action:@selector(TextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _passwordTF.delegate = self;
        _passwordTF.keyboardType = UIKeyboardTypeDefault;
        _passwordTF.clearsOnBeginEditing = YES;
        _passwordTF.secureTextEntry = YES;
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
        [_ckBtn addTarget:self action:@selector(ckbtnClickedw:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ckBtn;
}

-(UIButton *)tjmBtn{
    if(!_tjmBtn){
        _tjmBtn = [[UIButton alloc] init];
        
        _tjmBtn.backgroundColor = grcolor;
        [_tjmBtn setTitle:@"输入推荐码" forState:UIControlStateNormal];
        [_tjmBtn setTitleColor:lancolor forState:UIControlStateNormal];
        _tjmBtn.titleLabel.font =  [UIFont fontWithName:@"PingFangSC-Medium" size:15];;
        [_tjmBtn addTarget:self action:@selector(tjmbtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tjmBtn;
}
-(UILabel *)lab{
    if(!_lab){
        _lab = [[UILabel alloc] init];
        _lab.backgroundColor = grcolor;
        _lab.text =  @"（使用推荐码注册送额外好礼）";
        _lab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        _lab.textColor = [UIColor colorWithRed:168/255.0 green:168/255.0 blue:168/255.0 alpha:1/1.0];
    }
    return _lab;
}



-(UIView *)view2{
    if(!_view2){
        _view2 = [[noteView alloc] init];
        _view2.backgroundColor = [UIColor clearColor];
        self.view2.hidden = YES;
    }
    return _view2;
}
-(UIView *)forView{
    if(!_forView){
        _forView = [[UIView alloc] init];
        _forView.backgroundColor = [UIColor whiteColor];
        
        UIButton *xybBtn =[[UIButton alloc]init];
        [xybBtn setTitle:@"完成注册领取新手礼包" forState:UIControlStateNormal];
        [xybBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        xybBtn.backgroundColor = [UIColor redColor];
        xybBtn.layer.masksToBounds = YES;
        xybBtn.layer.cornerRadius = 4.0;
        xybBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        [xybBtn addTarget:self action:@selector(xybBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [_forView addSubview:xybBtn];
        [xybBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.offset(0);
            make.right.offset(-12);
            make.left.offset(12);
            make.height.offset(45);
        }];
    }
    return _forView;
}
-(void)Nav{
    self.backImageView.backgroundColor =grcolor;
    self.title =@"注册账号";
    
    [self NavBack];
}

- (void)backClick:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)textFieldDidChange:(UITextField *)textField{
    if (textField.text.length ==11) {
        NSMutableDictionary *pramas =[NSMutableDictionary dictionary];
        pramas[@"at"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"at"];
        pramas[@"mobile"] = textField.text;
        [WWZShuju initlizedData:yzsjsfzcurl paramsdata:pramas dicBlick:^(NSDictionary *info) {
            NSLog(@"--------%@",info[@"r"]);
            if ([info[@"r"] isEqualToString:@"1"]) {
                
            }else{
                [self showError:@"此号码已被注册"];
            }
            
        }];
        
    }
}

#pragma mark - UITextFieldDelegate
#pragma mark -对输入框的输入内容限制
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"/n"]) {
        return YES;
    }
    NSString *tobestr =[textField.text stringByReplacingCharactersInRange:range withString:string];
    if (tf == textField) {
        if ( [tobestr length]>=11 ) {
            textField.text = [tobestr substringToIndex:11];
            [self.textTF becomeFirstResponder];
            return NO;
        }
        NSCharacterSet *cs;
        cs = [[NSCharacterSet characterSetWithCharactersInString:Kshuzi] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""]; //按cs分离出数组,数组按@""分离出字符串
        BOOL canChange = [string isEqualToString:filtered];
        if (!canChange) {
            [self showTipView:@"手机号只能是数字噢"];
        }
        return  canChange;
        
    }else if(self.passwordTF == textField){
        if ( [tobestr length]>16 ) {
            textField.text = [tobestr substringToIndex:16];
            [self showTipView:@"亲，密码最大只能16位数哦"];
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
        
    }else if(self.textTF == textField){
        if ( [tobestr length]>6 ) {
            textField.text = [tobestr substringToIndex:6];
            [self.passwordTF becomeFirstResponder];
            [self showTipView:@"验证码最多只有6位数哦"];
            return NO;
        }
    }
    return YES;
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [MobClick beginLogPageView:@"注册"];
    [TalkingData trackPageBegin:@"注册"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"注册"];
    [TalkingData trackPageEnd:@"注册"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self Nav];
    [self.view addSubview:self.view1];
    [self.view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.offset(76);
        make.height.offset(150);
    }];
    [self.view addSubview:self.tjmBtn];
    [self.tjmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view1.mas_bottom).offset(14);
        make.centerX.offset(0);
    }];
    [self.view addSubview:self.lab];
    [self.lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tjmBtn.mas_bottom).offset(7);
        make.centerX.offset(0);
    }];
    
    [self.view addSubview:self.view2];
    [self.view2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(self.lab.mas_bottom).offset(13);
        make.height.offset(80);
    }];
    
    sjlab = [[UILabel alloc] init];
    sjlab.hidden = YES;
    NSString *str = @"推荐码所有者验证：";
    sjlab.text = str;
    
    sjlab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    sjlab.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0];
    [self.view addSubview:sjlab];
    
    [sjlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.top.equalTo(self.view2.mas_bottom).offset(13);
    }];
    
    [self.view addSubview:self.forView];
    [self.forView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.bottom.offset(0);
        make.height.offset(55);
    }];
    
    UILabel *wczclab = [[UILabel alloc] init];
    wczclab.text = @"完成注册即代表同意";
    wczclab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    wczclab.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0];
    [self.view addSubview:wczclab];
    [wczclab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.forView.mas_top).offset(-14);
    }];
    UIButton *wczcBtn =[[UIButton alloc]init];
    [wczcBtn setTitle:@"《银程金服注册协议》" forState:UIControlStateNormal];
    [wczcBtn setTitleColor:lancolor forState:UIControlStateNormal];
    wczcBtn.backgroundColor = grcolor;
    wczcBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    [wczcBtn addTarget:self action:@selector(wczcBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:wczcBtn];
    [wczcBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(wczclab.mas_centerY);
        make.left.equalTo(wczclab.mas_right).offset(3);
    }];
    
    self.view2.blockEndEnter = ^(NSString *tjr) {
        NSLog(@"%@", tjr);
        NSMutableDictionary * dict = [NSMutableDictionary new];
        dict[@"app_id"] = @"3";
        dict[@"os"] = @"ios";
        dict[@"at"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"at"];
        dict[@"version"] = @"v1.0.3";
        dict[@"tjr"] = tjr;
        
        [WWZShuju initlizedData:tjmurl paramsdata:dict dicBlick:^(NSDictionary *info) {
            NSLog(@"%@", info);
            if ([info[@"r"] integerValue] == 1) {
                NSString * txt = [@"推荐码所有者验证：" stringByAppendingString:info[@"mobile"]];
                NSMutableAttributedString *mothlabStr = [[NSMutableAttributedString alloc] initWithString:txt];
                [mothlabStr addAttribute:NSForegroundColorAttributeName
                                   value:[UIColor redColor]
                                   range:NSMakeRange(9, 11)];
                sjlab.attributedText = mothlabStr;
            }else
            {
                NSString * txt = @"推荐码所有者验证：无";
                NSMutableAttributedString *mothlabStr = [[NSMutableAttributedString alloc] initWithString:txt];
                [mothlabStr addAttribute:NSForegroundColorAttributeName
                                   value:[UIColor redColor]
                                   range:NSMakeRange(9, 1)];
                sjlab.attributedText = mothlabStr;
            }
        }];
    };
    
    // Do any additional setup after loading the view.
}
-(void)sfbtnClicked{
    if (tf.text.length == 0 || tf.text.length != 11) {
        [self showHUD:@"手机号码不能为空或不正确" de:1.0];
    }else
    {
        [self.sfbtn time];
        NSMutableDictionary *pramass =[NSMutableDictionary dictionary];
        pramass[@"mobile"] = tf.text;
        pramass[@"uid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"uid"];
        pramass[@"sid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"sid"];
        pramass[@"at"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"at"];
        pramass[@"version"] = @"v1.0.3";
        pramass[@"os"] = @"ios";
        [WWZShuju initlizedData:sjzcurl paramsdata:pramass dicBlick:^(NSDictionary *info) {
            if (tf.text.length == 11) {
                NSLog(@"%@",info);
                if ([info[@"r"] isEqualToString:@"1"]) {
                    // NSLog(@"qqqqqqqqqqq");
                }else{
                    
                }
            }else{
                [self showError:@"手机号码不规范"];
            }
            
            
        }];
    }
    
    
}



-(void)ckbtnClickedw:(UIButton *)sender{
    UIButton *button = sender;
    
    button.selected = !button.selected;
    if (button.selected) {
        self.passwordTF.secureTextEntry = NO;
    }else{
        self.passwordTF.secureTextEntry = YES;
    }
}

-(void)tjmbtnClicked:(UIButton *)sender{
    UIButton *button = sender;
    
    button.selected = !button.selected;
    if (button.selected) {
        self.view2.hidden = NO;
        sjlab.hidden = NO;
        self.view2.textfiled.clearsOnBeginEditing = YES;
    }else{
        self.view2.hidden = YES;
        //再次编辑就清空
        self.view2.textfiled.clearsOnBeginEditing = YES;
        sjlab.hidden = YES;
    }
}

-(void)leftbtnclicked{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
-(void)wczcBtnClicked{
    WebViewController * webVC = [[WebViewController alloc] init];
    webVC.url = zcxyh5;
    webVC.WebTiltle = @"银程金服注册协议";
    [self.navigationController pushViewController:webVC animated:YES];
}
#pragma mark - 提示框
-(void)showError:(NSString *)error
{
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:error preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *av = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if ([error isEqualToString:@"验证码无效"]) {
            self.textTF.text = @"";
        }
        //self.passwordTF.text =@"";
    }];
    [ac addAction:av];
    [self presentViewController:ac animated:YES completion:nil];
    
}

-(void)xybBtnClicked{
    if (tf.text.length == 0 || tf.text.length != 11) {
        [self showError:@"帐号信息有误，请检查后重新输入"];
    }else if (self.textTF.text.length == 0 || self.textTF.text.length <= 3)
    {
        [self showError:@"验证码长度不正确"];
    }else if(self.passwordTF.text.length < 6){
        [self showError:@"密码有误，请输入6-12位数字、字母组合"];
    }else{
        NSMutableDictionary *pramass =[NSMutableDictionary dictionaryWithDictionary:self.paramsBase];
        pramass[@"mobile"] = tf.text;
        pramass[@"channel"] = @"iosapp";
        pramass[@"source"] = [UserDefaults objectForKey:KChannelSource];
        pramass[@"idfa"] = [UserDefaults objectForKey:KAdid];
        pramass[@"password"] =[self.passwordTF.text MD5];
        pramass[@"verycode"] = self.textTF.text;
        if (self.view2.textfiled.text.length == 0) {
            
        }else{
            pramass[@"tjr"] = self.view2.textfiled.text;
        }
        NSString * paramsStr = [[NSString alloc] init];
        for (int i = 0; i < pramass.allKeys.count; i++) {
            paramsStr = [paramsStr stringByAppendingString:[NSString stringWithFormat:@"%@=%@&", pramass.allKeys[i], pramass.allValues[i]]];
        }
        NSLog(@"%@?%@", zcmdurl, paramsStr);
         [MBProgressHUD showActivityMessageInWindow:@"正在注册用户信息"];
        [WWZShuju initlizedData:zcmdurl paramsdata:pramass dicBlick:^(NSDictionary *info) {
            NSLog(@"%@", info);
            if ([info[@"r"] integerValue]==1) {
                [self getSaltNetWork];
            }else{
                NSLog(@"%@", info[@"msg"]);
                [self showTipView:NULL_TO_NIL(info[@"msg"])];
                [MBProgressHUD hideHUD];
            }
            
            NSLog(@"3%@",info);
            [[NSUserDefaults standardUserDefaults]setObject:info[@"item"][@"uid"] forKey:@"uid"];
            [[NSUserDefaults standardUserDefaults]setObject:info[@"item"][@"sid"] forKey:@"sid"];
            NSLog(@"%@,%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"uid"],[[NSUserDefaults standardUserDefaults]objectForKey:@"sid"]);
            
        }];
        
    }
}

- (void)getSaltNetWork
{
    NSMutableDictionary *paramss = [NSMutableDictionary dictionary];
    paramss[@"username"] =tf.text;
    paramss[@"at"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"at"];
    [MBProgressHUD showActivityMessageInWindow:@"正在获取加密信息"];
    [WWZShuju initlizedData:jmurl paramsdata:paramss dicBlick:^(NSDictionary *info) {
        NSLog(@"加密%@",info);
        [[NSUserDefaults standardUserDefaults]setObject:info[@"sid"] forKey:@"sid"];
        [[NSUserDefaults standardUserDefaults]setObject:info[@"salt"] forKey:@"salt"];
        [[NSUserDefaults standardUserDefaults]setObject:info[@"cd"] forKey:@"cd"];
        
        [self LogBtnNetWork];
        
    }];
    
}

- (void)LogBtnNetWork{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"at"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"at"];
    params[@"sid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"sid"];
    params[@"username"] =tf.text;
    // 数据MD5加密
    NSString * str = [self.passwordTF.text MD5];
    NSString *salt =  [NSString stringWithFormat:@"%@%@",str,[[NSUserDefaults standardUserDefaults]objectForKey:@"salt"]];
    NSString *str1 = [salt MD5];
    NSString *cd = [NSString stringWithFormat:@"%@%@",str1,[[NSUserDefaults standardUserDefaults]objectForKey:@"cd"]];
    NSString *str2 = [cd MD5];
    params[@"password"] = str2;
    NSLog(@"%@?%@",drurl, params);
    [MBProgressHUD showActivityMessageInWindow:@"即将登陆，请稍候"];
    [WWZShuju initlizedData:drurl paramsdata:params dicBlick:^(NSDictionary *info) {
        NSLog(@"-----2---------%@",info);
        [MBProgressHUD hideHUD];
        NSLog(@"%@------%@",str2,[[NSUserDefaults standardUserDefaults]objectForKey:@"cd"]);
        if ([info[@"r"] isEqualToNumber:@0]) {
            
            //加密
            NSString *temp = info[@"msg"];
            NSLog(@"%@", temp);
            if ([temp containsString:@"密码"]||[temp containsString:[@"密码" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]) {
                [MBProgressHUD hideHUD];
                [self showError:info[@"msg"]];
                return ;
            }else
            {
                [MBProgressHUD hideHUD];
                [self showHUD:temp de:2.0];
            }
            
        }else{
            // 绑定信鸽帐号
            [XGPush registerDevice:[UserDefaults objectForKey:KDeviceToken] successCallback:^{
                // 绑定信鸽帐号
                [XGPush setAccount:tf.text successCallback:^{
                    // 成功
                    NSLog(@"绑定信鸽帐号成功");
                } errorCallback:^{
                    // 失败
                    NSLog(@"绑定信鸽帐号失败");
                }];
            } errorCallback:^{
                NSLog(@"注册页面--注册信鸽推送失败！");
            }];
            
            
            [UserDefaults setObject:tf.text forKey:KAccount];
            [UserDefaults setObject:info[@"item"][@"uid"] forKey:@"uid"];
            [UserDefaults setObject:@"1" forKey:KNewRegister];
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
                            
                            [self turnToTabVC];
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
                    
                    [self turnToTabVC];
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
                            AppDelegateInstance.window.rootViewController = [[TabBarViewController alloc] init];
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
                [self turnToTabVC];
                break;
            }
            case LAErrorTouchIDNotAvailable:
            {
                NSLog(@"设备Touch ID不可用，例如未打开");
                [self turnToTabVC];
                break;
            }
            case LAErrorTouchIDNotEnrolled:
            {
                NSLog(@"设备Touch ID不可用，用户未录入");
                [self turnToTabVC];
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

- (void)turnToTabVC
{
    TabBarViewController *vc = [[TabBarViewController alloc]init];
    [self.view.window setRootViewController:vc];
}


#pragma mark - 提示框
-(void)showError1:(NSString *)error
{
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:error preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *av = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self turnToTabVC];
    }];
    [ac addAction:av];
    [self presentViewController:ac animated:YES completion:nil];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
