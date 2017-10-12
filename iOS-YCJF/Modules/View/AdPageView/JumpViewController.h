//
//  JumpViewController.h
//  iOS-YCJF
//
//  Created by 姜宁桃 on 2017/8/24.
//  Copyright © 2017年 Yincheng. All rights reserved.
//

#import "BaseViewController.h"

typedef void (^blockJumpMainViewController)();

@interface JumpViewController : BaseViewController

@property (nonatomic, copy) blockJumpMainViewController blockMainViewController;

@end
