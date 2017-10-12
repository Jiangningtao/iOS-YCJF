//
//  zfbczViewController.m
//  iOS-CHJF
//
//  Created by garday on 2017/3/23.
//  Copyright © 2017年 garday. All rights reserved.
//

#import "zfbczViewController.h"
#import "zfbczjgViewController.h"
//#import "czView.h"
#import "fundRecordViewController.h"
#import "BindAlipayAccViewController.h"
@interface zfbczViewController (){
    
}
/***金额Imgview ***/
@property (nonatomic ,strong)UIImageView *jeImv;
/***银行Imgview ***/
@property (nonatomic ,strong)UIImageView *yhImv;
@property (nonatomic ,strong)UIImageView *zxImv;
@property (nonatomic ,strong)UIImageView *fhImv;

/***<#注释#> ***/
@property (nonatomic ,strong)UILabel *jeLab;
@property (nonatomic ,strong)UILabel *moneyxsLab;
@property (nonatomic ,strong)UILabel *yhkLab;
@property (nonatomic ,strong)UILabel *sxfLab;
/***<#注释#> ***/
@property (nonatomic ,strong)UILabel *czxeLab;
/***<#注释#> ***/
@property (nonatomic ,strong)UIView *Vsx;

/***<#注释#> ***/
@property (nonatomic ,strong)UILabel *gzrLab;



/***充值 ***/


@property (nonatomic ,strong)UIButton *chongzhiBtn;




/***输入框 ***/
@property (nonatomic ,strong)UITextField *SrkTF;
@end








@implementation zfbczViewController

-(UILabel *)gzrLab{
    if(!_gzrLab){
        _gzrLab = [[UILabel alloc] init];
        _gzrLab.text = @"为了保障您的资金安全，需要实名审核\n审核时间为半个工作日";
        _gzrLab.textColor = [UIColor lightGrayColor];
        _gzrLab.textAlignment = NSTextAlignmentCenter;
        _gzrLab.numberOfLines = 0;
        _gzrLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];
    }
    return _gzrLab;
}

-(UIImageView *)jeImv{
    if(!_jeImv){
        _jeImv = [[UIImageView alloc] init];
        _jeImv.image = [UIImage imageNamed:@"pic_keti"];
    }
    return _jeImv;
}
-(UIImageView *)yhImv{
    if(!_yhImv){
        _yhImv = [[UIImageView alloc] init];
        _yhImv.image = [UIImage imageNamed:@"pic_zhifubao"];
    }
    return _yhImv;
}
-(UIImageView *)zxImv{
    if(!_zxImv){
        _zxImv = [[UIImageView alloc] init];
        _zxImv.image = [UIImage imageNamed:@"pic_arrow"];
    }
    return _zxImv;
}
-(UIImageView *)fhImv{
    if(!_fhImv){
        _fhImv = [[UIImageView alloc] init];
        _fhImv.image = [UIImage imageNamed:@"pic_jinbi"];
    }
    return _fhImv;
}

-(UILabel *)jeLab{
    if(!_jeLab){
        _jeLab = [[UILabel alloc] init];
        NSString *s =@"";
        _jeLab.text =[NSString stringWithFormat:@"我的账户\n(%@)%@",self.accModel.ky_account,s] ;
        _jeLab.numberOfLines = 0;
        _jeLab.textColor =[UIColor blackColor];
        _jeLab.textAlignment = NSTextAlignmentCenter;
        _jeLab.font = [UIFont systemFontOfSize:14];
        
    }
    return _jeLab;
}
-(UILabel *)moneyxsLab{
    if(!_moneyxsLab){
        _moneyxsLab = [[UILabel alloc] init];
        _moneyxsLab.text =@"实名审核" ;
        _moneyxsLab.textColor =[UIColor orangeColor];
        _moneyxsLab.font = [UIFont systemFontOfSize:12];
        
    }
    return _moneyxsLab;
}
-(UILabel *)yhkLab{
    if(!_yhkLab){
        _yhkLab = [[UILabel alloc] init];
        NSString *s =@"";
        _yhkLab.text =[NSString stringWithFormat:@"%@%@",self.zfb, s] ;
        _yhkLab.textColor =[UIColor blackColor];
        _yhkLab.numberOfLines = 0;
        _yhkLab.textAlignment = NSTextAlignmentCenter;
        _yhkLab.font = [UIFont systemFontOfSize:14];
        
    }
    return _yhkLab;
}

