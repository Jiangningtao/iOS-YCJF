//
//  GestureLockViewController.h
//  iOS-YCJF
//
//  Created by 姜宁桃 on 2017/8/18.
//  Copyright © 2017年 Yincheng. All rights reserved.
//

#import "BaseViewController.h"

@protocol setLockDelegate <NSObject>

- (void)resultOfSetLock:(NSString *)ret;

@end

@interface GestureLockViewController : BaseViewController

@property (nonatomic, strong) id<setLockDelegate>lockDelegate;

@end
