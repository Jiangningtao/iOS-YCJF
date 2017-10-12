//
//  paymentView.m
//  iOS-YCJF
//
//  Created by 姜宁桃 on 2017/8/21.
//  Copyright © 2017年 Yincheng. All rights reserved.
//

#import "paymentView.h"
#import "PasswordView.h"

@interface paymentView ()
@property (nonatomic, strong) PasswordView *passwordView;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UIButton * closeBtn;

@end

@implementation paymentView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = grcolor;
        UIImageView *imgxx = [[UIImageView alloc]init];
        imgxx.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:imgxx];
        [imgxx mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.offset(0);
            make.height.offset(0.5);
        }];

        [self addSubview:self.closeBtn];
        [self addSubview:self.passwordView];
        [self addSubview:self.tipLabel];
        
        [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self).offset(8);
            make.width.height.offset(30);
        }];
        
        [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self).offset(10);
            make.centerY.equalTo(self.closeBtn).offset(0);
            make.centerX.equalTo(self);
        }];
        
        
        [self.passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(264, 44));
            make.top.equalTo(self.tipLabel.mas_bottom).offset(40);
            make.centerX.equalTo(self);
        }];
        
        UIImageView *imgx = [[UIImageView alloc]init];
        imgx.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self addSubview:imgx];
        [imgx mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.offset(0);
            make.top.equalTo(self.closeBtn.mas_bottom).offset(8);
            make.height.offset(0.5);
        }];
        
        UIButton *bn = [[UIButton alloc] init];
        [bn setTitle:@"忘记密码？" forState:UIControlStateNormal];
        bn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        [bn setTitleColor: [UIColor colorWithRed:57/255.0 green:149/255.0 blue:223/255.0 alpha:1/1.0] forState:UIControlStateNormal];
        [bn addTarget:self action:@selector(foundBackEvent) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:bn];
        [bn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.passwordView.mas_right);
            make.top.equalTo(self.passwordView.mas_bottom).offset(10);
        }];
    }
    return self;
}

- (void)clear
{
    [self.passwordView cleanLastState];
}

/*
 找回密码
 */
- (void)foundBackEvent
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self endEditing:YES];
        if (_foundBlock) {
            [self removeFromSuperview];
            _foundBlock();
        }
    });
}


#pragma mark - FirstResponder
- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)becomeFirstResponder
{
    return  [self.passwordView becomeFirstResponder];
}

- (void)setTip:(NSString *)tip
{
    _tip = tip;
    self.tipLabel.text = tip;
}

- (void)setTextChangeBlock:(void (^)(NSString *))textChangeBlock
{
    _textChangeBlock = textChangeBlock;
    self.passwordView.textChangedBlock = textChangeBlock;
    
}

- (void)closeBtnEvnet
{
    [self endEditing:YES];
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.frame = CGRectMake(0, screen_height, screen_width, 420);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - getter
- (PasswordView *)passwordView
{
    if (!_passwordView) {
        _passwordView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([PasswordView class]) owner:nil options:nil].lastObject;
    }
    return _passwordView;
}

- (UILabel *)tipLabel
{
    if (!_tipLabel) {
        _tipLabel = [UILabel new];
        _tipLabel.text = @"";
    }
    return _tipLabel;
}

-(UIButton *)closeBtn
{
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc] init];
        [_closeBtn setBackgroundImage:IMAGE_NAMED(@"close_image") forState:UIControlStateNormal];
        [_closeBtn setBackgroundImage:IMAGE_NAMED(@"close_image") forState:UIControlStateSelected];
        [_closeBtn addTarget:self action:@selector(closeBtnEvnet) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}


@end
