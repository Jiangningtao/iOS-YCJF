//
//  rankingTableViewCell.m
//  iOS-CHJF
//
//  Created by garday on 2017/3/14.
//  Copyright © 2017年 garday. All rights reserved.
//

#import "rankingTableViewCell.h"
#import "AccinfoModel.h"
@interface rankingTableViewCell (){

}
/***<#注释#> ***/


@end
@implementation rankingTableViewCell

-(void)setModel:(AccinfoModel *)model{
    _model = model;
    [self.imgbTn setBackgroundImage:IMAGE_NAMED(@"icon_eye2") forState:UIControlStateNormal];
    [self.imgbTn setBackgroundImage:IMAGE_NAMED(@"icon_eye1") forState:UIControlStateSelected];
    
    if ([[UserDefaults objectForKey:KSecurytyshow] isEqualToString:@"0"]) {
        // 隐藏
        self.imgbTn.selected = YES;
        self.totalye.text = [self creatsecurtystrwithstr:self.model.tot_account];
        self.LJSYlab.text = [NSString stringWithFormat:@"累计收益(元)\n\n%@",[self creatsecurtystrwithstr:self.model.v_ttot_leijishouyi]];
        self.KYYElab.text = [NSString stringWithFormat:@"可用余额(元)\n\n%@",[self creatsecurtystrwithstr:self.model.ky_account]];
        [self labStr:self.LJSYlab.text :self.LJSYlab];
        [self labStr:self.KYYElab.text :self.KYYElab];
    }else
    {
        self.imgbTn.selected = NO;
        NSString *stq = [NSString stringWithFormat:@"累计收益(元)\n\n%@",model.v_ttot_leijishouyi?model.v_ttot_leijishouyi:@"--"];
        [self labStr:stq :self.LJSYlab];
        
        NSString *stw = [NSString stringWithFormat:@"可用余额(元)\n\n%@",model.ky_account?model.ky_account:@"--"];
        [self labStr:stw :self.KYYElab];
        
        if ([model.tot_account floatValue] != 0.00) {
            self.totalye.format = @"%.2f%";
            [self.totalye countFrom:0 to:[model.tot_account floatValue] withDuration:1.0];
        }
        self.totalye.text = model.tot_account?model.tot_account:@"--";
    }
}

//-(NSString *)oldvalue{
//    if (!_oldvalue) {
//        _oldvalue = [[NSString alloc]init];
//    }return _oldvalue;
//}
//
//-(void)setStaq:(NSString *)staq{
//    _staq = staq;
//     NSString *stq = [NSString stringWithFormat:@"累计收益(元)\n\n%@",staq];
//     [self labStr:stq :self.LJSYlab];
//
//}
//-(void)setStaw:(NSString *)staw{
//    _staw = staw;
//     NSString *stw = [NSString stringWithFormat:@"可用余额(元)\n\n%@",staw];
//    [self labStr:stw :self.KYYElab];
//
//}
- (IBAction)securytyshow:(id)sender {
    UIButton * btn = (UIButton *)sender;
    btn.selected = !btn.selected;
    if ([[UserDefaults objectForKey:KSecurytyshow] isEqualToString:@"1"]) {
        // 隐藏
        [UserDefaults setObject:@"0" forKey:KSecurytyshow];
        self.totalye.text = [self creatsecurtystrwithstr:self.model.tot_account];
        self.LJSYlab.text = [NSString stringWithFormat:@"累计收益(元)\n\n%@",[self creatsecurtystrwithstr:self.model.v_ttot_leijishouyi]];
        self.KYYElab.text = [NSString stringWithFormat:@"可用余额(元)\n\n%@",[self creatsecurtystrwithstr:self.model.ky_account]];
        [self labStr:self.LJSYlab.text :self.LJSYlab];
        [self labStr:self.KYYElab.text :self.KYYElab];

    }else
    {
        // 显示
        [UserDefaults setObject:@"1" forKey:KSecurytyshow];
        self.totalye.text = self.model.tot_account;
        NSString *stq = [NSString stringWithFormat:@"累计收益(元)\n\n%@",self.model.v_ttot_leijishouyi];
        [self labStr:stq :self.LJSYlab];
        
        NSString *stw = [NSString stringWithFormat:@"可用余额(元)\n\n%@",self.model.ky_account];
        [self labStr:stw :self.KYYElab];
    }
    [UserDefaults synchronize];
}

- (void)awakeFromNib {
    [super awakeFromNib];
   
//    [self.imgbTn addTarget:self action:@selector(securytyshow:) forControlEvents:UIControlEventTouchUpInside];
    
//    self.oldvalue = self.totalye.text;

    // Initialization code
}

//-(void)securytyshow:(UIButton *)btn{
//    [UserDefaults setObject:@"0" forKey:KSecurytyshow];
//    btn.selected = !btn.selected;
//    if (![self.totalye.text containsString:@"*"]) {
//        
//        self.totalye.text = [self creatsecurtystrwithstr:self.totalye.text];
//        self.LJSYlab.text = [NSString stringWithFormat:@"累计收益(元)\n\n%@",[self creatsecurtystrwithstr:self.staq]];
//        self.KYYElab.text = [NSString stringWithFormat:@"累计收益(元)\n\n%@",[self creatsecurtystrwithstr:self.staw]];
//
//        [self labStr:self.LJSYlab.text :self.LJSYlab];
//        [self labStr:self.KYYElab.text :self.KYYElab];
//
//    }else{
//        self.totalye.text = self.oldvalue;
//        self.LJSYlab.text = [NSString stringWithFormat:@"累计收益(元)\n\n%@",self.staq];
//        self.KYYElab.text = [NSString stringWithFormat:@"累计收益(元)\n\n%@",self.staw];
//        
//        [self labStr:self.LJSYlab.text :self.LJSYlab];
//         [self labStr:self.KYYElab.text :self.KYYElab];
//    }
//    //    [self.tab reloadData];
//}


-(NSMutableAttributedString *)labStr :(NSString *)str :(UILabel *)lab{
    NSMutableAttributedString *TZQXlabStr = [[NSMutableAttributedString alloc]initWithString:str];
    [TZQXlabStr addAttribute:NSFontAttributeName
                       value:[UIFont systemFontOfSize:14.0]
                       range:NSMakeRange(0, 7)];
    [TZQXlabStr addAttribute:NSForegroundColorAttributeName
                       value: color(255, 255, 255, 0.7)
                       range:NSMakeRange(0, 7)];
    lab.attributedText = TZQXlabStr;
    return TZQXlabStr;
}

-(NSMutableString *)creatsecurtystrwithstr:(NSString *)str{
    NSMutableString *newstr = [[NSMutableString alloc]init];
    for (int i =0; i<str.length; i++) {
        [newstr appendString:@"*"];
    }
    return newstr;
}
- (IBAction)messageBtnClicked:(id)sender {
    [self.btnDelegate respondsToSelector:@selector(messageBtnEvent)];
    [self.btnDelegate messageBtnEvent];
}

- (IBAction)personalBtnClicked:(id)sender {
    [self.btnDelegate respondsToSelector:@selector(personalBtnEvent)];
    [self.btnDelegate personalBtnEvent];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
