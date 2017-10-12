//
//  ChargeResultController.m
//  TableHeadView
//
//  Created by 汤文洪 on 2017/3/16.
//  Copyright © 2017年 JR.TWH. All rights reserved.
//

#import "ChargeResultController.h"

@interface ChargeResultController ()<UITableViewDelegate,UITableViewDataSource>

/** 充值结果列表 */
@property (nonatomic,strong)UITableView *ResultTable;
/** 充值成功头视图 */
@property (nonatomic,strong)UIView *SuccessHeadView;
/** 充值成功尾视图 */
@property (nonatomic,strong)UIView *SuccessFootView;
/** 充值失败头视图 */
@property (nonatomic,strong)UIView *FailHeadView;
/** 充值失败尾视图 */
@property (nonatomic,strong)UIView *FailFootView;
/** 结果图标 */
@property (nonatomic,strong)UIImageView *ResultImgVW;
/** 结果lab */
@property (nonatomic,strong)UILabel *ResultLab;

/** 列表标题 */
@property (nonatomic, copy)NSArray *TitleArr;
/** 数据数组 */
@property (nonatomic, copy)NSArray *DataArr;

@end

@implementation ChargeResultController

-(UIImageView *)ResultImgVW{
    if (!_ResultImgVW) {
        _ResultImgVW = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth/2-30, 40, 60, 60)];
        NSArray *a = [NSArray array];
        a  = self.IsSuccess == YES ? @[@"icon_right"] : @[@"icon_wrong"] ;
        _ResultImgVW.image = [UIImage imageNamed:a[0]];
        _ResultImgVW.layer.masksToBounds = YES;
        _ResultImgVW.layer.cornerRadius = 30;
    }
    return _ResultImgVW;
}

-(UILabel *)ResultLab{
    if (!_ResultLab) {
        _ResultLab = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/2-40, CGRectGetMaxY(self.ResultImgVW.frame)+8, 80, 20)];
        _ResultLab.textColor = [UIColor blackColor];
        _ResultLab.font = [UIFont systemFontOfSize:15];
        _ResultLab.textAlignment = NSTextAlignmentCenter;
    }
    return _ResultLab;
}

-(UIView *)SuccessHeadView{
    if (!_SuccessHeadView) {
        _SuccessHeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth,180)];
        _SuccessHeadView.backgroundColor = [UIColor whiteColor];
        [_SuccessHeadView addSubview:self.ResultImgVW];
        self.ResultLab.text = @"充值成功";
        [_SuccessHeadView addSubview:self.ResultLab];
    }
    return _SuccessHeadView;
}

-(UIView *)SuccessFootView{
    if (!_SuccessFootView) {
        _SuccessFootView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,ScreenWidth , ScreenHeight-64-self.SuccessHeadView.height-(2*46))];
        _SuccessFootView.backgroundColor = self.view.backgroundColor;
        
        UILabel *alertLab = [[UILabel alloc]initWithFrame:CGRectMake(15,10, ScreenWidth-15,20)];
        alertLab.font = [UIFont systemFontOfSize:13];
        alertLab.textColor = [UIColor grayColor];
        alertLab.text = @"因第三方支付原因,可能到账稍有延迟";
        [_SuccessFootView addSubview:alertLab];
        
        UIButton *InverstBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, CGRectGetMidY(_SuccessFootView.frame)-20, ScreenWidth-40, 45)];
        [InverstBtn setBackgroundColor:[UIColor redColor]];
        [InverstBtn setTitleColor:[UIColor whiteColor] forState:0];
        InverstBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        InverstBtn.layer.cornerRadius = 5.0;
        [InverstBtn setTitle:@"立即投资" forState:0];
        [_SuccessFootView addSubview:InverstBtn];
        
        UIButton *WarningBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_SuccessFootView.frame)-50, ScreenWidth, 20)];
        WarningBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        WarningBtn.userInteractionEnabled = NO;
        [WarningBtn setImage:[UIImage imageNamed:@"Group 6"] forState:UIControlStateNormal];
        [WarningBtn setTitle:@"投资有风险 理财需谨慎" forState:UIControlStateNormal];
        [WarningBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        WarningBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        
        [_SuccessFootView addSubview:WarningBtn];
    }
    return _SuccessFootView;
}

-(UIView *)FailHeadView{
    if (!_FailHeadView) {
        _FailHeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth,180+70)];
        _FailHeadView.backgroundColor = [UIColor whiteColor];
        [_FailHeadView addSubview:self.ResultImgVW];
        self.ResultLab.text = @"充值失败";
        self.ResultLab.frame = CGRectMake(ScreenWidth/2-40, CGRectGetMaxY(self.ResultImgVW.frame)+18, 80, 20);
        [_FailHeadView addSubview:self.ResultLab];
        
        UIView *HorizonLineView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.ResultLab.frame)+20, ScreenWidth, 1)];
        HorizonLineView.backgroundColor = grcolor;
        [_FailHeadView addSubview:HorizonLineView];
        
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(HorizonLineView.frame)+25, ScreenWidth, 20)];
        lab.textColor = [UIColor blackColor];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.font = [UIFont systemFontOfSize:15];
        lab.text = @"银行卡余额不足,请稍后再进行充值";
        [_FailHeadView addSubview:lab];
        
        UIView *grayView = [[UIView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(_FailHeadView.frame)-15, ScreenWidth, 15)];
        grayView.backgroundColor = color(231, 232, 234, 1);
        [_FailHeadView addSubview:grayView];
        
    }
    return _FailHeadView;
}

