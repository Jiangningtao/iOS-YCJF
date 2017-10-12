//
//  SRTableViewCell.m
//  iOS-CHJF
//
//  Created by garday on 2017/3/21.
//  Copyright © 2017年 garday. All rights reserved.
//

#import "SRTableViewCell.h"
#import "zdmodel.h"
@implementation SRTableViewCell
-(void)setModel:(zdmodel *)model{
    _model = model;
    _titleLab.text = model.money;
    _chongzhiLab.text = model.flowname;
    _timeLab.text =model.qdate;
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
