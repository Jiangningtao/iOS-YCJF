//
//  InviteFriendsViewController.m
//  iOS-YCJF
//
//  Created by 姜宁桃 on 2017/10/31.
//  Copyright © 2017年 Yincheng. All rights reserved.
//

#import "InviteFriendsViewController.h"
#import "InviteProgressView.h"
#import "ssyInviteModel.h"
#import "SsyRuleView.h"
#import "SunQRCode.h"
#import "yaoqingjiluViewController.h"
#import "myjiangliViewController.h"

@interface InviteFriendsViewController ()
{
    UIScrollView * _bgScrollView;
    UIButton * _bottomBtn;
    UIImageView * _bottomImgV;
    
    UIButton * _ruleBtn; // 活动规则
    UIImageView *img;   // 邀请二维码图片
    UILabel * label; // 专属推荐码
    UIButton *btnlj;
    UILabel * lablj;
    
    UIImageView * _animationImgV;
    
    ssyInviteModel * inviteModel;
}

@end

@implementation InviteFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"双11邀友夺壕礼";
    [self configUI];
    
    [self NetWork];
}

- (void)configUI
{
    [self NavBack];
    
    _bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, screen_width, screen_height-114)];
    _bgScrollView.showsVerticalScrollIndicator = NO;
    _bgScrollView.showsHorizontalScrollIndicator = NO;
    _bgScrollView.bounces = YES;
    _bgScrollView.scrollEnabled = YES;
    [self.view addSubview:_bgScrollView];
    
    _bottomBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, screen_height-50, screen_width, 50)];
    [_bottomBtn setTitle:@"邀请好友" forState:UIControlStateNormal];
    [_bottomBtn setTitleColor:KWhiteColor forState:UIControlStateNormal];
    [_bottomBtn addTarget:self action:@selector(shareFriendBtnEvent) forControlEvents:UIControlEventTouchUpInside];
    [_bottomBtn setBackgroundImage:IMAGE_NAMED(@"btn_touzi01") forState:UIControlStateNormal];
    [_bottomBtn setBackgroundImage:IMAGE_NAMED(@"btn_touzi02") forState:UIControlStateSelected];
    [self.view addSubview:_bottomBtn];
    
    _bottomImgV = [[UIImageView alloc] initWithImage:IMAGE_NAMED(@"yaoy_main3")];
    _bottomImgV.contentMode = UIViewContentModeScaleAspectFit;
    _bottomImgV.frame = CGRectMake(0, 0, screen_width, kRealValue(1817.5));
    _bgScrollView.contentSize = CGSizeMake(screen_width, kRealValue(1817.5));
    [_bgScrollView addSubview:_bottomImgV];
    
    _ruleBtn = [UIButton new];
    _ruleBtn.backgroundColor = color(252,179, 38, 1);
    [_ruleBtn border:KWhiteColor width:1 CornerRadius:12];
    _ruleBtn.titleLabel.font = systemFont(12);
    [_ruleBtn setTitle:@"活动规则" forState:UIControlStateNormal];
    [_ruleBtn setTitleColor:color(233, 56, 54, 1) forState:UIControlStateNormal];
    [_ruleBtn addTarget:self action:@selector(ActivityRuleBtnEvent) forControlEvents:UIControlEventTouchUpInside];
    [_bgScrollView addSubview:_ruleBtn];
    [_ruleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(22*heightScale);
        make.right.equalTo(self.view.mas_right).offset(10);
        make.width.offset(70);
        make.height.offset(24);
    }];
    
    img = [[UIImageView alloc]init];
    img.image = IMAGE_NAMED(@"default_erweima");
    [_bgScrollView addSubview:img];
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.offset(72*heightScale);
        make.width.height.offset(kRealValue(93));
    }];
    
    //邀请好友lab
    label = [[UILabel alloc] init];
    label.text = @"专属推荐码：--";
    label.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
    label.textColor = KWhiteColor;
    [_bgScrollView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.equalTo(img.mas_bottom).offset(100*heightScale);
    }];
    
    NSArray *arr = [NSArray arrayWithObjects:@"您已邀请好友（人）",@"您已获得奖励（元）", nil];
    NSArray * labArr = @[@"--", @"--"];
    for (int i = 0; i<2; i++) {
        
        btnlj = [[UIButton alloc] init];
        [btnlj setTitle:arr[i] forState:UIControlStateNormal];
        btnlj.titleLabel.font = [UIFont systemFontOfSize:12];
        btnlj.tag = i;
        [btnlj setTitleColor:KWhiteColor forState:UIControlStateNormal];
        btnlj.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        [btnlj addTarget:self action:@selector(btnljClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_bgScrollView addSubview:btnlj];
        [btnlj mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(label.mas_bottom).offset(10*heightScale);
            make.centerX.offset(-self.view.centerX/2 + i * self.view.centerX);
            make.height.offset(18);
        }];
        
        lablj = [[UILabel alloc] init];
        lablj.tag = 10+i;
        lablj.text = labArr[i];
        lablj.font = systemFont(18);
        lablj.textColor = KWhiteColor;
        lablj.textAlignment = NSTextAlignmentCenter;
        [_bgScrollView addSubview:lablj];
        [lablj mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(btnlj.mas_centerX).offset(-10*widthScale);
            make.top.equalTo(btnlj.mas_bottom).offset(0);
        }];
        
        UIView *viewc = [[UIView alloc] init];
        viewc.backgroundColor = KWhiteColor;
        [_bgScrollView addSubview:viewc];
        [viewc mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(btnlj.mas_bottom).offset(-10);
            make.bottom.equalTo(lablj.mas_bottom).offset(-4);
            make.centerX.offset(0);
            make.width.offset(0.5);
        }];
        
    }
    
    [self configImageViewAnimation];
}

