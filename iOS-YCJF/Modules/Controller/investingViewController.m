//
//  investingViewController.m
//  iOS-CHJF
//
//  Created by garday on 2017/3/15.
//  Copyright © 2017年 garday. All rights reserved.
//

#import "investingViewController.h"
#import "payView.h"
#import "yesandnoViewController.h"
#import "keshiyongViewController.h"
#import "xqModel.h"
#import "MineItemModel.h"
#import "AccinfoModel.h"
#import "paymentView.h"
#import "FindBackPayPwdViewController.h"
#import "ModiPwdViewController.h"
#import "protocolOfInvestViewController.h"
#import "certificationViewController.h"
#import "CashValueViewController.h"
#import "FindBackPayPwdViewController.h"

@interface investingViewController ()<UITextFieldDelegate>{
    NSString *ssdk;
    NSString * str1;
    xqModel *HeadVWDataMode;
}
/***年化 ***/
@property (nonatomic ,strong)NSString *nahuastr;
/***蓝色的view ***/
@property (nonatomic ,strong)UIView *lanView;
/***白色的View ***/
@property (nonatomic ,strong)UIView *baiView;
/***lab ***/
@property (nonatomic ,strong)UILabel *linlab;
/***余额 ***/
@property (nonatomic ,strong)UILabel *yuelab;
/***元 ***/
@property (nonatomic ,strong)UIButton *yuanbtn;
/***预期收益 ***/
@property (nonatomic ,strong)UILabel *yulab;

/***题目数据 ***/
@property (nonatomic ,strong)NSArray *HeadTitleArr;
/***显示数据 ***/
@property (nonatomic ,strong)NSMutableArray *sjarr;
/***textfield ***/
@property (nonatomic ,strong)UITextField *textf;

/***点击确定按钮 ***/
@property (nonatomic ,strong)UIButton *tbBtn;
/***同意遵守购买协议 ***/
@property (nonatomic ,strong)UIButton *tyBtn;
/***确定付款按钮 ***/
@property (nonatomic ,strong)UIButton *paymentBtn;
/*** ***/
@property (nonatomic ,strong)NSString *str;

/***<#注释#> ***/
@property (nonatomic ,strong)payView *payV;
/***<#注释#> ***/
@property (nonatomic ,strong)UIButton *jjbtn;
/***<#注释#> ***/
@property (nonatomic ,strong)NSString *ssy;
/***<#注释#> ***/
@property (nonatomic ,strong)UILabel *yulabxq;
/***<#注释#> ***/
@property (nonatomic ,strong)NSMutableArray *daArr;

@property (nonatomic, strong) paymentView * payView;
@property (nonatomic, copy) NSString *payPwd;

@end

@implementation investingViewController


-(NSMutableArray *)daArr{
    if (!_daArr) {
        _daArr =[NSMutableArray array];
        [_daArr addObject:self.borrow_account_wait];
        if ([self.model.apr_B floatValue] == 0) {
            NSString * s = @"%";
            [_daArr addObject:[NSString stringWithFormat:@"%@%@", self.borrow_apr, s]];
        }else
        {
            NSString * s = @"%";
            [_daArr addObject:[NSString stringWithFormat:@"%ld%@+%ld%@",[self.model.apr_A integerValue], bfh, [self.model.apr_B integerValue], s]];
        }
        [_daArr addObject:self.borrow_period];
    }return _daArr;
}
-(NSString *)str{
    if (!_str) {
        _str = [NSString string];
    }
    return _str;
}
-(NSString *)ssy{
    if (!_ssy) {
        _ssy = [NSString string];
    }
    return _ssy;
}
-(NSString *)nahuastr{
    if (!_nahuastr) {
        _nahuastr    = [NSString string];
    }
    return _nahuastr;
}
-(UITextField *)textf{
    if (!_textf) {
        _textf = [[UITextField alloc]init];
        _textf.placeholder = @"请输入金额";
        _textf.backgroundColor = [UIColor whiteColor];
        _textf.borderStyle =UITextBorderStyleNone;
        NSLog(@"%@", [UserDefaults objectForKey:KAccount]);
        if ([[UserDefaults objectForKey:KAccount] isEqualToString:@"15267065901"] || [[UserDefaults objectForKey:KAccount] isEqualToString:@"13516779834"]) {
            _textf.keyboardType = UIKeyboardTypeDecimalPad;
        }else
        {
            _textf.keyboardType = UIKeyboardTypeNumberPad;
        }
        _textf.keyboardAppearance=UIKeyboardAppearanceAlert;
    [_textf addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _textf.font = [UIFont fontWithName:@"PingFangSC-Regular" size:22];
    }
    return _textf;
}
-(UIButton *)jjbtn{
    if (!_jjbtn) {
        _jjbtn = [[UIButton alloc]init];
        [_jjbtn addTarget:self action:@selector(jjBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        _jjbtn.backgroundColor = [UIColor whiteColor];
        UILabel *sy =[[UILabel alloc]init];
        sy.text = @"使用优惠";
        sy.backgroundColor =[UIColor whiteColor];
        sy.font = [UIFont systemFontOfSize:15];
        sy.textColor = [UIColor lightGrayColor];
        [_jjbtn addSubview:sy];
        [sy mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(10);
            make.centerY.offset(0);
        }];
        self.xs =[[UILabel alloc]init];
        self.xs.text = @"优惠劵可用";
        self.xs.backgroundColor =[UIColor whiteColor];
        self.xs.font = [UIFont systemFontOfSize:15];
        self.xs.textColor = [UIColor lightGrayColor];
        [_jjbtn addSubview:self.xs];
        [self.xs mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-10);
            make.centerY.offset(0);
        }];
        
    }return _jjbtn;
}

