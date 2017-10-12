//
//  JXTZTableViewCell.h
//  iOS-CHJF
//
//  Created by garday on 2017/3/8.
//  Copyright © 2017年 garday. All rights reserved.
//

#import <UIKit/UIKit.h>
@class biaoModel;
@interface JXTZTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *zhuanchuLab;
@property (weak, nonatomic) IBOutlet UILabel *progressLab;
@property (weak, nonatomic) IBOutlet UIProgressView *progress;
@property (nonatomic ,strong) IBOutlet UIImageView *dyimgV;
/***<#注释#> ***/
@property (nonatomic ,strong)UIImageView *dyimgVtwo;
/***<#注释#> ***/
@property (nonatomic ,strong)UIImageView *dyimgVthree;

@property (weak, nonatomic) IBOutlet UILabel *titlelab;
@property (weak, nonatomic) IBOutlet UILabel *ptlab;
@property (weak, nonatomic) IBOutlet UILabel *BFBlab;
@property (weak, nonatomic) IBOutlet UILabel *monthLab;
/***<#注释#> ***/
@property (nonatomic ,strong)biaoModel *rst;

@end
