//
//  yhkczViewController.h
//  iOS-CHJF
//
//  Created by garday on 2017/3/23.
//  Copyright © 2017年 garday. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface yhkczViewController : UIViewController

@property (nonatomic, strong) AccinfoModel * accModel;
@property (nonatomic, strong) MineItemModel * Model;
@property (nonatomic, strong) NSDictionary * infoDict;
@property (nonatomic, copy) NSString * bankImgName; // 银行卡图标
@property (nonatomic, copy) NSString * bankName; // 银行卡姓名
@property (nonatomic, copy) NSString * bankNumber; // 银行卡号
@property (nonatomic, copy) NSString * myBalance; // 我的可用余额
@property (nonatomic, copy) NSString * card_code; // 银行卡代号

@end
