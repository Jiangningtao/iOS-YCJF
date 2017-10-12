//
//  zdxqViewController.m
//  iOS-CHJF
//
//  Created by garday on 2017/3/21.
//  Copyright © 2017年 garday. All rights reserved.
//

#import "zdxqViewController.h"

@interface zdxqViewController (){
    UIView *view;
}
/***<#注释#> ***/
@property (nonatomic ,strong)UIView *daView;
@end

@implementation zdxqViewController
-(UIView *)daView{
    if(!_daView){
        _daView = [[UIView alloc]initWithFrame:CGRectMake(0, 66, self.view.frame.size.width, 155)];
        _daView.backgroundColor = [UIColor whiteColor];
        UILabel *label = [[UILabel alloc] init];
        label.text = self.mor;
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:30];
        label.textColor = [UIColor colorWithRed:73/255.0 green:73/255.0 blue:73/255.0 alpha:1/1.0];
        [self.daView addSubview:label];
        [label mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.offset(0);
            make.top.offset(39);
        }];
        UILabel *labely = [[UILabel alloc] init];
        labely.text = @"收支金额(元)";
        labely.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        labely.textColor = [UIColor colorWithRed:136/255.0 green:136/255.0 blue:136/255.0 alpha:1/1.0];
        [self.daView addSubview:labely];
        [labely mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.offset(0);
            make.top.equalTo(label.mas_bottom).offset(10);
        }];
        
        
    }
    return _daView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self Nav];
    [self setUI];
    // Do any additional setup after loading the view.
}

-(void)setUI{
    [self.view addSubview:self.daView];
    
    for (int i = 0; i<4; i++) {
        view = [[UIView alloc] init];
        view.backgroundColor = grcolor;
        [self.view addSubview:view];
        
       [view mas_remakeConstraints:^(MASConstraintMaker *make) {
           make.left.offset(0);
           make.right.offset(0);
           make.height.offset(1);
           make.top.equalTo(self.daView.mas_bottom ).offset(i*48);
       }];
        
    }
    
    NSArray *q = [NSArray array];
    q = @[@"交易类型",@"交易时间",@"交易说明"];
    
   
    
    
    for (int i = 0; i<3; i++) {
        UILabel *label = [[UILabel alloc] init];
        label.text = q[i];
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        label.textColor = [UIColor colorWithRed:73/255.0 green:73/255.0 blue:73/255.0 alpha:1/1.0];
        [self.view addSubview:label];
        [label mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(17);
            make.top.equalTo(self.daView.mas_bottom).offset(12 + i*48);
            make.height.offset(21);
        }];
        
        UILabel *label1 = [[UILabel alloc] init];
        label1.text = self.arr[i];
        label1.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        label1.textColor = [UIColor colorWithRed:73/255.0 green:73/255.0 blue:73/255.0 alpha:1/1.0];
        label1.textAlignment = NSTextAlignmentRight;
        [self.view addSubview:label1];
        [label1 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-17);
            make.left.equalTo(label.mas_right).offset(10);
            make.top.equalTo(self.daView.mas_bottom).offset(12+ i*48);
        }];

    }
    
    
    UIButton *alertbtn = [[UIButton alloc]init];
    [alertbtn setImage:[UIImage imageNamed:@"Group 6"] forState:UIControlStateNormal];
    [alertbtn setTitleColor:[UIColor colorWithRed:195/255.0 green:195/255.0 blue:195/255.0 alpha:1/1.0] forState:UIControlStateNormal];
    [alertbtn setTitle:@"投资有风险 理财需谨慎" forState:UIControlStateNormal];
    alertbtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:alertbtn];
    [alertbtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.bottom.offset(-50);
    }];
    
    
}


-(void)Nav{
    self.view.backgroundColor = [UIColor whiteColor];
  
    self.navigationItem.title =@"账单详情";
    UIButton *leftbutton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 10, 21)];
    
    [leftbutton setBackgroundImage:[UIImage imageNamed:@"icon_back1"] forState:UIControlStateNormal];
    [leftbutton setBackgroundImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateHighlighted];
    [leftbutton addTarget:self action:@selector(leftbtnclicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftbarbtn=[[UIBarButtonItem alloc]initWithCustomView:leftbutton];
    self.navigationItem.leftBarButtonItem=leftbarbtn;
    
}


-(void)leftbtnclicked{
    [self.navigationController popViewControllerAnimated:YES];
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
