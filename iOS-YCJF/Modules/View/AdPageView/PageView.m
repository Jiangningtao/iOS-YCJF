//
//  PageView.m
//  iOS-YCJF
//
//  Created by 姜宁桃 on 2017/8/24.
//  Copyright © 2017年 Yincheng. All rights reserved.
//

#import "PageView.h"

@interface PageView ()

@property (nonatomic, strong) UIImageView * bgImageView;
@property (nonatomic ,strong) UIImageView *advertisingPageImageView;

@end

@implementation PageView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        
        _bgImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _bgImageView.image = [UIImage imageNamed:@"adBg"];
        _bgImageView.contentMode = UIViewContentModeScaleToFill;
        
        [self addSubview:_bgImageView];
        
        _advertisingPageImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 550*KScreenHeight/668)];
        _advertisingPageImageView.userInteractionEnabled = YES;
        [self addSubview:_advertisingPageImageView];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        [_advertisingPageImageView addGestureRecognizer:singleTap];
    }
    return self;
}


- (void)setPageURLString:(NSString *)pageURLString {
    _pageURLString = pageURLString;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_advertisingPageImageView sd_setImageWithURL:[NSURL URLWithString:_pageURLString] placeholderImage:nil];
}

#pragma mark --- 响应点击广告页的方法
- (void)handleSingleTap:(UITapGestureRecognizer *)sender
{
    if (self.blockSelect) {
        self.blockSelect();
    }
}

@end
