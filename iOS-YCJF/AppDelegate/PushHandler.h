//
//  PushHandler.h
//  iOS-YCJF
//
//  Created by 姜宁桃 on 2017/9/25.
//  Copyright © 2017年 Yincheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PushHandler : NSObject

+ (instancetype) shareInstance;

- (void)handlePush:(NSDictionary *)info;

@property (nonatomic, strong) UIViewController * baseController;

@end
