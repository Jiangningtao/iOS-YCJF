//
//  UpdateTipView.m
//  iOS-YCJF
//
//  Created by 姜宁桃 on 2017/8/29.
//  Copyright © 2017年 Yincheng. All rights reserved.
//

#import "UpdateTipView.h"

@interface UpdateTipView ()

@property (nonatomic, strong) UIView * bgView;  // 白色的背景
@property (nonatomic, strong) UIImageView * imgView;    // 图片
@property (nonatomic, strong) UITextView * contentTV;   // 内容
@property (nonatomic, strong) UIButton * nextTimeBtn;   //  下次再说按钮
@property (nonatomic, strong) UIButton * updateBtn; //  立即更新按钮
@property (nonatomic, strong) UIButton * closeBtn;  //  底部关闭按钮

@end

@implementation UpdateTipView

-(instancetype)initWithFrame:(CGRect)frame updateStr:(NSString *)updateStr{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUIWithUpdateStr:updateStr];
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        
        
    }
    return self;
}

- (void)setUIWithUpdateStr:(NSString *)updateStr
{
    self.bgView.frame = CGRectMake(26*widthScale, 140*heightScale, self.width-52*widthScale, self.height-280*heightScale);
    [self addSubview:self.bgView];
    
//    self.closeBtn.frame = CGRectMake(screen_width/2-20, self.bgView.bottom+25*heightScale, 40, 40);
    [self addSubview:self.closeBtn];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView.mas_bottom).offset(25*heightScale);
        make.centerX.offset(0);
        make.width.height.offset(30*widthScale);
    }];
    
    [self.bgView addSubview:self.imgView];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.bgView).offset(0);
        make.height.offset(178*heightScale);
    }];
    
    [self.bgView addSubview:self.nextTimeBtn];
    [self.nextTimeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.equalTo(self.bgView).offset(0);
        make.height.offset(44*heightScale);
        make.width.offset(self.bgView.width/2);
    }];
    
    [self.bgView addSubview:self.updateBtn];
    [self.updateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.equalTo(self.bgView).offset(0);
        make.height.offset(44*heightScale);
        make.width.offset(self.bgView.width/2);
    }];
    
    self.contentTV.text = updateStr;
    [self.bgView addSubview:self.contentTV];
    [self.contentTV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgView.mas_bottom).offset(20*heightScale);
        make.bottom.equalTo(self.nextTimeBtn.mas_top).offset(-20*heightScale);
        make.left.equalTo(self.bgView.mas_left).offset(25*widthScale);
        make.right.equalTo(self.bgView.mas_right).offset(-25*widthScale);
    }];
}

#pragma mark - Event Hander
- (void)nextTimeBtnEvent:(UIButton *)btn
{
    [self removeFromSuperview];
}

- (void)updateBtnEvent:(UIButton *)btn
{
    [self removeFromSuperview];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:AppStroreUrl]];
}

- (void)closeBtnEvent:(UIButton *)btn
{
    [self removeFromSuperview];
}

#pragma mark - Getter
-(UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.radius = 5;
    }
    return _bgView;
}

-(UIImageView *)imgView
{
    if (!_imgView) {
        _imgView = [[UIImageView alloc] initWithImage:IMAGE_NAMED(@"pop_img")];
        _imgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imgView;
}

-(UITextView *)contentTV
{
    if (_contentTV == nil) {
        _contentTV = [[UITextView alloc] init];
        _contentTV.editable = NO;
        _contentTV.selectable = NO;
        _contentTV.showsVerticalScrollIndicator = NO;
        _contentTV.showsHorizontalScrollIndicator = NO;
        _contentTV.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15*widthScale];
        _contentTV.textColor = UIColorHex(#666666);
        //@"1、性能更稳定，页面操作更流畅\n2、新增指纹解锁，一键登录更方便\n3、APP消息推送，更新活动及时获取\n4、色调统一，视觉呈现更舒适\n5、修改了部分bug，体验升级";
    }
    return _contentTV;
}

-(UIButton *)nextTimeBtn
{
    if (!_nextTimeBtn) {
        _nextTimeBtn = [[UIButton alloc] init];
        _nextTimeBtn.backgroundColor = UIColorHex(#d9d9d9);
        [_nextTimeBtn setTitle:@"下次再说" forState:UIControlStateNormal];
        [_nextTimeBtn setTitleColor:KWhiteColor forState:UIControlStateNormal];
        _nextTimeBtn.layer.masksToBounds = YES;
        [_nextTimeBtn addTarget:self action:@selector(nextTimeBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
        _nextTimeBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16*widthScale];
    }
    return _nextTimeBtn;
}

-(UIButton *)updateBtn
{
    if (!_updateBtn) {
        _updateBtn = [[UIButton alloc] init];
        _updateBtn.backgroundColor = UIColorHex(#0079ff);
        [_updateBtn setTitle:@"立即更新" forState:UIControlStateNormal];
        [_updateBtn setTitleColor:KWhiteColor forState:UIControlStateNormal];
        _updateBtn.layer.masksToBounds = YES;
        [_updateBtn addTarget:self action:@selector(updateBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
        _updateBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16*widthScale];
    }
    return _updateBtn;
}

-(UIButton *)closeBtn
{
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc] init];
        [_closeBtn setBackgroundImage:IMAGE_NAMED(@"popup_close") forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

@end
