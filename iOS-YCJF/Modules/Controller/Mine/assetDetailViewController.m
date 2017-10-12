//
//  assetDetailViewController.m
//  iOS-YCJF
//
//  Created by 姜宁桃 on 2017/8/21.
//  Copyright © 2017年 Yincheng. All rights reserved.
//

#import "assetDetailViewController.h"

#import "myzichanViewController.h"
#import "leijishouyiViewController.h"

@interface assetDetailViewController ()<UIScrollViewDelegate>
/***标签栏底部的红色指示器 ***/
@property (nonatomic ,weak)UIView *indicatorview;
/***当前选中的按钮 ***/
@property (nonatomic ,weak)UIButton *selectedButton;
/*** 顶部的所有标签 ***/
@property (nonatomic ,weak)UIView *titlesView;
/*** 底部的所有内容 ***/
@property (nonatomic ,weak)UIScrollView *contentView;

@property (nonatomic, strong) MineItemModel * Model;
@property (nonatomic, strong) AccinfoModel * accModel;

@end

@implementation assetDetailViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = @"资产明细";
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
    NSLog(@"%@", self.Model);
    [self NavBack];
    self.backImageView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = grcolor;
    
    [self setupChildVces]; //初始化子控制器
    [self setupTitlesView]; //设置顶部标签栏
    [self setupContentView]; //底部scrollview
    
    UIButton *WarningBtn = [[UIButton alloc]init];
    WarningBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    WarningBtn.userInteractionEnabled = NO;
    [WarningBtn setImage:[UIImage imageNamed:@"Group 6"] forState:UIControlStateNormal];
    [WarningBtn setTitle:@"投资有风险 理财需谨慎" forState:UIControlStateNormal];
    [WarningBtn setTitleColor:[UIColor colorWithRed:195/255.0 green:195/255.0 blue:195/255.0 alpha:1/1.0] forState:UIControlStateNormal];
    WarningBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:WarningBtn];
    [WarningBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.bottom.offset(-32);
    }];
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
    contentView.showsHorizontalScrollIndicator = NO;// 隐藏水平滚动条
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
    myzichanViewController *mynews = [[myzichanViewController alloc]init];
    mynews.title = @"我的资产";
    mynews.Model = self.Model;
    mynews.accModel = self.accModel;
    [self addChildViewController:mynews];
    
    leijishouyiViewController *chenghui = [[leijishouyiViewController alloc]init];
    chenghui.title = @"累计收益";
    chenghui.Model = self.Model;
    chenghui.accModel = self.accModel;
    [self addChildViewController:chenghui];
    
    
    
    
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
