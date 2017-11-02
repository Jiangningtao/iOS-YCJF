//
//  SuspendView.h
//  iOS-YCJF
//
//  Created by 姜宁桃 on 2017/11/2.
//  Copyright © 2017年 Yincheng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ssyNewUserModel;

typedef void(^toLoginBlock)();

@interface SuspendView : UIView

-(instancetype)initWithFrame:(CGRect)frame userModel:(ssyNewUserModel *)userModel;

@property (nonatomic, copy)toLoginBlock loginBlock;

@end
