//
//  MyNewsDetailViewController.m
//  iOS-CHJF
//
//  Created by 姜宁桃 on 2017/7/6.
//  Copyright © 2017年 garday. All rights reserved.
//

#import "MyNewsDetailViewController.h"

@interface MyNewsDetailViewController ()
{
    UILabel * titleLab;
    UILabel * dateLab;
    UITextView * contentView;
}
@end

@implementation MyNewsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self Nav];
    [self configUI];
    [self markNetWork];
}

-(void)Nav{
    self.navigationItem.title = @"消息详情";
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *leftbutton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 10, 21)];
    [leftbutton setBackgroundImage:[UIImage imageNamed:@"icon_back1"] forState:UIControlStateNormal];
    [leftbutton setBackgroundImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateHighlighted];
    [leftbutton addTarget:self action:@selector(leftbtnclicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftbarbtn=[[UIBarButtonItem alloc]initWithCustomView:leftbutton];
    self.navigationItem.leftBarButtonItem=leftbarbtn;
}

- (void)configUI
{
    titleLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2-100, 90, 200, 30)];
    titleLab.font = [UIFont systemFontOfSize:18];
    titleLab.text = self.dataDict[@"title"];
    titleLab.textColor = color(57, 149, 223, 1);
    titleLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLab];
    
    dateLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2-100, titleLab.bottom+8, 200, 20)];
    dateLab.font = [UIFont systemFontOfSize:13];
    dateLab.text = self.dataDict[@"time_h"];
    dateLab.textColor = color(73, 73, 73, 1);
    dateLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:dateLab];
    
    contentView = [[UITextView alloc] initWithFrame:CGRectMake(15, dateLab.bottom+8, ScreenWidth-30, ScreenHeight - 140)];
    contentView.font = [UIFont systemFontOfSize:14];
    contentView.text = self.dataDict[@"note"];
    contentView.textColor = color(152, 154, 158, 1);
    contentView.editable = NO;
    [self.view addSubview:contentView];
}

- (void)markNetWork
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"uid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"uid"];
    params[@"sid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"sid"];
    params[@"at"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"at"];
    params[@"version"] = @"v1.0.3";
    params[@"os"] = @"ios";
    params[@"id"] = self.dataDict[@"id"];
    params[@"dotype"] = @"1";
    
    NSLog(@"%@?%@", markmessage, params);
    [manager POST:markmessage parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@", responseObject);
        if ([[responseObject[@"r"] stringValue] isEqualToString: @"1"]) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadMymessage" object:nil userInfo:nil];
        }
        KPostNotification(KNotificationRefreshMineDatas, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
    }];
}

-(void)leftbtnclicked{
    [self.navigationController popViewControllerAnimated:YES];
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
