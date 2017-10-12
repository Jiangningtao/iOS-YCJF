//
//  TopTableViewCell.m
//  iOS-YCJF
//
//  Created by 姜宁桃 on 2017/8/14.
//  Copyright © 2017年 Yincheng. All rights reserved.
//

#import "TopTableViewCell.h"
#import "xqModel.h"

@implementation TopTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(xqModel *)model{
    _model = model;
    _Detail_ProTitleLab.text =[NSString stringWithFormat:@"%@",model.name] ;
    if ([model.apr_B floatValue] == 0) {
        _Detail_ProRateLab.text = model.borrow_apr;
        _Detail_ProRateLab.text = [NSString stringWithFormat:@"%@",model.borrow_apr];
    }else
    {
        _Detail_ProRateLab.text = [NSString stringWithFormat:@"%ld%@+%ld",[model.apr_A integerValue], bfh, [model.apr_B integerValue]];
        [self lab1Str:_Detail_ProRateLab.text :_Detail_ProRateLab];
    }
    _Detail_TotalCountLab.text = [NSString stringWithFormat:@"项目总额  %@元",model.account];
    NSString *s = [NSString string];
    s = @"%";
    _Detail_SaledRateLab.text = [NSString stringWithFormat:@"%@%@",model.borrow_account_scale,s];
    float floatstr = [model.borrow_account_scale floatValue]/100.0;
    _Detail_ProgressView.progress =floatstr;
    _Detail_DeadLineLab.text = model.v_borrow_period;
    _Detail_MinMoneyLab.text = model.tender_account_min;
    
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


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
