//
//  HomeActivityView.h
//  iOS-YCJF
//
//  Created by 姜宁桃 on 2017/9/25.
//  Copyright © 2017年 Yincheng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^blockSelectActivity)();

@interface HomeActivityView : UIView

@property (nonatomic, copy) NSString *pageURLString;
@property (nonatomic, copy) blockSelectActivity blockSelect;

@end
