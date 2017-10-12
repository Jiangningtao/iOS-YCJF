//
//  AccinfoModel.h
//  iOS-YCJF
//
//  Created by 姜宁桃 on 2017/8/17.
//  Copyright © 2017年 Yincheng. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface AccinfoModel : JSONModel

/**
 buketi = "0.00";
 "cur_seq" = 0;
 freeze = "0.00";
 "freeze_touzi" = "0.00";
 "hb_num" = 5;
 keti = "0.00";
 "ky_account" = "0.00";
 "tot_account" = "0.00";
 "tot_seq" = 1;
 "v_huodong" = "0.00";
 "v_nwait_benjinlixi" = "0.00";
 "v_tcur_lixi" = "0.58";
 "v_tot_yuqifaxi" = "0.00";
 "v_ttot_jiangli" = "0.00";
 "v_ttot_leijishouyi" = "0.58";
 "v_ttot_lixiguanlifei" = "0.00";
 "v_twait_benjin" = "0.00";
 "v_twait_benjinlixi" = "0.00";
 "v_twait_lixi" = "0.00";
 "zkt_rate" = 0;
 */

@property (nonatomic ,copy)NSString<Optional> *buketi;
@property (nonatomic ,copy)NSString<Optional> *cur_seq;
@property (nonatomic ,copy)NSString<Optional> *freeze;
@property (nonatomic ,copy)NSString<Optional> *freeze_touzi;
@property (nonatomic ,copy)NSString<Optional> *hb_num;  // 红包数量

@property (nonatomic ,copy)NSString<Optional> *keti;
@property (nonatomic ,copy)NSString<Optional> *ky_account;      //可用余额
@property (nonatomic ,copy)NSString<Optional> *tot_account;     // 资金总额
@property (nonatomic ,copy)NSString<Optional> *tot_seq;
@property (nonatomic ,copy)NSString<Optional> *v_huodong;

@property (nonatomic ,copy)NSString<Optional> *v_nwait_benjinlixi;
@property (nonatomic ,copy)NSString<Optional> *v_tcur_lixi;
@property (nonatomic ,copy)NSString<Optional> *v_tot_yuqifaxi;
@property (nonatomic ,copy)NSString<Optional> *v_ttot_jiangli;
@property (nonatomic ,copy)NSString<Optional> *v_ttot_leijishouyi;      // 累计收益

@property (nonatomic ,copy)NSString<Optional> *v_ttot_lixiguanlifei;
@property (nonatomic ,copy)NSString<Optional> *v_twait_benjin;
@property (nonatomic ,copy)NSString<Optional> *v_twait_benjinlixi;
@property (nonatomic ,copy)NSString<Optional> *v_twait_lixi;
@property (nonatomic ,copy)NSString<Optional> *zkt_rate;

@end
