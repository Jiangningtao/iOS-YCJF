//
//  touziViewController.m
//  iOS-CHJF
//
//  Created by garday on 2017/3/21.
//  Copyright © 2017年 garday. All rights reserved.
//

#import "touziViewController.h"
#import "quanbuViewController.h"
#import "mujiViewController.h"
#import "huikuanViewController.h"

@interface touziViewController ()<UIScrollViewDelegate>
/***标签栏底部的红色指示器 ***/
@property (nonatomic ,weak)UIView *indicatorview;
/***当前选中的按钮 ***/
@property (nonatomic ,weak)UIButton *selectedButton;
/*** 顶部的所有标签 ***/
@property (nonatomic ,weak)UIView *titlesView;
/*** 底部的所有内容 ***/
@property (nonatomic ,weak)UIScrollView *contentView;



@end

@implementation touziViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     self.title =@"投资记录";
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
    [self Nav];
    
    [self setupChildVces]; //初始化子控制器
    //
    [self setupTitlesView]; //设置顶部标签栏
    //
    [self setupContentView]; //底部scrollview
    
    UIButton *alertbtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.centerX-105, self.contentView.frame.size.height+110+10, 210, 20)];
    [alertbtn setImage:[UIImage imageNamed:@"Group 6"] forState:UIControlStateNormal];
    [alertbtn setTitleColor:[UIColor colorWithRed:195/255.0 green:195/255.0 blue:195/255.0 alpha:1/1.0] forState:UIControlStateNormal];
    [alertbtn setTitle:@"投资有风险 理财需谨慎" forState:UIControlStateNormal];
    alertbtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:alertbtn];
    
    // Do any additional setup after loading the view.
}
-(void)Nav{
    self.view.backgroundColor = grcolor;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.tabBarController.tabBar.hidden = YES;
    UIButton *leftbutton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 10, 21)];
    
    [leftbutton setBackgroundImage:[UIImage imageNamed:@"icon_back1"] forState:UIControlStateNormal];
    [leftbutton setBackgroundImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateHighlighted];
    [leftbutton addTarget:self action:@selector(leftbtnclicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftbarbtn=[[UIBarButtonItem alloc]initWithCustomView:leftbutton];
    self.navigationItem.leftBarButtonItem=leftbarbtn;
    
}


-(void)setupTitlesView
{
    //标签栏整体
    UIView *titlesView = [[UIView alloc]init];
    titlesView.backgroundColor = [UIColor whiteColor];
    titlesView.width = self.view.width;
    titlesView.height = CHTitileViewH;
    titlesView.y = CHTitileViewY;
    [self.view addSubview:titlesView];
    self.titlesView = titlesView;
    
    
    //底部蓝指示器
    UIView *indicatorView = [[UIView alloc]init];
    indicatorView.backgroundColor =  lancolor;
    indicatorView.height = 2;
    indicatorView.tag = -1;
    indicatorView.y = titlesView.height - indicatorView.height;
    self.indicatorview = indicatorView;
    
    
    //内部子标签
    
    CGFloat width = titlesView.width/self.childViewControllers.count;
    CGFloat height = titlesView.height;
    for (NSInteger i = 0; i < self.childViewControllers.count; i++) {
        UIButton *button =[  [UIButton alloc]init];
        button.tag = i;
        button.height = height;
        button.width = width ;
        button.x = i * width;
        UIViewController *vc = self.childViewControllers[i];
        
        [button setTitle:vc.title forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button setTitleColor: lancolor forState:UIControlStateDisabled];
        [button addTarget:self action:@selector(titlesClicked:) forControlEvents:UIControlEventTouchUpInside];
        [titlesView addSubview:button];
        
        //默认选中点击第一个按钮
        if (i == 0) {
            button.enabled = NO;
            self.selectedButton = button;
            [button.titleLabel sizeToFit]; // 让按钮内部label根据文字内容来计算尺寸
            self.indicatorview.width = button.titleLabel.width;
            self.indicatorview.centerX =button.centerX;
        }
    }
    [titlesView addSubview:indicatorView];
}

#pragma mark - 点击事件
-(void)titlesClicked:(UIButton *)button
{
    /**修改按钮状态**/
    self.selectedButton.enabled = YES;
    button.enabled = NO;
    self.selectedButton = button;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.indicatorview.width = button.titleLabel.width;
        self.indicatorview.centerX =button.centerX;
    }];
    
    //滚动
    CGPoint offset = self.contentView.contentOffset;
    offset.x =button.tag *self.contentView.width;
    [self.contentView setContentOffset:offset animated:YES];
}

/**底部scrollview**/

-(void)setupContentView
{
    //不要自动调整inset
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIScrollView *contentView = [[UIScrollView alloc]init];
    contentView.frame = CGRectMake(0, 110, self.view.frame.size.width, self.view.frame.size.height -110);
    contentView.delegate = self;
    contentView.pagingEnabled = YES;//分页
    [self.view insertSubview:contentView atIndex:0];
    contentView.contentSize = CGSizeMake(contentView.width * self.childViewControllers.count, 0);
    self.contentView = contentView;
    self.contentView.bounces= NO;
    
    //添加第一个控制器的view
    [self scrollViewDidEndScrollingAnimation:contentView];
    
}

/**初始化子控制器**/

-(void)setupChildVces
{
    quanbuViewController *quanbu = [[quanbuViewController alloc]init];
    quanbu.title = @"全部";
    
    [self addChildViewController:quanbu];
    
    mujiViewController *muji = [[mujiViewController alloc]init];
    muji.title = @"募集中";
    
    [self addChildViewController:muji];
    
    huikuanViewController *huikuan = [[huikuanViewController alloc]init];
    huikuan.title = @"回款中";
    
    [self addChildViewController:huikuan];
    
    
    
}
#pragma mark - <uiscrollView代理>
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    //添加子控制器view
    
    //当前的索引
    NSInteger index = scrollView.contentOffset.x/scrollView.width;
    
    //取出子控制器
    UIViewController *vc = self.childViewControllers[index];
    vc.view.x= scrollView.contentOffset.x;
    vc.view.y = 0; //设置控制器view的y值为0（默认是20）；
    vc.view.height = scrollView.height;
    [scrollView addSubview:vc.view];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
    
    //点击按钮
    NSInteger index =scrollView.contentOffset.x / scrollView.width;
    [self titlesClicked:self.titlesView.subviews[index]];
    
}

-(void)leftbtnclicked{
    [self.navigationController popViewControllerAnimated:YES];
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
