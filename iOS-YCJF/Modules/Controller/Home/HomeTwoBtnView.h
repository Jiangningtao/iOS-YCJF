//
//  HomeTwoBtnView.h
//  iOS-YCJF
//
//  Created by 姜宁桃 on 2017/9/13.
//  Copyright © 2017年 Yincheng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^blockHomeBtnOfSafe)(); // 安全保障的block
typedef void (^blockHomeBtnOfData)(); // 数据披露的block

@interface HomeTwoBtnView : UIView

- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)titleArray subTitleArray:(NSArray *)subTitleArray;

@property (nonatomic, strong) blockHomeBtnOfSafe blockOfSafeBtn;
@property (nonatomic, strong) blockHomeBtnOfSafe blockOfDataBtn;

@end
