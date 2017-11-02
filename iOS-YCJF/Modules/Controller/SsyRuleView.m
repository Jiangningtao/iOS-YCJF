//
//  SsyRuleView.m
//  iOS-YCJF
//
//  Created by 姜宁桃 on 2017/10/27.
//  Copyright © 2017年 Yincheng. All rights reserved.
//

#import "SsyRuleView.h"
@interface SsyRuleView()
{
    UIView * _bgView;
    UIView * _subBgView;
    UIWebView * _webView;
    UIButton * _closeBtn;
    UILabel * _titleLab;
}

@end

@implementation SsyRuleView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _bgView = [[UIView alloc] initWithFrame:self.bounds];
        _bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        [_bgView tapGesture:^(UIGestureRecognizer *ges) {
            [self removeViewsAnimation];
        }];
        _bgView.alpha = 0;
        [self addSubview:_bgView];
        [self cleanCacheAndCookie];
        [self configUI];
    }
    return self;
}

- (void)configUI
{
    _subBgView = [UIView new];
    _subBgView.backgroundColor = KWhiteColor;
    _subBgView.radius = 2;
    [self addSubview:_subBgView];
    [_subBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(118);
        make.left.offset(10);
        make.right.bottom.offset(-10);
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
    _titleLab.text = @"活动规则";
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
    
    _webView = [[UIWebView alloc] init];
    _webView.scrollView.bounces = NO;
    _webView.scrollView.showsHorizontalScrollIndicator = NO;
    _webView.scrollView.showsVerticalScrollIndicator = NO;
    [_subBgView addSubview:_webView];
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_lineV.mas_bottom).offset(0);
        make.left.right.bottom.offset(0);
    }];
    
    [UIView animateWithDuration:0.2 animations:^{
        _bgView.alpha = 1;
    }];
    
}

-(void)setUrl:(NSString *)url
{
    _url = url;
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

- (void)removeViewsAnimation
{
    //CGPoint originalPoint = _giftImgV.center;
    [UIView animateWithDuration:0.2 animations:^{
        //_giftImgV.center = CGPointMake(originalPoint.x, originalPoint.y+_giftImgV.height);
        _bgView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)animationSpread:(UIView*)view {
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0, 0, 1)];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)];
    scaleAnimation.duration = 1.5;
    scaleAnimation.cumulative = NO;
    scaleAnimation.repeatCount = 1;
    [scaleAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    view.layer.transform = CATransform3DMakeScale(1, 1, 1);//当动画完成后，保持现状
    [view.layer addAnimation: scaleAnimation forKey:@"myScale"];
}

- (void)animationBack:(UIView*)view {
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0, 0, 1)];
    scaleAnimation.duration = 1.5;
    scaleAnimation.cumulative = NO;
    scaleAnimation.repeatCount = 1;
    [scaleAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    view.layer.transform = CATransform3DMakeScale(0, 0, 1);
    [view.layer addAnimation: scaleAnimation forKey:@"myScale"];
}

/**清除缓存和cookie*/
- (void)cleanCacheAndCookie{
    //清除cookies
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]){
        [storage deleteCookie:cookie];
    }
    //清除UIWebView的缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];
}

@end
