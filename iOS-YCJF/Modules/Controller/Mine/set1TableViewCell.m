//
//  set1TableViewCell.m
//  iOS-CHJF
//
//  Created by garday on 2017/3/14.
//  Copyright © 2017年 garday. All rights reserved.
//

#import "set1TableViewCell.h"
@interface set1TableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgtx;

@end
@implementation set1TableViewCell

- (void)awakeFromNib {
    self.imgtx.layer.masksToBounds = YES;
    self.imgtx.layer.cornerRadius = self.imgtx.frame.size.width/2;
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
