//
//  xqModel.h
//  iOS-CHJF
//
//  Created by garday on 2017/4/7.
//  Copyright © 2017年 garday. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface xqModel : NSObject
/***<#注释#> ***/
@property (nonatomic ,strong)NSString *name;
@property (nonatomic ,strong)NSString *cname;
@property (nonatomic ,strong)NSString *flagname;
@property (nonatomic ,strong)NSString *v_borrow_period;
@property (nonatomic ,strong)NSString *account;
@property (nonatomic ,strong)NSString *borrow_account_scale;
@property (nonatomic ,strong)NSString *borrow_apr;
/***nss ***/
@property (nonatomic ,strong)NSString *borrow_account_wait;
//@property (nonatomic ,strong)NSString *borrow_apr;
/***<#注释#> ***/
@property (nonatomic ,strong)NSString *status;
@property (nonatomic, copy) NSString<Optional> * isxs; // 是否新手标 1 是 0 不是


@property (nonatomic ,strong)NSString *MeBalance;
@property (nonatomic ,strong)NSString *borrow_period;
@property (nonatomic ,strong)NSString *borrow_style;
@property (nonatomic ,strong)NSString *days;
@property (nonatomic ,strong)NSString *min_period;
@property (nonatomic ,strong)NSString *tender_account_min;
@property (nonatomic ,strong)NSString *uid;

/**
 *  当利率大于：15%， apr_B 等于0时不拼，不等于0时拼上去
 */
@property (nonatomic ,copy)NSString<Optional> *apr_B;
@property (nonatomic ,strong)NSString<Optional> *apr_A;
/**
 *  密码标：标详情接口app/binfo返回中item.ispassword==1是密码标 ==""是非密码标
 */
@property (nonatomic ,strong)NSString<Optional> *ispassword;

@end
