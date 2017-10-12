//
//  SheetCell.m
//  TableHeadView
//
//  Created by 汤文洪 on 2017/3/22.
//  Copyright © 2017年 JR.TWH. All rights reserved.
//

#import "SheetCell.h"

@interface SheetCell()

/** 时间 */
@property (nonatomic,strong)UILabel *TimeLab;
/** 本金 */
@property (nonatomic,strong)UILabel *BJLab;
/** 收益 */
@property (nonatomic,strong)UILabel *SYLab;
/** 状态 */
@property (nonatomic,strong)UILabel *ZTLab;
/** lab数组 */
@property (nonatomic, copy)NSArray *LabArr;


@end

@implementation SheetCell

-(UILabel *)TimeLab{
    if (!_TimeLab) {
        _TimeLab = [self QuickSetLabWithTextAligment:NSTextAlignmentLeft];
    }
    return _TimeLab;
}
-(UILabel *)BJLab{
    if (!_BJLab) {
        _BJLab = [self QuickSetLabWithTextAligment:NSTextAlignmentCenter];
    }
    return _BJLab;
}
-(UILabel *)SYLab{
    if (!_SYLab) {
        _SYLab = [self QuickSetLabWithTextAligment:NSTextAlignmentCenter];
    }
    return _SYLab;
}
-(UILabel *)ZTLab{
    if (!_ZTLab) {
        _ZTLab = [self QuickSetLabWithTextAligment:NSTextAlignmentRight];
    }
    return _ZTLab;
}

-(NSArray *)LabArr{
    if (!_LabArr) {
        _LabArr = @[self.TimeLab,self.BJLab,self.SYLab,self.ZTLab];
    }
    return _LabArr;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        CGFloat LeftMargin = 5;
        CGFloat LabWidth = (ScreenWidth-2*LeftMargin)/self.LabArr.count;
        for (NSInteger i = 0; i<self.LabArr.count; i++) {
            UILabel *lab = self.LabArr[i];
            lab.frame = CGRectMake(LeftMargin+(i*LabWidth),5,LabWidth, 45);
            [self addSubview:lab];
        }
    }
    return self;
}


-(void)setDataStr:(NSString *)DataStr{
    _DataStr = DataStr;
    NSArray *dataArr = [DataStr componentsSeparatedByString:@","];
    for (NSInteger i = 0; i<self.LabArr.count; i++) {
        UILabel *lab = self.LabArr[i];
        [lab setText:dataArr[i]];
        if (i==self.LabArr.count-1) {
            if ([lab.text isEqualToString:@"已回款"]) {
                lab.textColor = [UIColor cyanColor];
            }
        }
    }

}


-(UILabel *)QuickSetLabWithTextAligment:(NSTextAlignment )aligment{
    UILabel *lab = [[UILabel alloc]init];
    lab.backgroundColor = [UIColor clearColor];
    lab.textColor = [UIColor darkTextColor];
    lab.font = [UIFont systemFontOfSize:13];
    lab.textAlignment = aligment;
    lab.numberOfLines = 0;
    return lab;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
