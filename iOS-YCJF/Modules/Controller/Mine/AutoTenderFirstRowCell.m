//
//  AutoTenderFirstRowCell.m
//  TableHeadView
//
//  Created by 汤文洪 on 2017/3/30.
//  Copyright © 2017年 JR.TWH. All rights reserved.
//

#import "AutoTenderFirstRowCell.h"

@interface AutoTenderFirstRowCell()

/** 标题 */
@property (nonatomic,strong)UILabel *TitleLab;

@end

@implementation AutoTenderFirstRowCell

-(UISwitch *)AutoBidSwitch{
    if (!_AutoBidSwitch) {
        _AutoBidSwitch = [[UISwitch alloc]init];
    }return _AutoBidSwitch;
}

-(UILabel *)TitleLab{
    if (!_TitleLab) {
        _TitleLab = [[UILabel alloc]init];
        _TitleLab.font = [UIFont systemFontOfSize:16];
        _TitleLab.textColor = [UIColor blackColor];
        _TitleLab.text = @"自动投标";
    }return _TitleLab;
}

-(UILabel *)RankDetlLab{
    if (!_RankDetlLab) {
        _RankDetlLab = [[UILabel alloc]init];
        _RankDetlLab.font = [UIFont systemFontOfSize:15];
        _RankDetlLab.textColor = [UIColor lightGrayColor];
        _RankDetlLab.text = @"开启人数12345位";
    }return _RankDetlLab;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self SetMainUI];
    }return self;
}

-(void)SetMainUI{
    __weak AutoTenderFirstRowCell *weakSelf = self;
    [self addSubview:self.AutoBidSwitch];
    [self addSubview:self.TitleLab];
    [self addSubview:self.RankDetlLab];
    [self.TitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left).offset(15);
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.width.offset(70);
    }];
    [self.RankDetlLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.TitleLab.mas_right).offset(5);
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.height.offset(18);
    }];
    
    [self.AutoBidSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.right.equalTo(weakSelf.mas_right).offset(-27);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