-(NSArray *)HeadTitleArr{
    if (!_HeadTitleArr) {
        _HeadTitleArr = [NSArray array];
        _HeadTitleArr = @[@"剩余可投",@"预期收益率",@"项目期限"];
    }
    return _HeadTitleArr;
}
-(NSMutableArray *)sjarr{
    if (!_sjarr) {
        _sjarr = [NSMutableArray array];
      
    }
    return _sjarr;
}
-(UILabel *)linlab{
    if (!_linlab) {
        _linlab = [[UILabel alloc]init];
//        _linlab.text = @"【临平】宝马X4抵押";
        _linlab.textColor = [UIColor whiteColor];
        _linlab.backgroundColor = lancolor;
        _linlab.font = [UIFont systemFontOfSize:16];
    }
    return _linlab;
}
-(UIButton *)yuanbtn{
    if (!_yuanbtn) {
        _yuanbtn = [[UIButton alloc]init];
        [_yuanbtn setTitleColor:lancolor forState:UIControlStateNormal];
        [_yuanbtn setTitle:@"余额全投" forState:UIControlStateNormal];
        [_yuanbtn addTarget:self action:@selector(yuanBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        _yuanbtn.backgroundColor = [UIColor whiteColor];
        _yuanbtn.titleLabel.font =  [UIFont fontWithName:@"PingFangSC-Regular" size:14];    }
    return _yuanbtn;
}
-(UILabel *)yuelab{
    if (!_yuelab) {
        _yuelab = [[UILabel alloc]init];
        _yuelab.textColor = [UIColor redColor];
        NSString *st = [NSString stringWithFormat:@"账户余额 ¥ 0.00"];
        _yuelab.text = st;
        _yuelab.numberOfLines = 0;
        _yuelab.font = [UIFont systemFontOfSize:15];
       
        
    }
    return _yuelab;
}
-(UILabel *)yulab{
    if (!_yulab) {
        _yulab = [[UILabel alloc]init];
        _yulab.textColor = [UIColor blackColor];
        _yulab.text = @"预期收益:";
        _yulab.numberOfLines = 0;
        _yulab.font = [UIFont systemFontOfSize:15];
        
    }
    return _yulab;
}
-(UILabel *)yulabxq{
    if (!_yulabxq) {
        _yulabxq = [[UILabel alloc]init];
        _yulabxq.textColor = lancolor;
        _yulabxq.text = @"0.00";
        _yulabxq.numberOfLines = 0;
        _yulabxq.font = [UIFont systemFontOfSize:15];
        
    }
    return _yulabxq;
}


-(UIButton *)tbBtn{
    if (!_tbBtn) {
        _tbBtn = [[UIButton alloc]init];
        
        [_tbBtn setBackgroundImage:[UIImage imageNamed:@"icon_agree_click"] forState:UIControlStateNormal];
        [_tbBtn setBackgroundImage:[UIImage imageNamed:@"icon_agree"] forState:UIControlStateSelected];
        [_tbBtn addTarget:self action:@selector(quedingclicked:) forControlEvents:UIControlEventTouchUpInside];
        _tbBtn.layer.masksToBounds = YES;
        _tbBtn.layer.cornerRadius = _tbBtn.frame.size.width/2;
    }
    return _tbBtn;
}
-(UIButton *)tyBtn{
    if (!_tyBtn) {
        _tyBtn = [[UIButton alloc]init];
        [_tyBtn setTitle:@"我同意《银程金服购买协议》" forState:UIControlStateNormal];
        [_tyBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_tyBtn addTarget:self action:@selector(tongyiclicked) forControlEvents:UIControlEventTouchUpInside];
        _tyBtn.backgroundColor = grcolor;
        _tyBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:_tyBtn.titleLabel.text];
        [AttributedStr addAttribute:NSForegroundColorAttributeName
                              value: [UIColor colorWithRed:108/255.0 green:152/255.0 blue:228/255.0 alpha:1/1.0]
                              range:NSMakeRange(3, 10)];
        _tyBtn.titleLabel.attributedText = AttributedStr;

    }
    return _tyBtn;
}
-(UIButton *)paymentBtn{
    if (!_paymentBtn) {
        _paymentBtn = [[UIButton alloc]init];
        _paymentBtn.backgroundColor = [UIColor redColor];
        [_paymentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _paymentBtn.layer.masksToBounds = YES;
        [_paymentBtn setTitle:@"确定购买" forState:UIControlStateNormal];
        [_paymentBtn addTarget:self action:@selector(paymentBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        _paymentBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        _paymentBtn.layer.cornerRadius = 5.0;
    }
    return _paymentBtn;
}

-(UIView *)lanView{
    if (!_lanView) {
        _lanView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 114)];
        _lanView.backgroundColor = lancolor;
    }
    return _lanView;
}
-(UIView *)baiView{
    if (!_baiView) {
        _baiView = [[UIView alloc]initWithFrame:CGRectMake(0, _lanView.frame.size.height+_lanView.frame.origin.y +10, self.view.frame.size.width, 156)];
        _baiView.backgroundColor = [UIColor whiteColor];
    }
    return _baiView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self Nav];
    
    KPostNotification(KNotificationRefreshMineDatas, nil);
    self.mineModel = [MineInstance shareInstance].mineModel;
    self.accModel = [MineInstance shareInstance].accModel;
    if (!self.accModel.ky_account) {
        NSLog(@"数据为空");
        [self loadNewTopics];
    }
    self.linlab.text = [NSString stringWithFormat:@"%@",self.model.name];
    [self.view addSubview:self.lanView];
    [self.view addSubview:self.baiView];
    [self setbtn];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:self.title];
    [TalkingData trackPageEnd:self.title];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     self.title =@"购买";
    [MobClick beginLogPageView:self.title];
    [TalkingData trackPageBegin:self.title];
    [self AFN1];
    [self AFN];
    if (self.sqman == nil) {
        self.xs.text = @"优惠劵可用";
        self.xs.textColor = [UIColor lightGrayColor];
    }else{
        _xs.text = self.sqman;
        _xs.textColor = [UIColor redColor];
        self.yulabxq.text = @"";
    }
    
    if (self.jisuanbfb) {
        NSLog(@"%@  %@  %@  %@", self.jisuanbfb, _textf.text, self.ssy, self.nahuastr);
        float s = [_textf.text floatValue];
        float ss = [self.ssy floatValue];
        float nh = [self.nahuastr floatValue]/100;
        float jx = [self.jisuanbfb floatValue]/100;
        float zs = ((ss/nh) *(nh + jx))*s/100;
        self.yulabxq.text =[NSString stringWithFormat:@"%0.2f",zs];
    }else
    {
        float s = [_textf.text floatValue];
        float ss = [self.ssy floatValue];
        float sq = s/100 *ss;
        self.yulabxq.text =[NSString stringWithFormat:@"%0.2f",sq];
    }
}

