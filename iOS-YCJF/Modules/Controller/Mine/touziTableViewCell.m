//
//  touziTableViewCell.m
//  iOS-CHJF
//
//  Created by garday on 2017/3/21.
//  Copyright © 2017年 garday. All rights reserved.
//

#import "touziTableViewCell.h"
#import "touziModel.h"
#import "jiangliModel.h"
@implementation touziTableViewCell
-(void)setJianglimodel:(jiangliModel *)jianglimodel{
    _jianglimodel = jianglimodel;
    self.ztlab.text = @"";
    self.btLab.text =[NSString stringWithFormat:@"%@ %@",jianglimodel.money_str,jianglimodel.type_name] ;
    self.jinelab.text =jianglimodel.actname;
    self.jinelab.textColor = [UIColor lightGrayColor];
    self.jinelab.font =[UIFont fontWithName:@"PingFangSC-Regular" size:12];
         self.time.text = jianglimodel.time_h;
    self.time.textColor = [UIColor blackColor];
    self.repayTimeLab.hidden = YES;
}
-(void)setModel:(touziModel *)model{
    _model = model;
    self.btLab.text = model.name;
    self.jinelab.text =[NSString stringWithFormat:@"投资金额：%@元",model.money ];
    self.time.text = model.time_h;
    if ([model.status isEqualToString:@"0"]) {
        self.ztlab.text =@"待初审";
        self.ztlab.textColor = [UIColor lightGrayColor];
    }else if ([model.status isEqualToString:@"1"]){
      self.ztlab.text =@"募集中";
        self.ztlab.textColor = lancolor;
        self.repayTimeLab.text = @"正在火热募集中";
    }else if ([model.status isEqualToString:@"2"]){
       self.ztlab.text =@"初审失败";
        self.ztlab.textColor = [UIColor lightGrayColor];
    }else if ([model.status isEqualToString:@"3"]){
        self.ztlab.text =@"回款中";
        self.ztlab.textColor = [UIColor orangeColor];
        self.repayTimeLab.text = [@"回款时间：预计" stringByAppendingString:model.repay_each_time];
    }else if ([model.status isEqualToString:@"4"]){
      self.ztlab.text =@"复审失败";
        self.ztlab.textColor = [UIColor lightGrayColor];
    }else if ([model.status isEqualToString:@"5"]){
     self.ztlab.text =@"用户自行撤销";
        self.ztlab.textColor = [UIColor lightGrayColor];
    }else if ([model.status isEqualToString:@"6"]){
     self.ztlab.text =@"回款成功";
        self.ztlab.textColor = [UIColor lightGrayColor];
        self.repayTimeLab.text = [@"回款时间：" stringByAppendingString:model.repay_each_time];
    }else if ([model.status isEqualToString:@"7"]){
     self.ztlab.text =@"自动投标中";
        self.ztlab.textColor = [UIColor lightGrayColor];
    }else if ([model.status isEqualToString:@"8"]){
     self.ztlab.text =@"复审中";
        self.ztlab.textColor = [UIColor lightGrayColor];
    }
    
}


- (void)awakeFromNib {
    [super awakeFromNib];
//        if ((self.ztlab.text =@"回款中")) {
//            self.ztlab.textColor = [UIColor redColor];
//        }
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