-(UIView *)FailFootView{
    if (!_FailFootView) {
        _FailFootView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,ScreenWidth , ScreenHeight-64-self.FailHeadView.height-46)];
        _FailFootView.backgroundColor = self.view.backgroundColor;
        
        UIButton *ContinuerechargeBtn = [self QuickSetBtnWithTextColor:[UIColor whiteColor] ansText:@"继续充值" andBgColor:color(67, 149, 221,1)];
        [_FailFootView addSubview:ContinuerechargeBtn];
        [ContinuerechargeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_FailFootView.mas_centerX).offset(-15);
            make.left.equalTo(_FailFootView.mas_left).offset(20);
            make.centerY.equalTo(_FailFootView.mas_centerY);
            make.height.offset(45);
        }];
        
        UIButton *ContactCustomerBtn = [self QuickSetBtnWithTextColor:color(67, 149, 221, 1) ansText:@"联系客服" andBgColor:self.view.backgroundColor];
        [_FailFootView addSubview:ContactCustomerBtn];
        [ContactCustomerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_FailFootView.mas_centerX).offset(15);
            make.right.equalTo(_FailFootView.mas_right).offset(-20);
            make.centerY.equalTo(_FailFootView.mas_centerY);
            make.height.offset(45);
        }];
        
        
        UIButton *WarningBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_FailFootView.frame)-50, ScreenWidth, 20)];
        WarningBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        WarningBtn.userInteractionEnabled = NO;
        [WarningBtn setImage:[UIImage imageNamed:@"Group 6"] forState:UIControlStateNormal];
        [WarningBtn setTitle:@"投资有风险 理财需谨慎" forState:UIControlStateNormal];
        [WarningBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        WarningBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        
        [_FailFootView addSubview:WarningBtn];
    }
    return _FailFootView;
}

-(UITableView *)ResultTable{
    if (!_ResultTable) {
        _ResultTable = [[UITableView alloc]initWithFrame:CGRectMake(0,64, ScreenWidth, ScreenHeight-64) style:UITableViewStylePlain];
        _ResultTable.dataSource = self;
        _ResultTable.delegate = self;
        _ResultTable.rowHeight = 46;
        _ResultTable.tableHeaderView = self.IsSuccess == YES ? self.SuccessHeadView : self.FailHeadView;
        _ResultTable.tableFooterView = self.IsSuccess == YES ? self.SuccessFootView : self.FailFootView;
    }
    return _ResultTable;
}

-(NSArray *)DataArr{
    if (!_DataArr) {
        _DataArr = self.IsSuccess == YES ? @[@"1000元",@"10000元"] :@[@"你可能遇到的问题"] ;
    }
    return _DataArr;
}

-(NSArray *)TitleArr{
    if (!_TitleArr) {
        _TitleArr = self.IsSuccess == YES ? @[@"充值金额",@"账户余额"] : @[@"帮助中心"] ;
    }
    return _TitleArr;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self Nav];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.ResultTable];
    
}

-(void)Nav{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title =@"充值结果";
    self.navigationController.navigationBar.tintColor =[UIColor whiteColor];
    UIButton *leftButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 10, 19)];
    [leftButton addTarget:self action:@selector(leftbtnclicked) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"icon_back_click"] forState:UIControlStateNormal];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateHighlighted];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:leftButton];
    if (_IsSuccess == YES) {
        UIButton *rightbutton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 29, 17)];
        [rightbutton addTarget:self action:@selector(rightbtnclicked) forControlEvents:UIControlEventTouchUpInside];
        [rightbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [rightbutton setTitleColor:grcolor forState:UIControlStateHighlighted];
        [rightbutton setTitle:@"完成"  forState:UIControlStateNormal];
        rightbutton.titleLabel.font = [UIFont systemFontOfSize:14.0];
        self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:rightbutton];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.TitleArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        if (self.IsSuccess==NO) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    
    cell.textLabel.text = self.TitleArr[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.detailTextLabel.text = self.DataArr[indexPath.row];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}




-(UIButton *)QuickSetBtnWithTextColor:(UIColor *)textColor ansText:(NSString *)text andBgColor:(UIColor *)bgColor{
    UIButton *btn = [[UIButton alloc]init];
    
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn setTitleColor:textColor forState:0];
    [btn setTitle:text forState:0];
    [btn setBackgroundColor:bgColor];
    if ([btn.backgroundColor isEqual:self.view.backgroundColor]) {
        btn.layer.borderWidth = 1.0;
        btn.layer.borderColor = color(120, 172, 226, 1).CGColor;
    }
    btn.layer.cornerRadius = 8.0;
    
    return btn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)leftbtnclicked{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightbtnclicked{
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
