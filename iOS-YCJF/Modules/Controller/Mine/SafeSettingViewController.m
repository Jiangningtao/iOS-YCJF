//
//  SafeSettingViewController.m
//  iOS-YCJF
//
//  Created by 姜宁桃 on 2017/8/17.
//  Copyright © 2017年 Yincheng. All rights reserved.
//

#import "SafeSettingViewController.h"

#import "ModiPwdViewController.h"
#import "FindBackPayPwdViewController.h"
#import "ModiLoginPwdViewController.h"
#import "GestureLockViewController.h"
#import "CertificationViewController.h"

@interface SafeSettingViewController ()<UITableViewDelegate, UITableViewDataSource, setLockDelegate>

@property (nonatomic ,strong)UITableView *tab;
/***<#注释#> ***/
@property (nonatomic ,strong)NSArray *arr;
@property (nonatomic ,strong)UISwitch *switchButton;
/***Touch ID ***/
@property (nonatomic ,strong)UISwitch *swiButton;


@end

@implementation SafeSettingViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = @"安全中心";
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
    [self NavBack];
    [self.view addSubview:self.tab];
}


#pragma mark - Event Hander
-(void)switchAction:(id)sender
{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    
    if (isButtonOn) {
        GestureLockViewController *vc = [[GestureLockViewController alloc]init];
        vc.lockDelegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        [[NSUserDefaults standardUserDefaults]setObject:@"2" forKey:KGestureLock];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

#pragma mark - setLockDelegate
- (void)resultOfSetLock:(NSString *)ret
{
    if ([ret isEqualToString:@"1"]) {
        NSLog(@"设置后的密码:%@", [[NSUserDefaults standardUserDefaults] objectForKey:KGestureLock]);
        [self.switchButton setOn:YES];
    }else{
        [self.switchButton setOn:NO];
        [[NSUserDefaults standardUserDefaults]setObject:@"2" forKey:KGestureLock];
    }
    [[NSUserDefaults standardUserDefaults]synchronize];
    [self.tab reloadData];
}

-(void)switAction:(id)sender
{
    if ([NSString judueIPhonePlatformSupportTouchID])
    {
        [self startTouchIDWithPolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics];
    }
    else
    {
        [self showHUD:@"您的设置硬件暂时不支持指纹识别" de:1.5];
        NSLog(@"您的设置硬件暂时不支持指纹识别");
        [[NSUserDefaults standardUserDefaults]setObject:@"2" forKey:KTouchLock];
    }
    
}

#pragma mark - Help Hander
- (void)startTouchIDWithPolicy:(LAPolicy )policy{
    
    LAContext *context = [[LAContext alloc]init];//使用 new 不会给一些属性初始化赋值
    
    context.localizedFallbackTitle = @"";//@""可以不让 feedBack 按钮显示
    //LAPolicyDeviceOwnerAuthenticationWithBiometrics
    [context evaluatePolicy:policy localizedReason:@"请验证已有指纹" reply:^(BOOL success, NSError * _Nullable error) {
        
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
                        if ([[[NSUserDefaults standardUserDefaults]objectForKey:KTouchLock] isEqualToString:@"1"]) {
                            [_swiButton setOn:NO];
                            [self showHUD:@"关闭指纹成功！" de:1.5];
                            [[NSUserDefaults standardUserDefaults]setObject:@"2" forKey:KTouchLock];
                        }else{
                            [_swiButton setOn:YES];
                            [self showHUD:@"开启指纹成功！" de:1.5];
                            [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:KTouchLock];
                        }
                    }
                    [[NSUserDefaults standardUserDefaults] synchronize];
                });
            }
            
            if (error) {
                //指纹识别失败，回主线程更新UI
                NSLog(@"指纹识别成功");
                dispatch_async(dispatch_get_main_queue(), ^{
                    //失败操作
                    [self handelWithError:error];
                    
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
                if ([[[NSUserDefaults standardUserDefaults]objectForKey:KTouchLock] isEqualToString:@"1"]) {
                    [_swiButton setOn:YES];
                    [self showError:@"关闭指纹解锁失败！原因：系统未设置密码"];
                }else{
                    [_swiButton setOn:NO];
                    [self showError:@"开启指纹解锁失败！原因：系统未设置密码"];
                }
                break;
            }
            case LAErrorTouchIDNotAvailable:
            {
                NSLog(@"设备Touch ID不可用，例如未打开");
                if ([[[NSUserDefaults standardUserDefaults]objectForKey:KTouchLock] isEqualToString:@"1"]) {
                    [_swiButton setOn:YES];
                    [self showError:@"关闭指纹解锁失败！原因：设备Touch ID不可用"];
                }else{
                    [_swiButton setOn:NO];
                    [self showError:@"开启指纹解锁失败！原因：设备Touch ID不可用"];
                }
                break;
            }
            case LAErrorTouchIDNotEnrolled:
            {
                NSLog(@"设备Touch ID不可用，用户未录入");
                if ([[[NSUserDefaults standardUserDefaults]objectForKey:KTouchLock] isEqualToString:@"1"]) {
                    [_swiButton setOn:YES];
                    [self showError:@"关闭指纹解锁失败！原因：设备Touch ID不可用，用户未录入"];
                }else{
                    [_swiButton setOn:NO];
                    [self showError:@"开启指纹解锁失败！原因：设备Touch ID不可用，用户未录入"];
                }
                break;
            }
            default:
                if ([[[NSUserDefaults standardUserDefaults]objectForKey:KTouchLock] isEqualToString:@"1"]) {
                    [_swiButton setOn:YES];
                    [self showError:@"关闭指纹解锁失败！原因：指纹识别失败！"];
                }else{
                    [_swiButton setOn:NO];
                    [self showError:@"开启指纹解锁失败！原因：指纹识别失败！"];
                }
                break;
        }
    }
}


