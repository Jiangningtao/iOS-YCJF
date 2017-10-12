//
//  PUserDefault.h
//  iOS-YCJF
//
//  Created by 姜宁桃 on 2017/9/2.
//  Copyright © 2017年 Yincheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PUserDefault : NSObject

+ (void)saveBackgroundEnterTimes:(int)times;
+ (int)getBackgroundEnterTimes;

@end
