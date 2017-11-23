//
//  CashValueViewController.m
//  iOS-YCJF
//
//  Created by 姜宁桃 on 2017/8/21.
//  Copyright © 2017年 Yincheng. All rights reserved.
//

#import "CashValueViewController.h"

#import "CertificationViewController.h"
#import "ModiPwdViewController.h"
#import "fundRecordViewController.h"

#import "rechargeViewController.h"
#import "withdrawViewController.h"

@interface CashValueViewController ()
{
    NSDictionary * dict;
}
/***img ***/
@property (nonatomic ,strong)UIImageView *imvg;
/***账户余额 ***/
@property (nonatomic ,strong)UILabel *yelab;
/***余额的多少 ***/
@property (nonatomic ,strong)UILabel *selab;
/***充值 ***/
@property (nonatomic ,strong)UIButton  *czbtn;
/***提现 ***/
@property (nonatomic ,strong)UIButton *txbtn;

@property (nonatomic, strong) MineItemModel * Model;
@property (nonatomic, strong) AccinfoModel * accModel;

@end

@implementation CashValueViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = @"充值提现";
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
    self.Model = [MineInstance shareInstance].mineModel;
    self.accModel = [MineInstance shareInstance].accModel;
    //NSLog(@"%@", self.accModel.ky_account);
    if (!self.accModel.ky_account) {
        NSLog(@"数据为空");
        [self loadNewTopics];
    }
    
    [self NavBack];
    self.backImageView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = grcolor;
    
    [self setUI];
    [self getMyChannelBankList];
    
    UIButton *rightbutton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 57, 20)];
    [rightbutton addTarget:self action:@selector(rightbtnclicked) forControlEvents:UIControlEventTouchUpInside];
    rightbutton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    [rightbutton setTitle:@"资金记录" forState:UIControlStateNormal];
    [rightbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:rightbutton];
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
            // 给单例赋值
            [MineInstance shareInstance].mineModel = [[MineItemModel alloc] initWithDictionary:info[@"item"] error:nil];
            [MineInstance shareInstance].accModel = [[AccinfoModel alloc] initWithDictionary:info[@"accinfo"] error:nil];
            self.Model = [[MineItemModel alloc] initWithDictionary:info[@"item"] error:nil];
            self.accModel = [[AccinfoModel alloc] initWithDictionary:info[@"accinfo"] error:nil];
            self.selab.text =[NSString stringWithFormat:@"%@",self.accModel.ky_account] ;
            [UserDefaults setObject:info[@"item"][@"real_status"] forKey:KReal_status];
            [UserDefaults setObject:info[@"item"][@"is_defaultpaypass"] forKey:KIs_defaultpaypass];
            [UserDefaults synchronize];
        }
    }];
}

-(void)setUI{
    [self.view addSubview:self.imvg];
    [self.imvg mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.offset(127);
        make.width.offset(60);
        make.height.offset(WTStatus_And_Navigation_Height);
    }];
    
    
    [self.view addSubview:self.yelab];
    [self.yelab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.equalTo(self.imvg.mas_bottom).offset(25);
    }];
    
    
    [self.view addSubview:self.selab];
    [self.selab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.equalTo(self.yelab.mas_bottom).offset(7);
    }];
    
    [self.view addSubview:self.czbtn];
    [self.czbtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(13);
        make.right.offset(-13);
        make.height.offset(45);
        make.top.equalTo(self.selab.mas_bottom).offset(100);
    }];
    
    [self.view addSubview:self.txbtn];
    [self.txbtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(13);
        make.right.offset(-13);
        make.height.offset(45);
        make.top.equalTo(self.czbtn.mas_bottom).offset(20);
    }];
    
    UIButton *alertbtn = [[UIButton alloc]init];
    [alertbtn setImage:[UIImage imageNamed:@"Group 6"] forState:UIControlStateNormal];
    [alertbtn setTitleColor:[UIColor colorWithRed:195/255.0 green:195/255.0 blue:195/255.0 alpha:1/1.0] forState:UIControlStateNormal];
    [alertbtn setTitle:@"投资有风险 理财需谨慎" forState:UIControlStateNormal];
    alertbtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:alertbtn];
    [alertbtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.bottom.offset(-50);
    }];
    
}



