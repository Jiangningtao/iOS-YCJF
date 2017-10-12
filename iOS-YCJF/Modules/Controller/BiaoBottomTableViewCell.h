//
//  BiaoBottomTableViewCell.h
//  iOS-YCJF
//
//  Created by 姜宁桃 on 2017/8/15.
//  Copyright © 2017年 Yincheng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class xqModel;

@interface BiaoBottomTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *Ovel_One; // 第一个园
@property (weak, nonatomic) IBOutlet UIView *Ovel_Two;
@property (weak, nonatomic) IBOutlet UIView *Ovel_Three;
@property (weak, nonatomic) IBOutlet UIView *Ovel_Four;

@property (weak, nonatomic) IBOutlet UIView *Space_One; // 第一个间隔线
@property (weak, nonatomic) IBOutlet UIView *Space_Two;
@property (weak, nonatomic) IBOutlet UIView *Space_Three;

@property (weak, nonatomic) IBOutlet UILabel *State_One; // 投标
@property (weak, nonatomic) IBOutlet UILabel *State_Two; // 满标
@property (weak, nonatomic) IBOutlet UILabel *State_Three; // 还款
@property (weak, nonatomic) IBOutlet UILabel *State_Four; // 结案

/***模型 ***/
@property (nonatomic ,strong)xqModel *model;

@end
