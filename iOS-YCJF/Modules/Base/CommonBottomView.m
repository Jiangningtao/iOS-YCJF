//
//  CommonBottomView.m
//  iOS-YCJF
//
//  Created by 姜宁桃 on 2017/8/10.
//  Copyright © 2017年 Yincheng. All rights reserved.
//

#import "CommonBottomView.h"

@implementation CommonBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        label = [[UILabel alloc] initWithFrame:frame];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor colorWithRed:195/255.0 green:195/255.0 blue:195/255.0 alpha:1/1.0];
        label.font = [UIFont systemFontOfSize:12];
        label.attributedText =  [self AddImageToLabWithImg:[UIImage imageNamed:@"Group 6"] withBaseTitle:@" 投资有风险 理财需谨慎"];
        [self addSubview:label];
    }
    return self;
}

-(NSMutableAttributedString *)AddImageToLabWithImg:(UIImage *)img withBaseTitle:(NSString *)title{
    
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc]init];
    // 添加表情
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    // 表情图片
    attch.image = img;
    // 设置图片大小
    attch.bounds = CGRectMake(0, -2, 12 , 12);
    // 创建带有图片的富文本
    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
    [attri appendAttributedString:string];
    [attri appendAttributedString:[[NSAttributedString alloc] initWithString:title]];
    // 用label的attributedText属性来使用富文本
    return attri;
}

@end
