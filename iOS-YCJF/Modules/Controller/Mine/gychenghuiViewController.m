//
//  gychenghuiViewController.m
//  iOS-CHJF
//
//  Created by garday on 2017/3/21.
//  Copyright © 2017年 garday. All rights reserved.
//

#import "gychenghuiViewController.h"
#import "gychenghuiTableViewCell.h"
#import "fankuiViewController.h"
#import "WebViewController.h"

@interface gychenghuiViewController ()<UITableViewDataSource,UITableViewDelegate>
/***<#注释#> ***/
@property (nonatomic ,strong)UITableView *gytab;
/***<#注释#> ***/
@property (nonatomic ,strong)NSArray *arrq;
/***<#注释#> ***/
@property (nonatomic ,strong)NSArray *arr;
@end

@implementation gychenghuiViewController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.tabBarController.tabBar.hidden = YES;
}
-(NSArray *)arrq{
    if (!_arrq) {
        _arrq = [NSArray array];
        _arrq = @[@"银程金服",@"www.yinchenglicai.com",@"400-005-6677"];
    }
    return _arrq;
}
-(NSArray *)arr{
    if (!_arr) {
        _arr = [NSArray array];
        _arr = @[@[@"帮助中心",@"资费说明"],@[@"关注微信",@"官方网站",@"客服电话"],@[@"当前版本",@"意见反馈",@"欢迎点赞"]];
    }
    return _arr;
}
-(UITableView *)gytab{
    if (!_gytab) {
        _gytab = [[UITableView alloc]initWithFrame:CGRectMake(0,WTStatus_And_Navigation_Height, self.view.width, self.view.height-130-WTStatus_And_Navigation_Height) style:UITableViewStyleGrouped];
        self.gytab.scrollEnabled =NO;
        _gytab.dataSource= self;
        _gytab.delegate = self;
        _gytab.backgroundColor =grcolor;
        _gytab.estimatedRowHeight = 0;
        _gytab.estimatedSectionHeaderHeight = 0;
        _gytab.estimatedSectionFooterHeight = 0;
        _gytab.estimatedRowHeight = 0;
        _gytab.estimatedSectionHeaderHeight = 0;
        _gytab.estimatedSectionFooterHeight = 0;
    }
    return _gytab;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self Nav];
    [self.view addSubview:self.gytab];
    
    
    if (@available(iOS 11.0, *)) {
        self.gytab.contentInsetAdjustmentBehavior = UIApplicationBackgroundFetchIntervalNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = false;
    }
    // Do any additional setup after loading the view.
}
-(void)Nav{
    self.view.backgroundColor = grcolor;
    self.navigationItem.title =@"关于银程";
    UIButton *leftbutton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 10, 21)];
    
    [leftbutton setBackgroundImage:[UIImage imageNamed:@"icon_back1"] forState:UIControlStateNormal];
    [leftbutton setBackgroundImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateHighlighted];
    [leftbutton addTarget:self action:@selector(leftbtnclicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftbarbtn=[[UIBarButtonItem alloc]initWithCustomView:leftbutton];
    self.navigationItem.leftBarButtonItem=leftbarbtn;
  
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"Copyright © 2017 浙江齐融金融信息服务有限公司. All rights reserved.";
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:9];
    label.textColor = [UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:1/1.0];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.bottom.offset(-10);
    }];
    
    
    UIImageView *imv = [[UIImageView alloc]init];
    imv.image = [UIImage imageNamed:@"pic_logo"];
    [self.view addSubview:imv];
    [imv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.bottom.equalTo(label.mas_top).offset(-14);
        make.width.offset(111); make.height.offset(32);
    }];
    
    
}
-(void)leftbtnclicked{
    [self.navigationController popViewControllerAnimated:YES];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
     NSLog(@"%lu",(unsigned long)[self.arr[section]count]);
   return [self.arr[section]count];
   
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    gychenghuiTableViewCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"gychenghuiTableViewCell" owner:nil options:nil ]lastObject];
    cell.titleLab.text = self.arr[indexPath.section][indexPath.row];
    if (indexPath.section == 1 ||(indexPath.section ==2&&indexPath.row == 0)) {
        if (indexPath.section == 1) {
            cell.edtailLab.text = self.arrq[indexPath.row];
            if ([cell.edtailLab.text isEqualToString:@"400-005-6677"] || [cell.edtailLab.text isEqualToString:@"www.yinchenglicai.com"]) {
                cell.edtailLab.textColor = lancolor;
            }
        } else{
            cell.edtailLab.text = KVersion;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }else{
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section ==0&&indexPath.row ==0) {
        // 帮助中心
        WebViewController * webVC = [[WebViewController alloc] init];
        webVC.url = bzzxh5;
        webVC.WebTiltle = @"帮助中心";
        [self.navigationController pushViewController:webVC animated:YES];
    }else if (indexPath.section ==0&&indexPath.row ==1)
    {
        // 资费说明
        WebViewController * webVC = [[WebViewController alloc] init];
        webVC.url = zfsmh5;
        webVC.WebTiltle = @"资费说明";
        [self.navigationController pushViewController:webVC animated:YES];
    }
    
    if (indexPath.section==1 && indexPath.row ==2) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://400-005-6677"]];
    }else if (indexPath.section == 1 && indexPath.row == 1){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.yinchenglicai.com"]];
    }else if (indexPath.section == 1 && indexPath.row == 0){
        // 复制 文本，跳转至微信
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = @"银程金服服务号";
        NSString * str = @"微信公众号已复制，即将跳转";
        [self showHUD:str de:1.5];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
            NSURL *url = [NSURL URLWithString:@"wechat://"];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            [webView loadRequest:request];
            [self.view addSubview:webView];
        });
    }
    
    if (indexPath.section == 2 && indexPath.row == 1) {
        fankuiViewController *VC = [[fankuiViewController alloc]init];
        [self.navigationController pushViewController:VC animated:YES];
    }else if (indexPath.section ==2 && indexPath.row == 2){
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:AppStroreUrl]];
    }else if (indexPath.section == 2 && indexPath.row == 0){
        if ([preUrl hasPrefix:@"http://120.27.211.129"]) {
            // 测试服
            [self showHUD:@"测试服升级不了" de:1.5];
            return;
        }
        [self getAppVersion];   // 检测版本信息
    }
    
}

