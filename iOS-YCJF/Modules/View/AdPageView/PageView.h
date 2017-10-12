//
//  PageView.h
//  iOS-YCJF
//
//  Created by 姜宁桃 on 2017/8/24.
//  Copyright © 2017年 Yincheng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^blockSelectAdvertising)();

@interface PageView : UIView

@property (nonatomic, copy) NSString *pageURLString;
@property (nonatomic, copy) blockSelectAdvertising blockSelect;

@end
