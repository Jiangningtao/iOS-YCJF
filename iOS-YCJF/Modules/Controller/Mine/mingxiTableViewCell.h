//
//  mingxiTableViewCell.h
//  iOS-CHJF
//
//  Created by garday on 2017/4/11.
//  Copyright © 2017年 garday. All rights reserved.
//

#import <UIKit/UIKit.h>
@class mingxiModel;
@interface mingxiTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *chongzhi;
@property (weak, nonatomic) IBOutlet UILabel *shenheLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;

/***<#注释#> ***/
@property (nonatomic ,strong)mingxiModel *model;
@end