- (void)getAppVersion
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    //    CFShow(infoDictionary);
    // app名称
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    // app build版本
    NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
    NSLog(@"app名称：%@, app版本：%@, app build版本：%@", app_Name, app_Version, app_build);
    
    NSArray * versionArr = [app_Version componentsSeparatedByString:@"."];
    NSString * version1 = versionArr[0];
    NSString * version2 = [NSString stringWithFormat:@"%@.%@", versionArr[1], versionArr[2]];
    NSLog(@"versionArr：%@, version1：%@, version2：%@", versionArr, version1, version2);
    
    NSMutableDictionary * paramsDict = [NSMutableDictionary dictionary];
    paramsDict[@"app_id"] = @"3";
    paramsDict[@"os"] = @"ios";
    NSLog(@"%@?%@", versionurl, paramsDict);
    [WWZShuju initlizedData:versionurl paramsdata:paramsDict dicBlick:^(NSDictionary *info) {
        NSLog(@"%@", info);
        if ([info[@"r"] integerValue] == 1) {
            // 获取更新信息成功   app_Version(1.2.0) = version (version1) + versionName (version2)
            if ([info[@"item"][@"version"] floatValue] > [version1 floatValue] || [info[@"item"][@"versionName"] floatValue] > [version2 floatValue]) {
                    [self AlertWithTitle:@"发现新版本" message:info[@"item"][@"updateMsg"] andOthers:@[@"下次再说", @"立即更新"] animated:YES action:^(NSInteger index) {
                        if (index == 1) {
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:AppStroreUrl]];
                        }
                    }];
            }
        }
    }];
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.arr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}


@end
