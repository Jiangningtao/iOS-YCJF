//
//  PUserDefault.m
//  iOS-YCJF
//
//  Created by 姜宁桃 on 2017/9/2.
//  Copyright © 2017年 Yincheng. All rights reserved.
//

#import "PUserDefault.h"

#define PUserDefault_Key_BackgroundEnterTimes @"PUserDefault_Key_BackgroundEnterTimes"

@implementation PUserDefault

+ (void)saveBackgroundEnterTimes:(int)times
{
    [UserDefaults setInteger:times forKey:PUserDefault_Key_BackgroundEnterTimes];
    [UserDefaults synchronize];
}

+ (int)getBackgroundEnterTimes
{
    int times = 0;
    times = (int)[UserDefaults integerForKey:PUserDefault_Key_BackgroundEnterTimes];
    
    return times;
}

@end
