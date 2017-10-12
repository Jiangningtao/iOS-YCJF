//
//  WelfareViewController.h
//  iOS-CHJF
//
//  Created by 姜宁桃 on 2017/7/13.
//  Copyright © 2017年 garday. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol visitDetailDelegate <NSObject>

- (void)visitDetailOfWelfareEvent;
- (void)closePopupViewEvent;

@end

@interface WelfareViewController : UIViewController


@property (nonatomic, strong) id<visitDetailDelegate>visitDelegate;

@end
