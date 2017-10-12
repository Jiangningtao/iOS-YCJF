//
//  paymentView.h
//  iOS-YCJF
//
//  Created by 姜宁桃 on 2017/8/21.
//  Copyright © 2017年 Yincheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InputView.h"

typedef void (^foundBlock)();

@interface paymentView : UIView

@property (nonatomic, copy) void(^textChangeBlock)(NSString *text);
@property (nonatomic, copy) NSString *tip;

/***声明一个Block属性 ***/
@property (nonatomic ,copy)foundBlock foundBlock;

- (void)clear;
- (void)closeBtnEvnet;

@end
