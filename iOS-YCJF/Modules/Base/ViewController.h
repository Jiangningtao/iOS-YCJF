//
//  ViewController.h
//  iOS-YCJF
//
//  Created by 姜宁桃 on 2017/8/8.
//  Copyright © 2017年 Yincheng. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol btnClickDelegate <NSObject>

- (void)btnhaveClicked;

@end

@interface ViewController : UIViewController

@property (nonatomic,weak)id<btnClickDelegate> clickDelegate;

@end

