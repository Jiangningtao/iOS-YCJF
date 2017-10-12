//
//  zhangdanTableViewCell.h
//  iOS-CHJF
//
//  Created by garday on 2017/3/21.
//  Copyright © 2017年 garday. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DSZDMolde;

@interface zhangdanTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *morLab;
//@property (weak, nonatomic) IBOutlet UILabel *yueLab;//月还息到期还本
@property (weak, nonatomic) IBOutlet UILabel *benxilab;//本期待收本息
/***<#注释#> ***/
@property (nonatomic ,strong)DSZDMolde *model;
/***<#注释#> ***/
@property (nonatomic, copy) NSString * upVC;

@end
