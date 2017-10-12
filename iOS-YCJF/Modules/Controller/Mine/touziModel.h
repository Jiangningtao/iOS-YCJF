//
//  touziModel.h
//  iOS-CHJF
//
//  Created by garday on 2017/4/11.
//  Copyright © 2017年 garday. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface touziModel : NSObject
/***<#注释#> ***/
@property (nonatomic ,strong)NSString *time_h;
@property (nonatomic ,strong)NSString *money;
@property (nonatomic ,strong)NSString *name;
@property (nonatomic ,strong)NSString *status;
@property (nonatomic, strong)NSString * repay_each_time;
/***<#注释#> ***/
@property (nonatomic ,strong)NSString *bid;
@property (nonatomic, copy) NSString * id;

@end
