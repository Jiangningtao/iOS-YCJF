//
//  SuspendView.m
//  iOS-YCJF
//
//  Created by 姜宁桃 on 2017/11/2.
//  Copyright © 2017年 Yincheng. All rights reserved.
//

#import "SuspendView.h"
#import "ssyNewUserModel.h"

@interface SuspendView ()
{
    UIView * _bgView;
    UIView * _subBgView;
    UIButton * _closeBtn;
    
    UILabel * _titleLab;
    UIImageView * _imgV;
    UITextView * _textV;
    UILabel * _tipLab;
    ssyNewUserModel * _userModel;
}

@end

@implementation SuspendView

-(instancetype)initWithFrame:(CGRect)frame userModel:(ssyNewUserModel *)userModel{
    self = [super initWithFrame:frame];
    if (self) {
        _bgView = [[UIView alloc] initWithFrame:self.bounds];
        _bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        [_bgView tapGesture:^(UIGestureRecognizer *ges) {
            [self removeViewsAnimation];
        }];
        _userModel = userModel;
        [self addSubview:_bgView];
        [self configUI];
    }
    return self;
}

- (void)configUI
{
    _subBgView = [[UIView alloc] init];
    _subBgView.backgroundColor = KWhiteColor;
    _subBgView.radius = 2;
    [_bgView addSubview:_subBgView];
    [_subBgView tapGesture:^(UIGestureRecognizer *ges) {
        NSLog(@"....");
    }];
    [_subBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(iPhone5_Screen?kRealValue(30):35);
        make.right.offset(iPhone5_Screen?kRealValue(-30):-35);
        make.centerY.offset(0);
        if (iPhone6Plus_Screen) {
            make.height.offset(kRealValue(368));
        }else if (iPhone6_Screen || iPhone5_Screen)
        {
            make.height.offset(390);
        }
    
    }];
    
    _closeBtn = [UIButton new];
    [_closeBtn setBackgroundImage:IMAGE_NAMED(@"popup_close") forState:UIControlStateNormal];
    [_closeBtn setBackgroundImage:IMAGE_NAMED(@"popup_close") forState:UIControlStateSelected];
    [_closeBtn addTarget:self action:@selector(removeViewsAnimation) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_closeBtn];
    if (iPhone5_Screen) {
        _closeBtn.hidden=YES;
    }
    [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.equalTo(_subBgView.mas_bottom).offset(46);
    }];
    
    _titleLab = [[UILabel alloc] init];
    _titleLab.textColor = color(255,101,54, 1);
    _titleLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    [_subBgView addSubview:_titleLab];
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.equalTo(_subBgView.mas_top).offset(29);
    }];
    
    _imgV = [UIImageView new];
    _imgV.contentMode = UIViewContentModeScaleAspectFit;
    [_subBgView addSubview:_imgV];
    [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.equalTo(_titleLab.mas_bottom).offset(25);
        make.height.offset(97);
    }];
    
    UIView * _tipBgV = [UIView new];
    _tipBgV.backgroundColor = KWhiteColor;
    [_tipBgV border:color(255,101,54, 1) width:1 CornerRadius:22];
    [_subBgView addSubview:_tipBgV];
    [_tipBgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_subBgView.mas_bottom).offset(-20);
        make.centerX.offset(0);
        make.left.equalTo(_subBgView.mas_left).offset(20);
        make.right.equalTo(_subBgView.mas_right).offset(-20);
        make.height.offset(44);
    }];
    
    _tipLab = [UILabel new];
    _tipLab.numberOfLines = 2;
    _tipLab.textAlignment = NSTextAlignmentCenter;
    _tipLab.textColor = color(255,101,54, 1);
    _tipLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
    _tipLab.adjustsFontSizeToFitWidth = YES;
    [_tipBgV addSubview:_tipLab];
    [_tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(5);
        make.bottom.offset(-5);
        make.left.equalTo(_tipBgV.mas_left).offset(50);
        make.right.equalTo(_tipBgV.mas_right).offset(-50);
    }];
    
    _textV = [[UITextView alloc] init];
    _textV.showsVerticalScrollIndicator = NO;
    _textV.showsHorizontalScrollIndicator = NO;
    _textV.textAlignment = NSTextAlignmentCenter;
    _textV.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
    _textV.textColor = color(77, 77, 77, 1);
    _textV.editable = NO;
    [_subBgView addSubview:_textV];
    [_textV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.equalTo(_imgV.mas_bottom).offset(20);
        make.bottom.equalTo(_tipBgV.mas_top).offset(-20);
        make.left.equalTo(_subBgView.mas_left).offset(40);
        make.right.equalTo(_subBgView.mas_right).offset(-40);
    }];

    _titleLab.text = _userModel.title;
    [_imgV sd_setImageWithURL:[NSURL URLWithString:_userModel.banner] placeholderImage:IMAGE_NAMED(@"3wpopimg")];
    _tipLab.text = ![UserDefaults objectForKey:@"uid"]?@"前往登录":_userModel.btn;
    _textV.text = _userModel.content;
    
    [_tipLab tapGesture:^(UIGestureRecognizer *ges) {
        if ([_tipLab.text hasPrefix:@"前往登录"] || ![UserDefaults objectForKey:@"uid"]) {
            [self removeViewsAnimation];
            [self toLoginEvent];
        }else if ([_tipLab.text hasPrefix:@"前往投资"] || [_tipLab.text hasSuffix:@"前往投资"] || [_tipLab.text isEqualToString:@"前往投资"]) {
            [self removeViewsAnimation];
            [self toInvestEvent];
        }
    }];
    
}

- (void)removeViewsAnimation
{
    [UIView animateWithDuration:0.5 animations:^{
        _bgView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)toLoginEvent
{
    if (self.loginBlock) {
        self.loginBlock();
    }
}

- (void)toInvestEvent
{
    if (self.investBlock) {
        self.investBlock();
    }
}


@end
