//
//  yaoqinghyViewController.m
//  iOS-CHJF
//
//  Created by garday on 2017/3/21.
//  Copyright © 2017年 garday. All rights reserved.
//

#import "yaoqinghyViewController.h"
#import "yaoqingjiluViewController.h"
#import "myjiangliViewController.h"
#import <CoreImage/CoreImage.h>
#import "SunQRCode.h"
#import "ShareManager.h"
@interface yaoqinghyViewController (){
    UIScrollView *contentView;
    UIImageView * topImgV;
    UIButton *btnlj;
    UIImageView * imglj;
    UILabel * lablj;
    UIView * lineV;
    UIImageView * bgImgV;
    UIImageView *img;
    UILabel *label ;
    UITextView * textV;
    
    NSString * _ma;
    NSString * _shareAddressUrl;
    NSString * _shareTitle;
    NSString * _shareImg;
    NSString * _shareContent;
}
/***优惠链接按钮 ***/
@property (nonatomic ,strong)UIButton  *yhbtn;
@end

@implementation yaoqinghyViewController
-(UIButton *)yhbtn{
    if(!_yhbtn){
        _yhbtn = [[UIButton alloc] init];
        [_yhbtn setBackgroundImage:IMAGE_NAMED(@"btn_yaoq") forState:UIControlStateNormal];
        [_yhbtn setTitle:@"立刻邀请好友来理财" forState:UIControlStateNormal];
        [_yhbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_yhbtn addTarget:self action:@selector(yhBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [_yhbtn.layer setMasksToBounds:YES];
        _yhbtn.layer.cornerRadius = 4.0;
        
    }
    return _yhbtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self Nav];
    [self setUI];
    
    if (![UserDefaults objectForKey:KAccount]) {
        [self AlertWithTitle:@"提示" message:@"您还没有登录，请先去登录" andOthers:@[@"取消", @"确定"] animated:YES action:^(NSInteger index) {
            if (index == 0) {
                // 点击取消按钮 不进行操作
                NSLog(@"取消");
            }else if(index == 1)
            {
                // 点击确定按钮，去登录
                LoginViewController *sv = [[LoginViewController alloc]init];
                sv.isTurnToTabVC = @"YES";
                [self showViewController:sv sender:nil];
            }
        }];
    }
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.tabBarController.tabBar.hidden = YES;
    [self erweima];
    self.title =@"邀请好友";
    [MobClick beginLogPageView:self.title];
    [TalkingData trackPageBegin:self.title];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:self.title];
    [TalkingData trackPageEnd:self.title];
}