-(UIView *)Vsx{
    if(!_Vsx){
        _Vsx = [[UIView alloc] init];
        _Vsx.backgroundColor =[UIColor whiteColor];
        UIView *views = [[UIView alloc] init];
        views.backgroundColor = grcolor;
        [self.Vsx addSubview:views];
        [views mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.offset(0);
            make.top.offset(0);
            make.height.offset(1);
        }];
        
        
        UIButton *copybtn = [[UIButton alloc]init];
        copybtn.backgroundColor = [UIColor colorWithRed:57/255.0 green:149/255.0 blue:223/255.0 alpha:0.1/1.0];
        copybtn.titleLabel.layer.masksToBounds = YES;
        copybtn.layer.cornerRadius =10.0;
        [copybtn addTarget:self action:@selector(copyBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [copybtn.layer setBorderColor:lancolor.CGColor];
        [copybtn.layer setBorderWidth:1];
        [self.Vsx addSubview:copybtn];
        [copybtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.offset(0);
            make.top.offset(19);
            make.height.offset(66);
            make.left.offset(30*widthScale);
            make.right.offset(-30*widthScale);
        }];
        UIImageView *img = [[UIImageView alloc]init];
        img.image = [UIImage imageNamed:@"pic_zhifubao"];
        [copybtn addSubview:img];
        UILabel *gs =[[UILabel alloc]init];
        gs.text = @"点击复制公司支付宝账号";
        gs.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
        gs.textColor = [UIColor colorWithRed:57/255.0 green:149/255.0 blue:223/255.0 alpha:1/1.0];
        [copybtn addSubview:gs];
        [gs mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(copybtn.mas_top).offset(17);
            make.centerX.offset(0);
//            make.left.equalTo(img.mas_right).offset(9);
        }];
        UILabel *gszh =[[UILabel alloc]init];
        gszh.text =@"账号：xz@yinchenglicai.com";
        gszh.font = [UIFont fontWithName:@"PingFangSC-Medium" size:10];
        gszh.textColor = [UIColor colorWithRed:57/255.0 green:149/255.0 blue:223/255.0 alpha:1/1.0];
        [copybtn addSubview:gszh];
        [gszh mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.offset(0);
            make.top.equalTo(gs.mas_bottom);
//            make.bottom.equalTo(img.mas_bottom);
//            make.left.equalTo(img.mas_right).offset(9);
        }];
        [img mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.offset(0);
            make.left.equalTo(gszh.mas_left) .offset(-50);
            make.width.height.offset(36);
        }];
        
        UILabel *dd = [[UILabel alloc]init];
        dd.text = @"请前往支付宝完成转账";
        dd.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        dd.textColor = [UIColor colorWithRed:73/255.0 green:73/255.0 blue:73/255.0 alpha:1/1.0];
        [self.Vsx addSubview:dd];
        [dd mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.offset(0);
            make.top.equalTo(copybtn.mas_bottom).offset(14);
        }];
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = grcolor;
        [self.Vsx addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.offset(0);
            make.bottom.equalTo(self.Vsx.mas_bottom).offset(-2);
            make.height.offset(1);
        }];
        
    }
    return _Vsx;
}