#pragma mark - NetWork
- (void)getMyChannelBankList
{
    [MBProgressHUD showActivityMessageInView:@"努力加载中"];
    
    NSMutableDictionary *pass =[NSMutableDictionary dictionary];
    pass[@"uid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"uid"];
    pass[@"sid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"sid"];
    pass[@"at"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"at"];
    pass[@"version"] = @"v1.0.3";
    pass[@"os"] = @"ios";
    pass[@"type"] = @"1";
    pass[@"sid_kjcz"] = @"11";
    pass[@"_sid"] = @"11";
    [WWZShuju initlizedData:hqyhkxx paramsdata:pass dicBlick:^(NSDictionary *info) {
        NSLog(@"%@",info);
        dict = [NSDictionary dictionaryWithDictionary:info];
        [MBProgressHUD hideHUD];
    }];
}

#pragma mark - Event Hander
-(void)czBtnClicked{
    if ([preUrl hasPrefix:@"http://120.27.211.129"]) {
        // 测试服
        [self showError:@"测试服充值直接找后台给你充个1个亿"];
        return;
    }
    // 没有通过实名认证,请先去实名认证
    NSLog(@"%@", KGetReal_status);
    if ([KGetReal_status integerValue] == 2) {
        rechargeViewController *cv = [[rechargeViewController alloc]init];
        cv.infoDict = dict;
        [self.navigationController pushViewController:cv animated:YES];
    }else if([KGetReal_status integerValue] == 0)
    {
        [self showError:@"您还没有通过实名认证,请先去实名认证"];
    }else if ([KGetReal_status integerValue] == 1){
        [self showError:@"您正在认证中是否重新认证"];
    }
    
}
-(void)txBtnClicked{
    if ([preUrl hasPrefix:@"http://120.27.211.129"]) {
        // 测试服
        [self showError:@"测试服的钱你也要提现？疯了吧！"];
        return;
    }
    // 没有通过实名认证,请先去实名认证
    if ([KGetReal_status integerValue] == 2) {
        // 判断是否设置过交易密码
        NSString * localpassone = [UserDefaults objectForKey:KIs_defaultpaypass];
        if ([localpassone integerValue] == 1) {
            // 还没有设置过交易密码
            [self showError:@"您还没绑定过交易密码，请先绑定交易密码"];
        }else
        {
            withdrawViewController *cv = [[withdrawViewController alloc]init];
            cv.infoDict = dict;
            [self.navigationController pushViewController:cv animated:YES];
        }
    }else if([KGetReal_status integerValue] == 0)
    {
        [self showError:@"您还没有通过实名认证,请先去实名认证"];
    }else if ([KGetReal_status integerValue] == 1){
        [self showError:@"您正在认证中是否重新认证"];
    }
    
}

-(void)rightbtnclicked{
    // 资金记录
    fundRecordViewController *vc = [[fundRecordViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
}


#pragma mark - Getter
-(UIImageView *)imvg{
    if(!_imvg){
        _imvg = [[UIImageView alloc]init];
        _imvg.image = [UIImage imageNamed:@"pic_chongzhi"];
        //        _imvg.backgroundColor = [UIColor redColor];
    }
    return _imvg;
}

-(UILabel *)yelab{
    if(!_yelab){
        _yelab =[[UILabel alloc]init];
        _yelab.text = @"账户余额(元)";
        _yelab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        _yelab.textColor = [UIColor colorWithRed:136/255.0 green:136/255.0 blue:136/255.0 alpha:1/1.0];
    }
    return _yelab;
}
-(UILabel *)selab{
    if(!_selab){
        _selab = [[UILabel alloc]init];
        _selab.text =[NSString stringWithFormat:@"%@",self.accModel.ky_account] ;
        _selab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:30];
        _selab.textColor = [UIColor colorWithRed:73/255.0 green:73/255.0 blue:73/255.0 alpha:1/1.0];
        
    }
    
    return _selab;
}
-(UIButton *)czbtn{
    if(!_czbtn){
        _czbtn = [[UIButton alloc] init];
        _czbtn.backgroundColor = [UIColor redColor];
        [_czbtn setTitle:@"充值" forState:UIControlStateNormal];
        [_czbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_czbtn addTarget:self action:@selector(czBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [_czbtn.layer setMasksToBounds:YES];
        _czbtn.layer.cornerRadius = 4.0;
        
    }
    return _czbtn;
}
-(UIButton *)txbtn{
    if(!_txbtn){
        _txbtn = [[UIButton alloc] init];
        _txbtn.backgroundColor = [UIColor whiteColor];
        [_txbtn setTitle:@"提现" forState:UIControlStateNormal];
        [_txbtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_txbtn addTarget:self action:@selector(txBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [_txbtn.layer setMasksToBounds:YES];
        _txbtn.layer.cornerRadius =4.0;
        [_txbtn.layer setBorderColor:[UIColor redColor].CGColor];
        [_txbtn.layer setBorderWidth:1];
        
    }
    return _txbtn;
}

#pragma mark - 提示框
-(void)showError:(NSString *)error
{
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:error preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sv = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([ac.message isEqualToString:@"您正在认证中是否重新认证"]) {
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

-(void)showErrorSheet:(NSString *)error
{
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"联系客服" message:error preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *tv = [UIAlertAction actionWithTitle:@"呼叫" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://400-005-6677"]];
    }];
    [ac addAction:tv];
    UIAlertAction *av = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [ac addAction:av];
    [self presentViewController:ac animated:YES completion:nil];
    
}

-(MineItemModel *)Model
{
    if (!_Model) {
        _Model = [[MineItemModel alloc] init];
    }
    return _Model;
}

-(AccinfoModel *)accModel
{
    if (!_accModel) {
        _accModel = [[AccinfoModel alloc] init];
    }
    return _accModel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
