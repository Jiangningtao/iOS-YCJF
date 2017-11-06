//
//  SettingViewController.m
//  iOS-YCJF
//
//  Created by 姜宁桃 on 2017/8/17.
//  Copyright © 2017年 Yincheng. All rights reserved.
//

#import "SettingViewController.h"

#import "likeView.h"
#import "set1TableViewCell.h"
#import "set2TableViewCell.h"

#import "SafeSettingViewController.h"
#import "TabBarViewController.h"
#import "CertificationViewController.h"
#import "BindAlipayAccViewController.h"

@interface SettingViewController ()<UITableViewDataSource,UITableViewDelegate>
/***tabview ***/
@property (nonatomic ,strong)UITableView *tab;
/***数据 ***/
@property (nonatomic ,strong)NSArray *sjarray1;
@property (nonatomic ,strong)NSArray *sjarray2;
@property (nonatomic ,strong)NSArray *sjarray3;

@end

@implementation SettingViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = @"设置中心";
    
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
    [self.view addSubview:self.tab];
    self.Model = [MineInstance shareInstance].mineModel;
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
        return 2;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        set1TableViewCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"set1TableViewCell" owner:nil options:nil]lastObject];
        if ([self.Model.headpture integerValue] == 0) {
            cell.imgv.image = [UIImage imageNamed:@"defaultHead"];
            cell.imgv.layer.borderColor = color(217, 217, 217, 1).CGColor;
            cell.imgv.layer.borderWidth = 1;
        }else
        {
            [cell.imgv sd_setImageWithURL:[NSURL URLWithString:self.Model.avatar_url] placeholderImage:[UIImage imageNamed:@"defaultHead"]];
        }
        
        [likeView sharePicture:^(UIImage *HeadImage){
            cell.imgv.image = HeadImage;
            
        }];
        
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        return cell;
        
        
    }
    set2TableViewCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"set2TableViewCell" owner:nil options:nil]lastObject];
    if (indexPath.section == 1 || indexPath.section == 4) {
        
    }    else{
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (indexPath.section == 1) {
        cell.SJlab.text = self.sjarray1[indexPath.row];
        if (indexPath.row == 0) {
            cell.SJLab.text =self.Model.mobile;
        }else{
            if (self.Model.zfb.length ==  0) {
                cell.SJLab.text = @"未绑定";
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }else{
                cell.SJLab.text = self.Model.zfb;
            }
        }
        
    }else if (indexPath.section == 2){
        cell.SJlab.text = self.sjarray2[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0) {
            if ([KGetReal_status integerValue] == 2) {
                // 未认证
                cell.SJLab.text = @"已认证";
                cell.accessoryType = UITableViewCellAccessoryNone;
            }else if([KGetReal_status integerValue] == 0){
                // 未认证
                cell.SJLab.text = @"未认证";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }else if([KGetReal_status integerValue] == 1){
                // 未认证
                cell.SJLab.text = @"认证中";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            
        }
        
        
    }else{
        cell.SJlab.text = self.sjarray3[indexPath.row];
        cell.SJLab.text = nil;
    }
    
    if (indexPath.section == 4) {
        cell.SJLab.text = nil;
        cell.SJlab.text = nil;
        UILabel *lab = [[UILabel alloc]init];
        lab.text = @"退出账号";
        lab.font = [UIFont systemFontOfSize:15];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.textColor =  [UIColor colorWithRed:239/255.0 green:90/255.0 blue:78/255.0 alpha:1/1.0];
        [cell addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.offset(0);
            make.centerY.offset(0);
        }];
        
    }
    
    return cell;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 65;
    }
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 4) {
        return 30;
    }
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        likeView *v = [[likeView alloc]initWithFrame:self.view.frame];
        
        v.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
        
        [likeView sharePicture:^(UIImage *image) {
            NSLog(@"%@", image);
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            params[@"app_id"] = @"3";
            params[@"at"] =[[NSUserDefaults standardUserDefaults]objectForKey:@"at"];
            params[@"uid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"uid"];
            params[@"sid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"sid"];
            params[@"secret"] = @"aodsadhowiqhdwiqs";
            params[@"version"] = @"v1.0.3";
            params[@"os"] = @"ios";
//            [self showHUD:@"正在上传，请稍候"  isDim:YES];
            [MBProgressHUD showActivityMessageInWindow:@"正在上传，请稍候"];
            [NetRequest AF_RegisterByPostWithUrlString:sctxurl params:params image:image success:^(id data) {
//                [self hideHUD];
                [MBProgressHUD hideHUD];
                NSLog(@"%@", data);
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self showError:@"修改头像成功"];
                });
            } fail:^(NSString *errorDes) {
//                [self hideHUD];
                [MBProgressHUD hideHUD];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self showError:@"修改头像失败"];
                });
                NSLog(@"%@", errorDes);
            }];
        }];
        
        [self.view.window addSubview:v];
    }else if (indexPath.section == 1 && indexPath.row == 0){
        
        
    }else if (indexPath.section == 1 && indexPath.row == 1){
        NSLog(@"---%@---", self.Model.zfb);
        if([KGetReal_status integerValue] == 0){
            if ([preUrl hasPrefix:@"http://120.27.211.129"]) {
                // 测试服
                [self showError:@"测试服需要认证直接找后台修改状态就可以了"];
            }else
            {
                // 正式服
                CertificationViewController *vc = [[CertificationViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }else
        {
            if (self.Model.zfb.length > 0) {
                [self showErrorSheet:@"您已经绑定成功，若需要修改请联系客服:400-005-6677"];
            }else
            {
                BindAlipayAccViewController *vc = [[BindAlipayAccViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
        
    }else if (indexPath.section == 2 && indexPath.row == 0){
        if ([KGetReal_status integerValue] == 2) {
            [self showErrorSheet:@"您已经认证成功，若需要修改请联系客服:400-005-6677"];
        }else if([KGetReal_status integerValue] == 0){
            if ([preUrl hasPrefix:@"http://120.27.211.129"]) {
                // 测试服
                [self showError:@"测试服需要认证直接找后台修改状态就可以了"];
            }else
            {
                // 正式服
                CertificationViewController *vc = [[CertificationViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }else if ([KGetReal_status integerValue] == 1){
            [self showError:@"您正在认证中是否重新认证"];
        }
        
    }else if (indexPath.section == 3){
        SafeSettingViewController *safeVC = [[SafeSettingViewController alloc]init];
        [self.navigationController pushViewController:safeVC animated:YES];
        
        
        
    }else{
        NSUserDefaults *eUser = [NSUserDefaults standardUserDefaults];
        [eUser removeObjectForKey:[UserDefaults objectForKey:KAccount]];
        [eUser removeObjectForKey:KAccount];    // 帐户帐号
        [eUser setObject:@"2" forKey:KGestureLock];// 手势状态
        [eUser setObject:@"2" forKey:KTouchLock];
        [eUser removeObjectForKey:@"uid"];
        [eUser removeObjectForKey:@"sid"];
        [eUser removeObjectForKey:@"at"];
        [eUser removeObjectForKey:KReal_status];
        [eUser synchronize];
        
        [self loadSuspendData];
        
        TabBarViewController *vc = [[TabBarViewController alloc]init];
        [self.view.window setRootViewController:vc];
        
        
    }
    
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
        KPostNotification(KNotificationRefreshMineDatas, nil);
        NSLog(@"%@", info);
        if ([info[@"r"] integerValue] == 1) {
            [self showHUD:@"您已经成功重置认证信息" de:1.5];
            [self.tab reloadData];
        }else{
            [self showErrorSheet:@"重置失败，您已经认证成功，若需要修改请联系客服:400-005-6677"];
        }
    }];
}

-(void)leftbtnclicked{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 提示框
-(void)showError:(NSString *)error
{
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:error preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *av = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *sv = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([ac.message isEqualToString:@"您正在认证中是否重新认证"]) {
            [self reRealAction];
            [ac addAction:av];
        }else if ([error isEqualToString:@"修改头像成功"])
        {
            KPostNotification(KNotificationRefreshMineDatas, nil);
            // 发送通知，刷新数据
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self leftbtnclicked];
            });
        }
    }];
    [ac addAction:sv];
    [self presentViewController:ac animated:YES completion:nil];
    
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
-(NSArray *)sjarray1{
    if (!_sjarray1) {
        _sjarray1 = [NSArray array];
        _sjarray1 = @[@"手机绑定",@"支付宝绑定"];
    }
    return _sjarray1;
}
-(NSArray *)sjarray2{
    if (!_sjarray2) {
        _sjarray2 = [NSArray array];
        _sjarray2 = @[@"账户认证"];
    }
    return _sjarray2;
}
-(NSArray *)sjarray3{
    if (!_sjarray3) {
        _sjarray3 = [NSArray array];
        _sjarray3 = @[@"安全中心"];
    }
    return _sjarray3;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
