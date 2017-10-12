//
//  endRedPacketView.m
//  iOS-YCJF
//
//  Created by ycios on 2017/9/20.
//  Copyright © 2017年 Yincheng. All rights reserved.
//

#import "endRedPacketView.h"

@interface endRedPacketView ()

@property (nonatomic, strong) UIImageView * bgImageView;
@property (nonatomic, strong) UILabel * titleLab;
@property (nonatomic, strong) UILabel * descriptionLab;
@property (nonatomic, strong) UIImageView * circleImageView;
@property (nonatomic, strong) UILabel * moneyLab;
@property (nonatomic, strong) UILabel * yuanLab;
@property (nonatomic, strong) UIButton * useButton;
@property (nonatomic, strong) UIView * lineView;
@property (nonatomic, strong) UIButton * closeButton;

@end

@implementation endRedPacketView

- (instancetype)initWithFrame:(CGRect)frame money:(NSString *)money
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = color(0, 0, 0, 0.3f);
        [self configUIWithMoney:money];
    }
    return self;
}

- (void)configUIWithMoney:(NSString *)money
{
    self.moneyLab.text = money;
    self.descriptionLab.text = [NSString stringWithFormat:@"您获得了%@元抵扣券\n快去使用吧！", money];
    
    [self addSubview:self.bgImageView];
    [self addSubview:self.titleLab];
    [self addSubview:self.descriptionLab];
    [self addSubview:self.circleImageView];
    [self.circleImageView addSubview:self.moneyLab];
    [self.circleImageView addSubview:self.yuanLab];
    [self addSubview:self.useButton];
    [self addSubview:self.lineView];
    [self addSubview:self.closeButton];
    
    
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.offset(0);
        make.centerY.offset(-40*heightScale);
        make.width.offset(screen_width);
    }];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.offset(0);
        make.top.equalTo(self.bgImageView.mas_top).offset(50);
    }];
    [self.descriptionLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.offset(0);
        make.top.equalTo(self.titleLab.mas_bottom).offset(14);
    }];
    [self.circleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.offset(0);
        make.top.equalTo(self.descriptionLab.mas_bottom).offset(10);
    }];
    [self.moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.offset(-4);
        make.centerY.offset(0);
    }];
    [self.yuanLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.moneyLab.mas_right).offset(0);
        make.bottom.equalTo(self.moneyLab.mas_bottom).offset(-11);
    }];
    [self.useButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.offset(0);
        make.top.equalTo(self.circleImageView.mas_bottom).offset(12);
        make.width.offset(160*widthScale);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.offset(0);
        make.top.equalTo(self.bgImageView.mas_bottom).offset(-24);
        make.width.offset(1);
        make.height.offset(102*heightScale);
    }];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.offset(0);
        make.top.equalTo(self.lineView.mas_bottom).offset(0);
    }];
    
}

#pragma mark - Getter
-(UIImageView *)bgImageView
{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] initWithImage:IMAGE_NAMED(@"redbox")];
    }
    return _bgImageView;
}

-(UILabel *)titleLab
{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.text = @"恭喜获得扫尾红包";
        _titleLab.font = [UIFont boldSystemFontOfSize:21];
        _titleLab.textColor = UIColorHex(#ef2725);
        _titleLab.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLab;
}

-(UILabel *)descriptionLab
{
    if (!_descriptionLab) {
        _descriptionLab = [[UILabel alloc] init];
        _descriptionLab.font = [UIFont systemFontOfSize:15];
        _descriptionLab.textColor = UIColorHex(#a24e2d);
        _descriptionLab.numberOfLines = 2;
        _descriptionLab.textAlignment = NSTextAlignmentCenter;
    }
    return _descriptionLab;
}

-(UIImageView *)circleImageView
{
    if (!_circleImageView) {
        _circleImageView = [[UIImageView alloc] initWithImage:IMAGE_NAMED(@"circle")];
    }
    return _circleImageView;
}

-(UILabel *)moneyLab
{
    if (!_moneyLab) {
        _moneyLab = [[UILabel alloc] init];
        _moneyLab.font = [UIFont boldSystemFontOfSize:44];
        _moneyLab.textColor = [UIColor whiteColor];
    }
    return _moneyLab;
}

-(UILabel *)yuanLab
{
    if (!_yuanLab) {
        _yuanLab = [[UILabel alloc] init];
        _yuanLab.text = @"元";
        _yuanLab.font = [UIFont systemFontOfSize:11];
        _yuanLab.textColor = [UIColor whiteColor];
    }
    return _yuanLab;
}

-(UIButton *)useButton
{
    if (!_useButton) {
        _useButton = [[UIButton alloc] init];
        [_useButton setBackgroundImage:IMAGE_NAMED(@"btn_get") forState:UIControlStateNormal];
        [_useButton setTitle:@"立即使用" forState:UIControlStateNormal];
        _useButton.titleLabel.font = [UIFont boldSystemFontOfSize:21];
        [_useButton setTitleColor:UIColorHex(#ef2725) forState:UIControlStateNormal];
        [_useButton addTarget:self action:@selector(useButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _useButton;
}

-(UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = UIColorHex(#e22423);
    }
    return _lineView;
}

-(UIButton *)closeButton
{
    if (!_closeButton) {
        _closeButton = [[UIButton alloc] init];
        [_closeButton setBackgroundImage:IMAGE_NAMED(@"close") forState:UIControlStateNormal];
        [_closeButton setBackgroundImage:IMAGE_NAMED(@"close") forState:UIControlStateSelected];
        [_closeButton addTarget:self action:@selector(closeBtnEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}


#pragma mark - Event 
- (void)closeBtnEvent
{
    KPostNotification(KNotificationRefreshMineDatas, nil);
    [self removeFromSuperview];
}

- (void)useButtonEvent
{
    if (_useBlock) {
        KPostNotification(KNotificationRefreshMineDatas, nil);
        [self removeFromSuperview];
        _useBlock();
    }
}

@end
