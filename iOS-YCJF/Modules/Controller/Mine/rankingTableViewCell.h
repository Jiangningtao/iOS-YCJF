//
//  rankingTableViewCell.h
//  iOS-CHJF
//
//  Created by garday on 2017/3/14.
//  Copyright © 2017年 garday. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UICountingLabel.h"
@class AccinfoModel;
@protocol PersoanlBtnClickDelegate <NSObject>

- (void)messageBtnEvent;
- (void)personalBtnEvent;

@end

@interface rankingTableViewCell : UITableViewCell

@property (nonatomic, strong) id<PersoanlBtnClickDelegate>btnDelegate;


@property (weak, nonatomic) IBOutlet UICountingLabel *totalye;  // 资金总额
@property (weak, nonatomic) IBOutlet UIButton *imgbTn;  //显示隐藏按钮
@property (weak, nonatomic) IBOutlet UILabel *LJSYlab;//累计收益
@property (weak, nonatomic) IBOutlet UILabel *KYYElab;//可用余额

@property (nonatomic, strong) AccinfoModel * model;

//@property (nonatomic ,copy)NSString *oldvalue;
///***<#注释#> ***/
//@property (nonatomic ,strong)NSString *staq;
///***<#注释#> ***/
//@property (nonatomic ,strong)NSString *staw;

@end
