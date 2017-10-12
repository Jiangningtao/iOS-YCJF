//
//  mingxi2TableViewCell.h
//  iOS-CHJF
//
//  Created by garday on 2017/4/11.
//  Copyright © 2017年 garday. All rights reserved.
//

#import <UIKit/UIKit.h>
@class mingxi2Model;
@interface mingxi2TableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titlelab;
@property (weak, nonatomic) IBOutlet UILabel *shenheLab;
@property (weak, nonatomic) IBOutlet UILabel *weishenheLab;

/***<#注释#> ***/
@property (nonatomic ,strong)mingxi2Model *Model;
@end
