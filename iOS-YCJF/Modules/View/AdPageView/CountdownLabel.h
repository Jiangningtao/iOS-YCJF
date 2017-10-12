//
//  CountdownLabel.h
//  iOS-YCJF
//
//  Created by 姜宁桃 on 2017/8/24.
//  Copyright © 2017年 Yincheng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^blockSelectJumpNewViewController)();

@interface CountdownLabel : UILabel

@property (nonatomic, copy) blockSelectJumpNewViewController blockNewViewController;
@property (nonatomic, assign) BOOL isStop; //是否停止计时器

@end
