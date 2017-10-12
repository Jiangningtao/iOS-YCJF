//
//  zhangdanTableViewCell.m
//  iOS-CHJF
//
//  Created by garday on 2017/3/21.
//  Copyright © 2017年 garday. All rights reserved.
//

#import "zhangdanTableViewCell.h"
#import "DSZDMolde.h"
@implementation zhangdanTableViewCell
-(void)setModel:(DSZDMolde *)model{
    _model = model;
    _titleLab.text = model.name;
   
    if ([model.recover_period isEqualToString:@"-1"]){
//        _yueLab.text =[NSString stringWithFormat:@"末期/%@ %@",model.borrow_period,model.borrow_style_show];
        if (model.borrow_style_show ==nil) {
//            _yueLab.text =[NSString stringWithFormat:@"末期/%@",model.borrow_period];
        }
        if ([self.upVC isEqualToString:@"已收"]) {
            _benxilab.text = @"本期已收本金";
        }else
        {
            _benxilab.text = @"本期待收本金";
        }
        
    }else if (model.recover_period>0) {
        if (model.borrow_style_show ==nil) {
//            _yueLab.text =[NSString stringWithFormat:@"%@/%@ %@",model.recover_period,model.borrow_period,model.borrow_style_show];
//            _yueLab.text =[NSString stringWithFormat:@"%@/%@",model.recover_period,model.borrow_period];
        }
        if ([self.upVC isEqualToString:@"已收"]) {
            _benxilab.text = @"本期已收利息";
        }else
        {
            _benxilab.text = @"本期待收利息";
        }
    }
    _morLab.text = [model.recover_account stringByAppendingString:@"元"];
   
}
- (void)awakeFromNib {
    [super awakeFromNib];
//    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:_yueLab.text];
    
   
//    [AttributedStr addAttribute:NSForegroundColorAttributeName
//                          value: [UIColor colorWithRed:57/255.0 green:149/255.0 blue:223/255.0 alpha:1/1.0]
//                          range:NSMakeRange(0, 3)];
//    _yueLab.attributedText = AttributedStr;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
