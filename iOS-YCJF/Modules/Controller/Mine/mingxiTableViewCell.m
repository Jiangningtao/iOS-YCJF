//
//  mingxiTableViewCell.m
//  iOS-CHJF
//
//  Created by garday on 2017/4/11.
//  Copyright © 2017年 garday. All rights reserved.
//

#import "mingxiTableViewCell.h"
#import "mingxiModel.h"
@implementation mingxiTableViewCell
//充值类型：4 现金充值  7在线充值 10 对账充值 11-银行代扣充值
-(void)setModel:(mingxiModel *)model{
    _model =model;
    _titleLab.text = model.money;
    if ([model.aptype isEqualToString:@"4"]) {
        if ([model.cs2 isEqualToString:@""]) {
             _chongzhi.text = @"线下充值";
        }else{
           
            _chongzhi.text = model.cs2;
        }
        
    }else if ([model.aptype isEqualToString:@"7"]){
    _chongzhi.text = @"在线充值";
    }else{
      _chongzhi.text = @"";
    }
    NSString *sr = [model.time_h substringToIndex:10];
    _timeLab.text =sr;
    
  
   
    if (model.status ==0 && [model.aptype isEqualToString:@"7"]){
        _shenheLab.textColor = lancolor;
        _shenheLab.text =@"处理中查单";
//        [self labStr:_shenheLab.text :_shenheLab];
    }else{
        _shenheLab.text =model.statsname;
        
    if ([model.statsname isEqualToString:@"超时失效"]) {
        
        _shenheLab.textColor = [UIColor blackColor];
    }else if ([model.statsname isEqualToString:@"等待审核"]){
       _shenheLab.textColor = lancolor;
    }else if ([model.statsname isEqualToString:@"充值成功"]){
     _shenheLab.textColor = [UIColor greenColor];
    }
    }
    NSLog(@"%@%@",model.status,model.aptype);
    
    
    
}

-(NSMutableAttributedString *)labStr :(NSString *)str :(UILabel *)lab{
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:str];
    [AttributedStr addAttribute:NSForegroundColorAttributeName
                          value:[UIColor lightGrayColor]
                          range:NSMakeRange(2, 2)];
    lab.attributedText = AttributedStr;
    
    
    
    return AttributedStr;
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
