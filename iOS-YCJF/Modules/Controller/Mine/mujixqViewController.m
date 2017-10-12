//
//  mujixqViewController.m
//  iOS-CHJF
//
//  Created by garday on 2017/3/21.
//  Copyright © 2017年 garday. All rights reserved.
//

#import "mujixqViewController.h"
#import "BiaoDetailViewController.h"

@interface mujixqViewController (){
    UILabel *labeltm;
}
/***<#注释#> ***/
@property (nonatomic ,strong)UIView *viewa;
@end

@implementation mujixqViewController



-(UIView *)viewa{
    if(!_viewa){
        _viewa = [[UIView alloc] init];
        _viewa.backgroundColor = [UIColor whiteColor];
        
        UILabel *labelbt = [[UILabel alloc] init];
        labelbt.text = @"";
        labelbt.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        labelbt.textColor = [UIColor colorWithRed:73/255.0 green:73/255.0 blue:73/255.0 alpha:1/1.0];
        [self.viewa addSubview:labelbt];
        [labelbt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(33);
            make.left.offset(7);
        }];
        
        UILabel *labelsh = [[UILabel alloc] init];
        labelsh.text = @"";
        labelsh.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        labelsh.textColor = [UIColor colorWithRed:57/255.0 green:149/255.0 blue:223/255.0 alpha:1/1.0];
        [self.viewa addSubview:labelsh];
        [labelsh mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(labelbt.mas_top);
            make.right.offset(-20);
        }];
        
        UIView *fview = [[UIView alloc] init];
        fview.backgroundColor=grcolor;
        [self.viewa addSubview:fview];
        [fview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(labelbt.mas_bottom).offset(25);
            make.left.right.offset(0);
            make.height.offset(1);
        }];
        
        NSArray *arr = [NSArray array];
        arr = @[@"交易时间",@"预期收益率",@"项目期限",@"回款方式",@"投资金额",@"预期收益"];
        for (int i = 0; i<6; i++) {
            labeltm = [[UILabel alloc] init];
            labeltm.text = arr[i];
            labeltm.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
            labeltm.textColor = [UIColor colorWithRed:152/255.0 green:154/255.0 blue:158/255.0 alpha:1/1.0];
            [self.viewa addSubview:labeltm];
            [labeltm mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(18);
                make.top.equalTo(fview.mas_bottom).offset(32 +i*50);
            }];
            
            
            UILabel *labelxq = [[UILabel alloc] init];
            labelxq.text = @"";
            labelxq.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
            labelxq.textColor = [UIColor colorWithRed:73/255.0 green:73/255.0 blue:73/255.0 alpha:1/1.0];
            [self.viewa addSubview:labelxq];
            [labelxq mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.offset(-15);
                  make.top.equalTo(fview.mas_bottom).offset(32 +i*50);
            }];
        }
        
        UIButton *btn = [[UIButton alloc] init];
        [btn setTitle:@"查看投资项目" forState:UIControlStateNormal];
        [btn setTitleColor: [UIColor colorWithRed:57/255.0 green:149/255.0 blue:223/255.0 alpha:1/1.0] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        btn.backgroundColor = [UIColor whiteColor];
        [btn addTarget:self action:@selector(brnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.viewa addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.offset(0);
            make.top.equalTo(labeltm.mas_bottom).offset(42);
        }];
        
        
    }
    return _viewa;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self Nav];
    [self.view addSubview:self.viewa];
    
    [self.viewa mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(76);
        make.left.right.offset(0);
        make.width.offset(self.view.width);
        make.height.offset(self.view.height);
    }];
    
    
    // Do any additional setup after loading the view.
}

-(void)brnClicked{
    BiaoDetailViewController *ssv = [[BiaoDetailViewController alloc]init];
    ssv.idstr = self.idstr;
    [self.navigationController pushViewController:ssv animated:YES];
}


-(void)Nav{
    self.navigationItem.title =@"投资详情";
    self.view.backgroundColor = grcolor;
    UIButton *leftbutton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 10, 19)];
    
    [leftbutton setBackgroundImage:[UIImage imageNamed:@"icon_back1"] forState:UIControlStateNormal];
    [leftbutton setBackgroundImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateHighlighted];
    [leftbutton addTarget:self action:@selector(leftbtnclicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftbarbtn=[[UIBarButtonItem alloc]initWithCustomView:leftbutton];
    self.navigationItem.leftBarButtonItem=leftbarbtn;
    
    
    UIButton *rightbutton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 57, 20)];
    [rightbutton addTarget:self action:@selector(rightbtnclicked) forControlEvents:UIControlEventTouchUpInside];
    rightbutton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    [rightbutton setTitle:@"投资合同" forState:UIControlStateNormal];
    [rightbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:rightbutton];
}

-(void)leftbtnclicked{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rightbtnclicked{
    
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
