//
//  xiaoxiTableViewCell.m
//  iOS-CHJF
//
//  Created by garday on 2017/3/27.
//  Copyright © 2017年 garday. All rights reserved.
//

#import "xiaoxiTableViewCell.h"

@implementation xiaoxiTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    self.xinxiLab.font =  [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    self.timelab.font =  [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
