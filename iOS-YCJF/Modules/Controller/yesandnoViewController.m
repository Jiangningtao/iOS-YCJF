//
//  yesandnoViewController.m
//  iOS-CHJF
//
//  Created by garday on 2017/3/17.
//  Copyright © 2017年 garday. All rights reserved.
//

#import "yesandnoViewController.h"
#import "TabBarViewController.h"
#import "endRedPacketView.h"
@interface yesandnoViewController ()<UITableViewDelegate,UITableViewDataSource>

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

@implementation yesandnoViewController

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
        self.ResultLab.text = @"购买成功";
        [_SuccessHeadView addSubview:self.ResultLab];
    }
    return _SuccessHeadView;
}

-(UIView *)SuccessFootView{
    if (!_SuccessFootView) {
        _SuccessFootView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,ScreenWidth , ScreenHeight-64-self.SuccessHeadView.height-(2*46)-90)];
        _SuccessFootView.backgroundColor =self.view.backgroundColor;
        

        UIButton *InverstBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 50, ScreenWidth-40, 40)];
        [InverstBtn setBackgroundColor:[UIColor redColor]];
        [InverstBtn setTitleColor:[UIColor whiteColor] forState:0];
        [InverstBtn addTarget:self action:@selector(InverstBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        InverstBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        InverstBtn.layer.cornerRadius = 5.0;
        [InverstBtn setTitle:@"分享好友" forState:0];
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
        HorizonLineView.backgroundColor = [UIColor lightGrayColor];
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
        
        UIButton *ContinuerechargeBtn = [self QuickSetBtnWithTextColor:[UIColor whiteColor] ansText:@"继续充值" andBgColor:color(67, 149, 221, 1)];
        [ContinuerechargeBtn addTarget:self action:@selector(leftbtnclicked) forControlEvents:UIControlEventTouchUpInside];
        [_FailFootView addSubview:ContinuerechargeBtn];
        [ContinuerechargeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_FailFootView.mas_centerX).offset(-15);
            make.left.equalTo(_FailFootView.mas_left).offset(20);
            make.centerY.equalTo(_FailFootView.mas_centerY);
            make.height.offset(45);
        }];
        
        UIButton *ContactCustomerBtn = [self QuickSetBtnWithTextColor:color(67, 149, 221, 1) ansText:@"联系客服" andBgColor:self.view.backgroundColor];
        [ContactCustomerBtn addTarget:self action:@selector(contactBtnclicked) forControlEvents:UIControlEventTouchUpInside];
        [_FailFootView addSubview:ContactCustomerBtn];
        [ContactCustomerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_FailFootView.mas_centerX).offset(15);
            make.right.equalTo(_FailFootView.mas_right).offset(-20);
            make.centerY.equalTo(_FailFootView.mas_centerY);
            make.height.offset(45);
        }];
        
        
       
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
        NSString * s = @"%";
        NSString * apr = [NSString new];
        if ([self.model.apr_B floatValue] == 0) {
            apr = [NSString stringWithFormat:@"%@%@", self.model.borrow_apr, s];
        }else
        {
            apr = [NSString stringWithFormat:@"%ld%@+%ld%@",[self.model.apr_A integerValue], bfh, [self.model.apr_B integerValue], s];
        }
        NSLog(@"%@", self.model.apr_B);
        _DataArr = self.IsSuccess == YES ? @[self.model.name,apr,[NSString stringWithFormat:@"%@元", self.money],[NSString stringWithFormat:@"%@元", self.getMoney]] :@[@"你可能遇到的问题"] ;
        NSLog(@"%@", _DataArr);
    }
    return _DataArr;
}

-(NSArray *)TitleArr{
    if (!_TitleArr) {
        _TitleArr = self.IsSuccess == YES ? @[@"项目名称",@"预期收益率",@"交易金额",@"待收收益"] : @[@"帮助中心"] ;
    }
    return _TitleArr;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self Nav];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.ResultTable];
    
    if (self.isShowRedPacket == YES) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            endRedPacketView * redPacketView = [[endRedPacketView alloc] initWithFrame:screen_bounds money:self.moneyOfRedPacket];
            redPacketView.useBlock = ^{
                
                [self.navigationController popToRootViewControllerAnimated:YES];
            };
            [self.view.window addSubview:redPacketView];
        });
    }
}
-(void)Nav{
    self.view.backgroundColor = grcolor;
    self.navigationItem.title =@"购买结果";
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


-(void)contactBtnclicked{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"400-005-6677"];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];

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
-(void)rightbtnclicked{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)InverstBtnClicked{//分享好友
    //1、创建分享参数
    NSArray* imageArray = @[[UIImage imageNamed:@"share_ycjf"]];
    //    （注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    if (imageArray) {
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:[NSString stringWithFormat:@"我在银程金服理财，刚刚获得了%@元收益，安全可靠。顺便再送你%@元现金红包！", self.getMoney, [UserDefaults objectForKey:KXshbmoney]]
                                         images:imageArray
                                            url:[NSURL URLWithString:self.shareAddress]
                                          title:[NSString stringWithFormat:@"我刚刚获得了%@元收益，也分享给你！", self.getMoney]
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
