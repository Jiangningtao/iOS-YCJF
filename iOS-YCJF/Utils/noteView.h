//
//  noteView.h
//  iOS-CHJF
//
//  Created by garday on 2017/3/27.
//  Copyright © 2017年 garday. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^blockEnterEnd)(NSString *tjr);

@interface noteView : UIView
/***<#注释#> ***/
@property (nonatomic ,strong)UITextField *textfiled;
@property (nonatomic, strong) UIImageView * imgV;
@property (nonatomic, copy) blockEnterEnd blockEndEnter;

@end
