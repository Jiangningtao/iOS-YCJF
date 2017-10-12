//
//  AutoTenderSettingCell.m
//  TableHeadView
//
//  Created by 汤文洪 on 2017/3/31.
//  Copyright © 2017年 JR.TWH. All rights reserved.
//

#import "AutoTenderSettingCell.h"

@implementation AutoTenderSettingCell

-(UITextField *)InputTf{
    if (!_InputTf) {
        _InputTf = [[UITextField alloc]init];
        _InputTf.backgroundColor = [UIColor clearColor];
        _InputTf.font = [UIFont systemFontOfSize:14];
        _InputTf.placeholder = @"请输入金额";
        _InputTf.textAlignment = NSTextAlignmentRight;
        _InputTf.textColor = [UIColor blackColor];
    }return _InputTf;
}
-(UILabel *)Ylab{
    if (!_Ylab) {
        _Ylab =[[UILabel alloc]init];
        _Ylab.backgroundColor = [UIColor whiteColor];
        _Ylab.textColor = [UIColor blackColor];
        _Ylab.text = @"元";
    }
    return _Ylab;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self addSubview:self.InputTf];
        __weak AutoTenderSettingCell *weakSelf = self;
        [self.InputTf mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakSelf.mas_right).offset(-37);
            make.width.offset(100);
            make.centerY.equalTo(weakSelf.mas_centerY);
            make.height.offset(25);
        }];
        [self addSubview:self.Ylab];
        [self.Ylab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.InputTf.mas_centerY);
            make.left.equalTo(self.InputTf.mas_right).offset(10);
        }];
        
    }return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
