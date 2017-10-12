//
//  AutomaticTableViewCell.m
//  iOS-CHJF
//
//  Created by garday on 2017/3/14.
//  Copyright © 2017年 garday. All rights reserved.
//

#import "AutomaticTableViewCell.h"
@interface AutomaticTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *ZDTBlab;//自动投标

@end

@implementation AutomaticTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    NSString *str = [[NSUserDefaults standardUserDefaults]objectForKey:KCurseq];
    if (![str isEqualToString:@"0"]) {
        _ZDTBlab.text = @"自动投标排名:  已开启";
        _ZDTBlab.text = [NSString stringWithFormat:@"自动投标排名:  第%@位", [UserDefaults objectForKey:KCurseq]];
    }else{
         _ZDTBlab.text = @"自动投标排名:  未开启";
    }
    NSMutableAttributedString *TZQXlabStr = [[NSMutableAttributedString alloc]initWithString:_ZDTBlab.text];
    [TZQXlabStr addAttribute:NSForegroundColorAttributeName
                       value: [UIColor colorWithRed:253/255.0 green:128/255.0 blue:46/255.0 alpha:1/1.0]
                       range:NSMakeRange(9, _ZDTBlab.text.length-9)];
    _ZDTBlab.attributedText = TZQXlabStr;
 
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
