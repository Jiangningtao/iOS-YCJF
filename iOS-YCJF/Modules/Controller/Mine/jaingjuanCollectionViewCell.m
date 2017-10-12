//
//  jaingjuanCollectionViewCell.m
//  iOS-CHJF
//
//  Created by garday on 2017/3/22.
//  Copyright © 2017年 garday. All rights reserved.
//

#import "jaingjuanCollectionViewCell.h"
#import "myjjModel.h"
@implementation jaingjuanCollectionViewCell
-(void)setModel:(myjjModel *)model{
    _model = model;
    _yxtimelab.text = [NSString stringWithFormat:@"有效期至\n%@",model.time_end];
    if (model.money_ty_ch ==nil) {
        _jiaxiLab.text = model.type_name;
    }else{
        _jiaxiLab.text = model.money_ty_ch;
    }
    _touzitimeLab.text = [NSString stringWithFormat:@"投资时间：%@",model.term];
    if (model.use_v.length >=1) {
       _touzijineLab.text =[NSString stringWithFormat:@"实际投资：≧%@",model.use_v];
    }else if(model.use_v.length<1){
        int  s =[model.money intValue];
        int  b = [model.use_v intValue];
        _touzijineLab.text =[NSString stringWithFormat:@"实际投资：≧%f",ceil(s/b)];
    }
    
    if ([model.money_ty isEqualToString:@"5"]) {
       NSString *s = @"%";
        if ([model.money integerValue] == [model.money floatValue]) {
            NSLog(@"%@", model.money);
            _bflab.text = [NSString stringWithFormat:@"%d%@",[model.money intValue],s];
        }else
        {
            _bflab.text = [NSString stringWithFormat:@"%@%@",model.money,s];
        }
        _imgView.image = [UIImage imageNamed:@"jiaxi"];
    }else{
       _bflab.text = [NSString stringWithFormat:@"%ld元",[model.money integerValue]];
        _imgView.image = [UIImage imageNamed:@"dikou"];
    }
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:_bflab.text];
    
    [AttributedStr addAttribute:NSFontAttributeName
                          value:[UIFont systemFontOfSize:12.0]
                          range:NSMakeRange(_bflab.text.length-1, 1)];
    
    _bflab.attributedText = AttributedStr;
    
    NSMutableAttributedString *AttributedStr1 = [[NSMutableAttributedString alloc]initWithString:_yxtimelab.text];
//    [AttributedStr addAttribute:NSForegroundColorAttributeName
//                          value: [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1/1.0]
//                          range:NSMakeRange(0, 1)];
    _yxtimelab.attributedText = AttributedStr1;

    if ([model.ispay isEqualToString:@"2"]) {
        _imgView.image = [UIImage imageNamed:@"huise"];
      _biaojiimgV.image = [UIImage imageNamed:@"pic_yiguoqi"];
    }else if ([model.ispay isEqualToString:@"0"]){
        if ([model.is_due isEqualToString:@"1"]) {
            _biaojiimgV.image = [UIImage imageNamed:@"jjgq_table"];
            _biaojiimgV.hidden = NO;
        }else
        {
            _biaojiimgV.hidden = YES;
        }
    }else{
        _imgView.image = [UIImage imageNamed:@"huise"];
        _biaojiimgV.image = [UIImage imageNamed:@"pic_yishiyong"];
    }
    
       
}
-(void)setModelq:(myjjModel *)modelq{
    _modelq = modelq;
    
}

- (void)setTitlestr:(NSString *)titlestr
{
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
   
    
    

    
    // Initialization code
}

@end
