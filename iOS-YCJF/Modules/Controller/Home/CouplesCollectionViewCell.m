//
//  CouplesCollectionViewCell.m
//  iOS-CHJF
//
//  Created by 姜宁桃 on 2017/7/24.
//  Copyright © 2017年 garday. All rights reserved.
//

#import "CouplesCollectionViewCell.h"
#import "TopicModel.h"
@implementation CouplesCollectionViewCell

-(void)setPic:(TopicModel *)pic{
    _pic = pic;
    _titleLab.text = pic.name;
    if ([pic.tender_account_min isEqualToString:@"0"]) {
        _limitMoneyLab.text = @"不限制起投";
    }else{
        _limitMoneyLab.text = [NSString stringWithFormat:@"%@元起投", pic.tender_account_min];
    }
    
    if ([pic.apr_B floatValue] == 0) {
        _preLab.text = [NSString stringWithFormat:@"%@",pic.borrow_apr];
        NSLog(@"%@",_preLab.text);
    }else
    {
        _preLab.text = [NSString stringWithFormat:@"%ld%@+%ld",[pic.apr_A integerValue], bfh, [pic.apr_B integerValue]];
        [self lab1Str:_preLab.text :_preLab];
    }
    if ([pic.days isEqualToString:@"0"]) {
        _limitDaysLab.text = [NSString stringWithFormat:@"%@月期限",pic.borrow_period];
    }else{
        _limitDaysLab.text =[NSString stringWithFormat:@"%@天期限",pic.days];
    }
    NSMutableAttributedString *mothlabStr = [[NSMutableAttributedString alloc]initWithString:_limitDaysLab.text];
    [mothlabStr addAttribute:NSFontAttributeName
                       value:[UIFont systemFontOfSize:14.0]
                       range:NSMakeRange(self.limitDaysLab.text.length-1, 1)];
    _limitDaysLab.attributedText = mothlabStr;
    
}

-(NSMutableAttributedString *)lab1Str :(NSString *)str :(UILabel *)lab{
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:str];
    NSLog(@"%ld", str.length);
    [AttributedStr addAttribute:NSFontAttributeName
                          value:[UIFont systemFontOfSize:17.0]
                          range:NSMakeRange(2, 2)];
    lab.attributedText = AttributedStr;
    
    return AttributedStr;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
