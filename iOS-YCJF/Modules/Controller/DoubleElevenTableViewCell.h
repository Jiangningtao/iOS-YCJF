//
//  DoubleElevenTableViewCell.h
//  iOS-YCJF
//
//  Created by 姜宁桃 on 2017/10/25.
//  Copyright © 2017年 Yincheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DoubleElevenTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *rankingBgImgV; // 排名背景图
@property (weak, nonatomic) IBOutlet UILabel *rankingLab; // 排名
@property (weak, nonatomic) IBOutlet UILabel *telNumLab; // 电话号码
@property (weak, nonatomic) IBOutlet UILabel *prizeLab; // 奖品
@property (weak, nonatomic) IBOutlet UILabel *investmentLab; // 年化投资额

@end
