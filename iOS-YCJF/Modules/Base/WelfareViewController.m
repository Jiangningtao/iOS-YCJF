//
//  WelfareViewController.m
//  iOS-CHJF
//
//  Created by 姜宁桃 on 2017/7/13.
//  Copyright © 2017年 garday. All rights reserved.
//

#import "WelfareViewController.h"

@interface WelfareViewController ()
{
    UIView * _bgView;
    UIView * _popBgView;
    UIImageView * _activeImgView;
    UILabel * _tipLab;
    UILabel * _contentLab;
    UIButton * _detailBtn;
    UIButton * _closeBtn;
}

@end

@implementation WelfareViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"新手福利弹窗"];
    [TalkingData trackPageBegin:@"新手福利弹窗"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"新手福利弹窗"];
    [TalkingData trackPageEnd:@"新手福利弹窗"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configUI];
    
}

- (void)configUI
{
    _bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _bgView.backgroundColor = color(0, 0, 0, 0.6);
    [self.view addSubview:_bgView];
    
    _popBgView = [[UIView alloc] initWithFrame:CGRectMake(20, (ScreenHeight-450*heightScale)/2, ScreenWidth-40, 450*heightScale)];
    _popBgView.backgroundColor = [UIColor whiteColor];
    _popBgView.layer.cornerRadius = 5;
    _popBgView.clipsToBounds = YES;
    [self.view addSubview:_popBgView];
    
    _activeImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, _popBgView.width-20, 204*heightScale)];
    _activeImgView.image = [UIImage imageNamed:@"popup_img"];
    [_popBgView addSubview:_activeImgView];
    
    _tipLab = [[UILabel alloc] initWithFrame:CGRectMake(_popBgView.width/2-80,_activeImgView.bottom+8*heightScale, 160, 30*heightScale)];
    _tipLab.textAlignment = NSTextAlignmentCenter;
    _tipLab.text = @"注册成功";
    _tipLab.font = [UIFont systemFontOfSize:24];
    _tipLab.textColor = color(73, 123, 249, 1);
    [_popBgView addSubview:_tipLab];
    
    UIView * _contentBgView = [[UIView alloc] initWithFrame:CGRectMake(10, _tipLab.bottom+10*heightScale, _popBgView.width-20, 80*heightScale)];
    _contentBgView.layer.borderColor = color(217, 217, 217, 1).CGColor;
    _contentBgView.layer.borderWidth = 1;
    [_popBgView addSubview:_contentBgView];
    
    _contentLab = [[UILabel alloc] initWithFrame:CGRectMake(5, 5*heightScale, _contentBgView.width-10, 70*heightScale)];
    _contentLab.text = @"恭喜您成功领取618元抵扣券，红包已发送至您的个人账户，请前往“我的奖券”查看。";
    _contentLab.textColor = color(51, 51, 51, 1);
    _contentLab.numberOfLines = 0;
    _contentLab.font = [UIFont systemFontOfSize:15];
    [_contentBgView addSubview:_contentLab];
    
    _detailBtn = [[UIButton alloc] initWithFrame:CGRectMake(_popBgView.width/2-(275*widthScale)/2, _contentBgView.bottom+((_popBgView.height -10-204*heightScale-8*heightScale-30*heightScale-90*heightScale)/2 - 45*heightScale/2), 275*widthScale, 45*heightScale)];
    [_detailBtn setTitle:@"立即查看" forState:UIControlStateNormal];
    [_detailBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _detailBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    _detailBtn.backgroundColor = color(244, 198, 37, 1);
    _detailBtn.layer.cornerRadius = (45*heightScale)/2;
    _detailBtn.clipsToBounds = YES;
    [_detailBtn addTarget:self action:@selector(visitTheDetailOfWelfare:) forControlEvents:UIControlEventTouchUpInside];
    [_popBgView addSubview:_detailBtn];
    
    _closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth/2-(40*widthScale)/2, _popBgView.bottom+ (ScreenHeight-_popBgView.height)/4-(40*widthScale)/2, 40*widthScale, 40*widthScale)];
    [_closeBtn setBackgroundImage:[UIImage imageNamed:@"popup_close"] forState:UIControlStateNormal];
    [_closeBtn setBackgroundImage:[UIImage imageNamed:@"popup_close"] forState:UIControlStateSelected];
    [_closeBtn addTarget:self action:@selector(closePopupBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_closeBtn];
    
    UIButton * virtualBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, (ScreenHeight-450*heightScale)/2-10, (ScreenHeight-450*heightScale)/2-10)];
    virtualBtn.center = _closeBtn.center;
    [virtualBtn addTarget:self action:@selector(closePopupBtnClicked:) forControlEvents:UIControlEventAllEvents];
    [_bgView addSubview:virtualBtn];
    
}

- (void)visitTheDetailOfWelfare:(id)sender {
    NSLog(@"查看");
    [self.view removeFromSuperview];
    if ([self.visitDelegate respondsToSelector:@selector(visitDetailOfWelfareEvent)]) {
        [self.visitDelegate visitDetailOfWelfareEvent];
    }
}

- (void)closePopupBtnClicked:(UIButton *)btn
{
    NSLog(@"tap");
    [self.view removeFromSuperview];
    if ([self.visitDelegate respondsToSelector:@selector(closePopupViewEvent)]) {
        [self.visitDelegate closePopupViewEvent];
    }
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
