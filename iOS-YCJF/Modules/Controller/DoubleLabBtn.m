//
//  DoubleLabBtn.m
//  TableHeadView
//
//  Created by 汤文洪 on 2017/3/14.
//  Copyright © 2017年 JR.TWH. All rights reserved.
//

#import "DoubleLabBtn.h"

@interface DoubleLabBtn()

/** 内容 */
@property (nonatomic,strong)UILabel *TextLab;
/** 说明 */
@property (nonatomic,strong)UILabel *Detllab;

@end

@implementation DoubleLabBtn

-(UILabel *)TextLab{
    if (!_TextLab) {
        _TextLab = [[UILabel alloc]init];
        _TextLab.font = [UIFont systemFontOfSize:15];
        _TextLab.textAlignment = NSTextAlignmentCenter;
        _TextLab.textColor = [UIColor whiteColor];
    }
    return _TextLab;
}

-(UILabel *)Detllab{
    if (!_Detllab) {
        _Detllab = [[UILabel alloc]init];
        _Detllab.font = [UIFont systemFontOfSize:12];
        _Detllab.textAlignment = NSTextAlignmentCenter;
        _Detllab.textColor = [UIColor whiteColor];
    }
    return _Detllab;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.TextLab];
        [self addSubview:self.Detllab];
    }
    return self;
}


-(void)layoutSubviews{
    [super layoutSubviews];
    
    __weak DoubleLabBtn *weakSelf = self;
    [self.TextLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.bottom.equalTo(weakSelf.mas_centerY);
        make.height.offset(18);
    }];
    
    [self.Detllab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.top.equalTo(weakSelf.mas_centerY).offset(1);
        make.height.offset(15);
    }];
}

-(void)setText:(NSString *)text{
    _text = text;
    self.TextLab.text = text;
}

-(void)setDetailText:(NSString *)detailText{
    _detailText = detailText;
    self.Detllab.text = detailText;
}

@end
