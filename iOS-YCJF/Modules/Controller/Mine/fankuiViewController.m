//
//  fankuiViewController.m
//  iOS-CHJF
//
//  Created by garday on 2017/3/23.
//  Copyright © 2017年 garday. All rights reserved.
//

#import "fankuiViewController.h"

@interface fankuiViewController ()<UITextViewDelegate>{
    UILabel *lab;
    UITextView *tfView;
    UITextField *tfiled;
}
/***<#注释#> ***/
@property (nonatomic ,strong)UIButton *czbtn;
@end

@implementation fankuiViewController


-(void)Nav{
    self.view.backgroundColor = grcolor;
    self.navigationItem.title =@"意见反馈";
    UIButton *leftbutton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 10, 21)];
    
    [leftbutton setBackgroundImage:[UIImage imageNamed:@"icon_back1"] forState:UIControlStateNormal];
    [leftbutton setBackgroundImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateHighlighted];
    [leftbutton addTarget:self action:@selector(leftbtnclicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftbarbtn=[[UIBarButtonItem alloc]initWithCustomView:leftbutton];
    self.navigationItem.leftBarButtonItem=leftbarbtn;
    
    
   }
-(UIButton *)czbtn{
    if(!_czbtn){
        _czbtn = [[UIButton alloc] init];
        _czbtn.backgroundColor = [UIColor redColor];
        [_czbtn setTitle:@"提交" forState:UIControlStateNormal];
        [_czbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_czbtn addTarget:self action:@selector(czBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [_czbtn.layer setMasksToBounds:YES];
        _czbtn.layer.cornerRadius = 4.0;
        
    }
    return _czbtn;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self Nav];
    tfView = [[UITextView alloc]init];
        tfView.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets=NO;
    tfView.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    tfView.textContainerInset = UIEdgeInsetsMake(10, 10, 0, 10);//设置页边距
    [self.view addSubview:tfView];
    [tfView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(76);
        make.left.and.right.offset(0);
        make.height.offset(200);
    }];
    
    lab = [[UILabel alloc]init];
    lab.enabled = NO;
    lab.text = @"请输入您的意见或者建议，我们会及时给出反馈。";
    lab.font =  [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    lab.textColor = [UIColor lightGrayColor];
    [tfView addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.top.offset(10);
    }];
    tfView.delegate = self;
    
    
    UIView *viewa = [[UIView alloc]init];
    viewa.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:viewa];
    [viewa mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0); make.right.offset(0);
        make.top.equalTo(tfView.mas_bottom).offset(20);
        make.height.offset(50);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"联系方式";
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    label.textColor = [UIColor colorWithRed:73/255.0 green:73/255.0 blue:73/255.0 alpha:1/1.0];
    [viewa addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(0);
        make.left.offset(21);
    }];
    tfiled = [[UITextField alloc]init];
    tfiled.placeholder = @"手机号或者qq号，方便联系到您。";
    
    tfiled.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    [viewa addSubview:tfiled];
    [tfiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(0);
        make.left.equalTo(label.mas_right).offset(13);
    }];
    
    [self.view addSubview:self.czbtn];
    [self.czbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(13);
        make.right.offset(-13);
        make.height.offset(45);
        make.top.equalTo(viewa.mas_bottom).offset(50);
    }];
    

    
    // Do any additional setup after loading the view.
}
#pragma mark - UITextView的代理方法
- (void)textViewDidChange:(UITextView *)textView
{
    if ([textView.text length] == 0) {
        [lab setHidden:NO];
    }else{
        [lab setHidden:YES];
    }
}

-(void)leftbtnclicked{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)czBtnClicked{
    if (tfView.text.length > 0) {
        NSMutableDictionary *pramas = [NSMutableDictionary dictionary];
        pramas[@"uid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"uid"];
        pramas[@"sid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"sid"];
        pramas[@"at"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"at"];
        pramas[@"content"] = tfView.text;   // 意见反馈内容 （可选）
        pramas[@"contacts"] = tfiled.text;  // 联系方式 （可选）
        
        [WWZShuju initlizedData:yjfkurl paramsdata:pramas dicBlick:^(NSDictionary *info) {
            NSLog(@"%@", info);
            if ([info[@"r"] integerValue] == 1) {
                [self showHUD:@"提交成功！谢谢您的宝贵意见" de:1.5];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }else
            {
                if ([info[@"msg"] length] > 0) {
                    [self showHUD:info[@"msg"] de:1.0];
                }else
                {
                    [self showHUD:@"提交失败" de:1.0];
                }
            }
        }];
    }else
    {
        [self showHUD:@"反馈内容不能为空" de:1.0];
    }
    
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
