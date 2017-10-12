//
//  TopTableViewCell.h
//  iOS-YCJF
//
//  Created by 姜宁桃 on 2017/8/14.
//  Copyright © 2017年 Yincheng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class xqModel;

@interface TopTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *Detail_ProTitleLab;   // 项目标题
@property (weak, nonatomic) IBOutlet UILabel *Detail_ProRateLab; // 项目收益率
//@property (weak, nonatomic) IBOutlet UILabel *Detail_ExtRateLab; // 项目额外收益率
@property (weak, nonatomic) IBOutlet UILabel *Detail_TotalCountLab; // 项目总额
@property (weak, nonatomic) IBOutlet UILabel *Detail_SaledRateLab; // 已售
@property (weak, nonatomic) IBOutlet UIProgressView *Detail_ProgressView; // 进度条
@property (weak, nonatomic) IBOutlet UILabel *Detail_DeadLineLab; // 项目期限
@property (weak, nonatomic) IBOutlet UILabel *Detail_MinMoneyLab; // 起投金额

/***模型 ***/
@property (nonatomic ,strong)xqModel *model;

@end