-(void)loadNewTopics{
    
    NSMutableDictionary *pramas = [NSMutableDictionary dictionary];
    pramas[@"uid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"uid"];
    pramas[@"sid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"sid"];
    pramas[@"accinfo"] = @"1";
    pramas[@"at"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"at"];
    NSLog(@"%@?%@", Myurl, pramas);
    [WWZShuju initlizedData:Myurl paramsdata:pramas dicBlick:^(NSDictionary *info) {
        NSLog(@"%@", info[@"msg"]);
        NSLog(@"--我的--%@",info);
        if ([info[@"r"] integerValue] == 1) {
            // 给单例赋值
            self.mineModel = [[MineItemModel alloc] initWithDictionary:info[@"item"] error:nil];
            self.accModel = [[AccinfoModel alloc] initWithDictionary:info[@"accinfo"] error:nil];
            [UserDefaults setObject:info[@"item"][@"real_status"] forKey:KReal_status];
            [UserDefaults setObject:info[@"item"][@"is_defaultpaypass"] forKey:KIs_defaultpaypass];
            [UserDefaults synchronize];
        }
    }];
}

-(void)AFN1{
    [MBProgressHUD showActivityMessageInWindow:@"数据加载中"];
    NSMutableDictionary *pramas = [NSMutableDictionary dictionary];
    pramas[@"uid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"uid"];
    pramas[@"sid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"sid"];
    pramas[@"at"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"at"];
    pramas[@"version"] = @"v1.0.3";
    pramas[@"os"] = @"ios";
    pramas[@"bid"] = self.bid;
    NSLog(@"%@?%@", gmbxxxxurl, pramas);
    [WWZShuju initlizedData:gmbxxxxurl paramsdata:pramas dicBlick:^(NSDictionary *info) {
        NSLog(@"----购买---%@, msg:%@",info, info[@"msg"]);
        [MBProgressHUD hideHUD];
         HeadVWDataMode = [xqModel mj_objectWithKeyValues:info[@"binfo"]];
        
        if ([info[@"r"] integerValue]== 1) {
            [self.daArr addObject:HeadVWDataMode.borrow_account_wait];
            [self.daArr addObject:HeadVWDataMode.borrow_apr];
            if ([HeadVWDataMode.days isEqualToString:@"0"]) {
                [self.daArr addObject:HeadVWDataMode.borrow_period];
            }else{
                [self.daArr addObject:HeadVWDataMode.days];
                
            }
            
            if (HeadVWDataMode.MeBalance != NULL) {
                self.yuelab.text =[NSString stringWithFormat:@"账户余额 ¥%@",HeadVWDataMode.MeBalance] ;
            }else
            {
                self.yuelab.text =[NSString stringWithFormat:@"账户余额 ¥0.00"] ;
            }
            if ([self.xs.text isEqualToString:@"优惠劵可用"]) {
                self.xs.text = [NSString stringWithFormat:@"%@张优惠劵", info[@"tot_hbnum"]];
                NSMutableAttributedString *AttributedStr1 = [[NSMutableAttributedString alloc]initWithString:self.xs.text];
                NSInteger length = [[NSString stringWithFormat:@"%@张", info[@"tot_hbnum"]] length];
                NSRange range = NSMakeRange(0, length);
                [AttributedStr1 addAttribute:NSForegroundColorAttributeName
                                       value:[UIColor redColor]
                                       range:range];
                self.xs.attributedText = AttributedStr1;
            }
            NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:_yuelab.text];
            [AttributedStr addAttribute:NSForegroundColorAttributeName
                                  value:[UIColor blackColor]
                                  range:NSMakeRange(0, 4)];
            _yuelab.attributedText = AttributedStr;
            self.ssy = info[@"interest_total"];
            self.str = HeadVWDataMode.MeBalance;
            self.nahuastr = self.model.borrow_apr;
            

        }else if ([info[@"msg"] hasSuffix:@"请重新登录后访问！"]) {
            if ([UserDefaults objectForKey:KAccount] && [UserDefaults objectForKey:[UserDefaults objectForKey:KAccount]]) {
                [self reloginEvent];
            }
        }
    }];
}

- (void)reloginEvent
{
    NSMutableDictionary *paramss = [NSMutableDictionary dictionary];
    paramss[@"username"] =[UserDefaults objectForKey:KAccount];
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

- (void)LogBtnNetWork{
    [MBProgressHUD showActivityMessageInWindow:@"正在登录，请稍候"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"at"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"at"];
    params[@"sid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"sid"];
    params[@"username"] =[UserDefaults objectForKey:KAccount];
    // 数据MD5加密
    NSString * str = [[UserDefaults objectForKey:[UserDefaults objectForKey:KAccount]] MD5];
    NSString *salt =  [NSString stringWithFormat:@"%@%@",str,[[NSUserDefaults standardUserDefaults]objectForKey:@"salt"]];
    NSString *strr1 = [salt MD5];
    NSString *cd = [NSString stringWithFormat:@"%@%@",strr1,[[NSUserDefaults standardUserDefaults]objectForKey:@"cd"]];
    NSString *str2 = [cd MD5];
    params[@"password"] = str2;
    NSLog(@"%@?%@",drurl, params);
    [WWZShuju initlizedData:drurl paramsdata:params dicBlick:^(NSDictionary *info) {
        NSLog(@"-----2---------%@",info);
        [MBProgressHUD hideHUD];
        NSLog(@"%@------%@",str2,[[NSUserDefaults standardUserDefaults]objectForKey:@"cd"]);
        
        if ([info[@"r"] isEqualToNumber:@0]) {
            
            //加密
            NSString *temp = info[@"msg"];
            NSLog(@"%@", temp);
            
        }else{
            KPostNotification(KNotificationRefreshMineDatas, nil);
            [self AFN1];
        }
        
    }];
    
}


- (void)textFieldDidChange:(UITextField *)textField
{
    if (self.sqman ==nil) {
        NSLog(@"%@ ssy:%@", textField.text, self.ssy);
        float s = [textField.text floatValue];
        float ss = [self.ssy floatValue];
        float sq = s/100 *ss;
        self.yulabxq.text =[NSString stringWithFormat:@"%0.2f",sq];
    }else{
        if ([self.jsyhq isEqualToString:@"抵扣券"]) {
            ssdk = [NSString string];
            float s = [textField.text floatValue];
            float jx = [self.jssuan floatValue];
            float zs = s-jx;
            ssdk= [NSString stringWithFormat:@"-%.0f",zs];
            NSLog(@"%@", ssdk);
            
            float ss = [self.ssy floatValue];
            float sq = s/100 *ss;
            self.yulabxq.text =[NSString stringWithFormat:@"%0.2f",sq];
            
        }else{
            float s = [textField.text floatValue];
            
            float ss = [self.ssy floatValue];
            float nh = [self.nahuastr floatValue]/100;
            float jx = [self.jisuanbfb floatValue]/100;
            float zs = ((ss/nh) *(nh + jx))*s/100;
            self.yulabxq.text =[NSString stringWithFormat:@"%0.2f",zs];
            
        }
    }
    
}

-(void)Nav{
    self.view.backgroundColor = grcolor;
    self.navigationController.navigationBar.tintColor =[UIColor whiteColor];
    UIButton *leftButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 10, 19)];
    [leftButton addTarget:self action:@selector(leftbtnclicked) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"icon_back_click"] forState:UIControlStateNormal];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateHighlighted];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:leftButton];
}

