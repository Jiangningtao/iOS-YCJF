//
//  MineInstance.m
//  iOS-YCJF
//
//  Created by 姜宁桃 on 2017/8/27.
//  Copyright © 2017年 Yincheng. All rights reserved.
//

#import "MineInstance.h"

@implementation MineInstance
// 通过类方法创建单例对象
+(instancetype)shareInstance
{
    static MineInstance * sharedVC = nil;
    if (sharedVC == nil) {
        sharedVC = [[MineInstance alloc] init];
    }
    
    return sharedVC;
}

@end
