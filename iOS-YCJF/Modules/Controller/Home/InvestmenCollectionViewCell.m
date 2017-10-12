//
//  InvestmenCollectionViewCell.m
//  iOS-CHJF
//
//  Created by garday on 2017/3/10.
//  Copyright © 2017年 garday. All rights reserved.
//

#import "InvestmenCollectionViewCell.h"
//#import "newsModel.h"
@interface InvestmenCollectionViewCell ()

@end
@implementation InvestmenCollectionViewCell


- (void)awakeFromNib {
    [super awakeFromNib];
    self.imgV.layer.masksToBounds = YES;
    self.imgV.layer.cornerRadius = self.imgV.frame.size.height/2;
    
    //奖杯
//    UIImageView *imageVjb = [[UIImageView alloc]init];
//    imageVjb.image = [UIImage imageNamed:@"pic_gold"];
//    [self addSubview:imageVjb];
//    [imageVjb mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.hmlab.mas_top).offset(-9);
//        make.right.equalTo(self.hmlab.mas_right);
//        make.width.offset(26);
//        make.height.offset(30);
//    }];
    // Initialization code
}

@end
