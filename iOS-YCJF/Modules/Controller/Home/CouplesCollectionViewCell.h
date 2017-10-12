//
//  CouplesCollectionViewCell.h
//  iOS-CHJF
//
//  Created by 姜宁桃 on 2017/7/24.
//  Copyright © 2017年 garday. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TopicModel;
@interface CouplesCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *preLab;
@property (weak, nonatomic) IBOutlet UILabel *limitDaysLab;
@property (weak, nonatomic) IBOutlet UILabel *limitMoneyLab;
@property (weak, nonatomic) IBOutlet UIButton *investBtn;

/***<#注释#> ***/
@property (nonatomic ,strong)TopicModel *pic;

@end
