//
//  YinChengNewsDetailViewController.m
//  iOS-CHJF
//
//  Created by 姜宁桃 on 2017/7/6.
//  Copyright © 2017年 garday. All rights reserved.
//

#import "YinChengNewsDetailViewController.h"

@interface YinChengNewsDetailViewController ()
{
    UILabel * titleLab;
    UILabel * dateLab;
    UITextView * contentView;
}

@end

@implementation YinChengNewsDetailViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self AFNetWork];
    [self Nav];
}

- (void)AFNetWork{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"uid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"uid"];
    params[@"sid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"sid"];
    params[@"at"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"at"];
    params[@"version"] = @"v1.0.3";
    params[@"os"] = @"ios";
    params[@"news_id"] = self.news_id;
    [self showHUD];
    NSLog(@"%@?%@", ycmessageDetail, params);
    [manager POST:ycmessageDetail parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self hideHud];
        NSLog(@"%@", responseObject);
        if ([[responseObject[@"r"] stringValue] isEqualToString: @"1"]) {
            [self configUIWithData:responseObject[@"data"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
    }];
}

-(void)Nav{
    self.navigationItem.title = @"动态详情";
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *leftbutton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 10, 21)];
    [leftbutton setBackgroundImage:[UIImage imageNamed:@"icon_back1"] forState:UIControlStateNormal];
    [leftbutton setBackgroundImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateHighlighted];
    [leftbutton addTarget:self action:@selector(leftbtnclicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftbarbtn=[[UIBarButtonItem alloc]initWithCustomView:leftbutton];
    self.navigationItem.leftBarButtonItem=leftbarbtn;
}

- (void)configUIWithData:(NSDictionary *)dict
{
    
    titleLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 90, ScreenWidth - 20, 30)];
    titleLab.font = [UIFont systemFontOfSize:18];
    titleLab.text = dict[@"title"];
    titleLab.textColor = color(57, 149, 223, 1);
    titleLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLab];
    
    dateLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2-100, titleLab.bottom+8, 200, 20)];
    dateLab.font = [UIFont systemFontOfSize:13];
    dateLab.text = dict[@"publish_time"];
    dateLab.textColor = color(73, 73, 73, 1);
    dateLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:dateLab];
    
    
    contentView = [[UITextView alloc] initWithFrame:CGRectMake(15, dateLab.bottom+8, ScreenWidth-30, ScreenHeight - 140)];
    contentView.font = [UIFont systemFontOfSize:14];
    NSAttributedString * strAtt = [[NSAttributedString alloc] initWithData:[dict[@"content"] dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    contentView.showsHorizontalScrollIndicator = NO;
    contentView.showsVerticalScrollIndicator = NO;
    contentView.attributedText = strAtt;
    contentView.textColor = color(152, 154, 158, 1);
    contentView.editable = NO;
    [self.view addSubview:contentView];
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