/**
 支付宝处理锁定
 */
- (void)handleLockOutTypeAliPay{
    
    //开启验证--调用非全指纹指纹验证
    [self startTouchIDWithPolicy:LAPolicyDeviceOwnerAuthentication];
    
}



#pragma mark - UITableViewDelegate & UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.arr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 11;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.arr[section]count];;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        cell.textLabel.text =self.arr[indexPath.section][indexPath.row];
        cell.textLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        cell.textLabel.textColor = [UIColor colorWithRed:73/255.0 green:73/255.0 blue:73/255.0 alpha:1/1.0];
        
        if (indexPath.section == 2) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell addSubview:self.swiButton];
            [self.swiButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.offset(0);
                make.right.offset(-20);
            }];
        }   else if (indexPath.section == 3){
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell addSubview:self.switchButton];
            [self.switchButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.offset(0);
                make.right.offset(-20);
            }];
        }
        else{
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0 &indexPath.row == 0) {
        ModiPwdViewController *vc = [[ModiPwdViewController alloc]init];
        vc.Model = self.Model;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (indexPath.section ==0 &&indexPath.row == 1){
        // 没有通过实名认证,请先去实名认证
        if ([KGetReal_status integerValue] == 2) {
            FindBackPayPwdViewController *vc = [[FindBackPayPwdViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }else
        {
            [self showError:@"您还没有通过实名认证,请先去实名认证"];
        }
        
    }else if (indexPath.section == 1){
        ModiLoginPwdViewController  *vc = [[ModiLoginPwdViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

#pragma mark - 提示框
-(void)showError:(NSString *)error
{
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:error preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *av = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if ([error isEqualToString:@"您还没有通过实名认证,请先去实名认证"]) {
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

#pragma mark - Getter
-(UITableView *)tab{
    if (!_tab) {
        _tab = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, screen_width, screen_height-64) style:UITableViewStyleGrouped];
        _tab.dataSource= self;
        _tab.delegate = self;
        _tab.backgroundColor =grcolor;
    }
    return _tab;
}
-(NSArray *)arr{
    if (!_arr) {
        _arr = @[@[@"修改交易密码",@"找回交易密码"],@[@"修改登录密码"],@[@"Touch ID指纹解锁"],@[@"手势密码"]];
    }
    return _arr;
}
-(UISwitch *)switchButton{
    if(!_switchButton){
        _switchButton = [[UISwitch alloc] init];
        [_switchButton addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        // 手势密码
        if (![[UserDefaults objectForKey:KGestureLock] isEqualToString:@"2"]&&[UserDefaults objectForKey:KGestureLock]) {
            [self.switchButton setOn:YES];
        }else{
            [self.switchButton setOn:NO];
        }
    }
    return _switchButton;
}
-(UISwitch *)swiButton{
    if(!_swiButton){
        _swiButton = [[UISwitch alloc] init];
        [_swiButton addTarget:self action:@selector(switAction:) forControlEvents:UIControlEventValueChanged];
        // 指纹认证 touch = 1 表示开启
        NSLog(@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:KTouchLock]);
        if ([[[NSUserDefaults standardUserDefaults]objectForKey:KTouchLock] isEqualToString:@"1"]) {
            [_swiButton setOn:YES];
        }else{
            [_swiButton setOn:NO];
        }
    }
    return _swiButton;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
