//
//  WelfareView.m
//  iOS-YCJF
//
//  Created by 姜宁桃 on 2017/8/24.
//  Copyright © 2017年 Yincheng. All rights reserved.
//

#import "WelfareView.h"

@interface WelfareView ()
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

@implementation WelfareView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // UI布局
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        [self configUI];
    }
    return self;
}

- (void)configUI
{
    _bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _bgView.backgroundColor = color(0, 0, 0, 0.6);
    [self addSubview:_bgView];
    
    _popBgView = [[UIView alloc] initWithFrame:CGRectMake(20, (ScreenHeight-450*heightScale)/2, ScreenWidth-40, 450*heightScale)];
    _popBgView.backgroundColor = [UIColor whiteColor];
    _popBgView.layer.cornerRadius = 5;
    _popBgView.clipsToBounds = YES;
    [self addSubview:_popBgView];
    
    _activeImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, _popBgView.width-20, 204*heightScale)];
    //_activeImgView.image = [UIImage imageNamed:@"popup_img"];
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
    //_contentLab.text = @"恭喜您成功领取618元抵扣券，红包已发送至您的个人账户，请前往“我的奖券”查看。";
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

- (void)setImgUrl:(NSString *)imgUrl {
    _imgUrl = imgUrl;
    [_activeImgView sd_setImageWithURL:[NSURL URLWithString:_imgUrl]];
}

- (void)setTxtStr:(NSString *)txtStr
{
    _txtStr = txtStr;
    _contentLab.text = _txtStr;
}

- (void)visitTheDetailOfWelfare:(id)sender {
    NSLog(@"查看");
    [self removeFromSuperview];
    if ([self.visitDelegate respondsToSelector:@selector(visitDetailOfWelfareEvent)]) {
        [self.visitDelegate visitDetailOfWelfareEvent];
    }
}

- (void)closePopupBtnClicked:(UIButton *)btn
{
    NSLog(@"tap");
    [self removeFromSuperview];
    if ([self.visitDelegate respondsToSelector:@selector(closePopupViewEvent)]) {
        [self.visitDelegate closePopupViewEvent];
    }
}


@end
