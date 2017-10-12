//
//  newsTableViewCell.h
//  iOS-CHJF
//
//  Created by garday on 2017/3/13.
//  Copyright © 2017年 garday. All rights reserved.
//

#import <UIKit/UIKit.h>
@class newsModel;


@interface newsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *xwtitle;
@property (weak, nonatomic) IBOutlet UILabel *xwlab;
@property (weak, nonatomic) IBOutlet UIImageView *xwImg;
@property (nonatomic ,strong) newsModel  *model;
@end
