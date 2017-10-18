//
//  TabBarViewController.m
//  YouLX
//
//  Created by king on 15/12/12.
//  Copyright © 2015年 feiwei. All rights reserved.
//

#import "TabBarViewController.h"
#import "HomeViewController.h"
#import "InvestViewController.h"
#import "MineViewController.h"
#import "LoginViewController.h"
//#import "TouchViewController.h"

@interface TabBarViewController ()


@end

@implementation TabBarViewController
{
    MyPicButton *lastBtn;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.tabBar.hidden = NO;
    if (self.viewControllers.count > 0) {
        return;
    }
    
    [self initTabBar];
    [self saveNavCon];
    
}

- (void)saveNavCon{
    HomeViewController *homeVC = [[HomeViewController alloc] init];
    InvestViewController *investVC = [[InvestViewController alloc] init];
    MineViewController *mineVC = [[MineViewController alloc] init];
    
    NSArray *viewArr = [[NSArray alloc] initWithObjects:homeVC,investVC,mineVC, nil];
    NSMutableArray *mArray = [[NSMutableArray alloc] initWithCapacity:viewArr.count];
    for (UIViewController *vc in viewArr) {
        UINavigationController *navCon = [[UINavigationController alloc] initWithRootViewController:vc];
        navCon.delegate = self;
        [mArray addObject:navCon];
    }
    self.viewControllers = mArray;
    self.selectedIndex = 0;
}

- (void)initTabBar{
    _tabView = [[UIView alloc] initWithFrame:CGRectMake(0, screen_height-49, screen_height, 49)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 49)];
    imageView.backgroundColor = tabBar_color;
    [_tabView addSubview:imageView];
    //细线
    UIView *sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0.5, screen_width, 0.5)];
    sepLine.backgroundColor = background_color;
    [_tabView addSubview:sepLine];
    NSArray *titleArray = @[@"首页",@"投资",@"我的"];
    NSArray *picArray = @[@"icon_home_unselected",@"icon_touzi_unselected",@"icon_user_unselected"];
    NSArray *highArray = @[@"icon_home_selected",@"icon_touzi_selected",@"icon_user_selected"];
    for (int i=0; i<titleArray.count; i++) {
        MyPicButton *button = [MyPicButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(screen_width/titleArray.count*i, 0, screen_width/titleArray.count, 49);
        [button setBtnViewWithImage:[picArray objectAtIndex:i] withImageWidth:20 withTitle:[titleArray objectAtIndex:i] withTitleColor:default_text_color withFont:systemFont(11.0f)];
        button.picPlacement = 1;
        button.imageDistant = 5;
        [button setBtnselectImage:[highArray objectAtIndex:i]withselectTitleColor:tabBar_SelectedColor];
        button.tag = 100+i;
        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_tabView addSubview:button];
        if (i == 0) {
            button.myBtnSelected = YES;
            lastBtn = button;
        }
    }
    [self.view addSubview:_tabView];
}

#pragma 标签栏按钮
- (void)btnClick:(MyPicButton *)button{
    
    NSLog(@"%ld", button.tag);
    NSString *userId =  [UserDefaults objectForKey:KAccount];
    if ((button.tag == 102 && userId) || button.tag == 100 || button.tag ==101) {
        
        //如果用户ID存在的话，说明已登陆
        if (button != lastBtn) {
            button.myBtnSelected = !button.myBtnSelected;
            lastBtn.myBtnSelected = NO;
            lastBtn = button;
        }
        //计算按钮间隔
        self.selectedIndex = button.tag - 100;
        
    }else
    {
        //  跳到登录页面
        LoginViewController *loginVC = [[LoginViewController  alloc] init];
        //隐藏tabbar
        UINavigationController * naVC = [[UINavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:naVC animated:YES completion:nil];
        
        NSLog(@"未登录");
        
    }
}

#pragma UINavigationDelegate
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    //计算导航栏控制器子控制器个数
    int count = (int)navigationController.viewControllers.count;
    if (count == 2) {
        [self showTabbar:NO];
    }else if(count == 1) {
        [self showTabbar:YES];
    }
}

//是否隐藏tabbar
- (void)showTabbar:(BOOL)show
{
    [UIView animateWithDuration:0.2 animations:^{
        if (show) {
            _tabView.frame = CGRectMake(0, screen_height - 49 , screen_width, 49);
        }else{
            _tabView.frame = CGRectMake(0, screen_height , screen_width, 49);
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 通知 选择 投资 tabbar
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(investListTabClick) name:KNotificationTabSelectInvest object:nil];
}

- (void)investListTabClick
{
    MyPicButton * btn = [self.view viewWithTag:101];
    [self btnClick:btn];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
