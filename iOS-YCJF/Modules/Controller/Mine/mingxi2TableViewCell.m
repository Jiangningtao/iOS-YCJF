//
//  mingxi2TableViewCell.m
//  iOS-CHJF
//
//  Created by garday on 2017/4/11.
//  Copyright © 2017年 garday. All rights reserved.
//

#import "mingxi2TableViewCell.h"
#import "mingxi2Model.h"
@implementation mingxi2TableViewCell
-(void)setModel:(mingxi2Model *)Model{
    _Model = Model;
    
    _titlelab.text =[NSString stringWithFormat:@"%@[到账：%@ ,手续：%@]",Model.money,Model.credited,Model.fee];
    _weishenheLab.text = Model.statsname;
    _shenheLab.text = Model.cs2;
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
