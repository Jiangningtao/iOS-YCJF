//
//  payView.m
//  iOS-CHJF
//
//  Created by garday on 2017/3/16.
//  Copyright © 2017年 garday. All rights reserved.
//

#import "payView.h"
#import "payTableViewCell.h"
#import "zqtextfield.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "yesandnoViewController.h"

#define kPasswordLength  6
#define kLineTag 1000
#define kDotTag 3000

#define kDotSize CGSizeMake (10, 10) //密码点的大小

#define K_Field_Height 45  //每一个输入框的高度
@interface payView()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>{
    UILabel *l;
}
/***<#注释#> ***/
@property (nonatomic ,strong)UITableView *tab;
/***付款界面 ***/
@property (nonatomic ,strong)UIView *view;
/***支付密码界面 ***/
@property (nonatomic ,strong)UIView *view1;
/***密码输入框 ***/
@property (nonatomic ,strong)zqtextfield *textf;
/***标题 ***/
@property (nonatomic ,strong)NSArray *btarr;
/***<#注释#> ***/
@property (nonatomic ,strong)UIButton *paymentBtn;
@property (nonatomic, strong) NSMutableArray *dotArray; //用于存放黑色的点点
@end
@implementation payView
-(UIButton *)paymentBtn{
    if (!_paymentBtn) {
        _paymentBtn = [[UIButton alloc]init];
        _paymentBtn.backgroundColor = [UIColor redColor];
        [_paymentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _paymentBtn.layer.masksToBounds = YES;
        [_paymentBtn setTitle:@"立即支付" forState:UIControlStateNormal];
        [_paymentBtn addTarget:self action:@selector(paymentBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        _paymentBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        _paymentBtn.layer.cornerRadius = 5.0;
    }
    return _paymentBtn;
}
-(UITableView *)tab{
    if (!_tab) {
        
        _tab = [[UITableView alloc]initWithFrame:CGRectMake(0, 66, ScreenWidth, 150) style:UITableViewStylePlain];
        _tab.dataSource = self;
        _tab.delegate = self;
//        _tab.scrollEnabled = NO;
        _tab.backgroundColor = [UIColor whiteColor];
        
            }
    return _tab;
}
-(UITextField *)textf{
    if (!_textf) {
        _textf = [[zqtextfield alloc]initWithFrame:CGRectMake(38, 79, self.frame.size.width - 76, 45)];
        _textf.backgroundColor = [UIColor clearColor];
        //输入的文字颜色为白色
        _textf.textColor = [UIColor clearColor];
        //输入框光标的颜色为白色
        _textf.tintColor = [UIColor clearColor];
        _textf.borderStyle =UITextBorderStyleNone;
        _textf.delegate = self;
        _textf.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _textf.keyboardType = UIKeyboardTypeNumberPad;
        _textf.keyboardAppearance=UIKeyboardAppearanceAlert;
        _textf.layer.masksToBounds = YES;
        _textf.layer.cornerRadius = 3.0;
        _textf.layer.borderColor = [[UIColor blackColor] CGColor];
        _textf.layer.borderWidth = 1;
        [_textf addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    }
    return _textf;
}

-(UIView *)view{
    if (!_view) {
        _view = [[UIView alloc]initWithFrame:CGRectMake(0, (self.frame.size.height/2)-100, self.frame.size.width, (self.frame.size.height/2)+100)];
        _view.backgroundColor = [UIColor whiteColor];

    }
    return _view;
}
-(UIView *)view1{
    if (!_view1) {
        _view1 = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width,( self.frame.size.height/2)-100, self.frame.size.width, (self.frame.size.height/2)+100)];
        _view1.backgroundColor = [UIColor whiteColor];
        
    }
    return _view1;
}
-(NSArray *)btarr{
    if (!_btarr) {
        _btarr = [NSArray array];
        _btarr = @[@"购买金额",@"使用优惠",@"支付金额"];
    }
    return _btarr;
}

-(NSArray *)sjarr{
    if (!_sjarr) {
        _sjarr  = [NSArray array];
//        _sjarr = @[@"1000.00元",@"优惠劵满1000减20",@"- 900.98元"];
    }
    return _sjarr;
}

-(instancetype)initWithFrame:(CGRect)frame{
   self = [super initWithFrame:frame];
    if (self) {
       
        [self setUI];
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];

        
    }
    return self;
}

-(void)setUI{
    UIButton *b = [[UIButton alloc]initWithFrame:CGRectMake(20, 20, 20 , 20)];
    [b setImage:[UIImage imageNamed:@"arrow_close_g"] forState:UIControlStateNormal];
    [b setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    b.backgroundColor = [UIColor whiteColor];
    b.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:17];

    [b addTarget:self action:@selector(cwsxBtnCilcked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:b];
    
    UILabel *la = [[UILabel alloc]initWithFrame:CGRectMake(self.view.center.x-34, 15, 69, 24)];
    la.text = @"付款详情";
    la.backgroundColor =[UIColor whiteColor];
    la.font = [UIFont fontWithName:@"PingFangSC-Regular" size:17];
    [self.view addSubview:la];
    
    
    [self.view addSubview:self.paymentBtn];
    [self.paymentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(13);
        make.right.offset(-13);
        make.bottom.offset(-(self.view.frame.size.height/7*2-30));
        make.height.offset(45);
    }];
    [self.view addSubview:self.tab];
    [self addSubview:self.view];

    //密码支付界面返回按钮
    UIButton *b1 = [[UIButton alloc]initWithFrame:CGRectMake(20, 20, 12 , 19)];
    [b1 setImage:[UIImage imageNamed:@"icon_back_click"] forState:UIControlStateNormal];
    b1.backgroundColor = [UIColor whiteColor];
    b1.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:36];
    [b1 addTarget:self action:@selector(mmfhBtnCilcked) forControlEvents:UIControlEventTouchUpInside];
    [self.view1 addSubview:b1];
    UILabel *la1 = [[UILabel alloc]initWithFrame:CGRectMake(self.view.center.x-52, 14, 104, 24)];
    la1.text = @"输入交易密码";
    la1.backgroundColor =[UIColor whiteColor];
    la1.font = [UIFont fontWithName:@"PingFangSC-Regular" size:17];
    [self.view1 addSubview:la1];
    
    l = [[UILabel alloc]init];
    l.backgroundColor =[UIColor whiteColor];
   
    l.textColor =[UIColor redColor];
    l.font = [UIFont fontWithName:@"PingFangSC-Regular" size:17];
    [self.view1 addSubview:l];
    [l mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.equalTo(la1.mas_bottom).offset(5);
    }];
    
    
      //每个密码输入框的宽度
    CGFloat width = self.textf.frame.size.width  / kPasswordLength;
    
    //生成分割线
    for (int i = 0; i < kPasswordLength - 1; i++) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.textf.frame) + (i + 1) * width, CGRectGetMinY(self.textf.frame), 1, K_Field_Height)];
        lineView.backgroundColor = grcolor;
        [self.view1 addSubview:lineView];
    }
    self.dotArray = [[NSMutableArray alloc] init];
    //生成中间的点
    for (int i = 0; i < kPasswordLength; i++) {
        UIView *dotView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.textf.frame) + (width - kPasswordLength) / 2 + i * width, CGRectGetMinY(self.textf.frame) + (K_Field_Height - kDotSize.height) / 2, kDotSize.width, kDotSize.height)];
        dotView.backgroundColor = [UIColor blackColor];
        dotView.layer.cornerRadius = kDotSize.width / 2.0f;
        dotView.clipsToBounds = YES;
        dotView.hidden = YES; //先隐藏
        [self.view1 addSubview:dotView];
        //把创建的黑色点加入到数组中
        [self.dotArray addObject:dotView];
    }

    UIButton *bn = [[UIButton alloc] init];
    bn.frame = CGRectMake(self.center.x + self.textf.width/4, CGRectGetMaxY(self.textf.frame)+15, 72, 20);
    [bn setTitle:@"忘记密码？" forState:UIControlStateNormal];
    [bn addTarget:self action:@selector(bnClicked) forControlEvents:UIControlEventTouchUpInside];
        bn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    [bn setTitleColor: [UIColor colorWithRed:57/255.0 green:149/255.0 blue:223/255.0 alpha:1/1.0] forState:UIControlStateNormal];

    [self.view1 addSubview:bn];
    [self.view1 addSubview:self.textf];
    
    
    [self addSubview:self.view1];
    
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSLog(@"变化%@", string);
    if([string isEqualToString:@"\n"]) {
        //按回车关闭键盘
        [textField resignFirstResponder];
        return NO;
    } else if(string.length == 0) {
        //判断是不是删除键
        return YES;
    }
    else if(textField.text.length >= kPasswordLength) {
        //输入的字符个数大于6，则无法继续输入，返回NO表示禁止输入
        NSLog(@"输入的字符个数大于6，忽略输入");
        return NO;
    } else {
        return YES;
    }
}