-(void)setUI{
    
}
-(void)setbtn{
    [self.lanView addSubview:self.linlab];
    [self.linlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(6);
        make.top.offset(17);
        
        }];
    
    CGFloat labMargin = 8;
    CGFloat SingleLabMargin = 5;
    CGFloat SingleLabWidth = (ScreenWidth-(2*labMargin)-(2*SingleLabMargin))/3;
    for (NSInteger i= 0; i<3; i++) {
        UILabel *lab = [self QuickSetLab];
        if (i == 1 ||i == 2 ) {
            lab.textAlignment = NSTextAlignmentCenter;
        }
        lab.text = self.HeadTitleArr[i];
        [self.lanView addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.lanView.mas_centerY);
            make.height.offset(18);
            make.left.equalTo(self.lanView.mas_left).offset(labMargin +(i *(SingleLabMargin + SingleLabWidth)));
            make.width.offset(SingleLabWidth);
        }];
         }
           for (NSInteger j= 0; j<self.daArr.count; j++) {
            UILabel *lab1 = [self QuickSetLab];
            if (j == 1 ||j == 2 ) {
                lab1.textAlignment = NSTextAlignmentCenter;
            }
            lab1.text = self.daArr[j];
            
            [self.lanView addSubview:lab1];
    
            [lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.lanView.mas_centerY).offset(24);
                make.height.offset(18);
                make.left.equalTo(self.lanView.mas_left).offset(labMargin +(j *(SingleLabMargin + SingleLabWidth)));
                make.width.offset(SingleLabWidth);
            }];
    }
    
    [self.baiView addSubview:self.yuelab];
    [_yuelab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.offset(17);

    }];
    
    
    [self.baiView addSubview:self.textf];
    [_textf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.baiView.mas_centerY);
        make.left.mas_offset(14);
        make.size.mas_equalTo(CGSizeMake(_baiView.width *2/3, 30));
    }];
    
    [self.baiView addSubview:self.yuanbtn];
    [self.yuanbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(_textf.centerY);
        make.right.offset(-20);
    }];

    UIView *view = [[UIView alloc] init];
    view.backgroundColor =lancolor;
    [self.baiView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.yuanbtn.mas_centerY);
        make.right.equalTo(self.yuanbtn.mas_left).offset(-20);
        make.width.offset(1);make.height.offset(20);
    }];
    
    
    UIImageView *imv = [[UIImageView alloc]init];
    imv.image = [UIImage imageNamed:@"xuxian"];
    [self.baiView addSubview:imv];
    [imv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(16);
        make.right.offset(-19);
        make.top.offset(104);
    }];
    
    [self.baiView addSubview:self.yulab];
    [self.yulab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.bottom.offset(-16);
    }];
    [self.baiView addSubview:self.yulabxq];
    [self.yulabxq mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_yulab.mas_right).offset(2);
        make.bottom.offset(-16);
    }];
    
