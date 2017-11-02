//
//  InviteProgressView.m
//  iOS-YCJF
//
//  Created by 姜宁桃 on 2017/10/31.
//  Copyright © 2017年 Yincheng. All rights reserved.
//

#import "InviteProgressView.h"

@interface InviteProgressView ()
{
    UIView * _bgView;
    UIView * _subBgView;
    UIButton * _closeBtn;
    UILabel * _titleLab;
    
    UILabel * _descriptionLab; // 目前已邀请人数24人   符合条件18人
    UILabel * _subDescriptionLab; // 再努力一下，拿大奖吧!
    UISlider * _sliderView; // 进度条
    UIView * _thumbV;
    UIView * _flagImgV;
    UILabel * _captionLab; // 说明：仅统计符合条件人数
    UIButton * _inviteBtn;
    CGFloat fvalue;
}
@property (nonatomic, strong) UISlider * sliderView;

@end

@implementation InviteProgressView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _bgView = [[UIView alloc] initWithFrame:self.bounds];
        _bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        [_bgView tapGesture:^(UIGestureRecognizer *ges) {
            [self removeViewsAnimation];
        }];
        _bgView.alpha = 0;
        fvalue = 0;
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
        make.left.offset(10);
        make.right.offset(-10);
        make.centerY.offset(0);
        make.height.offset(330);
    }];
    
    _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeBtn setBackgroundImage:IMAGE_NAMED(@"icon_close") forState:UIControlStateNormal];
    [_closeBtn setBackgroundImage:IMAGE_NAMED(@"icon_close") forState:UIControlStateNormal];
    [_subBgView addSubview:_closeBtn];
    [_closeBtn addTarget:self action:@selector(removeViewsAnimation) forControlEvents:UIControlEventTouchUpInside];
    [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-14);
        make.top.offset(14);
    }];
    
    _titleLab = [UILabel new];
    _titleLab.text = @"我的进度";
    _titleLab.font = systemFont(15);
    _titleLab.textColor = color(51, 51, 51, 1);
    _titleLab.textAlignment = NSTextAlignmentCenter;
    [_subBgView addSubview:_titleLab];
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(15);
        make.centerX.equalTo(_subBgView.mas_centerX).offset(0);
    }];
    
    UIView * _lineV = [UIView new];
    _lineV.backgroundColor = color(224, 224, 224, 1);
    [_subBgView addSubview:_lineV];
    [_lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.offset(44);
        make.height.offset(0.5);
    }];
    
    _descriptionLab = [[UILabel alloc] init];
    _descriptionLab.font = systemFont(12);
    [_subBgView addSubview:_descriptionLab];
    [_descriptionLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.equalTo(_lineV.mas_bottom).offset(34);
    }];
    
    _subDescriptionLab = [[UILabel alloc] init];
    _subDescriptionLab.font = systemFont(12);
    [_subBgView addSubview:_subDescriptionLab];
    [_subDescriptionLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.equalTo(_descriptionLab.mas_bottom).offset(19);
    }];
    
    [_subBgView addSubview:self.sliderView];
    [_sliderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_subDescriptionLab.mas_bottom).offset(50);
        make.height.offset(7);
        make.centerX.offset(0);
        make.left.offset(20);
        make.right.offset(-20);
    }];
    
    // 自己写进度视图，方便加载小旗动画
    _thumbV = [UIView new];
    _thumbV.backgroundColor = color(253,134,98, 1);
    [_subBgView addSubview:_thumbV];
    [_thumbV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(2);
        make.width.offset(2);
        make.centerY.equalTo(self.sliderView.mas_centerY).offset(0);
        make.left.equalTo(self.sliderView.mas_left).offset(0);
    }];
    
    _flagImgV = [[UIImageView alloc] initWithImage:IMAGE_NAMED(@"flag_img")];
    [_subBgView addSubview:_flagImgV];
    [_flagImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_thumbV.mas_bottom).offset(2);
        make.right.equalTo(_thumbV.mas_right).offset(6);
    }];
    
    UILabel * _zeroLab = [UILabel new];
    _zeroLab.text = @"0人";
    _zeroLab.font = systemFont(12);
    [_subBgView addSubview:_zeroLab];
    [_zeroLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_sliderView.mas_bottom).offset(8);
        make.left.equalTo(_sliderView.mas_left).offset(0);
    }];
    
    UILabel * _twoLab = [UILabel new];
    _twoLab.text = @"2人";
    _twoLab.font = systemFont(12);
    [_subBgView addSubview:_twoLab];
    [_twoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_sliderView.mas_bottom).offset(8);
        make.centerX.equalTo(_sliderView.mas_left).offset((screen_width-60)/4);
        //make.left.equalTo(_zeroLab.mas_right).offset(_sliderView.width/4);
    }];
    
    UILabel * _fiveLab = [UILabel new];
    _fiveLab.text = @"5人";
    _fiveLab.font = systemFont(12);
    [_subBgView addSubview:_fiveLab];
    [_fiveLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_sliderView.mas_bottom).offset(8);
        make.centerX.offset(0);
    }];
    
    UILabel * _twenty = [UILabel new];
    _twenty.text = @"20人";
    _twenty.font = systemFont(12);
    [_subBgView addSubview:_twenty];
    [_twenty mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_sliderView.mas_bottom).offset(8);
        make.centerX.equalTo(_fiveLab.mas_centerX).offset((screen_width-60)/4);
    }];
    
    UILabel * _thirtyLab = [UILabel new];
    _thirtyLab.text = @"30人";
    _thirtyLab.font = systemFont(12);
    [_subBgView addSubview:_thirtyLab];
    [_thirtyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_sliderView.mas_bottom).offset(8);
        make.right.equalTo(_sliderView.mas_right).offset(0);
    }];
    
    _captionLab = [UILabel new];
    _captionLab.text = @"仅统计符合条件人数";
    _captionLab.textColor = color(243, 80, 31, 1);
    _captionLab.font = systemFont(10);
    [_subBgView addSubview:_captionLab];
    [_captionLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_thirtyLab.mas_bottom).offset(9);
        make.right.equalTo(_sliderView.mas_right).offset(0);
    }];
    
    _inviteBtn = [UIButton new];
    [_inviteBtn setTitle:@"前往邀请" forState:UIControlStateNormal];
    [_inviteBtn setTitleColor:color(243, 80, 31, 1) forState:UIControlStateNormal];
    [_inviteBtn border:color(243, 80, 31, 1) width:0.5 CornerRadius:22];
    _inviteBtn.backgroundColor = KWhiteColor;
    [_inviteBtn addTarget:self action:@selector(inviteBtnEvent) forControlEvents:UIControlEventTouchUpInside];
    [_subBgView addSubview:_inviteBtn];
    [_inviteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.left.offset(20);
        make.right.offset(-20);
        make.height.offset(44);
        make.bottom.equalTo(_subBgView.mas_bottom).offset(-20);
    }];
    
    
    [UIView animateWithDuration:0.5 animations:^{
        _bgView.alpha = 1;
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:1.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            _thumbV.width = fvalue*(self.sliderView.width/30);
            _flagImgV.right +=_thumbV.width;
        } completion:nil];
    });
    
}

