//
//  zdmodel.h
//  iOS-CHJF
//
//  Created by garday on 2017/4/11.
//  Copyright © 2017年 garday. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface zdmodel : NSObject
/***<#注释#> ***/

/*
 actid = 4;
 actname = "\U5e73\U5
 "allow_zhuanketi" =
 btjuid = 0;
 day = 14;
 "deadline_remind_sta
 "dx_cltid" = 1;
 "expire_remind_state
 "ext_fields" = "";
 fidtype = 0;
 flag = 1;
 hbid = 3;
 ispay = 1;
 "ispay_msg" = "\U5df
 money = "18.00";
 "money_str" = "18.00
 "money_ty" = 0;
 note = "\U5e73\U53f0
 ss = "{\"day\":\"14\
 stordr = 1;
 term = "\U226514\U59
 "time_account" = "20
 "time_end" = "2017-0
 "time_h" = "2017-07-
 "time_use" = "2017-0
 "to_msg" = "\U7528\U
 tofid = 16;
 "type_name" = "\U62b
 uid = 6;
 "use_rule" = touzi;
 "use_rule_msg" = "\U
 "use_v" = 1888;
 "use_verify" = 1;
 v = "1888.000";
 "v_min" = "0.000";
 "wait_tiyan_shouhui"
 */
@property (nonatomic ,strong)NSString *accounttype;
@property (nonatomic ,strong)NSString *aid;
@property (nonatomic ,strong)NSString *aid2;
@property (nonatomic ,strong)NSString *atnm;
@property (nonatomic ,strong)NSString *atnm2;
@property (nonatomic ,strong)NSString *balance;
@property (nonatomic ,strong)NSString *busid;
@property (nonatomic ,strong)NSString *cid;
@property (nonatomic ,strong)NSString *fid;
@property (nonatomic ,strong)NSString *flowname;
@property (nonatomic ,strong)NSString *flowty;
@property (nonatomic ,strong)NSString *freeze;
@property (nonatomic ,strong)NSString *money;
@property (nonatomic ,strong)NSString *note;
@property (nonatomic ,strong)NSString *objid2;

@property (nonatomic ,strong)NSString *objname;
@property (nonatomic ,strong)NSString *objtype2;
@property (nonatomic ,strong)NSString *qdate;
@property (nonatomic ,strong)NSString *qtime_h;
@property (nonatomic ,strong)NSString *state;
@property (nonatomic ,strong)NSString *time_h;
@property (nonatomic ,strong)NSString *uid;
@property (nonatomic ,strong)NSString *actname;
@property (nonatomic ,strong)NSString *time_use;
//@property (nonatomic ,strong)NSString *uid;

@end