#warning 奖劵
    UILabel *qitou = [[UILabel alloc]init];
    qitou.text = [NSString stringWithFormat:@"%@起投，且以一元的整数倍递增", self.model.tender_account_min];
    qitou.backgroundColor =grcolor;
    qitou.font = [UIFont systemFontOfSize:14];
    qitou.textColor = [UIColor blackColor];
    [self.view addSubview:qitou];
    [qitou mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.top.equalTo(_baiView.mas_bottom).offset(5);
    }];
    
    [self.view addSubview:self.jjbtn];
    [self.jjbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(qitou.mas_bottom).offset(5);
        make.left.right.offset(0);
        make.height.offset(40);
    }];
    
    [self.view addSubview:self.tbBtn];
    [self.tbBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.top.equalTo(self.jjbtn.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
    
    [self.view addSubview:self.tyBtn];
    [self.tyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       make.centerY.equalTo(self.tbBtn.mas_centerY);
        make.left.equalTo(self.tbBtn.mas_right).offset(2);
    }];
    
    [self.view addSubview:self.paymentBtn];
    [self.paymentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(13);
        make.right.offset(-13);
        make.top.equalTo(self.tyBtn).offset(40);
        make.height.offset(45);
    }];
    
    UIButton *alertbtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.center.x-100,CGRectGetMaxY(self.view.frame)-42, 200, 17)];
    [alertbtn setTitleColor:[UIColor colorWithRed:195/255.0 green:195/255.0 blue:195/255.0 alpha:1/1.0] forState:UIControlStateNormal];
    [alertbtn setImage:[UIImage imageNamed:@"Group 6"] forState:UIControlStateNormal];
    [alertbtn setTitle:@"投资有风险 理财需谨慎" forState:UIControlStateNormal];
    alertbtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:alertbtn];
}