#pragma mark - Setter
-(void)setSubDescriptionStr:(NSString *)subDescriptionStr
{
    _subDescriptionStr = subDescriptionStr;
    _subDescriptionLab.text = self.subDescriptionStr;
}

-(void)setSliderValue:(NSString *)sliderValue
{
    _sliderValue = sliderValue;
    CGFloat svalue = [sliderValue integerValue];
    NSLog(@"%@", sliderValue);
    
    if (svalue >=0 && svalue <= 2) {
        fvalue = (30/4)*(svalue/2);
    }else if (svalue >2 && svalue <=5){
        fvalue = 7.5+((svalue-2)/3)*(30/4);
    }else if (svalue>5 && svalue <=20){
        fvalue = 15+((svalue-5)/15)*(30/4);
    }else if (svalue>20 && svalue <30){
        fvalue = 22.5+((svalue-20)/10)*(30/4);
    }else{
        fvalue = 30;
    }
    
    //这里只是示例，你要求出需要设置颜色的字符的数量，这里为colorCount
    NSInteger colorStrCount0 = self.inviteCount.length;
    NSInteger colorStrCount1 = self.sliderValue.length;
    NSString *tempString = [NSString stringWithFormat:@"目前已邀请人数%@人   符合条件%@人", self.inviteCount,self.sliderValue];
    NSRange tjRange0 = [tempString localizedStandardRangeOfString:@"人数"];
    NSRange tjRange1 = [tempString localizedStandardRangeOfString:@"条件"];
    //用tempString来初始化一个NSMutableAttributedString
    NSMutableAttributedString *colorString = [[NSMutableAttributedString alloc]initWithString:tempString];
    //把colorString的4~colorStrCount这个范围内的字符设置为红色
    [colorString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(tjRange0.location+tjRange0.length, colorStrCount0)];
    [colorString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(tjRange1.location+tjRange1.length, colorStrCount1)];
    //注意，这里要用label的attributedText来接收，不能用text
    _descriptionLab.attributedText = colorString;
}

#pragma mark - Getter
-(UISlider *)sliderView
{
    if (!_sliderView) {
        _sliderView = [[UISlider alloc] init];
        _sliderView.backgroundColor = color(255, 233, 227, 1);
        _sliderView.tintColor = color(253,134,98, 1);
        _sliderView.minimumTrackTintColor = color(253,134,98, 1);
        _sliderView.maximumTrackTintColor = color(255, 233, 227, 1);
        _sliderView.thumbTintColor = KRedColor;//color(255, 233, 227, 1);
        _sliderView.minimumValue = 0;
        _sliderView.maximumValue = 30;
        _sliderView.radius = 3.5;
        _sliderView.enabled = NO;
        [_sliderView setThumbImage:IMAGE_NAMED(@"flag_circle") forState:UIControlStateNormal];
    }
    return _sliderView;
}

#pragma mark - Event Hander
- (void)inviteBtnEvent
{
    [self removeViewsAnimation];
    if (self.inviteBlock) {
        self.inviteBlock();
    }
}

- (void)removeViewsAnimation
{
    [UIView animateWithDuration:0.5 animations:^{
        _bgView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
