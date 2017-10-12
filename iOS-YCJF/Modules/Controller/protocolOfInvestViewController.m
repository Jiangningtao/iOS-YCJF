//
//  protocolOfInvestViewController.m
//  iOS-CHJF
//
//  Created by 姜宁桃 on 2017/7/18.
//  Copyright © 2017年 garday. All rights reserved.
//

#import "protocolOfInvestViewController.h"

@interface protocolOfInvestViewController ()
{
    UIScrollView * _bgView;
}

@end

@implementation protocolOfInvestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self Nav];
    [self configUI];
}

-(void)Nav{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title =@"银程金服购买协议";
    self.navigationController.navigationBar.tintColor =[UIColor whiteColor];
    UIButton *leftButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 10, 19)];
    [leftButton addTarget:self action:@selector(leftbtnclicked) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"icon_back_click"] forState:UIControlStateNormal];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateHighlighted];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:leftButton];
}

- (void)configUI
{
    _bgView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _bgView.backgroundColor = [UIColor whiteColor];
    _bgView.contentSize = CGSizeMake(ScreenWidth, 690);
    [self.view addSubview:_bgView];
    
    NSArray * titleArray = @[@"委托人：", @"身份证号：", @"住址：", @"联系方式：", @"受托人：", @"住所："];
    NSArray * dataArray = @[self.tzrinfo[@"uname"], self.tzrinfo[@"persionid"], self.tzrinfo[@"v_area"],self.tzrinfo[@"mobile"], @"浙江齐融金融信息服务有限公司（以下简称“银程金服”）", @"浙江省杭州市西湖区文三路477号华星科技大厦9楼902室"];
    for (int i = 0; i < titleArray.count-2; i++) {
        UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(10*widthScale, 10*heightScale+i*28, ScreenWidth-20*widthScale, 28)];
        lab.text = [NSString stringWithFormat:@"%@%@",  titleArray[i], dataArray[i]];
        lab.textColor = color(0, 7, 24, 1);
        lab.font = [UIFont systemFontOfSize:14];
        [_bgView addSubview:lab];
    }
    UILabel * lab1 = [[UILabel alloc] initWithFrame:CGRectMake(10*widthScale, 10*heightScale+4*28, ScreenWidth-20*widthScale, 36)];
    lab1.text = [NSString stringWithFormat:@"%@%@",  titleArray[4], dataArray[4]];
    lab1.textColor = color(0, 7, 24, 1);
    lab1.font = [UIFont systemFontOfSize:14];
    lab1.numberOfLines = 2;
    [_bgView addSubview:lab1];
    UILabel * lab2 = [[UILabel alloc] initWithFrame:CGRectMake(10*widthScale, lab1.bottom, ScreenWidth-20*widthScale, 36)];
    lab2.text = [NSString stringWithFormat:@"%@%@",  titleArray[5], dataArray[5]];
    lab2.textColor = color(0, 7, 24, 1);
    lab2.numberOfLines = 2;
    lab2.font = [UIFont systemFontOfSize:14];
    [_bgView addSubview:lab2];
    
    UITextView * tv = [[UITextView alloc] initWithFrame:CGRectMake(10*widthScale, lab2.bottom+10*widthScale, ScreenWidth-20*widthScale, 400)];
    tv.editable = NO;
    tv.text = [NSString stringWithFormat:@"\t鉴于委托人为在银程金服运营的平台银程金服实名注册的用户，现拟参与银程金服平台开发的“信用贷”，为优化委托人的用户体验，委托人就“信用贷”的相关投标、资金划转、退出等相关事项向受托人做出如下授权：\n一、授权范围\n    （一）代委托人在银程金服平台上点击确认投标、出借资金、借款协议、债权转让协议等业务流程中的全部协议。\n    （二）代委托人进行划转出借资金、收回借款本息、收取债权转让款项等业务流程中涉及的全部资金管理。\n    二、授权出借信息\n    （一）授权出借的账户\n    银程金服平台账号：%@\n    （二)  授权出借的金额：人民币（大写）_XXXXXX_元（￥_XXX_）\n    三、授权期限\n    本授权期限自委托人与受托人间签署《“信用贷计划”授权委托书》之日起至完全退出“信用贷”（或紧急退出）之日止。\n    四、本委托书经委托人在银程金服平台以线上点击确认的方式签署。", self.tzrinfo[@"mobile"]];
    tv.font = [UIFont systemFontOfSize:14];
    tv.textColor = color(152, 154, 158, 1);
    tv.showsHorizontalScrollIndicator = NO;
    tv.showsVerticalScrollIndicator = NO;
    tv.bouncesZoom = NO;
    tv.scrollEnabled = NO;
    tv.backgroundColor = [UIColor clearColor];
    [_bgView addSubview:tv];
    
    NSArray * bottomArray = @[[NSString stringWithFormat:@"委托人：%@", self.tzrinfo[@"uname"]], self.data[@"yearm"]];
    for (int i = 0; i < bottomArray.count; i++) {
        UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(10*widthScale, tv.bottom+10*heightScale+i*28, ScreenWidth-20*widthScale, 28)];
        lab.text = bottomArray[i];
        lab.textColor = color(152, 154, 158, 1);
        lab.textAlignment = NSTextAlignmentRight;
        lab.font = [UIFont systemFontOfSize:14];
        [_bgView addSubview:lab];
    }
    
