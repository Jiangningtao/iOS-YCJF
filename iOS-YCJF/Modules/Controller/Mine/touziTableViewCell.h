//
//  touziTableViewCell.h
//  iOS-CHJF
//
//  Created by garday on 2017/3/21.
//  Copyright © 2017年 garday. All rights reserved.
//

#import <UIKit/UIKit.h>
@class touziModel;
@class jiangliModel;
@interface touziTableViewCell : UITableViewCell
//显示装态
@property (weak, nonatomic) IBOutlet UILabel *ztlab;
@property (weak, nonatomic) IBOutlet UILabel *btLab;
@property (weak, nonatomic) IBOutlet UILabel *jinelab;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *repayTimeLab;

/***<#注释#> ***/
@property (nonatomic ,strong)touziModel *model;
/***<#注释#> ***/
@property (nonatomic ,strong)jiangliModel *jianglimodel;
@end
