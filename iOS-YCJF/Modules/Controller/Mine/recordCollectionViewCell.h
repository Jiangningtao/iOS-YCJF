//
//  recordCollectionViewCell.h
//  iOS-CHJF
//
//  Created by garday on 2017/3/14.
//  Copyright © 2017年 garday. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface recordCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *slimv;//右上方送礼图标
@property (weak, nonatomic) IBOutlet UILabel *tzlab;//题目lab
@property (weak, nonatomic) IBOutlet UILabel *xqlab;//详情lab
@property (weak, nonatomic) IBOutlet UIImageView *imgtx;
@end