-(void)erweima{
    NSMutableDictionary *parms = [ NSMutableDictionary dictionary];
    parms[@"uid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"uid"];
     parms[@"sid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"sid"];
     parms[@"at"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"at"];
    [WWZShuju initlizedData:tjhyurl paramsdata:parms dicBlick:^(NSDictionary *info) {
        NSLog(@"%@",info);
        UILabel * lab1 = (UILabel *)[self.view viewWithTag:10];
        lab1.text = [NSString stringWithFormat:@"%@", info[@"total"]];
        UILabel * lab2 = (UILabel *)[self.view viewWithTag:11];
        lab2.text = [NSString stringWithFormat:@"%@", info[@"money"]];
        img.image = [SunQRCode GenerateQRCode:info[@"item"][@"tj_url"]];
        NSLog(@"img --- %@",img.image);
        label.text = [NSString stringWithFormat:@"专属推荐码: %@",info[@"item"][@"tj_uid"]];
        
        _ma =info[@"item"][@"tj_uid"];
        _shareTitle = info[@"share_title"];
        _shareContent = info[@"share_content"];
        _shareAddressUrl = info[@"share_url"];
        NSLog(@"推荐码 --- %@",label.text);
        NSLog(@"%@",info[@"msg"]);
    }];
    
}


-(void)setUI{
    contentView = [[UIScrollView alloc]initWithFrame:self.view.frame];
        contentView.backgroundColor =[UIColor whiteColor];
    contentView.bounces = NO;
    contentView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:contentView];
    
    topImgV = [[UIImageView alloc] initWithImage:IMAGE_NAMED(@"banner")];
    [contentView addSubview:topImgV];
    [topImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.offset(0);
    }];
    
    NSArray *arr = [NSArray arrayWithObjects:@"您已邀请好友（人）",@"您已获得奖励（元）", nil];
    NSArray * imgArr = @[@"icon_haoyou", @"icon_jiangli"];
//    NSArray * labArr = @[@"2", @"100"];
    for (int i = 0; i<2; i++) {
        
        btnlj = [[UIButton alloc] init];
        [btnlj setTitle:arr[i] forState:UIControlStateNormal];
        btnlj.backgroundColor = [UIColor whiteColor];
        btnlj.titleLabel.font = [UIFont systemFontOfSize:15*widthScale];
        btnlj.tag = i;
        [btnlj setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        btnlj.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        [btnlj addTarget:self action:@selector(btnljClicked:) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:btnlj];
        [btnlj mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(topImgV.mas_bottom).offset(10);
            make.centerX.offset(-self.view.centerX/2+20*widthScale + i * self.view.centerX);
        }];
        
        imglj = [[UIImageView alloc] initWithImage:IMAGE_NAMED(imgArr[i])];
        [contentView addSubview:imglj];
        [imglj mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(btnlj.mas_left).offset(-5);
            make.top.equalTo(btnlj.mas_centerY).offset(0);
        }];
        
        lablj = [[UILabel alloc] init];
        lablj.tag = 10+i;
        lablj.textColor = blue_color;
        lablj.textAlignment = NSTextAlignmentCenter;
        [contentView addSubview:lablj];
        [lablj mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(btnlj.mas_centerX).offset(-10*widthScale);
            make.top.equalTo(btnlj.mas_bottom).offset(0);
        }];
        
        UIView *viewc = [[UIView alloc] init];
        viewc.backgroundColor = [UIColor colorWithRed:209/255.0 green:209/255.0 blue:209/255.0 alpha:1/1.0];
        [contentView addSubview:viewc];
        [viewc mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(btnlj.mas_top).offset(5);
            make.bottom.equalTo(lablj.mas_bottom).offset(-3);
            make.centerX.offset(0);
            make.width.offset(1*widthScale);
        }];
        
    }
    
    lineV = [[UIView alloc] init];
    lineV.backgroundColor = grcolor;
    [contentView addSubview:lineV];
    [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lablj.mas_bottom).offset(8);
        make.left.right.equalTo(self.view).offset(0);
        make.height.offset(1*widthScale);
    }];
    
    bgImgV = [[UIImageView alloc] initWithImage:IMAGE_NAMED(@"main_img")];
    [contentView addSubview:bgImgV];
    [bgImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.equalTo(lineV.mas_bottom).offset(36);
    }];
    
    img = [[UIImageView alloc]init];
    [bgImgV addSubview:img];
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.centerY.offset(-60*heightScale);
        make.width.height.offset(120*widthScale);
    }];
    //邀请好友lab
    label = [[UILabel alloc] init];
    label.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    label.textColor = [UIColor redColor];
    [contentView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
         make.centerX.offset(0);
        make.top.equalTo(bgImgV.mas_bottom).offset(12);
    }];
    
    UILabel *label1 = [[UILabel alloc] init];
    label1.text = @"好友扫描二维码注册，或者通过分享专属链接注册，送专属活动礼包，包含现金券等礼包。";
    label1.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.numberOfLines = 0;
    label1.textColor = [UIColor colorWithRed:73/255.0 green:73/255.0 blue:73/255.0 alpha:1/1.0];
    [contentView addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.equalTo(label.mas_bottom).offset(16);
        make.left.offset(38);
        make.right.offset(-38);
    }];
    
    [contentView addSubview:self.yhbtn];
    [self.yhbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(38);
        make.right.offset(-38);
        make.top.equalTo(label1.mas_bottom).offset(31);
        make.height.offset(45);
    }];
    
    /*
    UIView *xview = [[UIView alloc]init];
    xview.backgroundColor = blue_color;
    [contentView addSubview:xview];
    [xview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.yhbtn.mas_bottom).offset(61);
        make.left.right.offset(0);
        make.height.offset(0.8*widthScale);
    }];
    
    UILabel *labelcj = [[UILabel alloc] init];
    labelcj.text = @"邀请规则";
    labelcj.textAlignment = NSTextAlignmentCenter;
    labelcj.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    labelcj.textColor = blue_color;
    labelcj.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:labelcj];
    [labelcj mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.width.offset(80);
        make.top.equalTo(self.yhbtn.mas_bottom).offset(53);
    }];
    
    UIView * yqCircleV = [UIView new];
    yqCircleV.backgroundColor = blue_color;
    [contentView addSubview:yqCircleV];
    [yqCircleV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labelcj.mas_bottom).offset(10);
        make.left.offset(10);
        make.width.height.offset(6);
    }];
    yqCircleV.radius = 3;
    UILabel * yqgzTitle1 = [UILabel new];
    yqgzTitle1.text = @"邀请人可得";
    yqgzTitle1.textColor = blue_color;
    yqgzTitle1.font = systemFont(12);
    [contentView addSubview:yqgzTitle1];
    [yqgzTitle1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(yqCircleV.mas_right).offset(2);
        make.centerY.equalTo(yqCircleV.mas_centerY);
    }];
    
    textV = [[UITextView alloc] init];
    textV.text = @"每成功邀请一位好友注册后首笔投资金额达到2000元，即可获得50元红包（红包使用门槛：投资金额≥100元，投资标期无限制）\n\n每成功邀请一位好友注册后首笔投资金额达到20000元，即可获得200元红包（红包使用门槛：投资金额≥500元，投资标期无限制）\n\n每成功邀请一位好友注册后首笔投资金额达到50000元，即可获得500元红包（红包使用门槛：投资金额≥1000元，投资标期无限制）\n\n";
    textV.editable = NO;
    textV.bounces = NO;
    textV.scrollEnabled = NO;
    textV.textColor = [UIColor colorWithRed:73/255.0 green:73/255.0 blue:73/255.0 alpha:1/1.0];
    [contentView addSubview:textV];
    [textV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labelcj.mas_bottom).offset(20);
        make.left.offset(10);
        make.right.offset(-10);
        make.height.offset(170);
    }];
    
    UIView * yqCircleV1 = [UIView new];
    yqCircleV1.backgroundColor = blue_color;
    [contentView addSubview:yqCircleV1];
    [yqCircleV1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textV.mas_bottom).offset(10);
        make.left.offset(10);
        make.width.height.offset(6);
    }];
    yqCircleV1.radius = 3;
    UILabel * yqgzTitle2 = [UILabel new];
    yqgzTitle2.text = @"被邀请人可得";
    yqgzTitle2.textColor = blue_color;
    yqgzTitle2.font = systemFont(12);
    [contentView addSubview:yqgzTitle2];
    [yqgzTitle2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(yqCircleV1.mas_right).offset(2);
        make.centerY.equalTo(yqCircleV1.mas_centerY);
    }];

    UITextView * btextV = [[UITextView alloc] init];
    btextV.text = @"被邀请人使用邀请人的链接注册或者自己下载注册时输入邀请人的推荐码，即可获得一张3%的加息券（加息券使用限制：新手标不可使用）\n\n";//@"每成功邀请一位好友注册后累计投资满1000元，即可获得50元抵扣券，邀请越多奖励越多，上不封顶。\n\n只有通过您的好友推荐链接或专属推荐码注册并投资，您才可以获得红包哦！\n\n活动期间相同手机号、身份证号视为同一会员。如发现违规行为（恶意注册、使用作弊程序等），银程金服将取消该会员奖励\n\n本次活动最终解释权归银程金服所有，如对活动有任何疑问可拨打银程金服服务热线：400-005-6677";
    btextV.editable = NO;
    btextV.bounces = NO;
    btextV.scrollEnabled = NO;
    btextV.textColor = [UIColor colorWithRed:73/255.0 green:73/255.0 blue:73/255.0 alpha:1/1.0];
    [contentView addSubview:btextV];
    [btextV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(yqgzTitle2.mas_bottom).offset(5);
        make.left.offset(10);
        make.right.offset(-10);
        make.height.offset(60);
    }];
    
    UIView *xview1 = [[UIView alloc]init];
    xview1.backgroundColor = blue_color;
    [contentView addSubview:xview1];
    [xview1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(btextV.mas_bottom).offset(25);
        make.left.right.offset(0);
        make.height.offset(0.8*widthScale);
    }];
    
    UILabel *labelcj1 = [[UILabel alloc] init];
    labelcj1.text = @"注意事项";
    labelcj1.textAlignment = NSTextAlignmentCenter;
    labelcj1.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    labelcj1.textColor = blue_color;
    labelcj1.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:labelcj1];
    [labelcj1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.width.offset(80);
        make.centerY.equalTo(xview1.mas_centerY).offset(0);
    }];
    
    UITextView * ztextV = [[UITextView alloc] init];
    ztextV.text = @"1.只有通过您的好友推荐链接或专属推荐码注册并投资，您才可以获得红包哦！\n\n2.活动期间相同手机号、身份证号视为同一会员。如发现违规行为（恶意注册、使用作弊程序等），银程金服将取消该会员奖励\n\n3.本次活动最终解释权归银程金服所有，如对活动有任何疑问可拨打银程金服服务热线：400-005-6677";
    ztextV.editable = NO;
    ztextV.bounces = NO;
    ztextV.scrollEnabled = NO;
    ztextV.textColor = [UIColor colorWithRed:73/255.0 green:73/255.0 blue:73/255.0 alpha:1/1.0];
    [contentView addSubview:ztextV];
    [ztextV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labelcj1.mas_bottom).offset(10);
        make.left.offset(10);
        make.right.offset(-10);
        make.height.offset(160);
    }];
     */
    UIView *xview = [[UIView alloc]init];
    xview.backgroundColor = blue_color;
    [contentView addSubview:xview];
    [xview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.yhbtn.mas_bottom).offset(61);
        make.left.offset(10);  make.right.offset(-10);
        make.height.offset(1*widthScale);
    }];
    
    UILabel *labelcj = [[UILabel alloc] init];
    labelcj.text = @"活动注意事项";
    labelcj.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    labelcj.textColor = blue_color;//[UIColor colorWithRed:73/255.0 green:73/255.0 blue:73/255.0 alpha:1/1.0];
    labelcj.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:labelcj];
    [labelcj mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.equalTo(self.yhbtn.mas_bottom).offset(53);
    }];
    
    textV = [[UITextView alloc] init];
    textV.text = @"1.每成功邀请一位好友注册后累计投资满1000元，即可获得50元理财红包，邀请越多奖励越多，上不封顶。\n\n2.只有通过您的好友推荐链接或专属推荐码注册并投资，您才可以获得红包哦！\n\n3、活动期间相同手机号、身份证号视为同一会员。如发现违规行为（恶意注册、使用作弊程序等），银程金服将取消该会员奖励\n\n4、本次活动最终解释权归银程金服所有，如对活动有任何疑问可拨打银程金服服务热线：400-005-6677";
    textV.editable = NO;
    textV.textColor = [UIColor colorWithRed:73/255.0 green:73/255.0 blue:73/255.0 alpha:1/1.0];
    [contentView addSubview:textV];
    [textV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labelcj.mas_bottom).offset(20);
        make.left.offset(10);
        make.right.offset(-10);
        make.height.offset(380);
    }];
}

