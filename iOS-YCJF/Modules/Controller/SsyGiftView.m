//
//  SsyGiftView.m
//  iOS-YCJF
//
//  Created by 姜宁桃 on 2017/10/26.
//  Copyright © 2017年 Yincheng. All rights reserved.
//

#import "SsyGiftView.h"

@interface SsyGiftView ()
{
    UIView * _bgView;
    UIImageView * _giftImgV;
}

@end

@implementation SsyGiftView

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
        [self configUI];
    }
    return self;
}

- (void)configUI
{
    _giftImgV = [[UIImageView alloc] initWithImage:IMAGE_NAMED(@"pop_gift")];
    _giftImgV.contentMode = UIViewContentModeScaleAspectFit; // 750*642
    [_giftImgV tapGesture:^(UIGestureRecognizer *ges) {
        NSLog(@"店家t");
    }];
    [self addSubview:_giftImgV];
    [_giftImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(0);
        make.left.right.offset(0);
        make.height.offset(kRealValue(321));
    }];
    
    CGPoint originalPoint = _giftImgV.center;
    _giftImgV.center = CGPointMake(originalPoint.x, originalPoint.y+_giftImgV.height);
    [UIView animateWithDuration:0.5 animations:^{
        _giftImgV.center = originalPoint;
        _bgView.alpha = 1;
    }];
}

- (void)removeViewsAnimation
{
    CGPoint originalPoint = _giftImgV.center;
    [UIView animateWithDuration:0.5 animations:^{
        _giftImgV.center = CGPointMake(originalPoint.x, originalPoint.y+_giftImgV.height);
        _bgView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
