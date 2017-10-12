//
//  SRTableViewCell.h
//  iOS-CHJF
//
//  Created by garday on 2017/3/21.
//  Copyright © 2017年 garday. All rights reserved.
//

#import <UIKit/UIKit.h>
@class zdmodel;
@interface SRTableViewCell : UITableViewCell
/***<#注释#> ***/
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *chongzhiLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (nonatomic ,strong)zdmodel *model;
@end
