//
//  zfbczjgViewController.m
//  iOS-CHJF
//
//  Created by garday on 2017/3/24.
//  Copyright © 2017年 garday. All rights reserved.
//

#import "zfbczjgViewController.h"
#import "fundRecordViewController.h"

@interface zfbczjgViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSDictionary * bankDict;
}
/** 充值结果列表 */
@property (nonatomic,strong)UITableView *ResultTable;
/** 等待审核头视图 */
@property (nonatomic,strong)UIView *SuccessHeadView;
/** 等待审核头视图 */
@property (nonatomic,strong)UIView *SuccessFootView;
/** 等待审核头视图图标 */
@property (nonatomic,strong)UIImageView *ResultImgVW;
/** 等待审核头视图lab */
@property (nonatomic,strong)UILabel *ResultLab;
/** 等待审核头视图详情lab */
@property (nonatomic,strong)UILabel *sultLab;
/** 列表标题 */
@property (nonatomic, copy)NSArray *TitleArr;
/** 数据数组 */
@property (nonatomic, copy)NSArray *DataArr;
@end

@implementation zfbczjgViewController
-(void)Nav{
    self.view.backgroundColor = grcolor;
    self.navigationItem.title =@"提现结果";
    self.navigationController.navigationBar.tintColor =[UIColor whiteColor];
    UIButton *leftButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 10, 19)];
    [leftButton addTarget:self action:@selector(leftbtnclicked) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"icon_back_click"] forState:UIControlStateNormal];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateHighlighted];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:leftButton];

}
-(UIImageView *)ResultImgVW{
    if (!_ResultImgVW) {
        _ResultImgVW = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth/2-30, 40, 60, 60)];
        _ResultImgVW.image = [UIImage imageNamed:@"icon_loading"];
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
-(UILabel *)sultLab{
    if (!_sultLab) {
        _sultLab = [[UILabel alloc]init];
       
        if (self.classtype == classOne) {
            _sultLab.text = @"支付宝充值信息已提交，审核确认后资金到账";
        }
        else{
           _sultLab.text = @" 提现申请信息已提交，一个工作日内资金到账";
        }
        _sultLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        _sultLab.textColor = [UIColor colorWithRed:73/255.0 green:73/255.0 blue:73/255.0 alpha:1/1.0];
        _sultLab.textAlignment = NSTextAlignmentCenter;
    }
    return _sultLab;
}


-(UIView *)SuccessHeadView{
    if (!_SuccessHeadView) {
        _SuccessHeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth,196)];
        _SuccessHeadView.backgroundColor = [UIColor whiteColor];
        [_SuccessHeadView addSubview:self.ResultImgVW];
        if (self.classtype == classOne) {
           self.ResultLab.text = @"等待审核";
        }else{
            self.ResultLab.text = @"提现审核";
        }
        [_SuccessHeadView addSubview:self.ResultLab];
        [_SuccessHeadView addSubview:self.sultLab];
        [self.sultLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.offset(0);
            make.top.equalTo(self.ResultLab.mas_bottom).offset(15);
        }];
    }
    return _SuccessHeadView;
}
-(UIView *)SuccessFootView{
    if (!_SuccessFootView) {
        _SuccessFootView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,ScreenWidth , ScreenHeight-WTStatus_And_Navigation_Height-self.SuccessHeadView.height-(2*46))];
        _SuccessFootView.backgroundColor = self.view.backgroundColor;
        
        UIButton *InverstBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, CGRectGetMidY(_SuccessFootView.frame)-20, ScreenWidth-40, 45)];
        [InverstBtn setBackgroundColor:[UIColor redColor]];
        [InverstBtn setTitleColor:[UIColor whiteColor] forState:0];
        InverstBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        InverstBtn.layer.cornerRadius = 5.0;
        if (self.classtype == classOne) {
             [InverstBtn setTitle:@"立即投资" forState:0];
        }else{
        [InverstBtn setTitle:@"查看明细" forState:0];
        }
        [InverstBtn addTarget:self action:@selector(InverstBtnClicked) forControlEvents:UIControlEventTouchUpInside];
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
-(NSArray *)DataArr{
    if (!_DataArr) {
        if (self.classtype == classOne) {
            NSString *s =@"";
             _DataArr =  @[self.zfb,@"",[NSString stringWithFormat:@"%@%@元", self.tixianMoney, s]] ;
        }else if (self.classtype == classTwo){
            NSString *s =@"";
            NSString * bankNum = [bankDict[@"account"] substringFromIndex:[bankDict[@"account"] length] - 4];
            _DataArr  = @[[NSString stringWithFormat:@"%@ 尾号（%@%@)", self.infoDict[@"bankList"][0][@"name"],bankNum, s],[NSString stringWithFormat:@"%@%@元",self.tixianMoney,s],s] ;
        }else{
            _DataArr  = @[self.zfb, [[NSUserDefaults standardUserDefaults]objectForKey:@"hidden_name"],self.tixianMoney] ;
        }
    }
    return _DataArr;
}

-(NSArray *)TitleArr{
    if (!_TitleArr) {
        if (self.classtype == classOne) {
            _TitleArr  = @[@"支付宝账号",@"姓名",@"充值金额"] ;
        }else if (self.classtype == classTwo){
            _TitleArr  = @[@"到账银行卡",@"提现金额",@""] ;
        }else{
            _TitleArr  = @[@"到账支付宝账号",@"支付宝账号持有人",@"提现金额"] ;
        }
        
    }
    return _TitleArr;
}


-(UITableView *)ResultTable{
    if (!_ResultTable) {
        _ResultTable = [[UITableView alloc]initWithFrame:CGRectMake(0,WTStatus_And_Navigation_Height, ScreenWidth, ScreenHeight-WTStatus_And_Navigation_Height) style:UITableViewStylePlain];
        _ResultTable.dataSource = self;
        _ResultTable.delegate = self;
        _ResultTable.rowHeight = 46;
        _ResultTable.tableHeaderView =  self.SuccessHeadView ;
        _ResultTable.tableFooterView =  self.SuccessFootView ;
    }
    return _ResultTable;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self Nav];
    bankDict = self.infoDict[@"bankList"][0];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.ResultTable];
    self.view.backgroundColor =[UIColor whiteColor];
    
    // Do any additional setup after loading the view.
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
    }
    
        cell.textLabel.text = self.TitleArr[indexPath.row];
        cell.detailTextLabel.text = self.DataArr[indexPath.row];
   
    cell.textLabel.font = [UIFont systemFontOfSize:16];
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

-(void)leftbtnclicked{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)InverstBtnClicked{
    fundRecordViewController * vc = [[fundRecordViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