- (void)configImageViewAnimation
{
    _animationImgV =[[UIImageView alloc] init];
    [self.view addSubview:_animationImgV];
    [_animationImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-20);
        make.bottom.equalTo(_bottomBtn.mas_top).offset(-20);
    }];
    
    // 加载所有的动画图片
    NSMutableArray *images = [NSMutableArray array];
    for (int i = 1; i<=6; i++) {
        NSString *filename = [NSString stringWithFormat:@"progress0%d", i];
        UIImage * image = [UIImage imageNamed:filename];
        [images addObject:image];
    }
    
    // 设置动画图片
    _animationImgV.animationImages = images;
    _animationImgV.image = IMAGE_NAMED(@"progress06");
    // 设置播放次数
    _animationImgV.animationRepeatCount = 1000000*1000000;
    // 设置动画的时间
    _animationImgV.animationDuration = 1.2;
    // 开始动画
    [_animationImgV startAnimating];
    
    [_animationImgV tapGesture:^(UIGestureRecognizer *ges) {
        
        [self inviteProgressEvent];
    }];
}

-(void)NavBack{
    UIButton *leftbutton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 10, 21)];
    
    [leftbutton setBackgroundImage:[UIImage imageNamed:@"icon_back1"] forState:UIControlStateNormal];
    [leftbutton setBackgroundImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateHighlighted];
    [leftbutton addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftbarbtn=[[UIBarButtonItem alloc]initWithCustomView:leftbutton];
    self.navigationItem.leftBarButtonItem=leftbarbtn;
    
    [self rightBarBtnImgN:@"icon_share" act:@selector(shareBtnEvent)];
}

- (void)shareBtnEvent
{
    [ShareManager shareWithTitle:inviteModel.share_title Content:inviteModel.share_content ImageName:@"share_ycjf" Url:inviteModel.share_url];
}

- (void)shareFriendBtnEvent
{
    if(![UserDefaults objectForKey:@"uid"])
    {
        [self AlertWithTitle:@"提示" message:@"您尚未登录，请前往登录" andOthers:@[@"稍后", @"登录"] animated:YES action:^(NSInteger index) {
            if (index == 0) {
                // 点击取消按钮 不进行操作
                NSLog(@"取消");
            }else if(index == 1)
            {
                // 点击确定按钮，去登录
                LoginViewController *sv = [[LoginViewController alloc]init];
                sv.isTurnToTabVC = @"YES";
                [self showViewController:sv sender:nil];
            }
        }];
    }else
    {
        [ShareManager shareWithTitle:inviteModel.share_title_ext Content:inviteModel.share_content_ext ImageName:@"share_ycjf" Url:inviteModel.share_url_ext];
        //[ShareManager shareWithTitle:[NSString stringWithFormat:@"%@元抵扣券", [UserDefaults objectForKey:KXshbmoney]] Content:[NSString stringWithFormat:@"您的好友赠送您%@元抵扣券，点击领取！", [UserDefaults objectForKey:KXshbmoney]] ImageName:@"share_ycjf" Url:[NSString stringWithFormat:@"%@ind/h5/act.html?tjr=%@", guangUrl,inviteModel.tjrnumber]];
    }
}

