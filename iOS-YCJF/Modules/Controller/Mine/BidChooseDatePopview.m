//
//  BidChooseDataPopview.m
//  TableHeadView
//
//  Created by 汤文洪 on 2017/3/30.
//  Copyright © 2017年 JR.TWH. All rights reserved.
//

#import "BidChooseDatePopview.h"

@interface BidChooseDatePopview()<UIPickerViewDelegate,UIPickerViewDataSource>
/** 选择时间 */
@property (nonatomic,strong)UIPickerView *ChooseDatePick;
/** 顶部视图 */
@property (nonatomic,strong)UIView *TopView;
/** 底部视图 */
@property (nonatomic,strong)UIView *bottomView;
/** 起始日期 */
@property (nonatomic, copy) NSString *BeginTime;
/** 截止日期 */
@property (nonatomic, copy) NSString *EndTime;
/** 选择日期 */
@property (nonatomic, copy)NSMutableArray  *ChooseDataArr;
/** 右侧选择数据 */
@property (nonatomic, copy)NSMutableArray *RightChooseData;
/**是否是百分比*/
@property (nonatomic,assign)BOOL IsBFBChoose;
@end

@implementation BidChooseDatePopview

-(NSString *)BeginTime{
    if (!_BeginTime) {
        _BeginTime = [[NSString alloc]init];
    }return _BeginTime;
}

-(NSString *)EndTime{
    if (!_EndTime) {
        _EndTime = [[NSString alloc]init];
        _EndTime = @"";
    }return _EndTime;
}

-(NSMutableArray *)ChooseDataArr{
    if (!_ChooseDataArr) {
        _ChooseDataArr = [[NSMutableArray alloc]init];
        for (NSInteger i = 1; i<13; i++) {
            [_ChooseDataArr addObject:[NSString stringWithFormat:@"%ld个月",i]];
        }
        [_ChooseDataArr insertObject:@"不限" atIndex:0];
        self.BeginTime =_ChooseDataArr[0];
        
    }return _ChooseDataArr;
}

-(NSMutableArray *)RightChooseData{
    if (!_RightChooseData) {
        _RightChooseData = [[NSMutableArray alloc]init];
        for (NSInteger i = 1; i<13; i++) {
            [_RightChooseData addObject:[NSString stringWithFormat:@"%ld个月",i]];
        }
        [_RightChooseData insertObject:@"不限" atIndex:0];
        self.EndTime = _RightChooseData[0];
    }return _RightChooseData;
}

-(UIView *)TopView{
    if (!_TopView) {
        _TopView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight-180-10, ScreenWidth, 40)];
        _TopView.backgroundColor = [UIColor whiteColor];
        
        UIView *lineView = [[UIView alloc]init];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [_TopView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(_TopView);
            make.height.offset(.5);
        }];
        
        UILabel *lab = [[UILabel alloc]init];
        lab.font = [UIFont systemFontOfSize:16];
        lab.textColor = [UIColor blackColor];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.text = @"选择投资期限";
        [_TopView addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_TopView.mas_centerX);
            make.centerY.equalTo(_TopView.mas_centerY);
            make.height.offset(20);
        }];
        
        UIButton *confirmBtn = [[UIButton alloc]init];
        [confirmBtn setBackgroundColor:[UIColor clearColor]];
        confirmBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        //        [confirmBtn.titleLabel setText:@"确定"];
        [confirmBtn setTitle:@"确定" forState:0];
        [confirmBtn setTitleColor:color(65, 148, 221, 1) forState:0];
        [confirmBtn addTarget:self action:@selector(ConfirmBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [_TopView addSubview:confirmBtn];
        [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_TopView.mas_right).offset(-10);
            make.centerY.equalTo(_TopView.mas_centerY);
            make.height.offset(25);
            make.width.offset(50);
        }];
        
        UIButton *cancleBtn = [[UIButton alloc]init];
        [cancleBtn setBackgroundColor:[UIColor clearColor]];
        cancleBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [cancleBtn setImage:[UIImage imageNamed:@"arrow_close_g"] forState:UIControlStateNormal];
        [cancleBtn addTarget:self action:@selector(CancleBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [_TopView addSubview:cancleBtn];
        [cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_TopView.mas_left).offset(10);
            make.centerY.equalTo(_TopView.mas_centerY);
            make.height.offset(25);
            make.width.offset(50);
        }];
        UIView *v = [[UIView alloc]init];
        v.backgroundColor = grcolor;
        [_TopView addSubview:v];
        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.offset(0);
            make.bottom.offset(0);
            make.height.offset(1);
        }];
        
        
    }return _TopView;
}

-(UIPickerView *)ChooseDatePick{
    if (!_ChooseDatePick) {
        _ChooseDatePick = [[UIPickerView alloc]init];
        _ChooseDatePick.delegate = self;
    }return _ChooseDatePick;
}

-(UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight-150, ScreenWidth, 150)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        
        self.ChooseDatePick.frame = _bottomView.frame;
        [_bottomView addSubview:self.ChooseDatePick];
        [self.ChooseDatePick mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.top.equalTo(_bottomView);
        }];
        
    }return _bottomView;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.frame = frame;
        self.IsBFBChoose = NO;
        
        self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3];
        
        [self addSubview:self.TopView];
        [self addSubview:self.bottomView];
        
    }return self;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return component == 0 ? self.ChooseDataArr.count : self.RightChooseData.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    return component == 0 ? self.ChooseDataArr[row] : self.RightChooseData[row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component==0) {
        self.BeginTime = self.ChooseDataArr[row];
        if (self.IsBFBChoose==YES) {
            NSString *DateStr = [self.BeginTime substringToIndex:self.BeginTime.length-1];
            [self DealRightDataWithMinNum:DateStr];
        }else{
            NSString *DateStr = [self.BeginTime substringToIndex:self.BeginTime.length-2];
            [self.RightChooseData removeAllObjects];
            for (NSInteger i = [DateStr integerValue]; i<13; i++) {
                [_RightChooseData addObject:[NSString stringWithFormat:@"%ld个月"  ,i]];
            }
        }
        [self.ChooseDatePick reloadComponent:1];
        NSLog(@"self.EndTime = %@",self.EndTime);
        if ([self.EndTime isEqualToString:@""]) {
            self.EndTime = self.RightChooseData[0];
        }else{
            self.EndTime = self.RightChooseData[[self.ChooseDatePick selectedRowInComponent:1]];
        }
    }else if (component==1){
        self.EndTime = self.RightChooseData[row];
    }
}

-(void)CancleBtnClicked{
    _block();
}

-(void)ConfirmBtnClicked{
    [self.delegate chooseDatewithDateStr:[NSString stringWithFormat:@"%@到%@",self.BeginTime,self.EndTime] andView:self];
    _block();
}

-(void)setBlock:(DismissBlock)block{
    _block = block;
}

-(void)setChooseData:(NSArray *)ChooseData{
    _ChooseData = ChooseData;
    self.IsBFBChoose = YES;
    self.ChooseDataArr = [[NSMutableArray alloc]initWithArray:ChooseData];
    [self DealRightDataWithMinNum:@"10"];
    self.BeginTime = self.ChooseDataArr [0];
    self.EndTime = self.RightChooseData[0];
    [self.ChooseDatePick reloadAllComponents];
}

-(void)DealRightDataWithMinNum:(NSString *)minStr{
    [self.RightChooseData removeAllObjects];
    for (NSInteger i = [minStr integerValue]; i<25; i++) {
        [self.RightChooseData addObject:[NSString stringWithFormat:@"%ld%@",i,@"%"]];
    }
}

@end
