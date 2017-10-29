//
//  JumpViewController.m
//  iOS-YCJF
//
//  Created by 姜宁桃 on 2017/8/24.
//  Copyright © 2017年 Yincheng. All rights reserved.
//

#import "JumpViewController.h"
#import "WebViewController.h"
#import "PageView.h"
#import "CountdownLabel.h"
#import "TouchViewController.h"

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

@interface JumpViewController ()

@property (nonatomic, strong) PageView *pageView;

@end

@implementation JumpViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self pageViewInit];
}

- (void)pageViewInit {
    WS(weakSelf);
    
    
    CountdownLabel *countdownLabel = [[CountdownLabel alloc] initWithFrame:CGRectMake(KScreenWidth - 80, 20, 72, 30)];
    countdownLabel.blockNewViewController = ^{
        [weakSelf removerSCPageView];
    };
    
    
    _pageView = [[PageView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    NSString * imgUrl = [UserDefaults objectForKey:@"adImage"];
     _pageView.pageURLString = imgUrl; //这个里面可以写url的连接  动态改变广告页面
    _pageView.blockSelect = ^{
        NSLog(@"广告页被点击。。。跳转下载的地址。或者产品的官网都可以的！！！");
        
        countdownLabel.isStop = YES;
        WebViewController *demoVC = [[WebViewController alloc] init];
        demoVC.upVC = @"AdpageVC";
        NSString * urlStr = [UserDefaults objectForKey:imgUrl];
        demoVC.url = urlStr;
        demoVC.WebTiltle = @"活动";
        [weakSelf.navigationController pushViewController:demoVC animated:YES];
    };
    [self.view addSubview:_pageView];
    
    [_pageView addSubview:countdownLabel];
}

- (void)removerSCPageView {
    WS(weakSelf);
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.pageView.alpha = 0.5;
        [weakSelf.pageView setTransform:(CGAffineTransformMakeScale(1.5, 1.5))];
    } completion:^(BOOL finished) {
        if (weakSelf.blockMainViewController) {
            weakSelf.blockMainViewController();
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
