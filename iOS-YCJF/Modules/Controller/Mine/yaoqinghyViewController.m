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
//    img.image = [UIImage imageNamed:@"pic"];
    [bgImgV addSubview:img];
//    [img.layer setBorderColor:[UIColor blackColor].CGColor];
//    [img.layer setBorderWidth:1];
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.centerY.offset(-60*heightScale);
        make.width.height.offset(120*widthScale);
    }];
    //邀请好友lab
    label = [[UILabel alloc] init];
    
//    label.text = @"专属推荐码";
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
    textV.text = @"1.每成功邀请一位好友注册后累计投资满1000元，即可获得50元现金红包，邀请越多奖励越多，上不封顶。\n\n2.只有通过您的好友推荐链接或专属推荐码注册并投资，您才可以获得红包哦！\n\n3、活动期间相同手机号、身份证号视为同一会员。如发现违规行为（恶意注册、使用作弊程序等），银程金服将取消该会员奖励\n\n4、本次活动最终解释权归银程金服所有，如对活动有任何疑问可拨打银程金服服务热线：400-005-6677";
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
    
    
    UIButton *rightbutton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 22, 20)];
    [rightbutton addTarget:self action:@selector(rightbtnclicked) forControlEvents:UIControlEventTouchUpInside];
    [rightbutton setBackgroundImage:[UIImage imageNamed:@"icon_tel"] forState:UIControlStateNormal];
    [rightbutton setBackgroundImage:[UIImage imageNamed:@"Page 1"] forState:UIControlStateHighlighted];
//    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:rightbutton];
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
    //1、创建分享参数
    NSArray* imageArray = @[[UIImage imageNamed:@"share_hongbao"]];
    //    （注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    if (imageArray) {
        NSString * urlStr = [NSString stringWithFormat:@"%@ind/h5/act.html?tjr=%@", guangUrl,_ma];
        NSLog(@"%@", urlStr);
        [TalkingData trackEvent:@"邀请好友" label:urlStr];
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:[NSString stringWithFormat:@"您的好友赠送您%@元现金红包，点击领取！", [UserDefaults objectForKey:KXshbmoney]]
                                         images:imageArray
                                            url:[NSURL URLWithString:urlStr]
                                          title:[NSString stringWithFormat:@"%@元现金红包", [UserDefaults objectForKey:KXshbmoney]]
                                           type:SSDKContentTypeAuto];
        //有的平台要客户端分享需要加此方法，例如微博
        [shareParams SSDKEnableUseClientShare];
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                                 items:nil
                           shareParams:shareParams
                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                       
                       switch (state) {
                           case SSDKResponseStateSuccess:
                           {
                               //                               [self showError:@"分享成功"];                           break;
                           }
                           case SSDKResponseStateFail:
                           {
                               //                               [self showError:@"分享失败"];
                               break;
                           }
                           default:
                               break;
                       }
                   }
         ];}
    
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
