//
//  biaoModel.h
//  iOS-YCJF
//
//  Created by 姜宁桃 on 2017/8/9.
//  Copyright © 2017年 Yincheng. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "Jiangli.h"

@interface biaoModel : JSONModel

@property (nonatomic, strong) NSString * account;
@property (nonatomic, strong) NSString * aprb;
@property (nonatomic, strong) NSString * area;
@property (nonatomic, strong) NSString * attrv;
@property (nonatomic, strong) NSString * autorepay;
@property (nonatomic, strong) NSString * bid;
@property (nonatomic, strong) NSString * bimg;
@property (nonatomic, strong) NSString * borrowAccountScale;
@property (nonatomic, strong) NSString * borrowAccountWait;
@property (nonatomic, strong) NSString * borrowAccountYes;
@property (nonatomic, assign) NSInteger borrowApr;
@property (nonatomic, strong) NSString * borrowJiangli;
@property (nonatomic, strong) NSString * borrowJiangliPer;
@property (nonatomic, strong) NSString * borrowPeriod;
@property (nonatomic, strong) NSString * borrowStyle;
@property (nonatomic, strong) NSString * borrowTimes;
@property (nonatomic, strong) NSString * bun;
@property (nonatomic, strong) NSString * city;
@property (nonatomic, strong) NSString * classify;
@property (nonatomic, strong) NSString * cname;
@property (nonatomic, strong) NSString * days;
@property (nonatomic, strong) NSString * diyaType;
@property (nonatomic, strong) NSString * djBzj;
@property (nonatomic, strong) NSString * djSq;
@property (nonatomic, strong) NSString * flag;
@property (nonatomic, strong) NSString * hits;
@property (nonatomic, assign) NSInteger isHot;
@property (nonatomic, strong) NSString * ispassword;
@property (nonatomic, strong) NSString * isxs;
@property (nonatomic, strong) NSString * isyuqid;
@property (nonatomic, strong) Jiangli * jiangli;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * pflag;
@property (nonatomic, strong) NSString * province;
@property (nonatomic, strong) NSString * reverifyTime;
@property (nonatomic, strong) NSString * status;
@property (nonatomic, strong) NSString * tenderAccountMax;
@property (nonatomic, strong) NSString * tenderAccountMin;
@property (nonatomic, strong) NSString * tenderNum;
@property (nonatomic, strong) NSString * tenderTimes;
@property (nonatomic, strong) NSString * timeH;
@property (nonatomic, strong) NSString * uid;
@property (nonatomic, strong) NSString * verifyTime;
/***<#注释#> ***/
@property (nonatomic ,strong)NSMutableArray *total;
@property (nonatomic, strong) NSString * tender_account_min;
@property (nonatomic ,copy)NSString *borrow_apr;
@property (nonatomic ,copy)NSMutableString *borrow_period;
@property (nonatomic ,strong)NSString *borrow_account_scale;

/**
 *  当利率大于：15%， apr_B 等于0时不拼，不等于0时拼上去
 */
@property (nonatomic ,copy)NSString<Optional> *apr_B;
@property (nonatomic ,strong)NSString<Optional> *apr_A;

@end
