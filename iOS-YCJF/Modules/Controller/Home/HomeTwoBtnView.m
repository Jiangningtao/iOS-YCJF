//
//  HomeTwoBtnView.m
//  iOS-YCJF
//
//  Created by 姜宁桃 on 2017/9/13.
//  Copyright © 2017年 Yincheng. All rights reserved.
//

#import "HomeTwoBtnView.h"

@interface HomeTwoBtnView ()

@property (nonatomic, strong) NSArray * imgArray;
@property (nonatomic, strong) NSArray * titleArray;
@property (nonatomic, strong) NSArray * subTitleArray;

@end

@implementation HomeTwoBtnView

- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)titleArray subTitleArray:(NSArray *)subTitleArray
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.imgArray = @[@"icon_aqbz", @"icon_sjpl"];
        self.titleArray = titleArray;//@[@"安全保障", @"数据披露"];
        self.subTitleArray = subTitleArray;//@[@"银行存管即将上线", @"运营数据完全透明"];
         
        [self configUI];
    }
    return self;
}

- (void)configUI
{
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(self.width/2-0.25, 15, 0.5, self.height-30)];
    line.backgroundColor = UIColorHex(#f0f0f0);
    [self addSubview:line];
    for (int i = 0; i < 2; i++) {
        UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(0+i*(1+(self.width-2)/2), 0, (self.width-1)/2, self.height)];
        btn.tag = 50+i;
        UIImageView * imgV = [[UIImageView alloc] initWithImage:IMAGE_NAMED(self.imgArray[i])];
        [btn addSubview:imgV];
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.offset(57);
            make.left.equalTo(btn.mas_left).offset(10);
            make.centerY.offset(0);
        }];
        
        UILabel * titleLab = [[UILabel alloc] init];
        titleLab.text = self.titleArray[i];
        titleLab.font = [UIFont boldSystemFontOfSize:16*widthScale];
        titleLab.textColor = UIColorHex(#494949);
        [btn addSubview:titleLab];
        [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imgV.mas_right).offset(3);
            make.bottom.equalTo(imgV.mas_centerY).offset(0);
        }];
        
        UILabel * subTitleLab = [[UILabel alloc] init];
        subTitleLab.text = self.subTitleArray[i];
        subTitleLab.font = [UIFont systemFontOfSize:12*widthScale];
        subTitleLab.textColor = UIColorHex(#999999);
        [btn addSubview:subTitleLab];
        [subTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imgV.mas_right).offset(3);
            make.top.equalTo(imgV.mas_centerY).offset(3);
        }];
    }
}

- (void)btnClicked:(UIButton *)btn
{
    if (btn.tag == 50) {
        // 安全保障
        if (self.blockOfSafeBtn) {
            self.blockOfSafeBtn();
        }
    }else if (btn.tag == 51){
        // 数据披露
        if (self.blockOfDataBtn) {
            self.blockOfDataBtn();
        }
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