//    bg_seal
    UIImageView * imgView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-211*0.5-5, tv.bottom+50-210*0.25, 211*0.5, 210*0.5)];
    imgView.image = [UIImage imageNamed:@"bg_seal"];
    [_bgView addSubview:imgView];
}

-(void)leftbtnclicked{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 数字金额转大写

-(NSString *)getCnMoneyByString:(NSString*)string

{
    
    // 设置数据格式
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    
    // NSLocale的意义是将货币信息、标点符号、书写顺序等进行包装，如果app仅用于中国区应用，为了保证当用户修改语言环境时app显示语言一致，则需要设置NSLocal（不常用）
    
    numberFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    
    // 全拼格式
    
    [numberFormatter setNumberStyle:NSNumberFormatterSpellOutStyle];
    
    // 小数点后最少位数
    
    [numberFormatter setMinimumFractionDigits:2];
    
    // 小数点后最多位数
    
    [numberFormatter setMaximumFractionDigits:6];
    
    [numberFormatter setFormatterBehavior:NSNumberFormatterBehaviorDefault];
    
    //
    
    NSString *formattedNumberString = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:[string doubleValue]]];
    
    //通过NSNumberFormatter转换为大写的数字格式 eg:一千二百三十四
    
    //替换大写数字转为金额
    
    formattedNumberString = [formattedNumberString stringByReplacingOccurrencesOfString:@"一" withString:@"壹"];
    
    formattedNumberString = [formattedNumberString stringByReplacingOccurrencesOfString:@"二" withString:@"贰"];
    
    formattedNumberString = [formattedNumberString stringByReplacingOccurrencesOfString:@"三" withString:@"叁"];
    
    formattedNumberString = [formattedNumberString stringByReplacingOccurrencesOfString:@"四" withString:@"肆"];
    
    formattedNumberString = [formattedNumberString stringByReplacingOccurrencesOfString:@"五" withString:@"伍"];
    
    formattedNumberString = [formattedNumberString stringByReplacingOccurrencesOfString:@"六" withString:@"陆"];
    
    formattedNumberString = [formattedNumberString stringByReplacingOccurrencesOfString:@"七" withString:@"柒"];
    
    formattedNumberString = [formattedNumberString stringByReplacingOccurrencesOfString:@"八" withString:@"捌"];
    
    formattedNumberString = [formattedNumberString stringByReplacingOccurrencesOfString:@"九" withString:@"玖"];
    
    formattedNumberString = [formattedNumberString stringByReplacingOccurrencesOfString:@"〇" withString:@"零"];
    
    formattedNumberString = [formattedNumberString stringByReplacingOccurrencesOfString:@"千" withString:@"仟"];
    
    formattedNumberString = [formattedNumberString stringByReplacingOccurrencesOfString:@"百" withString:@"佰"];
    
    formattedNumberString = [formattedNumberString stringByReplacingOccurrencesOfString:@"十" withString:@"拾"];
    
    // 对小数点后部分单独处理
    
    // rangeOfString 前面的参数是要被搜索的字符串，后面的是要搜索的字符
    
    if ([formattedNumberString rangeOfString:@"点"].length>0)
        
    {
        
        // 将“点”分割的字符串转换成数组，这个数组有两个元素，分别是小数点前和小数点后
        
        NSArray* arr = [formattedNumberString componentsSeparatedByString:@"点"];
        
        // 如果对一不可变对象复制，copy是指针复制（浅拷贝）和mutableCopy就是对象复制（深拷贝）。如果是对可变对象复制，都是深拷贝，但是copy返回的对象是不可变的。
        
        // 这里指的是深拷贝
        
        NSMutableString* lastStr = [[arr lastObject] mutableCopy];
        
        NSLog(@"---%@---长度%ld", lastStr, lastStr.length);
        
        if (lastStr.length>=2)
            
        {
            
            // 在最后加上“分”
            
            [lastStr insertString:@"分" atIndex:lastStr.length];
            
        }
        
        if (![[lastStr substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"零"])
            
        {
            
            // 在小数点后第一位后边加上“角”
            
            [lastStr insertString:@"角" atIndex:1];
            
        }
        
        // 在小数点左边加上“元”
        
        formattedNumberString = [[arr firstObject] stringByAppendingFormat:@"元%@",lastStr];
        
    }
    
    else // 如果没有小数点
        
    {
        
        formattedNumberString = [formattedNumberString stringByAppendingString:@"元"];
        
    }
    
    return formattedNumberString;
    
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
