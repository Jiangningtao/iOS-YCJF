//
//  inTableViewCell.m
//  iOS-CHJF
//
//  Created by garday on 2017/3/15.
//  Copyright © 2017年 garday. All rights reserved.
//

#import "inTableViewCell.h"
#import "shouruModel.h"
@interface inTableViewCell()

@end
@implementation inTableViewCell
-(void)setModel:(shouruModel *)model{
    _model = model;
    NSString *str =[model.time_h substringToIndex:9];
    _titlab.text =str;
    _zhonglab.text = model.value;
    _dalab.text =model.name;
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
