//
//  ssyInfoModel.h
//  iOS-YCJF
//
//  Created by 姜宁桃 on 2017/10/27.
//  Copyright © 2017年 Yincheng. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface ssyInfoModel : JSONModel

@property (nonatomic ,copy)NSString<Optional> *yqsy;  // 预期收益
@property (nonatomic ,copy)NSString<Optional> *mobile; // 手机号
@property (nonatomic ,copy)NSString<Optional> *last_successtime; // 排行榜-投资时间
@property (nonatomic ,copy)NSString<Optional> *rule; // 活动规则网址

@property (nonatomic ,copy)NSString<Optional> *headpture;  // 头像
@property (nonatomic ,copy)NSString<Optional> *tender_money; // 年化投资额
@property (nonatomic ,copy)NSString<Optional> *ranking; // 排行榜-投资时间
@property (nonatomic ,copy)NSString<Optional> *msg; // 消息、信息
@property (nonatomic ,copy)NSString<Optional> *gap; // 排行榜描述

@property (nonatomic ,copy)NSString<Optional> *share_content; // 分享内容
@property (nonatomic ,copy)NSString<Optional> *share_title; // 分享标题
@property (nonatomic ,copy)NSString<Optional> *share_url; // 分享网址

@end
