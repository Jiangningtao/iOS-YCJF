//
//  MineInstance.h
//  iOS-YCJF
//
//  Created by 姜宁桃 on 2017/8/27.
//  Copyright © 2017年 Yincheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MineItemModel.h"
#import "AccinfoModel.h"

@interface MineInstance : NSObject

+(instancetype)shareInstance;

@property (nonatomic, strong) MineItemModel * mineModel;
@property (nonatomic, strong) AccinfoModel * accModel;

@end
