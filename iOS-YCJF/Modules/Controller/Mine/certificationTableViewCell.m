//
//  certificationTableViewCell.m
//  iOS-CHJF
//
//  Created by garday on 2017/3/20.
//  Copyright © 2017年 garday. All rights reserved.
//

#import "certificationTableViewCell.h"
@interface certificationTableViewCell()

@end
@implementation certificationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self endEditing:YES];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
