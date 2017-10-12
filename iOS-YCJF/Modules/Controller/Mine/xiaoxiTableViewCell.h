//
//  xiaoxiTableViewCell.h
//  iOS-CHJF
//
//  Created by garday on 2017/3/27.
//  Copyright © 2017年 garday. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface xiaoxiTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgvjx;//消息图片
@property (weak, nonatomic) IBOutlet UILabel *titLab;//标题
@property (weak, nonatomic) IBOutlet UILabel *timelab;//时间
@property (weak, nonatomic) IBOutlet UILabel *xinxiLab; //详情
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftLeading;

@end
