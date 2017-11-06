//
//  BaseViewController.m
//  YouLX
//
//  Created by king on 15/12/12.
//  Copyright © 2015年 feiwei. All rights reserved.
//

#import "BaseViewController.h"
#import <UMSocialQQHandler.h>
#import <UMSocialWechatHandler.h>
#import <UMSocialSinaHandler.h>
#import <UMSocialSinaSSOHandler.h>
#import "TabBarViewController.h"

#import "SuspendView.h"
#import "ssyNewUserModel.h"
#import "BiaoDetailViewController.h"

@interface BaseViewController ()<UMSocialUIDelegate>
{
    ssyNewUserModel * newUserModel;
}
//加载视图
@property (nonatomic,strong)UILabel *tipLabel;

@end

@implementation BaseViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.hidden = YES;
//    self.navigationController.toolbar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
//    [MobClick beginLogPageView:self.title];
//    [TalkingData trackPageBegin:self.title];
    
    TabBarViewController *tabVC = (TabBarViewController *)self.tabBarController;
    if (self.navigationController.viewControllers.count > 1) {
        [tabVC showTabbar:NO];
    }else {
        [tabVC showTabbar:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [MobClick endLogPageView:self.title];
//    [TalkingData trackPageEnd:self.title];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavView];
    
    if (iOS7Later) { // 判断是否是IOS7
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    }
    
}

- (void)initNavView{
    //创建主视图包含基础视图
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, screen_width, screen_height-20)];
    //创建背景视图
    _backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screen_width, screen_height)];
    _backImageView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_backImageView];
//    [self.view addSubview:backView];
    
    //自定义导航栏视图
    _navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 64)];
    _navView.backgroundColor = [UIColor whiteColor];
    _sepView = [[UIView alloc] initWithFrame:CGRectMake(0, 63, screen_width, 1)];
    _sepView.backgroundColor = sepline_color;
    [_navView addSubview:_sepView];
    //标题视图
    _titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
    _titleView.frame = CGRectMake(0, 0, 40, 30);
    _titleView.center = CGPointMake(screen_width/2, 20+22);
    _titleView.contentMode = UIViewContentModeScaleAspectFit;
    [_navView addSubview:_titleView];
    //标题名
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((screen_width-200)/2, 24, 200, 36)];
    _titleLabel.textAlignment = 1;
    _titleLabel.font = [UIFont systemFontOfSize:20.0f];
    _titleLabel.textColor = color(0, 0, 0, 0.9);
    [_navView addSubview:_titleLabel];
    [self.view addSubview:_navView];
    self.navView.hidden = YES;
    
    //输入提示框
    _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screen_width, 30)];
    _tipLabel.textColor = [UIColor whiteColor];
    _tipLabel.backgroundColor = color(0, 0, 0, 0.7);
    _tipLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    _tipLabel.layer.cornerRadius = 5;
    _tipLabel.clipsToBounds = YES;
    _tipLabel.textAlignment = 1;
}

