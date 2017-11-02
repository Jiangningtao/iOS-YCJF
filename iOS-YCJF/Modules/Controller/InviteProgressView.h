//
//  InviteProgressView.h
//  iOS-YCJF
//
//  Created by 姜宁桃 on 2017/10/31.
//  Copyright © 2017年 Yincheng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^InviteBtnBlock)();

@interface InviteProgressView : UIView

@property (nonatomic, copy) InviteBtnBlock inviteBlock;

@property (nonatomic, copy) NSString * inviteCount;
@property (nonatomic, copy) NSString * sliderValue;
@property (nonatomic, copy) NSString * descriptionStr;
@property (nonatomic, copy) NSString * subDescriptionStr;

@end
