//
//  WelfareView.h
//  iOS-YCJF
//
//  Created by 姜宁桃 on 2017/8/24.
//  Copyright © 2017年 Yincheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol visitDetailDelegate <NSObject>

- (void)visitDetailOfWelfareEvent;
- (void)closePopupViewEvent;

@end

@interface WelfareView : UIView

@property (nonatomic, copy) NSString * imgUrl;
@property (nonatomic, copy) NSString * txtStr;

@property (nonatomic, strong) id<visitDetailDelegate>visitDelegate;

@end
