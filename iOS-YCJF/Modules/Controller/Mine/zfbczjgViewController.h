//
//  zfbczjgViewController.h
//  iOS-CHJF
//
//  Created by garday on 2017/3/24.
//  Copyright © 2017年 garday. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum :NSUInteger{
    classOne = 0,
    classTwo,
    classThree,
}JUSTClass;
@interface zfbczjgViewController : UIViewController

/***<#注释#> ***/
@property (nonatomic, strong) NSDictionary * infoDict;
@property (nonatomic, strong) NSString * tixianMoney;
@property (nonatomic, strong) NSString * zfb;
@property (nonatomic ,assign)JUSTClass classtype;
@end
