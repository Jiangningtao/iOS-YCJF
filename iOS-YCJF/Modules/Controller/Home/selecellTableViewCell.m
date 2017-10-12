//
//  selecellTableViewCell.m
//  iOS-CHJF
//
//  Created by garday on 2017/3/9.
//  Copyright © 2017年 garday. All rights reserved.
//

#import "selecellTableViewCell.h"
#import "biaoModel.h"
@interface selecellTableViewCell ()


@end
@implementation selecellTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(biaoModel *)model{
    _model = model;
    _pingtailab.text =[NSString stringWithFormat:@"%@",model.name] ;
    _titlelab.text = @"";
    float floatstr = [model.borrow_account_scale floatValue]/100.0;
    _progress.progress = floatstr;
    NSString *s = [NSString string];
    s = @"%";
    _progresslab.text = [NSString stringWithFormat:@"%@%@",model.borrow_account_scale,s];
    if ([model.tender_account_min isEqualToString:@"0"]) {
        _QSJZlab.text = @"起投金额: 不限制";
    }else{
        _QSJZlab.text =[NSString stringWithFormat:@"起投金额: %@",model.tender_account_min] ;
    }
     [self labStr:_QSJZlab.text :_QSJZlab];
    
    NSLog(@"%@, B%@", model.apr_A, model.apr_B);
    /*
    if ([model.borrow_apr floatValue] <= 15) {
        _baifbLab.text = [NSString stringWithFormat:@"%@",model.borrow_apr];
        _extrAprLab.text = bfh;
    }else
    {
        _baifbLab.text = @"15.00";
        _extrAprLab.text = [NSString stringWithFormat:@"%@+%.2f%@", bfh, [model.borrow_apr floatValue] - 15.0f, bfh];
    }
     */
    
    if ([model.apr_B floatValue] == 0) {
        _baifbLab.text = [NSString stringWithFormat:@"%@",model.borrow_apr];
        _extrAprLab.text = bfh;
    }else
    {
        _baifbLab.text = [NSString stringWithFormat:@"%ld%@+%ld",[model.apr_A integerValue], bfh, [model.apr_B integerValue]];
        [self lab1Str:_baifbLab.text :_baifbLab];
    }
    
    
    if ([model.days isEqualToString:@"0"]) {
        _TZQXlab.text = [NSString stringWithFormat:@"投资期限: %@个月",model.borrow_period];
    }else{
        _TZQXlab.text =[NSString stringWithFormat:@"投资期限: %@天",model.days];
    }
    [self labStr:_TZQXlab.text :_TZQXlab];
    

    
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


-(NSMutableAttributedString *)labStr :(NSString *)str :(UILabel *)lab{
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:str];
    [AttributedStr addAttribute:NSForegroundColorAttributeName
                          value:[UIColor lightGrayColor]
                          range:NSMakeRange(0, 5)];
    lab.attributedText = AttributedStr;
    

    
    return AttributedStr;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