- (void)ActivityRuleBtnEvent
{
    SsyRuleView * ruleView = [[SsyRuleView alloc] initWithFrame:screen_bounds];
    ruleView.url = inviteModel.rule;
    [self.view.window addSubview:ruleView];
}

- (void)inviteProgressEvent
{
    if(![UserDefaults objectForKey:@"uid"])
    {
        [self AlertWithTitle:@"提示" message:@"您尚未登录，请前往登录" andOthers:@[@"稍后", @"登录"] animated:YES action:^(NSInteger index) {
            if (index == 0) {
                // 点击取消按钮 不进行操作
                NSLog(@"取消");
            }else if(index == 1)
            {
                // 点击确定按钮，去登录
                LoginViewController *sv = [[LoginViewController alloc]init];
                sv.isTurnToTabVC = @"YES";
                [self showViewController:sv sender:nil];
            }
        }];
    }else
    {
        InviteProgressView * progressView = [[InviteProgressView alloc] initWithFrame:screen_bounds];
    progressView.inviteCount = inviteModel.tjrcount?inviteModel.tjrcount:@"--";
    progressView.subDescriptionStr = inviteModel.txt?inviteModel.txt:@"再努力一下，拿大奖吧!";
    progressView.sliderValue = inviteModel.adopt?inviteModel.adopt:@"--";
    progressView.inviteBlock = ^{
        [self shareFriendBtnEvent];
    };
    [self.view.window addSubview:progressView];
    }
    
}

-(void)btnljClicked:(UIButton *)sender{
    if(![UserDefaults objectForKey:@"uid"])
    {
        [self AlertWithTitle:@"提示" message:@"您尚未登录，请前往登录" andOthers:@[@"稍后", @"登录"] animated:YES action:^(NSInteger index) {
            if (index == 0) {
                // 点击取消按钮 不进行操作
                NSLog(@"取消");
            }else if(index == 1)
            {
                // 点击确定按钮，去登录
                LoginViewController *sv = [[LoginViewController alloc]init];
                sv.isTurnToTabVC = @"YES";
                [self showViewController:sv sender:nil];
            }
        }];
    }else
    {
        switch (sender.tag) {
        case 0:
            [self yaoqing];
            break;
        case 1:
            [self touzi];
            break;
        default:
            break;
        }
    }
    
}

-(void)yaoqing{
    yaoqingjiluViewController *cx = [[yaoqingjiluViewController alloc]init];
    cx.activity = YES;
    [self.navigationController pushViewController:cx animated:YES];
}
-(void)touzi{
    myjiangliViewController *cx = [[myjiangliViewController alloc]init];
    cx.activity = YES;
    [self.navigationController pushViewController:cx animated:YES];
}

#pragma mark - Network
- (void)NetWork
{
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    params[@"uid"] = [UserDefaults objectForKey:@"uid"]?[UserDefaults objectForKey:@"uid"]:@"";
    NSLog(@"%@?uid=%@", ssyInviteActivityUrl, params[@"uid"]);
    [WWZShuju initlizedData:ssyInviteActivityUrl paramsdata:params dicBlick:^(NSDictionary *info) {
        NSLog(@"%@", info);
        inviteModel = [[ssyInviteModel alloc] initWithDictionary:info error:nil];
        if ([info[@"r"] integerValue] == 1) {
            UILabel * lab1 = (UILabel *)[self.view viewWithTag:10];
            lab1.text = [NSString stringWithFormat:@"%@", inviteModel.tjrcount];
            UILabel * lab2 = (UILabel *)[self.view viewWithTag:11];
            lab2.text = [NSString stringWithFormat:@"%@", inviteModel.tjrmoney];
            img.image = [SunQRCode GenerateQRCode:inviteModel.tjrurl];
            label.text = [NSString stringWithFormat:@"专属推荐码: %@",inviteModel.tjrnumber];
        }else if([info[@"msg"] isEqualToString:@"未登录！"] || ![UserDefaults objectForKey:@"uid"])
        {
            [self showTipView:info[@"msg"]];
            [self AlertWithTitle:@"提示" message:@"您尚未登录，请前往登录" andOthers:@[@"稍后", @"登录"] animated:YES action:^(NSInteger index) {
                if (index == 0) {
                    // 点击取消按钮 不进行操作
                    NSLog(@"取消");
                }else if(index == 1)
                {
                    // 点击确定按钮，去登录
                    LoginViewController *sv = [[LoginViewController alloc]init];
                    sv.isTurnToTabVC = @"YES";
                    [self showViewController:sv sender:nil];
                }
            }];
        }else
        {
            [self showTipView:info[@"msg"]];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