/**
 *  清除密码
 */
- (void)clearUpPassword
{
    
    self.textf.text = @"";
    [self textFieldDidChange:self.textf];
}

/**
 *  重置显示的点
 */
- (void)textFieldDidChange:(UITextField *)textField
{
    NSLog(@"%@", textField.text);
    for (UIView *dotView in self.dotArray) {
        dotView.hidden = YES;
    }
    for (int i = 0; i < textField.text.length; i++) {
        ((UIView *)[self.dotArray objectAtIndex:i]).hidden = NO;
    }
    if (textField.text.length == kPasswordLength) {
        NSLog(@"输入完毕");
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    NSString *tempUid = [defaults objectForKey:@"padss"];
        

        if ([textField.text isEqualToString:tempUid]) {
             [self endEditing:YES];
            if (_deliverViewBlock) {
                [self removeFromSuperview];
                _deliverViewBlock();
            }

        }else{
            NSLog(@"%@",tempUid);
       l.text = @"密码错误,请重新输入";
            textField.text = @"";
            textField.clearsOnBeginEditing = YES;
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0/*延迟执行时间*/ * NSEC_PER_SEC));
            
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
               l.text = @"";
            });
    
    }
}

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.sjarr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    payTableViewCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"payTableViewCell" owner:nil options:nil]lastObject];
    cell.xslab.text =self.btarr[indexPath.row];
    cell.nrlab.text = self.sjarr[indexPath.row];
    if (indexPath.row == 2) {
        cell.nrlab.textColor = [UIColor redColor];
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(void)paymentBtnClicked{
    dispatch_async(dispatch_get_main_queue(), ^(void){
        if (_deliverViewBlock)
        {
            [self removeFromSuperview];
            _deliverViewBlock();
        }
    });
//    LAContext *context = [LAContext new];
//
//    //这个属性是设置指纹输入失败之后的弹出框的选项
//    context.localizedFallbackTitle = @"手动输入密码";
//    
//    NSError *error = nil;
//    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error])
//    {
//        NSLog(@"支持指纹识别");
//        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"请按home键指纹解锁" reply:^(BOOL success, NSError * _Nullable error)
//{
//            if (success) {
//                NSLog(@"验证成功 刷新主界面");
//                dispatch_async(dispatch_get_main_queue(), ^(void){
//                    if (_deliverViewBlock)
//                    {
//                        [self removeFromSuperview];
//                        _deliverViewBlock();
//                    }
//                           });
//
//
//               
//            }
//else{
//                NSLog(@"%@",error.localizedDescription);
//                switch (error.code) {
//                    case LAErrorSystemCancel:
//                    {
//                        NSLog(@"系统取消授权，如其他APP切入");
//                        break;
//                    }
//                case LAErrorUserCancel:
//                {
//                        NSLog(@"用户取消验证Touch ID");
//                        break;
//                }
//                    case LAErrorAuthenticationFailed:
//                    {
//                        NSLog(@"授权失败");
//                        break;
//                    }
//                case LAErrorPasscodeNotSet:
//                {
//                        NSLog(@"系统未设置密码");
//                        break;
//                }
//                    case LAErrorTouchIDNotAvailable:
//                    {
//                        NSLog(@"设备Touch ID不可用，例如未打开");
//                        break;
//                    }
//            case LAErrorTouchIDNotEnrolled:
//            {
//                        NSLog(@"设备Touch ID不可用，用户未录入");
//                        break;
//            }
//                    case LAErrorUserFallback:
//                    {
//                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//                            NSLog(@"用户选择输入密码，切换主线程处理");
//                            
//                            [self anniu];
//
//
//                        }];
//                        
//                        break;
//                    }
//                         default:
//                        {
//                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//                            NSLog(@"其他情况，切换主线程处理");
//                        }];
//                        break;
//                        }
//    }
//    
//}
//            
//        }];
//        
//    }else{
//        NSLog(@"不支持指纹识别");
//        switch (error.code) {
//            case LAErrorTouchIDNotEnrolled:
//            {
//                NSLog(@"TouchID is not enrolled");
//                break;
//            }
//            case LAErrorPasscodeNotSet:
//            {
//                NSLog(@"A passcode has not been set");
//                break;
//            }
//            default:
//            {
//                
//                NSLog(@"TouchID not available");
//                break;
//            }
//        }
//        
//        NSLog(@"%@",error.localizedDescription);
//    }

}


-(void)anniu{
   
        self.view.frame = CGRectMake(-self.frame.size.width, (self.frame.size.height/2)-100, self.frame.size.width, (self.frame.size.height/2)+100);
        self.view1.frame =CGRectMake(0, (self.frame.size.height/2)-100, self.frame.size.width, (self.frame.size.height/2)+100);
//    [self.textf becomeFirstResponder];
        [self clearUpPassword];
   
}



-(void)cwsxBtnCilcked{
    
      [self removeFromSuperview];
    
}
-(void)bnClicked{
    
}

-(void)mmfhBtnCilcked{
    [UIView animateWithDuration:.3 animations:^{
         [self endEditing:YES];
        self.view.frame = CGRectMake(0, (self.frame.size.height/2)-100, self.frame.size.width, (self.frame.size.height/2)+100);
        
        self.view1.frame =CGRectMake(self.view.frame.size.width, (self.frame.size.height/2)-100, self.frame.size.width, (self.frame.size.height/2)+100);
        
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
