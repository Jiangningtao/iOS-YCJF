//
//  ViewController.m
//  iOS-YCJF
//
//  Created by 姜宁桃 on 2017/8/8.
//  Copyright © 2017年 Yincheng. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor clearColor];
    [super viewDidLoad];
    [self loadImageView];
    
    /**
     *  获取设备型号的方法
     */
        NSString * strModel  = [UIDevice currentDevice].model;
        NSLog(@"%d  %@", [QuickControl osVersion], strModel);
        NSLog(@"uniqueIdentifier: %@", [[UIDevice currentDevice].identifierForVendor UUIDString]);
        NSLog(@"name: %@", [[UIDevice currentDevice] name]);
        NSLog(@"systemName: %@", [[UIDevice currentDevice] systemName]);
        NSLog(@"systemVersion: %@", [[UIDevice currentDevice] systemVersion]);
        NSLog(@"model: %@", [[UIDevice currentDevice] model]);
        NSLog(@"localizedModel: %@", [[UIDevice currentDevice] localizedModel]);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self getAdvertisementRequest];
    });
}

- (void)loadImageView{
    NSArray *picArr = @[@"guide01",@"guide02",@"guide03"];
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width*(int)picArr.count, self.view.frame.size.height);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    for (int i=0; i<(int)picArr.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width*i, 0, self.view.frame.size.width, self.view.frame.size.height)];
        imageView.image = [UIImage imageNamed:[picArr objectAtIndex:i]];
        [scrollView addSubview:imageView];
        if (i == (int)picArr.count-1) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake((self.view.frame.size.width-200)/2, self.view.frame.size.height-200, 200, 200);
            [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            imageView.userInteractionEnabled = YES;
            [imageView addSubview:button];
        }
    }
    
    //添加视图
    [self.view addSubview:scrollView];
}

- (void)getAdvertisementRequest
{
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(concurrentQueue, ^{
        dispatch_async(concurrentQueue, ^{
            //获得开机画面
            if ([[NSUserDefaults standardUserDefaults]objectForKey:@"at"]) {
                NSDictionary *parameters = @{ @"device":@"2",
                                              @"flag": @"4",
                                              @"has_flash":@"1",
                                              @"flash_policy": @"rand"
                                              };
                
                NSLog(@"%@?%@", adimages, parameters);
                [WWZShuju initlizedData:adimages paramsdata:parameters dicBlick:^(NSDictionary *info) {
                    
                    NSLog(@"%@", info);
                    if ([info[@"r"] integerValue] == 1) {
                        // 请求成功
                        id data = info[@"flash"];
                        if ([data isKindOfClass:[NSDictionary class]]) {
                            [[NSUserDefaults standardUserDefaults] setObject:data[@"img_url"] forKey:@"adImage"];
                            [UserDefaults setObject:data[@"url"] forKey:data[@"img_url"]];
                            [[NSUserDefaults standardUserDefaults]synchronize];
                            NSLog(@"adImage:%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"adImage"]);
                        }
                    }else
                    {
                        NSLog(@"请求广告页图片失败");
                    }
                }];
                
            }
        });
    });
}


- (void)btnClick:(UIButton *)button{
    if ([self.clickDelegate respondsToSelector:@selector(btnhaveClicked)]) {
        [self.clickDelegate btnhaveClicked];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
