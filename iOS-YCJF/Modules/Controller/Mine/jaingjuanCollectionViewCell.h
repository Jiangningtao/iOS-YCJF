//
//  jaingjuanCollectionViewCell.h
//  iOS-CHJF
//
//  Created by garday on 2017/3/22.
//  Copyright © 2017年 garday. All rights reserved.
//

#import <UIKit/UIKit.h>
@class myjjModel;
@interface jaingjuanCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *bflab;//加息劵的百分比
@property (weak, nonatomic) IBOutlet UILabel *yxtimelab;//有效时间
@property (weak, nonatomic) IBOutlet UIImageView *imgView;//背景
@property (weak, nonatomic) IBOutlet UILabel *jiaxiLab;
@property (weak, nonatomic) IBOutlet UIImageView *xuxianView;
@property (weak, nonatomic) IBOutlet UILabel *touzitimeLab;
@property (weak, nonatomic) IBOutlet UILabel *touzijineLab;
@property (weak, nonatomic) IBOutlet UIImageView *biaojiimgV;//右上图标
/***<#注释#> ***/

@property (nonatomic ,strong)myjjModel *model;
@property (nonatomic ,strong)myjjModel *modelq;

@end
