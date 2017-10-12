//
//  FindBackPayPwdViewController.m
//  iOS-YCJF
//
//  Created by 姜宁桃 on 2017/8/18.
//  Copyright © 2017年 Yincheng. All rights reserved.
//

#import "FindBackPayPwdViewController.h"
#import "yzBtn.h"
#import "SetPayPwdViewController.h"

@interface FindBackPayPwdViewController (){
    UIButton *btn;
}
/***<#注释#> ***/
@property (nonatomic ,strong)UITextField *textTF;
/***<#注释#> ***/
@property (nonatomic ,strong)yzBtn *sfbtn;
/***<#注释#> ***/
@property (nonatomic ,strong)UIView *view1;

@end

@implementation FindBackPayPwdViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = @"找回交易密码";
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
    UILabel *label = [[UILabel alloc] init];
    NSString *b = [NSString stringWithFormat:@"点击发送按钮向%@发送短信",[MineInstance shareInstance].mineModel.mobile_hidden];
    
    label.text = b;
    label.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    label.textColor = [UIColor colorWithRed:168/255.0 green:168/255.0 blue:168/255.0 alpha:1/1.0];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX. offset(0);
        make.top.offset(66+32);
    }];
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:label.text];
    
    [AttributedStr addAttribute:NSForegroundColorAttributeName
                          value:[UIColor orangeColor]
                          range:NSMakeRange(7, 11)];
    label.attributedText = AttributedStr;
    
    [self.view addSubview:self.view1];
    [self.view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(label.mas_bottom).offset(38);
        make.height.offset(50);
    }];
    
    btn = [[UIButton alloc]init];
    [btn setTitle:@"进行验证" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor redColor];
    btn.layer.masksToBounds =YES;
    btn.layer.cornerRadius = 4.0;
    
    btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    [btn addTarget:self action:@selector(btnclicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(12);make.right.offset(-12);
        make.top.equalTo(self.view1.mas_bottom).offset(40);
        make.height.offset(45);
    }];
    
}

#pragma mark - Event Hander
-(void)btnclicked{
    if (self.textTF.text.length == 0) {
        [self showTipView:@"请输入短信验证码"];
        [self.textTF becomeFirstResponder];
        return;
    }
    NSMutableDictionary *pramas = [NSMutableDictionary dictionary];
    pramas[@"mobile"] = [[NSUserDefaults standardUserDefaults]objectForKey:KAccount];
    pramas[@"verycode"] = self.textTF.text;
    pramas[@"at"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"at"];
    [WWZShuju initlizedData:yzsjyzmurl paramsdata:pramas dicBlick:^(NSDictionary *info) {
        NSLog(@"%@",info);
        NSLog(@"%@",info[@"msg"]);
        if ([info[@"r"] isEqualToString:@"1"]) {
            SetPayPwdViewController *vc = [[SetPayPwdViewController alloc]init];
            vc.verycodestr = self.textTF.text;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [self showTipView:info[@"msg"]];
        }
        
    }];
    
    
}
-(void)sfbtnClicked{
    [self.sfbtn time];
    NSMutableDictionary *pramass =[NSMutableDictionary dictionary];
    pramass[@"at"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"at"];
    pramass[@"mobile"] = [[NSUserDefaults standardUserDefaults]objectForKey:KAccount];
    NSLog(@"%@?%@", sjzhyzmurl, pramass);
    [WWZShuju initlizedData:sjzhyzmurl paramsdata:pramass dicBlick:^(NSDictionary *info) {
        
        NSLog(@"%@",info);
        if ([info[@"r"] isEqualToString:@"1"]) {
            NSLog(@"qqqqqqqqqqq");
        }else{
            NSLog(@"%@",info[@"msg"]);
        }
        
        [self showHUD:info[@"msg"] de:1.0];
        
    }];
}

#pragma mark - Getter
-(UIView *)view1{
    if(!_view1){
        _view1 = [[UIView alloc] init];
        _view1.backgroundColor = [UIColor whiteColor];
        [_view1 addSubview:self.textTF];
        [self.textTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(20);
            make.centerY.offset(0);
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
    }
    return _view1;
}
-(UITextField *)textTF{
    if(!_textTF){
        _textTF = [[UITextField alloc] init];
        _textTF.placeholder = @"输入短信验证码";
        //首字母是否大写
        _textTF.keyboardType = UIKeyboardTypeNumberPad;
        _textTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _textTF.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        
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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
