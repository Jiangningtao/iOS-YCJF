//
//  selecellTableViewCell.h
//  iOS-CHJF
//
//  Created by garday on 2017/3/9.
//  Copyright © 2017年 garday. All rights reserved.
//

#import <UIKit/UIKit.h>
@class biaoModel;
@interface selecellTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *pingtailab;

@property (weak, nonatomic) IBOutlet UILabel *titlelab;
@property (weak, nonatomic) IBOutlet UIImageView *titimgV;
@property (weak, nonatomic) IBOutlet UILabel *baifbLab;
@property (weak, nonatomic) IBOutlet UILabel *extrAprLab; // 额外加息


@property (weak, nonatomic) IBOutlet UILabel *TZQXlab;
@property (weak, nonatomic) IBOutlet UILabel *QSJZlab;
@property (weak, nonatomic) IBOutlet UIProgressView *progress;
@property (weak, nonatomic) IBOutlet UILabel *progresslab;

/***模型 ***/
@property (nonatomic ,strong)biaoModel *model;

@end