#pragma mark -- 创建控件
//------默认的右边按钮-------
- (void)showRightBtn {
    if (_rightButton == nil) {
        //基础控件的初始化
        _rightButton = [MyPicButton buttonWithType:UIButtonTypeCustom];
        [_rightButton setFrame:CGRectMake(screen_width-45, 24, 40, 36)];
        [_rightButton setBtnViewWithImage:@"" withImageWidth:30 withTitle:@"" withTitleColor:[UIColor whiteColor] withFont:systemFont(17.0f)];
        [_rightButton setOnlyText];
        [_rightButton addTarget:self action:@selector(navRightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_navView addSubview:_rightButton];
    }
}
//------自定义的右边按钮(图片)-------
- (void)showRightBtn:(CGRect)rightBtnFrame withImage:(NSString *)imageName withImageWidth:(float)imageWidth{
    if (_rightButton == nil) {
        //基础控件的初始化
        _rightButton = [MyPicButton buttonWithType:UIButtonTypeCustom];
        [_rightButton setFrame:rightBtnFrame];
        [_rightButton setBtnViewWithImage:imageName withImageWidth:imageWidth withTitle:@"" withTitleColor:[UIColor whiteColor] withFont:systemFont(17.0f)];
        [_rightButton addTarget:self action:@selector(navRightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_navView addSubview:_rightButton];
    }
}
//------自定义的右边按钮(文字)-------
- (void)showRightBtn:(CGRect)rightBtnFrame withFont:(UIFont *)font withTitle:(NSString *)title withTitleColor:(UIColor *)titleColor{
    if (_rightButton == nil) {
        //基础控件的初始化
        _rightButton = [MyPicButton buttonWithType:UIButtonTypeCustom];
        [_rightButton setFrame:rightBtnFrame];
        [_rightButton setBtnViewWithImage:@"" withImageWidth:1 withTitle:title withTitleColor:titleColor withFont:font];
//        _rightButton.picPlacement = 2;
        [_rightButton setOnlyText];
        [_rightButton addTarget:self action:@selector(navRightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_navView addSubview:_rightButton];
    }
}

//当push的时候显示返回按钮
//------默认的返回按钮-------
- (void)showBackBtn {
    if (_backButton == nil) {
        _backButton = [MyPicButton buttonWithType:UIButtonTypeCustom];
        _backButton.frame = CGRectMake(10, 24, 55, 36);
        _backButton.imageDistant = 0;
        [_backButton setBtnViewWithImage:@"back_high" withImageWidth:25 withTitle:@"" withTitleColor:[UIColor whiteColor] withFont:systemFont(17.0f)];
        [_backButton addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
        [_navView addSubview:_backButton];
    }
    //    _titleView.left = _backButton.right;
}

// navBar 上的back按钮
-(void)NavBack{
    UIButton *leftbutton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 10, 21)];
    
    [leftbutton setBackgroundImage:[UIImage imageNamed:@"icon_back1"] forState:UIControlStateNormal];
    [leftbutton setBackgroundImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateHighlighted];
    [leftbutton addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftbarbtn=[[UIBarButtonItem alloc]initWithCustomView:leftbutton];
    self.navigationItem.leftBarButtonItem=leftbarbtn;
    
}

- (void)showImgBackBtn{
    if (_backButton == nil) {
        //基础控件的初始化
        _backButton = [MyPicButton buttonWithType:UIButtonTypeCustom];
        [_backButton setFrame:CGRectMake(16, 31, 10, 21)];
        [_backButton setBackgroundImage:IMAGE_NAMED(@"icon_back1") forState:UIControlStateNormal];
        [_backButton setBackgroundImage:IMAGE_NAMED(@"icon_back") forState:UIControlStateHighlighted];
        [_backButton addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
        [_navView addSubview:_backButton];
    }
}

//------自定义的返回按钮(图片)-------
- (void)showBackBtn:(CGRect)rightBtnFrame withImage:(NSString *)imageName withImageWidth:(float)imageWidth {
    if (_backButton == nil) {
        //基础控件的初始化
        _backButton = [MyPicButton buttonWithType:UIButtonTypeCustom];
        [_backButton setFrame:rightBtnFrame];
        [_backButton setBtnViewWithImage:imageName withImageWidth:imageWidth withTitle:@"" withTitleColor:[UIColor whiteColor] withFont:systemFont(17.0f)];
        [_backButton addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
        [_navView addSubview:_backButton];
    }
}
//------自定义的返回按钮(文字)-------
- (void)showBackBtn:(CGRect)rightBtnFrame withFont:(UIFont *)font withTitle:(NSString *)title withTitleColor:(UIColor *)titleColor {
    if (_backButton == nil) {
        //基础控件的初始化
        _backButton = [MyPicButton buttonWithType:UIButtonTypeCustom];
        [_backButton setFrame:rightBtnFrame];
        [_backButton setBtnViewWithImage:@"" withImageWidth:1 withTitle:title withTitleColor:titleColor withFont:font];
        [_backButton setOnlyText];
        [_backButton addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
        [_navView addSubview:_backButton];
    }
}
//------默认的其他按钮-------
- (void)showOtherBtn {
    if (_otherButton == nil) {
        //基础控件的初始化
        _otherButton = [MyPicButton buttonWithType:UIButtonTypeCustom];
        [_otherButton setFrame:CGRectMake(screen_width-80, 27, 30, 30)];
        [_otherButton setBtnViewWithImage:@"" withImageWidth:30 withTitle:@"" withTitleColor:[UIColor whiteColor] withFont:systemFont(17.0f)];
        [_otherButton addTarget:self action:@selector(navOtherBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_navView addSubview:_otherButton];
    }
}

#pragma 加载框
- (void)showHUD:(NSString *)title isDim:(BOOL)isDim{
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.labelText = title;
    self.hud.dimBackground = isDim;
}

- (void)showHUDComplete:(NSString *)title{
    self.hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    self.hud.mode = MBProgressHUDModeCustomView;
    self.hud.labelText = title;
    [self.hud hide:YES afterDelay:1];
}
- (void)hideHUD
{
    [self.hud hide:YES];
}

#pragma 提示框
- (void)showTipView:(NSString *)tipStr {
    if (![_tipLabel superview]) {
        [_tipLabel removeFromSuperview];
        _tipLabel.text = tipStr;
        CGSize size = [_tipLabel sizeThatFits:CGSizeMake(MAXFLOAT, 30)];
        _tipLabel.width = size.width+30;
        _tipLabel.center = CGPointMake(screen_width/2, screen_height/2);
        [self.view addSubview:_tipLabel];
    }
    [_tipLabel performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:2];
}

#pragma 导航栏按钮事件
//左边
- (void)backClick:(UIButton *)button {
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
//    [self.navigationController popViewControllerAnimated:YES];
}
//右边
- (void)navRightBtnClick:(UIButton *)button {
    
}
//其他
- (void)navOtherBtnClick:(UIButton *)button {
    
}

#pragma 分享事件
- (void)shareQQAndWechat:(NSString *)urlStr {
    [UMSocialWechatHandler setWXAppId:WX_Key appSecret:WX_Secret url:urlStr];
    [UMSocialQQHandler setQQWithAppId:QQ_Key appKey:QQ_Secret url:urlStr];
}
//控制器
- (void)shareController:(NSString *)shareText withImage:(NSString *)shareImage {
    [UMSocialSnsService presentSnsController:self appKey:UMengKey shareText:shareText shareImage:[UIImage imageNamed:shareImage] shareToSnsNames:@[UMShareToWechatSession,UMShareToQQ,UMShareToWechatTimeline,UMShareToSina] delegate:self];
}
//活动视图
- (void)shareSheetView:(NSString *)shareText withImage:(NSString *)shareImage {
    [UMSocialSnsService presentSnsIconSheetView:self appKey:UMengKey shareText:shareText shareImage:[UIImage imageNamed:shareImage] shareToSnsNames:@[UMShareToWechatSession,UMShareToQQ,UMShareToWechatTimeline,UMShareToSina] delegate:self];
}
//分享
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //分享成功操作
    if (response.responseCode == UMSResponseCodeSuccess) {
        [self showTipView:@"分享成功"];
    } else if(response.responseCode != UMSResponseCodeCancel) {
        [self showTipView:@"分享失败"];
    }
}

-(BOOL)closeOauthWebViewController:(UINavigationController *)navigationCtroller socialControllerService:(UMSocialControllerService *)socialControllerService{
    
    
    return NO;
}
-(void)didCloseUIViewController:(UMSViewControllerType)fromViewControllerTyp {
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

// 活动
/**
 *  双十一活动悬浮窗
 */
- (void)showSuspendView
{
    UIImageView * imgV = [UIImageView new];
    imgV.contentMode = UIViewContentModeScaleAspectFit;
    imgV.tag = 543;
    [self.view addSubview:imgV];
    [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(-85);
        make.width.height.offset(67);
    }];
    [imgV tapGesture:^(UIGestureRecognizer *ges) {
        [self showSuspendPopView];
    }];
    
}

- (void)loadSuspendData
{
    NSLog(@"%@?uid=%@", ssyNewUserActivityUrl, [UserDefaults objectForKey:@"uid"]);
    [WWZShuju initlizedData:ssyNewUserActivityUrl paramsdata:@{@"uid":[UserDefaults objectForKey:@"uid"]?[UserDefaults objectForKey:@"uid"]:@""} dicBlick:^(NSDictionary *info) {
        NSLog(@"%@", info);
        UIImageView * imgV = [self.view viewWithTag:543];
        newUserModel = [[ssyNewUserModel alloc] initWithDictionary:info error:nil];
        if ([newUserModel.ifshow integerValue] == 1) {
            imgV.hidden=NO;
        }else
        {
            imgV.hidden=YES;
        }
        [imgV sd_setImageWithURL:[NSURL URLWithString:newUserModel.ico] placeholderImage:IMAGE_NAMED(@"3wicon")];
    }];
}

- (void)showSuspendPopView
{
    SuspendView * suspendView = [[SuspendView alloc] initWithFrame:screen_bounds userModel:newUserModel];
    suspendView.loginBlock = ^{
        LoginViewController *sv = [[LoginViewController alloc]init];
        sv.isTurnToTabVC = @"YES";
        [self showViewController:sv sender:nil];
    };
    suspendView.investBlock = ^{
        BiaoDetailViewController *ssc = [[BiaoDetailViewController alloc]init];
        ssc.idstr = newUserModel.bid;
        [self showViewController:ssc sender:nil];
    };
    [self.view.window addSubview:suspendView];
}

#pragma mark - Getter
-(NSDictionary *)paramsBase
{
    if (!_paramsBase) {
        _paramsBase = @{
                        @"app_id":@"3",
                        @"secret":@"aodsadhowiqhdwiqs",
                        @"at":[UserDefaults objectForKey:@"at"],
                        @"os":@"ios",
                        @"version":KVersion
                        };
    }
    return _paramsBase;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
