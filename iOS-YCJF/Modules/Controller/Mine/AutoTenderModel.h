//
//  AutoTenderModel.h
//  iOS-YCJF
//
//  Created by 姜宁桃 on 2017/11/21.
//  Copyright © 2017年 Yincheng. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface AutoTenderModel : JSONModel

@property (nonatomic ,copy)NSString<Optional> *money;  // 预期收益
@property (nonatomic ,copy)NSString<Optional> *day_apr_last; // 手机号
@property (nonatomic ,copy)NSString<Optional> *tender_type; // 排行榜-投资时间
@property (nonatomic ,copy)NSString<Optional> *lastbufen; // 活动规则网址

@property (nonatomic ,copy)NSString<Optional> *timelimit_day_first;  // 预期收益
@property (nonatomic ,copy)NSString<Optional> *uid; // 手机号
@property (nonatomic ,copy)NSString<Optional> *timelimit_month_last; // 排行榜-投资时间
@property (nonatomic ,copy)NSString<Optional> *autotimes; // 活动规则网址
@property (nonatomic ,copy)NSString<Optional> *timelimit_status;  // 头像
@property (nonatomic ,copy)NSString<Optional> *apr_first; // 年化投资额
@property (nonatomic ,copy)NSString<Optional> *aid_ban; // 排行榜-投资时间
@property (nonatomic ,copy)NSString<Optional> *lastscore; // 消息、信息
@property (nonatomic ,copy)NSString<Optional> *timelimit_day_flag; // 排行榜描述
@property (nonatomic ,copy)NSString<Optional> *apr_last; // 排行榜描述

@property (nonatomic ,copy)NSString<Optional> *time_l;  // 预期收益
@property (nonatomic ,copy)NSString<Optional> *aid_keti_ban; // 手机号
@property (nonatomic ,copy)NSString<Optional> *seq; // 排行榜-投资时间
@property (nonatomic ,copy)NSString<Optional> *isjiangli; // 活动规则网址
@property (nonatomic ,copy)NSString<Optional> *curseqjing;  // 头像
@property (nonatomic ,copy)NSString<Optional> *lundaonum; // 年化投资额
@property (nonatomic ,copy)NSString<Optional> *curseq; // 排行榜-投资时间
@property (nonatomic ,copy)NSString<Optional> *min_money; // 消息、信息
@property (nonatomic ,copy)NSString<Optional> *isjihuo; // 排行榜描述
@property (nonatomic ,copy)NSString<Optional> *is_open_day_apr; // 排行榜描述

@property (nonatomic ,copy)NSString<Optional> *day_apr_first;  // 预期收益
@property (nonatomic ,copy)NSString<Optional> *isreset; // 手机号
@property (nonatomic ,copy)NSString<Optional> *apr_status; // 排行榜-投资时间
@property (nonatomic ,copy)NSString<Optional> *lasttop; // 活动规则网址
@property (nonatomic ,copy)NSString<Optional> *totseqjing;  // 头像
@property (nonatomic ,copy)NSString<Optional> *curseqjing100; // 年化投资额
@property (nonatomic ,copy)NSString<Optional> *totseq; // 排行榜-投资时间
@property (nonatomic ,copy)NSString<Optional> *timelimit_day_last; // 消息、信息
@property (nonatomic ,copy)NSString<Optional> *timelimit_month_first; // 排行榜描述
@property (nonatomic ,copy)NSString<Optional> *aid_buketi_ban; // 排行榜描述

@end
