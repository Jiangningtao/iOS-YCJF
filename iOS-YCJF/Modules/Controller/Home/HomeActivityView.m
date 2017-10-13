//
//  HomeActivityView.m
//  iOS-YCJF
//
//  Created by 姜宁桃 on 2017/9/25.
//  Copyright © 2017年 Yincheng. All rights reserved.
//

#import "HomeActivityView.h"

@interface HomeActivityView ()

@property (nonatomic, strong) UIImageView * bgImageView;
@property (nonatomic, strong) UIButton * closeButton;

@end

@implementation HomeActivityView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = color(0, 0, 0, 0.6f);
        [self configUI];
    }
    return self;
}

- (void)configUI
{
    _bgImageView = [[UIImageView alloc] init];
    _bgImageView.userInteractionEnabled = YES;
    _bgImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_bgImageView];
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.offset(0);
        make.centerY.offset(0);
        make.width.offset(300*widthScale);
        make.height.offset(350*heightScale);
    }];
    
    [self addSubview:self.closeButton];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.offset(0);
        make.top.equalTo(_bgImageView.mas_bottom).offset(50*heightScale);
    }];
    
    _bgImageView.center = CGPointMake(self.centerX, self.centerY-screen_height);
    self.closeButton.hidden = YES;
    [UIView animateWithDuration:0.5 animations:^{
        
        _bgImageView.center = CGPointMake(self.centerX, self.centerY);
        self.closeButton.hidden = NO;
    }];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [_bgImageView addGestureRecognizer:singleTap];
    
}

- (void)setPageURLString:(NSString *)pageURLString {
    _pageURLString = pageURLString;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_bgImageView sd_setImageWithURL:[NSURL URLWithString:_pageURLString] placeholderImage:nil];
}

#pragma mark --- 响应点击广告页的方法
- (void)handleSingleTap:(UITapGestureRecognizer *)sender
{
    [self removeFromSuperview];
    if (self.blockSelect) {
        self.blockSelect();
    }
}


#pragma mark - Getter
-(UIButton *)closeButton
{
    if (!_closeButton) {
        _closeButton = [[UIButton alloc] init];
        [_closeButton setBackgroundImage:IMAGE_NAMED(@"popup_close") forState:UIControlStateNormal];
        [_closeButton setBackgroundImage:IMAGE_NAMED(@"popup_close") forState:UIControlStateSelected];
        [_closeButton addTarget:self action:@selector(closeBtnEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

#pragma mark - Event
- (void)closeBtnEvent
{
    [UIView animateWithDuration:0.5 animations:^{
        self.closeButton.hidden = YES;
        _bgImageView.center = CGPointMake(self.centerX, self.centerY-screen_height);
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


@end
