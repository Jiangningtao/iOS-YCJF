//
//  endRedPacketView.h
//  iOS-YCJF
//
//  Created by ycios on 2017/9/20.
//  Copyright © 2017年 Yincheng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^useRightNowBlock)();

@interface endRedPacketView : UIView

- (instancetype)initWithFrame:(CGRect)frame money:(NSString *)money;

@property (nonatomic, copy) useRightNowBlock useBlock;

@end
