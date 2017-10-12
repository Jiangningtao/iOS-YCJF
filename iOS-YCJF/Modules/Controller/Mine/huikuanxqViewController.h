//
//  huikuanxqViewController.h
//  iOS-CHJF
//
//  Created by garday on 2017/3/21.
//  Copyright © 2017年 garday. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "touziModel.h"

typedef enum _TTGState {
    TTGStateOK  = 0,
    TTGStateError,
    TTGStateErrorq
    
} TTGState; //OK 全部  Error  募集中  Errorq  回款中
@interface huikuanxqViewController : UIViewController
@property (nonatomic ,strong)NSString *idstr;
@property (nonatomic ,strong)NSString *idstr1;
@property (nonatomic ,strong)NSString *idstr2;
@property (nonatomic, strong) touziModel * mode;
/***<#注释#> ***/
@property (nonatomic ,strong)UILabel *labelbt;
/***<#注释#> ***/
@property (nonatomic ,strong)UILabel *labelsh;

@property (nonatomic ,assign)TTGState typ;
@end
