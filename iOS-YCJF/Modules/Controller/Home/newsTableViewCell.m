//
//  newsTableViewCell.m
//  iOS-CHJF
//
//  Created by garday on 2017/3/13.
//  Copyright © 2017年 garday. All rights reserved.
//

#import "newsTableViewCell.h"
#import "newsModel.h"
@interface newsTableViewCell ()

@end
@implementation newsTableViewCell
-(void)setModel:(newsModel *)model{
    _model = model;
    [self.xwImg sd_setImageWithURL:[NSURL URLWithString:model.preview_pic] placeholderImage:[UIImage imageNamed:@"pic"]];
    self.xwImg.contentMode = UIViewContentModeScaleAspectFit;
    _xwtitle.text = model.title;
    _xwlab.text = model.summary;
    
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
