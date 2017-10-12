//
//  inTableViewCell.h
//  iOS-CHJF
//
//  Created by garday on 2017/3/15.
//  Copyright © 2017年 garday. All rights reserved.
//

#import <UIKit/UIKit.h>
@class shouruModel;
@interface inTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titlab;

@property (weak, nonatomic) IBOutlet UILabel *dalab;
@property (weak, nonatomic) IBOutlet UILabel *zhonglab;
/***<#注释#> ***/
@property (nonatomic ,strong)shouruModel *model;
@end