-(UIButton *)chongzhiBtn{
    if(!_chongzhiBtn){
        _chongzhiBtn = [[UIButton alloc] init];
        [_chongzhiBtn setTitle:@"确认转账完成" forState:UIControlStateNormal];
        [_chongzhiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _chongzhiBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        _chongzhiBtn.titleLabel.layer.masksToBounds = YES;
        _chongzhiBtn.layer.cornerRadius =5.0;
        _chongzhiBtn.backgroundColor = [UIColor redColor];
        [_chongzhiBtn addTarget:self action:@selector(chongzhiBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _chongzhiBtn;
}
-(UITextField *)SrkTF{
    if(!_SrkTF){
        _SrkTF = [[UITextField alloc] init];
        _SrkTF.placeholder =@"请输入您刚才转账的金额";
        _SrkTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _SrkTF.keyboardType = UIKeyboardTypeDecimalPad;
        _SrkTF.keyboardAppearance=UIKeyboardAppearanceAlert;
        _SrkTF.font = [UIFont fontWithName:@"PingFangSC-Regular" size:22];
    }
    return _SrkTF;
}
-(void)UIlayout{
    UIView *xuxian1 = [[UIView alloc]init];
    xuxian1.backgroundColor = grcolor;
    [self.view addSubview:xuxian1];
    [xuxian1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.height.offset(2);
        make.top.offset(0);
    }];
    //可提金额
    [self.view addSubview:self.yhImv];
    [self.yhImv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(47);
        make.top.offset(17);
        make.width.height.offset(50);
    }];
    [self.view addSubview:self.yhkLab];
    [self.yhkLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.yhImv.mas_centerX);
        make.top.equalTo(self.yhImv.mas_bottom).offset(7);
    }];
    
    //银行
    [self.view addSubview:self.jeImv];
    [self.jeImv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-47);
        make.top.offset(17);
        make.width.offset(50);
        make.height.offset(50);
    }];
    [self.view addSubview:self.jeLab];
    [self.jeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.jeImv.mas_centerX);
        make.top.equalTo(self.jeImv.mas_bottom).offset(7);
    }];
    
    
    //支付显示
    [self.view addSubview:self.moneyxsLab];
    [self.moneyxsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.jeImv.mas_centerY);
        make.centerX.offset(0);
    }];
    [self.view addSubview:self.zxImv];
    [self.zxImv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.equalTo(self.moneyxsLab).offset(10);
        make.width.offset(100);
        make.height.offset(10);
    }];
    
    
    
    [self.view addSubview:self.Vsx];
    [self.Vsx mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.height.offset(130);
        make.top.equalTo(self.yhkLab.mas_bottom).offset(16);
    }];
    
    
    [self.view addSubview:self.fhImv];
    [self.fhImv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.top.equalTo(self.Vsx.mas_bottom).offset(22);
        make.width.height.offset(18);
    }];
    [self.view addSubview:self.SrkTF];
    [self.SrkTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.fhImv.mas_centerY);
        make.left.equalTo(_fhImv.mas_right).offset(10);
        make.right.offset(-20);
    }];
    UIImageView *imgxx = [[UIImageView alloc]init];
    imgxx.image = [UIImage imageNamed:@"line"];
    [self.view addSubview:imgxx];
    [imgxx mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.height.offset(4);
        make.top.equalTo(_fhImv.mas_bottom).offset(10);
    }];
    
    [self.view addSubview:self.chongzhiBtn];
    [self.chongzhiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.equalTo(imgxx.mas_bottom).offset(22);
        make.left.offset(10);make.right.offset(-10);
        make.height.offset(45);
        
    }];
    
    [self.view addSubview:self.gzrLab];
    [self.gzrLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.equalTo(self.chongzhiBtn.mas_bottom).offset(10);
    }];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];
    [self UIlayout];
    
}

-(void)copyBtnClicked{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = @"xz@yinchenglicai.com";
    if ([pasteboard.string isEqualToString:@"xz@yinchenglicai.com"])
    {
        [self showHUD:@"复制成功" de:1.5];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
            NSURL *url = [NSURL URLWithString:@"alipay://"];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            [webView loadRequest:request];
            [self.view addSubview:webView];
        });
    }else{
        [self showHUD:@"复制失败" de:1.5];
    }
}

-(void)chongzhiBtnClicked{
    
    if (self.zfb.length == 0) {
        [self showError:@"请先绑定支付宝帐号，再进行此操作"];
    }else
    {
        NSMutableDictionary *pass =[NSMutableDictionary dictionary];
        pass[@"uid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"uid"];
        pass[@"sid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"sid"];
        pass[@"at"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"at"];
        pass[@"version"] = @"v1.0.3";
        pass[@"os"] = @"ios";
        pass[@"app_id"] = @"3";
        pass[@"secret"] = @"aodsadhowiqhdwiqs";
        pass[@"channel"] = @"";
        pass[@"money1"] = self.SrkTF.text;
        pass[@"zhanghao"] = self.zfb;
        [WWZShuju initlizedData:zfbcz paramsdata:pass dicBlick:^(NSDictionary *info) {
            NSLog(@"%@， msg%@", info, info[@"msg"]);
            if ([info[@"r"] integerValue] == 1) {
//                [TalkingDataAppCpa onPay:[[NSUserDefaults standardUserDefaults]objectForKey:@"uid"] withOrderId:self.zfb withAmount:[self.SrkTF.text intValue] withCurrencyType:@"支付宝充值" withPayType:@"支付宝充值"];
                [self showError:@"提交成功！"];
            }else
            {
                [self showError:info[@"msg"]];
            }
        }];
    }
}

#pragma mark - 提示框
-(void)showError:(NSString *)error
{
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:error preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *av = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([error isEqualToString:@"请先绑定支付宝帐号，再进行此操作"]) {
            BindAlipayAccViewController * vc = [[BindAlipayAccViewController alloc] init];
            vc.Model = self.Model;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            fundRecordViewController * vc = [[fundRecordViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
    [ac addAction:av];
    [self presentViewController:ac animated:YES completion:nil];
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(void)czBtnClicked{
   
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
