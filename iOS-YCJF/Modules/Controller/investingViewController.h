//
//  investingViewController.h
//  iOS-CHJF
//
//  Created by garday on 2017/3/15.
//  Copyright © 2017年 garday. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "xqModel.h"

@interface investingViewController : UIViewController

@property (nonatomic ,strong)NSString *borrow_account_wait;
@property (nonatomic ,strong)NSString *borrow_apr;
@property (nonatomic ,strong)NSString *borrow_period;
@property (nonatomic, strong) xqModel * model; // 模型
@property (nonatomic, copy) NSString * shareAddress;    // 分享给好友的URL地址

/***<#注释#> ***/
@property (nonatomic ,strong)NSString *bid;
/***<#注释#> ***/
@property (nonatomic ,strong) UILabel  *xs;
/***<#注释#> ***/
@property (nonatomic ,strong)NSString *sqman;
@property (nonatomic ,strong)NSString *jisuanbfb;  // 加息 利息
@property (nonatomic ,strong)NSString *jsyhq;
@property (nonatomic ,strong)NSString *hbid;
@property (nonatomic, strong) NSString * jxid;  // 加息券id
/***<#注释#> ***/
@property (nonatomic ,strong)NSString *jssuan;

@property (nonatomic, strong) MineItemModel * mineModel;
@property (nonatomic, strong) AccinfoModel * accModel;

@end