-(void)viewDidLayoutSubviews
{
    //contentView.contentSize = CGSizeMake(self.view.frame.size.width, self.yhbtn.centerY+270+300);
    contentView.contentSize = CGSizeMake(self.view.frame.size.width, self.yhbtn.centerY+18+280);
}

-(void)Nav{
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *leftbutton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 10, 19)];
    
    [leftbutton setBackgroundImage:[UIImage imageNamed:@"icon_back1"] forState:UIControlStateNormal];
    [leftbutton setBackgroundImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateHighlighted];
    [leftbutton addTarget:self action:@selector(leftbtnclicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftbarbtn=[[UIBarButtonItem alloc]initWithCustomView:leftbutton];
    self.navigationItem.leftBarButtonItem=leftbarbtn;
    
}

-(void)yaoqing{
    yaoqingjiluViewController *cx = [[yaoqingjiluViewController alloc]init];
    [self.navigationController pushViewController:cx animated:YES];
}
-(void)touzi{
    myjiangliViewController *cx = [[myjiangliViewController alloc]init];
    [self.navigationController pushViewController:cx animated:YES];
}
-(void)btnljClicked:(UIButton *)sender{
   
    switch (sender.tag) {
        case 0:
            [self yaoqing];
            break;
            case 1:
            [self touzi];
            break;
        default:
            break;
    }
}

-(void)leftbtnclicked{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rightbtnclicked{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"400-005-6677"];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];

}
-(void)btnclicked{
    
    WebViewController * webVC = [[WebViewController alloc] init];
    webVC.url = hdxqh5;
    webVC.WebTiltle = @"活动详情";
    [self.navigationController pushViewController:webVC animated:YES];
    
}
-(void)yhBtnClicked{
    [ShareManager shareWithTitle:_shareTitle Content:_shareContent ImageName:@"share_hongbao" Url:_shareAddressUrl];
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
