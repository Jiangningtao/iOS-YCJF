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

@property (nonatomic ,strong)NSString<Optional> *account;
@property (nonatomic ,strong)NSString<Optional> *aprb;
@property (nonatomic ,strong)NSString<Optional> *area;
@property (nonatomic ,strong)NSString<Optional> *attrv;
@property (nonatomic ,strong)NSString<Optional> *autorepay;
@property (nonatomic ,strong)NSString<Optional> *bid;
@property (nonatomic ,strong)NSString<Optional> *bimg;
@property (nonatomic ,strong)NSString<Optional> *borrowAccountScale;
@property (nonatomic ,strong)NSString<Optional> *borrowAccountWait;
@property (nonatomic ,strong)NSString<Optional> *borrowAccountYes;
@property (nonatomic, assign) NSInteger borrowApr;
@property (nonatomic ,strong)NSString<Optional> *borrowJiangli;
@property (nonatomic ,strong)NSString<Optional> *borrowJiangliPer;
@property (nonatomic ,strong)NSString<Optional> *borrowPeriod;
@property (nonatomic ,strong)NSString<Optional> *borrowStyle;
@property (nonatomic ,strong)NSString<Optional> *borrowTimes;
@property (nonatomic ,strong)NSString<Optional> *bun;
@property (nonatomic ,strong)NSString<Optional> *city;
@property (nonatomic ,strong)NSString<Optional> *classify;
@property (nonatomic ,strong)NSString<Optional> *cname;
@property (nonatomic ,strong)NSString<Optional> *days;
@property (nonatomic ,strong)NSString<Optional> *diyaType;
@property (nonatomic ,strong)NSString<Optional> *djBzj;
@property (nonatomic ,strong)NSString<Optional> *djSq;
@property (nonatomic ,strong)NSString<Optional> *flag;
@property (nonatomic ,strong)NSString<Optional> *hits;
@property (nonatomic, assign) NSInteger isHot;
@property (nonatomic ,strong)NSString<Optional> *isxs;
@property (nonatomic ,strong)NSString<Optional> *isyuqid;
@property (nonatomic, strong) Jiangli * jiangli;
@property (nonatomic ,strong)NSString<Optional> *name;
@property (nonatomic ,strong)NSString<Optional> *pflag;
@property (nonatomic ,strong)NSString<Optional> *province;
@property (nonatomic ,strong)NSString<Optional> *reverifyTime;
@property (nonatomic ,strong)NSString<Optional> *status;
@property (nonatomic ,strong)NSString<Optional> *tenderAccountMax;
@property (nonatomic ,strong)NSString<Optional> *tenderAccountMin;
@property (nonatomic ,strong)NSString<Optional> *tenderNum;
@property (nonatomic ,strong)NSString<Optional> *tenderTimes;
@property (nonatomic ,strong)NSString<Optional> *timeH;
@property (nonatomic ,strong)NSString<Optional> *uid;
@property (nonatomic ,strong)NSString<Optional> *verifyTime;
/***<#注释#> ***/
@property (nonatomic ,strong)NSMutableArray *total;
@property (nonatomic ,strong)NSString<Optional> *tender_account_min;
@property (nonatomic ,copy)NSString *borrow_apr;
@property (nonatomic ,copy)NSMutableString *borrow_period;
@property (nonatomic ,strong)NSString *borrow_account_scale;

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
