//
//  payView.h
//  iOS-CHJF
//
//  Created by garday on 2017/3/16.
//  Copyright © 2017年 garday. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^deliverBlock)();
@interface payView : UIView
/***声明一个Block属性 ***/
@property (nonatomic ,copy)deliverBlock deliverViewBlock;
/***标题 ***/
@property (nonatomic ,strong)NSArray *sjarr;
@end
