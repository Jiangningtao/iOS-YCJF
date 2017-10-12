//
//  BindAlipayAccViewController.m
//  iOS-YCJF
//
//  Created by 姜宁桃 on 2017/8/18.
//  Copyright © 2017年 Yincheng. All rights reserved.
//

#import "BindAlipayAccViewController.h"

@interface BindAlipayAccViewController (){
    UITextField *tf ;
    UILabel *lab;
    UILabel *labq;
}
/***view ***/
@property (nonatomic ,strong)UIView *backgroundView;
/***字体 ***/
@property (nonatomic ,strong)UILabel *ztlab;
/***确定保存 ***/
@property (nonatomic ,strong)UIButton *saveBtn;

@end

@implementation BindAlipayAccViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = @"支付宝绑定";
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
    
    [self setUI];
    [self NavBack];
    self.Model = [MineInstance shareInstance].mineModel;
}

-(UIView *)backgroundView{
    if (!_backgroundView) {
        NSArray *arr = [NSArray array];
        arr = @[@{@"title":@"支付宝账号",@"text":@"请输入支付宝账号"},
                @{@"title":@"支付宝账号持有人",@"text":@"请输入持有人姓名"}
                ];
        _backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 77, self.view.frame.size.width, 101)];
        _backgroundView.backgroundColor =[UIColor whiteColor];
        for (int i = 0; i<2; i++) {
            lab = [[UILabel alloc]init];
            lab.text = arr[i][@"title"];
            lab.backgroundColor = _backgroundView.backgroundColor;
            lab.numberOfLines = 0;
            lab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
            [_backgroundView addSubview:lab];
            [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(21);
                make.top.offset(17 + i *50);
            }];
        }
        tf = [[UITextField alloc]init];
        tf.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        tf.placeholder = arr[0][@"text"];
        [_backgroundView addSubview:tf];
        
        [tf mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(17);
            make.left.equalTo(lab.mas_right).offset(-25);
        }];
        
        labq = [[UILabel alloc]init];
        labq.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        NSLog(@"%@", self.Model.uname_hidden);
        labq.text = self.Model.uname_hidden?self.Model.uname_hidden:@"";
        [_backgroundView addSubview:labq];
        
        [labq mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(tf.mas_bottom).offset(30);
            make.left.equalTo(lab.mas_right).offset(30 );
        }];
        
        //分界线
        UIView *v =[[UIView alloc]initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 1)];
        v.backgroundColor = self.view.backgroundColor;
        [_backgroundView addSubview:v];
        
    }
    return _backgroundView;
}

-(UILabel *)ztlab{
    if (!_ztlab) {
        _ztlab = [[UILabel alloc]init];
        _ztlab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];
        _ztlab.textColor = [UIColor colorWithRed:178/255.0 green:178/255.0 blue:178/255.0 alpha:1/1.0];
        
        _ztlab.text = @"此信息仅用于支付宝充值提现使用，银程金服承诺绝不向第三方透露，为了资金安全，绑定后无法自行修改绑定支付宝账号，请慎重填写，如有问题请联系客服 。";
        _ztlab.numberOfLines = 0;
    }
    return _ztlab;
}
-(UIButton *)saveBtn{
    if (!_saveBtn) {
        _saveBtn = [[UIButton alloc]initWithFrame:CGRectMake(13, self.view.centerY+20, self.view.frame.size.width - 26, 45)];
        _saveBtn.backgroundColor = lancolor;
        [_saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _saveBtn.layer.masksToBounds = YES;
        [_saveBtn setTitle:@"确定保存" forState:UIControlStateNormal];
        [_saveBtn addTarget:self action:@selector(saveBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        _saveBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        _saveBtn.layer.cornerRadius = 5.0;
    }
    
    return _saveBtn;
}

-(void)setUI{
    self.view.backgroundColor = grcolor;
    [self.view addSubview:self.backgroundView];
    
    [self.view addSubview:self.ztlab];
    [self.ztlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(16);
        make.right.offset(-28);
        make.top.mas_equalTo(self.backgroundView).offset(111);
    }];
    
    [self.view addSubview:self.saveBtn];
    
    
    UIButton *alertbtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.centerX-105, self.view.frame.size.height-59, 210, 20)];
    [alertbtn setImage:[UIImage imageNamed:@"Group 6"] forState:UIControlStateNormal];
    [alertbtn setTitleColor:[UIColor colorWithRed:195/255.0 green:195/255.0 blue:195/255.0 alpha:1/1.0] forState:UIControlStateNormal];
    [alertbtn setTitle:@"投资有风险 理财需谨慎" forState:UIControlStateNormal];
    alertbtn.titleLabel.font = [UIFont systemFontOfSize:12];
    
    [self.view addSubview:alertbtn];
    
    
}

-(void)saveBtnClicked{
    [self.view endEditing:YES];
    NSMutableDictionary *pass =[NSMutableDictionary dictionary];
    pass[@"uid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"uid"];
    pass[@"sid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"sid"];
    pass[@"at"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"at"];
    pass[@"version"] = @"v1.0.3";
    pass[@"os"] = @"ios";
    
    pass[@"zfb_zh"] =tf.text;
    [WWZShuju initlizedData:zfbdburl paramsdata:pass dicBlick:^(NSDictionary *info) {
        NSLog(@"%@",info);
        if ([info[@"r"] integerValue] == 1) {
            [self showError:@"绑定成功"];
        }
        [self showError:info[@"msg"]];
        
        
    }];
}
#pragma mark - 提示框
-(void)showError:(NSString *)error
{
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:error preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *av = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if ([error isEqualToString:@"绑定成功"]) {
            KPostNotification(KNotificationRefreshMineDatas, nil);
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        
    }];
    [ac addAction:av];
    [self presentViewController:ac animated:YES completion:nil];
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
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
