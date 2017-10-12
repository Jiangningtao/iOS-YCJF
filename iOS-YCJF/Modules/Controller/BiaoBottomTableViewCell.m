//
//  BiaoBottomTableViewCell.m
//  iOS-YCJF
//
//  Created by 姜宁桃 on 2017/8/15.
//  Copyright © 2017年 Yincheng. All rights reserved.
//

#import "BiaoBottomTableViewCell.h"
#import "xqModel.h"

#define SELECTEDCOLOR color(57, 149, 223, 1)
#define DESELECTEDCOLOR color(216, 216, 216, 1)

@implementation BiaoBottomTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(xqModel *)model{
    _model = model;
    NSInteger borrow_Scale = [model.status intValue];
    if (borrow_Scale == 6) {
        // 满标
        _Space_One.backgroundColor = SELECTEDCOLOR;
        _Ovel_Two.backgroundColor = SELECTEDCOLOR;
        _Space_Two.backgroundColor = SELECTEDCOLOR;
        _Ovel_Three.backgroundColor = SELECTEDCOLOR;
        _Space_Three.backgroundColor = SELECTEDCOLOR;
        _Ovel_Four.backgroundColor = SELECTEDCOLOR;
        _State_Two.textColor = SELECTEDCOLOR;
        _State_Three.textColor = SELECTEDCOLOR;
        _State_Four.textColor = SELECTEDCOLOR;
    }else if (borrow_Scale == 3){
        //  还款
        _Space_One.backgroundColor = SELECTEDCOLOR;
        _Ovel_Two.backgroundColor = SELECTEDCOLOR;
        _Space_Two.backgroundColor = SELECTEDCOLOR;
        _Ovel_Three.backgroundColor = SELECTEDCOLOR;
        _State_Two.textColor = SELECTEDCOLOR;
        _State_Three.textColor = SELECTEDCOLOR;
    }else if (borrow_Scale == 8){
        // 满标
        _Space_One.backgroundColor = SELECTEDCOLOR;
        _Ovel_Two.backgroundColor = SELECTEDCOLOR;
        _State_Two.textColor = SELECTEDCOLOR;
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