-(void)jjBtnClicked{
    if (_textf.text.length != 0 || [_textf.text integerValue] != 0) {
        keshiyongViewController *keshi =[[keshiyongViewController alloc]init];
        keshi.titlestr = @"我的奖劵";
        keshi.inputMoney = self.textf.text;
        NSLog(@"%@%@", keshi.titlestr, keshi.inputMoney);
        [self.navigationController pushViewController:keshi animated:YES];
    }else
    {
        [MBProgressHUD showTipMessageInView:@"请先输入投资金额" timer:1.0];
    }

}

-(void)leftbtnclicked{
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rightbtnclicked{
    
}
-(void)yuanBtnClicked{
    NSLog(@"%@, %@", self.borrow_account_wait, self.str);
    if ([self.borrow_account_wait floatValue]>[self.str floatValue]) {
        if ([[UserDefaults objectForKey:KAccount] isEqualToString:@"15267065901"] || [[UserDefaults objectForKey:KAccount] isEqualToString:@"13516779834"]) {
            _textf.text = [NSString stringWithFormat:@"%.2f", [self.str floatValue]];
        }else
        {
            _textf.text = [NSString stringWithFormat:@"%ld", [self.str integerValue]];
        }
    }else{
        if ([[UserDefaults objectForKey:KAccount] isEqualToString:@"15267065901"] || [[UserDefaults objectForKey:KAccount] isEqualToString:@"13516779834"]) {
            _textf.text = [NSString stringWithFormat:@"%.2f", [self.borrow_account_wait floatValue]];
        }else
        {
            _textf.text = [NSString stringWithFormat:@"%ld", [self.borrow_account_wait integerValue]];
        }
    }
    [self textFieldDidChange:self.textf];
}

-(void)quedingclicked:(UIButton *)sender{

    UIButton *button = sender;
    
    button.selected = !button.selected;
    if (button.selected) {
        _paymentBtn.alpha = 0.4;
        _paymentBtn.userInteractionEnabled= NO;
    }else{
        _paymentBtn.alpha = 1.0;
        _paymentBtn.userInteractionEnabled= YES;
    }
   
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(void)tongyiclicked{
    
    NSMutableDictionary *prama = [NSMutableDictionary dictionary];
    prama[@"uid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"uid"];
    prama[@"sid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"sid"];
    prama[@"at"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"at"];
    prama[@"version"] = @"v1.0.3";
    prama[@"os"] = @"ios";
    prama[@"bid"] = self.bid;
    NSLog(@"%@?%@", ycjfgmxy, prama);
    [WWZShuju initlizedData:ycjfgmxy paramsdata:prama dicBlick:^(NSDictionary *info) {
        NSLog(@"%@", info);
        if ([info[@"r"] integerValue] == 1) {
            protocolOfInvestViewController * vc = [[protocolOfInvestViewController alloc] init];
            vc.tzrinfo = info[@"tzrinfo"];
            vc.money = self.textf.text;
            vc.data = info[@"data"];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
}

-(void)AFN{
    str1 = [NSString string]; //密匙
    
    NSMutableDictionary *prama = [NSMutableDictionary dictionary];
    prama[@"uid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"uid"];
    prama[@"sid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"sid"];
    prama[@"at"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"at"];
    prama[@"version"] = @"v1.0.3";
    prama[@"os"] = @"ios";
    
    [WWZShuju initlizedData:mmmsrl paramsdata:prama dicBlick:^(NSDictionary *info) {
        NSLog(@"%@", info);
        if ([info[@"r"] integerValue] == 1) {
            str1 =[NSString stringWithFormat:@"%@",info[@"sedpassed"]];
            NSLog(@"%@",str1);
        }
    }];
}


-(void)paymentBtnClicked{
    
    NSString * localpassone = [[NSUserDefaults standardUserDefaults]objectForKey:KIs_defaultpaypass];
    if ( [localpassone integerValue] == 1) {
        //  还没有修改过交易密码
        [self showError:@"您还没绑定过交易密码，请先绑定交易密码"];
    }else
    {
        NSString * real_status = [UserDefaults objectForKey:KReal_status];
        // 没有通过实名认证,请先去实名认证
        if ([real_status integerValue] == 2) {
            if (_textf.text.length ==0) {
                [self showError:@"投入金额不能为空或者不能为零"];
            }else if ( [_textf.text floatValue] == 0){
                [self showError:@"投入金额不能为空或者不能为零"];
            }else if ([_textf.text floatValue] < [HeadVWDataMode.tender_account_min floatValue])
            {
                [self showHUD:[NSString stringWithFormat:@"%@起投", HeadVWDataMode.tender_account_min] de:1.0];
            }else if ([_textf.text floatValue] > [HeadVWDataMode.borrow_account_wait floatValue])
            {
                [self showHUD:[NSString stringWithFormat:@"投入金额不能大于可投金额"] de:1.0];
            }else if ([_textf.text floatValue] > [HeadVWDataMode.MeBalance floatValue])
            {
                [self showErrorSheet:[NSString stringWithFormat:@"帐户余额不足%@元, 请先充值", _textf.text]];
            }else{
        
                _payV = [[payView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
                
                NSString *qaq =[NSString stringWithFormat:@"-%@",_textf.text];
                ssdk = [NSString string];
                float s = [_textf.text floatValue];
                float jx = [self.jssuan floatValue];
                float zs = s-jx;
                ssdk= [NSString stringWithFormat:@"-%.0f",zs];
                NSLog(@"%@ %@",[ssdk substringFromIndex:1], qaq);
                _payV.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
                _payV.sjarr =[NSArray arrayWithObjects:_textf.text,self.self.sqman== nil?@"无奖劵使用":self.xs.text,[self.jsyhq isEqualToString:@"抵扣券"] ?ssdk:  qaq, nil];
                NSLog(@"%@", _payV.sjarr);
                [self.view.window addSubview:_payV];
                
                __block investingViewController *blockSelf = self;
                self.payV.deliverViewBlock = ^(){
                    
                    [blockSelf.view addSubview:blockSelf.payView];
                    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                        blockSelf.payView.frame = CGRectMake(0, screen_height-420, screen_width, 420);
                    } completion:^(BOOL finished) {
                        [blockSelf.payView becomeFirstResponder];
                    }];
                    /**
                     *  会崩，先注了
                     */
                    blockSelf.payView.foundBlock = ^{
                        NSLog(@"忘记交易密码，找回密码");
                        [self showError:@"忘记交易密码，找回密码"];
                    };
                };
            }
        }else if([KGetReal_status integerValue] == 0)
        {
            [self showError:@"您还没有通过实名认证,请先去实名认证"];
        }else if ([KGetReal_status integerValue] == 1){
            [self showError:@"您正在认证中是否重新认证"];
        }
    }
}
-(void)push{
    
}
/*
#pragma mark - 提示框
-(void)showError:(NSString *)error
{
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:error preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *av = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if ([error isEqualToString:@"您还没绑定过交易密码，请先绑定交易密码"]) {
            ModiPwdViewController * vc = [[ModiPwdViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([error isEqualToString:@"您暂未认证,请前往设置中心认证"]){
            if ([preUrl hasPrefix:@"http://120.27.211.129"]) {
                // 测试服
                [self showError:@"测试服需要认证直接找后台修改状态就可以了"];
            }else
            {
                // 正式服
                CertificationViewController *vc = [[CertificationViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
        
    }];
    [ac addAction:av];
    [self presentViewController:ac animated:YES completion:nil];
    
}
*/

#pragma mark - 提示框
-(void)showError:(NSString *)error
{
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:error preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sv = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([error isEqualToString:@"您正在认证中是否重新认证"]) {
            [self reRealAction];
        }else if ([error isEqualToString:@"您还没有通过实名认证,请先去实名认证"]) {
            if ([preUrl hasPrefix:@"http://120.27.211.129"]) {
                // 测试服
                [self showError:@"测试服需要认证直接找后台修改状态就可以了"];
            }else
            {
                // 正式服
                CertificationViewController *vc = [[CertificationViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }else if ([error isEqualToString:@"您还没绑定过交易密码，请先绑定交易密码"])
        {
            ModiPwdViewController * setPassVC = [[ModiPwdViewController alloc] init];
            [self.navigationController pushViewController:setPassVC animated:YES];
        }else if ([error isEqualToString:@"忘记交易密码，找回密码"]){
            FindBackPayPwdViewController * vc = [[FindBackPayPwdViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
    [ac addAction:sv];
    UIAlertAction *av = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [ac addAction:av];
    [self presentViewController:ac animated:YES completion:nil];
    
}

- (void)reRealAction
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"uid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"uid"];
    params[@"sid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"sid"];
    params[@"at"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"at"];
    params[@"version"] = @"v1.0.3";
    params[@"os"] = @"ios";
    
    NSLog(@"%@?%@", qxscsmrzurl, params);
    [WWZShuju initlizedData:qxscsmrzurl paramsdata:params dicBlick:^(NSDictionary *info) {
        
        NSLog(@"%@", info);
        if ([info[@"r"] integerValue] == 1) {
            [self showHUD:@"您已经成功重置认证信息" de:1.5];
            [UserDefaults setObject:@"0" forKey:KReal_status];
            [UserDefaults synchronize];
        }else{
            [self showErrorSheet:@"重置失败，您已经认证成功，若需要修改请联系客服:400-005-6677"];
        }
    }];
}

#pragma mark - 提示框
-(void)showErrorSheet:(NSString *)error
{
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:error preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *tv = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        CashValueViewController * vc = [[CashValueViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [ac addAction:tv];
    UIAlertAction *av = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [ac addAction:av];
    [self presentViewController:ac animated:YES completion:nil];
    
}

-(UILabel *)QuickSetLab{
    UILabel *Lab = [[UILabel alloc]init];
    Lab.textColor = [UIColor whiteColor];
    Lab.font = [UIFont systemFontOfSize:13];
    Lab.backgroundColor = lancolor;
     Lab.numberOfLines = 0;
    return Lab;
}

-(paymentView *)payView
{
    if (!_payView) {
        _payView = [[paymentView alloc] initWithFrame:CGRectMake(0, screen_height-420, screen_width, 420)];
        _payView.tip = @"请输入交易密码";
        __weak typeof(self) weakself = self;
        _payView.textChangeBlock = ^(NSString *text){
            weakself.payPwd = text;
        };
        _payView.frame = CGRectMake(0, screen_height, screen_width, 420);
    }
    return _payView;
}

- (void)setPayPwd:(NSString *)payPwd
{
    _payPwd = payPwd;
    if (payPwd.length == 6) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 提现网络请求
            NSLog(@"%@", payPwd);
            [self.payView endEditing:YES];
            [self NetWorkOfWithdraw];
        });
    }
    
}

- (void)NetWorkOfWithdraw
{
    NSMutableDictionary *pass =[NSMutableDictionary dictionary];
    pass[@"uid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"uid"];
    pass[@"sid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"sid"];
    pass[@"at"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"at"];
    pass[@"version"] = @"v1.0.3";
    pass[@"os"] = @"ios";
    pass[@"bid"] = self.bid;
    pass[@"account"] = self.textf.text;;
    pass[@"hbid"] = self.hbid;
    pass[@"jxid"] = self.jxid;
    NSString *ljm = [self.payPwd MD5];
    NSString *ms = [NSString stringWithFormat:@"%@%@",ljm,str1];
    NSLog(@"%@", ms);
    NSString *xmm = [ms MD5];
    pass[@"paypass"] = xmm;
    pass[@"txtype"] = @"zfb";
    NSLog(@"%@?%@", gmburl, pass);
    [WWZShuju initlizedData:gmburl paramsdata:pass dicBlick:^(NSDictionary *info) {
        NSLog(@"%@",info);
        if ([info[@"r"] integerValue] == 1) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD showSuccessMessage:info[@"msg"]];
                [self.payView clear];
                [self.payView closeBtnEvnet];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    //                交易成功跳转的界面
                    NSString * money = [_payV.sjarr[2] substringFromIndex:1];
                    yesandnoViewController *vc = [[yesandnoViewController alloc]init];
                    vc.shareAddress = self.shareAddress;
                    vc.IsSuccess = YES;
                    vc.money = money;//self.textf.text;
                    if ([info[@"s"] count] >=5) {
                        NSLog(@"%@", [info[@"s"] objectAtIndex:3]);
                        NSLog(@"%@", [info[@"s"] objectAtIndex:4]);
                        if ([[info[@"s"] objectAtIndex:3] integerValue] == 0) {
                            vc.isShowRedPacket = NO;
                        }else if ([[info[@"s"] objectAtIndex:3] integerValue] == 1)
                        {
                            vc.isShowRedPacket = YES;
                        }
                        if ([info[@"s"] objectAtIndex:4]) {
                            vc.moneyOfRedPacket = [[info[@"s"] objectAtIndex:4] stringValue];
                            NSLog(@"%@", vc.moneyOfRedPacket);
                        }
                    }
                    vc.getMoney = self.yulabxq.text;
                    vc.model = self.model;
                    NSLog(@"%@", self.model.apr_B);
                    [self.navigationController pushViewController:vc animated:YES];
                });
            });
        }else
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD showErrorMessage:info[@"msg"]];
                if ([info[@"msg"] hasPrefix:@"交易密码"]) {
                    [self.payView clear];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.payView becomeFirstResponder];
                    });
                }else
                {
                    [self.payView clear];
                    [self.payView closeBtnEvnet];
                }
            });
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
